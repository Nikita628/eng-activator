using EngActivator.APP.Shared.Interfaces;
using Microsoft.AspNetCore.Http;
using System.Linq;
using System.Security.Claims;

namespace EngActivator.APP.Shared.Services
{
    public class CurrentUserService : ICurrentUserService
    {
        private readonly IHttpContextAccessor _http;
        private readonly int _currentUserId;

        public CurrentUserService(IHttpContextAccessor ca)
        {
            _http = ca;

            var IdClaim = _http.HttpContext?.User?.Claims?.FirstOrDefault(c => c.Type == ClaimTypes.NameIdentifier);

            if (IdClaim != null)
            {
                _currentUserId = int.Parse(IdClaim.Value);
            }
        }

        public int CurrentUserId 
        {
            get => _currentUserId;
        }
    }
}
