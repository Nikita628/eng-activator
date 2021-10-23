using EngActivator.APP.Shared.Enums;

namespace EngActivator.APP.Dtos
{
    public class ActivityResponseForReview
    {
        public int Id { get; set; }
        public ActivityTypeEnum ActivityTypeId { get; set; }
        public string Activity { get; set; }
        public string Answer { get; set; }
        public Dtos.User CreatedBy { get; set; }
    }
}
