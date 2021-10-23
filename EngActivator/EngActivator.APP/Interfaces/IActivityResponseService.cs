using EngActivator.APP.Dtos;
using EngActivator.APP.Shared.Dtos;
using System.Threading.Tasks;

namespace EngActivator.APP.Interfaces
{
    public interface IActivityResponseService
    {
        Task<int> CreateAsync(ActivityResponseForCreate dto);
        Task<PageResponse<ActivityResponseForPreview>> SearchForPreviewAsync(ActivityResponseSearchParam searchParam);
        Task<ActivityResponseForReview> GetForReviewAsync();
        Task<ActivityResponseForDetails> GetForDetailsAsync(int id);
    }
}
