using EngActivator.APP.Dtos;
using EngActivator.APP.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using System.Threading.Tasks;

namespace EngActivator.API.Controllers
{
    [ApiController]
    [Authorize]
    [Route("api/auth")]
    public class AuthController : ControllerBase
    {
        private readonly ILogger<AuthController> _logger;
        private readonly IAuthService _authService;

        public AuthController(
            ILogger<AuthController> logger, 
            IAuthService auth)
        {
            _logger = logger;
            _authService = auth;
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
            return Ok(await _authService.SignupAsync(dto));
        }

        [HttpPost("email-exists")]
        [AllowAnonymous]
        public async Task<IActionResult> IsEmailExists([FromQuery]string email)
        {
            return Ok(await _authService.IsEmailExistsAsync(email));
        }
    }
}
