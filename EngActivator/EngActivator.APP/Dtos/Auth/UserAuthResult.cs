using System;

namespace EngActivator.APP.Dtos
{
    public class UserAuthResult
    {
        public string Token { get; set; }
        public DateTime TokenExpirationDate { get; set; }
        public User User { get; set; }
    }
}
