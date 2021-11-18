using System;

namespace EngActivator.APP.Shared.Exceptions
{
    public class AppUnauthorizedException : Exception
    {
        public AppUnauthorizedException(string message, Exception innerException) : base(message, innerException)
        {

        }

        public AppUnauthorizedException(string message) : base(message)
        {

        }
    }
}
