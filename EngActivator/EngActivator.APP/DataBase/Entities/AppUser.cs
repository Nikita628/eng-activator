using Microsoft.AspNetCore.Identity;
using System.Collections.Generic;

namespace EngActivator.APP.DataBase.Entities
{
    public class AppUser : IdentityUser<int>
    {
        public string Name { get; set; }
        public List<ActivityResponse> ActivityResponses { get; set; } = new List<ActivityResponse>();
        public List<ActivityResponseReview> ActivityResponseReviews { get; set; } = new List<ActivityResponseReview>();
    }
}
