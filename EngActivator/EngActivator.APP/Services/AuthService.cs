using EngActivator.APP.DataBase.Entities;
using EngActivator.APP.Dtos;
using EngActivator.APP.Dtos.Auth;
using EngActivator.APP.Interfaces;
using EngActivator.APP.Shared.Dtos;
using EngActivator.APP.Shared.Exceptions;
using EngActivator.APP.Shared.Interfaces;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using Microsoft.IdentityModel.Tokens;
using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;

namespace EngActivator.APP.Services
{
    public class AuthService : IAuthService
    {
        private readonly UserManager<AppUser> _userManager;
        private readonly SignInManager<AppUser> _signInManager;
        private readonly IConfiguration _config;
        private readonly SymmetricSecurityKey _key;
        private readonly IEmailSender _emailSender;
        private readonly IEmailConstructor _emailConstructor;
        private readonly ILogger<AuthService> _logger;

        public AuthService(
            IConfiguration c,
            UserManager<AppUser> um,
            SignInManager<AppUser> sm,
            IEmailConstructor ec,
            IEmailSender es,
            ILogger<AuthService> l)
        {
            _emailConstructor = ec;
            _emailSender = es;
            _userManager = um;
            _signInManager = sm;
            _config = c;
            _logger = l;
            _key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_config["Token:Key"]));
        }

        public async Task<bool> ConfirmEmailAsync(string email, string emailConfirmationToken)
        {
            try
            {
                var user = await _userManager.FindByEmailAsync(email);

                if (user is null)
                {
                    throw new AppUnauthorizedException("Cannot find user by email");
                }

                var result = await _userManager.ConfirmEmailAsync(user, emailConfirmationToken);

                return result.Succeeded;
            }
            catch (Exception e)
            {
                _logger.LogError(e, $"Could not confirm email: {e.Message} {email}");

                return false;
            }
        }

        public async Task<UserAuthResult> LoginAsync(LoginData loginData)
        {
            var user = await _userManager.FindByEmailAsync(loginData.Email);

            if (user is null || !user.EmailConfirmed)
            {
                throw new AppUnauthorizedException("Invalid email and/or password");
            }

            var result = await _signInManager.CheckPasswordSignInAsync(user, loginData.Password, false);

            if (!result.Succeeded)
            {
                throw new AppUnauthorizedException("Invalid email and/or password");
            }

            var tokenData = GenerateToken(user);

            return new UserAuthResult
            {
                User = new User
                {
                    Id = user.Id,
                    Name = user.Name,
                },
                Token = tokenData.Item1,
                TokenExpirationDate = tokenData.Item2,
            };
        }

        public async Task SignupAsync(SignupData signupData)
        {
            await ValidateSignupData(signupData);

            var entity = new AppUser
            {
                Name = signupData.Name,
                Email = signupData.Email,
                UserName = signupData.Email,
            };

            var result = await _userManager.CreateAsync(entity, signupData.Password);

            ValidateSignupResult(result);

            await SendSignupEmail(signupData, entity);
        }

        public async Task DeleteUserAsync(string email)
        {
            var user = await _userManager.FindByEmailAsync(email);

            if (user is null)
            {
                throw new AppNotFoundException("User not found");
            }

            await _userManager.DeleteAsync(user);
        }

        public async Task SendResetPasswordEmailAsync(ResetPasswordDto dto)
        {
            var user = await _userManager.FindByEmailAsync(dto.Email);

            if (user is null || !user.EmailConfirmed)
            {
                throw new AppNotFoundException("User with this email was not found");
            }

            try
            {
                var resetPassToken = await _userManager.GeneratePasswordResetTokenAsync(user);
                var email = _emailConstructor.ConstructResetPasswordEmail(user.Email, user.Name, resetPassToken);
                await _emailSender.SendEmailAsync(email);
            }
            catch (Exception e)
            {
                var errorResponse = new ErrorResponse("We were not able to send email to provided address");
                errorResponse.ErrorsMap.Add("email", new List<string> { "We were not able to send email to provided address" });
                _logger.LogError(e, $"Could not send reset password email: {e.Message} {dto.Email}");

                throw new AppErrorResponseException(errorResponse, e);
            }
        }

        public async Task<bool> ResetPasswordAsync(string email, string token, string password)
        {
            var user = await _userManager.FindByEmailAsync(email);

            try
            {
                if (user is null)
                {
                    throw new AppNotFoundException("User with this email was not found");
                }

                var result = await _userManager.ResetPasswordAsync(user, token, password);

                return result.Succeeded;
            }
            catch (Exception e)
            {
                var errorResponse = new ErrorResponse("We were not able to reset your password");
                errorResponse.ErrorsMap.Add("email", new List<string> { "We were not able to reset your password" });
                _logger.LogError(e, $"Could not reset password: {e.Message} {email}");

                return false;
            }
        }

        private void ValidateSignupResult(IdentityResult result)
        {
            if (result.Succeeded) return;

            var errorResponse = new ErrorResponse("Something went wrong during user registration");

            foreach (var error in result.Errors)
            {
                errorResponse.ErrorsMap.Add(error.Code, new List<string> { error.Description });
            }

            throw new AppErrorResponseException(errorResponse);
        }

        private async Task ValidateSignupData(SignupData data)
        {
            var isEmailAlreadyTaken = await IsEmailExistsAsync(data.Email);

            if (isEmailAlreadyTaken)
            {
                var errorResponse = new ErrorResponse("User with this email already exists");
                errorResponse.ErrorsMap.Add("email", new List<string> { "User with this email already exists" });
                throw new AppErrorResponseException(errorResponse);
            }

            var isNameTaken = await _userManager.FindByNameAsync(data.Name) != null;

            if (isNameTaken)
            {
                var errorResponse = new ErrorResponse("User with this name already exists");
                errorResponse.ErrorsMap.Add("name", new List<string> { "User with this name already exists" });
                throw new AppErrorResponseException(errorResponse);
            }
        }

        private async Task<bool> IsEmailExistsAsync(string email)
        {
            var user = await _userManager.FindByEmailAsync(email);

            return user != null;
        }

        private async Task SendSignupEmail(SignupData signupData, AppUser user)
        {
            try
            {
                var emailConfirmationToken = await _userManager.GenerateEmailConfirmationTokenAsync(user);
                var email = _emailConstructor.ConstructSignupEmail(signupData.Email, signupData.Name, emailConfirmationToken);
                await _emailSender.SendEmailAsync(email);
            }
            catch (Exception e)
            {
                await _userManager.DeleteAsync(user);
                var errorResponse = new ErrorResponse("We were not able to send registration email to provided address");
                errorResponse.ErrorsMap.Add("email", new List<string> { "We were not able to send registration email to provided address" });
                _logger.LogError(e, $"Could not send signup email: {e.Message} {signupData.Email}");

                throw new AppErrorResponseException(errorResponse, e);
            }
        }

        private Tuple<string, DateTime> GenerateToken(AppUser user)
        {
            var claims = new List<Claim>
            {
                new Claim(JwtRegisteredClaimNames.Email, user.Email),
                new Claim(JwtRegisteredClaimNames.NameId, user.Id.ToString()),
                new Claim(JwtRegisteredClaimNames.Name, user.Name),
            };

            var creds = new SigningCredentials(_key, SecurityAlgorithms.HmacSha512Signature);

            var tokenExpirationDate = DateTime.UtcNow.AddYears(2); // TODO change if app survives first version test, use refresh token

            var tokenDescr = new SecurityTokenDescriptor
            {
                Subject = new ClaimsIdentity(claims),
                Expires = tokenExpirationDate,
                SigningCredentials = creds,
                Issuer = _config["Token:Issuer"],
            };

            var tokenHandler = new JwtSecurityTokenHandler();

            var token = tokenHandler.CreateToken(tokenDescr);

            return Tuple.Create(tokenHandler.WriteToken(token), tokenExpirationDate);
        }
    }
}
