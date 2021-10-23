using System.Collections.Generic;

namespace EngActivator.APP.Shared.Dtos
{
    public class ErrorResponse
    {
        public ErrorResponse()
        {

        }

        public ErrorResponse(string message)
        {
            Message = message;
        }

        public string Message { get; set; }
        public Dictionary<string, List<string>> ErrorsMap { get; set; } = new Dictionary<string, List<string>>();
        public string Details { get; set; }
    }
}
