﻿using System;

namespace EngActivator.APP.Shared.Exceptions
{
    public class AppNotFoundException : Exception
    {
        public AppNotFoundException(string message, Exception innerException) : base (message, innerException)
        {

        }

        public AppNotFoundException(string message) : base(message)
        {
        }
    }
}
