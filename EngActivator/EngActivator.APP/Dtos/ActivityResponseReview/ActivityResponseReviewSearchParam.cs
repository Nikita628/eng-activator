using EngActivator.APP.Shared.Dtos;

namespace EngActivator.APP.Dtos.ActivityResponseReview
{
    public class ActivityResponseReviewSearchParam : PageRequest
    {
        public int ActivityResponseIdEquals { get; set; }
    }
}
