using EngActivator.APP.Shared.Enums;

namespace EngActivator.APP.Dtos
{
    public class ActivityResponseForCreate
    {
        public string Answer { get; set; }
        public string Activity { get; set; }
        public ActivityTypeEnum ActivityTypeId { get; set; }
    }
}
