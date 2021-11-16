using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Hosting;
using System.Threading.Tasks;

namespace EngActivator.API.Controllers
{
    [ApiController]
    [Route("api/info")]
    public class InfoController : ControllerBase
    {
        private readonly IHostEnvironment _env;

        public InfoController(IHostEnvironment e)
        {
            _env = e;
        }

        [HttpGet("env")]
        public async Task<IActionResult> GetEnv()
        {
            return Ok(_env.EnvironmentName);
        }
    }
}
