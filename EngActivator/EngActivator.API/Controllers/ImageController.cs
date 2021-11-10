using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Threading.Tasks;

namespace EngActivator.API.Controllers
{
    [ApiController]
    [Authorize]
    [Route("api/dictionary")]
    public class ImageController : ControllerBase
    {
        [HttpGet("random-pic/{picUrl}")]
        public async Task<IActionResult> GetRandomPic([FromRoute] string picUrl)
        {
            var filePath = @"E:\\Test.jpg"; // construct file path Files/randomPics/picUrl

            return PhysicalFile(filePath, "image/jpeg");
        }

        [HttpGet("word-pic/{picUrl}")]
        public async Task<IActionResult> GetWordPic([FromRoute] string picUrl)
        {
            var filePath = @"E:\\Test.jpg";

            return PhysicalFile(filePath, "image/jpeg");
        }
    }
}
