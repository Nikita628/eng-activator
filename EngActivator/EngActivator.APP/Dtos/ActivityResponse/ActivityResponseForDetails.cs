using EngActivator.APP.Shared.Enums;

namespace EngActivator.APP.Dtos
{
    public class ActivityResponseForDetails
    {
        public int Id { get; set; }
        public string Answer { get; set; }
        public ActivityTypeEnum ActivityTypeId { get; set; }
        public string Activity { get; set; }
        public double Score { get; set; }
    }
}
