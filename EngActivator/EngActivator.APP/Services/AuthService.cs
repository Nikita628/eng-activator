using EngActivator.APP.DataBase.Entities;
using EngActivator.APP.Dtos;
using EngActivator.APP.Interfaces;
using EngActivator.APP.Shared.Dtos;
using EngActivator.APP.Shared.Exceptions;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Configuration;
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

        public AuthService(
            IConfiguration c,
            UserManager<AppUser> um,
            SignInManager<AppUser> sm)
        {
            _userManager = um;
            _signInManager = sm;
            _config = c;
            _key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_config["Token:Key"]));
        }

        public async Task<UserAuthResult> LoginAsync(LoginData loginData)
        {
            var user = await _userManager.FindByEmailAsync(loginData.Email);

            if (user is null)
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

        public async Task<UserAuthResult> SignupAsync(SignupData signupData)
        {
            await ValidateIfEmailAlreadyTaken(signupData.Email);

            var entity = new AppUser
            {
                Name = signupData.Name,
                Email = signupData.Email,
                UserName = signupData.Email,
            };

            var result = await _userManager.CreateAsync(entity, signupData.Password);

            ValidateSignupResult(result);

            var tokenData = GenerateToken(entity);

            return new UserAuthResult
            {
                Token = tokenData.Item1,
                TokenExpirationDate = tokenData.Item2,
                User = new User
                {
                    Id = entity.Id,
                    Name = entity.Name,
                }
            };
        }

        public async Task<bool> IsEmailExistsAsync(string email)
        {
            var user = await _userManager.FindByEmailAsync(email);

            return user != null;
        }

        private void ValidateSignupResult(IdentityResult result)
        {
            if (result.Succeeded) return;

            var errorResponse = new ErrorResponse("Cannot register new user");

            foreach (var error in result.Errors)
            {
                errorResponse.ErrorsMap.Add(error.Code, new List<string> { error.Description });
            }

            throw new AppErrorResponseException(errorResponse);
        }

        private async Task ValidateIfEmailAlreadyTaken(string email)
        {
            var isEmailAlreadyTaken = await IsEmailExistsAsync(email);

            if (isEmailAlreadyTaken)
            {
                var errorResponse = new ErrorResponse("User with this email already exists");
                errorResponse.ErrorsMap.Add("email", new List<string> { "User with this email already exists" });
                throw new AppErrorResponseException(errorResponse);
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
