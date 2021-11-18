using EngActivator.APP.Shared.Dtos;
using System;

namespace EngActivator.APP.Shared.Exceptions
{
    public class AppErrorResponseException : Exception
    {
        public AppErrorResponseException(ErrorResponse errorResponse, Exception innerException) : base(errorResponse.Message, innerException)
        {
            ErrorResponse = errorResponse;
        }

        public AppErrorResponseException(ErrorResponse errorResponse)
        {
            ErrorResponse = errorResponse;
        }

        public ErrorResponse ErrorResponse { get; set; }
    }
}
