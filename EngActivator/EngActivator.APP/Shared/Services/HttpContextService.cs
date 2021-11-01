using EngActivator.APP.Shared.Interfaces;
using Microsoft.AspNetCore.Http;
using System.Linq;
using System.Security.Claims;

namespace EngActivator.APP.Shared.Services
{
    public class HttpContextService : IHttpContextService
    {
        private readonly IHttpContextAccessor _http;
        private readonly int _currentUserId;
        private readonly int _utcOffset;

        public HttpContextService(IHttpContextAccessor ca)
        {
            _http = ca;

            var IdClaim = _http.HttpContext?.User?.Claims?.FirstOrDefault(c => c.Type == ClaimTypes.NameIdentifier);

            if (IdClaim != null)
            {
                _currentUserId = int.Parse(IdClaim.Value);
            }

            if (_http.HttpContext.Request.Headers.TryGetValue("utcOffset", out var value))
            {
                _utcOffset = int.Parse(value);
            }
        }

        public int CurrentUserId 
        {
            get => _currentUserId;
        }

        public int UtcOffset
        {
            get => _utcOffset;
        }
    }
}
