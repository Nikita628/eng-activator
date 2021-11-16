using Microsoft.AspNetCore.Http;
using System.Collections.Generic;

namespace EngActivator.APP.Shared.Dtos
{
    public class Email
    {
        public string To { get; set; }
        public string Body { get; set; }
        public string Subject { get; set; }
        public List<IFormFile> Attachments { get; set; } = new List<IFormFile>();
    }
}
