using EngActivator.APP.Dtos;
using EngActivator.APP.Dtos.Auth;
using EngActivator.APP.Interfaces;
using EngActivator.APP.Shared.Models.Settings;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;
using System.IO;
using System.Threading.Tasks;
using System.Web;

namespace EngActivator.API.Controllers
{
    [ApiController]
    [Authorize]
    [Route("api/auth")]
    public class AuthController : ControllerBase
    {
        private readonly IAuthService _authService;
        private readonly AppSettings _appSettings;
        private readonly IWebHostEnvironment _env;

        public AuthController(IAuthService auth, IOptions<AppSettings> s, IWebHostEnvironment e)
        {
            _authService = auth;
            _appSettings = s.Value;
            _env = e;
        }

        [HttpPost("login")]
        [AllowAnonymous]
        public async Task<IActionResult> Login([FromBody] LoginData dto)
        {
            return Ok(await _authService.LoginAsync(dto));
        }

        [HttpPost("signup")]
        [AllowAnonymous]
        public async Task<IActionResult> Signup([FromBody] SignupData dto)
        {
            await _authService.SignupAsync(dto);

            return Ok();
        }

        [HttpGet("confirm-email")]
        [AllowAnonymous]
        public async Task<IActionResult> ConfirmEmail([FromQuery] string email, [FromQuery] string token)
        {
            var isEmailConfirmed = await _authService.ConfirmEmailAsync(email, token);

            if (isEmailConfirmed)
            {
                return Redirect("/pages/emailConfirmationSuccess.html");
            }
            else
            {
                return Redirect("/pages/emailConfirmationError.html");
            }
        }

        [HttpDelete("delete-user")]
        [AllowAnonymous]
        public async Task<IActionResult> DeleteUser([FromQuery] string email)
        {
            await _authService.DeleteUserAsync(email);

            return Ok();
        }

        [HttpPost("send-reset-password-email")]
        [AllowAnonymous]
        public async Task<IActionResult> SendResetPasswordEmail([FromBody]ResetPasswordDto dto)
        {
            await _authService.SendResetPasswordEmailAsync(dto);

            return Ok();
        }

        [HttpGet("reset-password-page")]
        [AllowAnonymous]
        public async Task<IActionResult> GetResetPasswordPage([FromQuery]string email, [FromQuery]string token)
        {
            var resetPasswordLink = $"{_appSettings.ApiUrl}/api/auth/reset-password?email={HttpUtility.UrlEncode(email)}&token={HttpUtility.UrlEncode(token)}";
            var logoUrl = $"{_appSettings.ApiUrl}/pages/logo.png";

            var resetPasswordPagePath = Path.Combine(_env.WebRootPath, "pages", "resetPassword.html");

            var pageText = await System.IO.File.ReadAllTextAsync(resetPasswordPagePath);

            pageText = pageText.Replace("LOGO_URL", logoUrl);
            pageText = pageText.Replace("RESET_URL", resetPasswordLink);

            return Content(pageText, "text/html");
        }

        [HttpPost("reset-password")]
        [AllowAnonymous]
        public async Task<IActionResult> ResetPassword([FromQuery] string email, [FromQuery] string token)
        {
            var form = HttpContext.Request.Form;
            var password = form["password"];

            var isResetSucceeded = await _authService.ResetPasswordAsync(email, token, password);

            if (isResetSucceeded)
            {
                return Redirect("/pages/resetPasswordSuccess.html");
            }
            else
            {
                return Redirect("/pages/resetPasswordError.html");
            }
        }
    }
}
