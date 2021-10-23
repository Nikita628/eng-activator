using System;
using System.Collections.Generic;
using System.Text;

namespace EngActivator.APP.Shared.Exceptions
{
    public class AppUnauthorizedException : Exception
    {
        public AppUnauthorizedException(string message) : base(message)
        {

        }
    }
}
