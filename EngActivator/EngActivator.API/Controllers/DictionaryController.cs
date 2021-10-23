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
    [Route("api/dictionary")]
    public class DictionaryController : ControllerBase
    {
        private readonly ILogger<ActivityResponseController> _logger;
        private readonly IDictionaryService _service;

        public DictionaryController(
            ILogger<ActivityResponseController> logger,
            IDictionaryService s
        )
        {
            _logger = logger;
            _service = s;
        }

        [HttpPost("search")]
        public async Task<IActionResult> Search([FromBody] DictionarySearchParam dto)
        {
            var res = await _service.SearchAsync(dto);

            return Ok(res);
        }
    }
}
