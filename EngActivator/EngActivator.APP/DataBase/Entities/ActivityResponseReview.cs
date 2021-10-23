namespace EngActivator.APP.DataBase.Entities
{
    public class ActivityResponseReview : BaseEntity
    {
        public string Text { get; set; }
        public double Score { get; set; }
        public bool IsViewed { get; set; }
        public ActivityResponse ActivityResponse { get; set; }
        public int ActivityResponseId { get; set; }
    }
}
