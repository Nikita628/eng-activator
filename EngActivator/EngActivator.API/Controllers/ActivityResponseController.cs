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
    [Route("api/activity-response")]
    public class ActivityResponseController : ControllerBase
    {
        private readonly ILogger<ActivityResponseController> _logger;
        private readonly IActivityResponseService _service;

        public ActivityResponseController(
            ILogger<ActivityResponseController> logger,
            IActivityResponseService s
        )
        {
            _logger = logger;
            _service = s;
        }

        [HttpPost("create")]
        public async Task<IActionResult> Create([FromBody]ActivityResponseForCreate dto)
        {
            var res = await _service.CreateAsync(dto);

            return Ok(res);
        }

        [HttpPost("search-preview")]
        public async Task<IActionResult> SearchForPreview([FromBody]ActivityResponseSearchParam searchParam)
        {
            var res = await _service.SearchForPreviewAsync(searchParam);

            return Ok(res);
        }

        [HttpGet("review")]
        public async Task<IActionResult> GetForReview()
        {
            var res = await _service.GetForReviewAsync();

            return Ok(res);
        }

        [HttpGet("details/{id}")]
        public async Task<IActionResult> GetForDetails([FromRoute]int id)
        {
            var res = await _service.GetForDetailsAsync(id);

            return Ok(res);
        }
    }
}
