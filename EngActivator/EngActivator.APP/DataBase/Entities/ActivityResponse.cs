using System.Collections.Generic;

namespace EngActivator.APP.DataBase.Entities
{
    public class ActivityResponse : BaseEntity
    {
        public string Answer { get; set; }
        public string Activity { get; set; }
        public ActivityType ActivityType { get; set; }
        public int ActivityTypeId { get; set; }
        public int ReviewsCount { get; set; }
        public List<ActivityResponseReview> ActivityResponseReviews { get; set; } = new List<ActivityResponseReview>();
    }
}
