using EngActivator.APP.Dtos;
using EngActivator.APP.Interfaces;
using EngActivator.APP.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Threading.Tasks;

namespace EngActivator.API.Controllers
{
    [ApiController]
    [Authorize]
    [Route("api/abusive-content-report")]
    public class AbusiveContentReportController : ControllerBase
    {
        private readonly IAbusiveContentReportService _service;

        public AbusiveContentReportController(IAbusiveContentReportService s)
        {
            _service = s;
        }

        [HttpPost("create")]
        public async Task<IActionResult> Create([FromBody] AbusiveContentReport dto)
        {
            await _service.CreateAsync(dto);

            return Ok();
        }
    }
}
