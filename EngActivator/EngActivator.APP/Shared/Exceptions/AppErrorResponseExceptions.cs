using EngActivator.APP.Shared.Dtos;
using System;

namespace EngActivator.APP.Shared.Exceptions
{
    public class AppErrorResponseException : Exception
    {
        public AppErrorResponseException(ErrorResponse errorResponse)
        {
            ErrorResponse = errorResponse;
        }

        public ErrorResponse ErrorResponse { get; set; }
    }
}
