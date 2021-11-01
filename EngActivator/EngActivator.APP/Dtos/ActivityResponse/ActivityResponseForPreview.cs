using EngActivator.APP.Shared.Enums;
using System;

namespace EngActivator.APP.Dtos
{
    public class ActivityResponseForPreview
    {
        public int Id { get; set; }
        public string Answer { get; set; }
        public ActivityTypeEnum ActivityTypeId { get; set; }
        public DateTime CreatedDate { get; set; }
        public bool HasUnreadReviews { get; set; }
        public DateTime LastUpdatedDate { get; set; }
    }
}
