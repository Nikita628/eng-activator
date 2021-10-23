using EngActivator.APP.Dtos;
using EngActivator.APP.Dtos.ActivityResponseReview;
using EngActivator.APP.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using System.Threading.Tasks;

namespace EngActivator.API.Controllers
{
    [ApiController]
    [Authorize]
    [Route("api/activity-response-review")]
    public class ActivityResponseReviewController : ControllerBase
    {
        private readonly ILogger<ActivityResponseReviewController> _logger;
        private readonly IActivityResponseReviewService _service;

        public ActivityResponseReviewController(ILogger<ActivityResponseReviewController> logger, IActivityResponseReviewService s)
        {
            _logger = logger;
            _service = s;
        }

        [HttpPost("create")]
        public async Task<IActionResult> Create([FromBody]ActivityResponseReviewForCreate dto)
        {
            return Ok(await _service.CreateAsync(dto));
        }

        [HttpPost("search")]
        public async Task<IActionResult> Search([FromBody]ActivityResponseReviewSearchParam searchParam)
        {
            return Ok(await _service.SearchAsync(searchParam));
        }

        [HttpPut("mark-viewed/{id}")]
        public async Task<IActionResult> MarkViewed([FromRoute]int id)
        {
            return Ok(await _service.MarkAsViewedAsync(id));
        }
    }
}
