using EngActivator.APP.Dtos;
using EngActivator.APP.Dtos.ActivityResponseReview;
using EngActivator.APP.Shared.Dtos;
using System.Threading.Tasks;

namespace EngActivator.APP.Interfaces
{
    public interface IActivityResponseReviewService
    {
        Task<int> CreateAsync(ActivityResponseReviewForCreate dto);
        Task<ActivityResponseHasUnreadReviewsDto> MarkAsViewedAsync(int id);
        Task<KeysetPageResponse<ActivityResponseReviewForSearch>> SearchAsync(ActivityResponseReviewSearchParam searchParam);
    }
}
