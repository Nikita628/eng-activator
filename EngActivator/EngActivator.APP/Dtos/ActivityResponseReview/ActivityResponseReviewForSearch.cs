using System;

namespace EngActivator.APP.Dtos
{
    public class ActivityResponseReviewForSearch
    {
        public int Id { get; set; }
        public double Score { get; set; }
        public string Text { get; set; }
        public Dtos.User CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public bool IsViewed { get; set; }
    }
}
