using EngActivator.APP.Shared.Dtos;
using Microsoft.AspNetCore.Mvc;
using System.Net;

namespace EngActivator.API.Controllers
{
    [ApiController]
    [Route("error/{code}")]
    public class ErrorController : ControllerBase
    {
        public IActionResult Error(int code)
        {
            var errorMessage = ((HttpStatusCode)code).ToString();

            return new ObjectResult(new ErrorResponse(errorMessage));
        }
    }
}
