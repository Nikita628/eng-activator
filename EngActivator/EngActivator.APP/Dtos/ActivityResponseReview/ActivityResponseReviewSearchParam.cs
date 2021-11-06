using EngActivator.APP.Shared.Dtos;
using System;

namespace EngActivator.APP.Dtos.ActivityResponseReview
{
    public class ActivityResponseReviewSearchParam : KeysetPageRequest
    {
        public int ActivityResponseIdEquals { get; set; }
        public DateTime? CreatedDateLessThan { get; set; }
    }
}
