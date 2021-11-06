using AutoMapper;
using EngActivator.APP.DataBase;
using EngActivator.APP.Dtos;
using EngActivator.APP.Dtos.ActivityResponseReview;
using EngActivator.APP.Interfaces;
using EngActivator.APP.Shared.Dtos;
using EngActivator.APP.Shared.Interfaces;
using Microsoft.EntityFrameworkCore;
using System;
using System.Linq;
using System.Threading.Tasks;

namespace EngActivator.APP.Services
{
    public class ActivityResponseReviewService : IActivityResponseReviewService
    {
        private readonly EngActivatorContext _db;
        private readonly IMapper _mapper;
        private readonly IHttpContextService _http;

        public ActivityResponseReviewService(EngActivatorContext db, IMapper m, IHttpContextService c)
        {
            _db = db;
            _mapper = m;
            _http = c;
        }

        public async Task<int> CreateAsync(ActivityResponseReviewForCreate dto)
        {
            var entitiy = _mapper.Map<DataBase.Entities.ActivityResponseReview>(dto);
            entitiy.CreatedDate = DateTime.UtcNow;
            entitiy.CreatedById = _http.CurrentUserId;

            using (var transaction = _db.Database.BeginTransaction())
            {
                try
                {
                    _db.ActivityResponseReviews.Add(entitiy);

                    await _db.SaveChangesAsync();

                    var affectedRowsCount = await _db.Database.ExecuteSqlInterpolatedAsync(@$"
                        UPDATE dbo.ActivityResponses 
                        SET ReviewsCount = ReviewsCount + 1,
                            LastUpdatedDate = getutcdate()
                        WHERE Id = ({dto.ActivityResponseId});
                    ");

                    if (affectedRowsCount <= 0)
                        throw new Exception("Could not update reviews count and/or last updated date");

                    await transaction.CommitAsync();
                }
                catch (Exception e)
                {
                    await transaction.RollbackAsync();
                    throw;
                }
            }

            return entitiy.Id;
        }

        public async Task<ActivityResponseHasUnreadReviewsDto> MarkAsViewedAsync(int id)
        {
            var review = await _db.ActivityResponseReviews.FirstOrDefaultAsync(r => r.Id == id);
            review.IsViewed = true;

            await _db.SaveChangesAsync();

            var activityResponseHasMoreUnreadReviews = (from r in _db.ActivityResponseReviews
                                                        where r.ActivityResponseId == review.ActivityResponseId && !r.IsViewed
                                                        select 1).Any();

            return new ActivityResponseHasUnreadReviewsDto { ActivityResponseHasUnreadReviews = activityResponseHasMoreUnreadReviews };
        }

        public async Task<KeysetPageResponse<ActivityResponseReviewForSearch>> SearchAsync(ActivityResponseReviewSearchParam searchParam)
        {
            var countQuery = _db.ActivityResponseReviews
                .Where(arr => arr.ActivityResponseId == searchParam.ActivityResponseIdEquals);

            var createdDateLessThan = DateTime.MaxValue;

            if (searchParam.CreatedDateLessThan.HasValue)
            {
                createdDateLessThan = searchParam.CreatedDateLessThan.Value.AddMinutes(-_http.UtcOffset);
                countQuery = countQuery.Where(arr => arr.CreatedDate < createdDateLessThan);
            }

            var count = await countQuery.CountAsync();

            var searchQuery = from arr in _db.ActivityResponseReviews

                              where arr.ActivityResponseId == searchParam.ActivityResponseIdEquals
                                && (!searchParam.CreatedDateLessThan.HasValue || arr.CreatedDate < createdDateLessThan)

                              orderby arr.CreatedDate descending

                              select new ActivityResponseReviewForSearch
                              {
                                  CreatedBy = new User
                                  {
                                      Id = arr.CreatedBy.Id,
                                      Name = arr.CreatedBy.Name,
                                  },
                                  Id = arr.Id,
                                  CreatedDate = arr.CreatedDate,
                                  IsViewed = arr.IsViewed,
                                  Score = arr.Score,
                                  Text = arr.Text,
                                  ActivityResponseId = arr.ActivityResponseId,
                              };

            var dtos = await searchQuery
                .AsNoTracking()
                .Take(searchParam.PageSize)
                .ToListAsync();

            return new KeysetPageResponse<ActivityResponseReviewForSearch>
            {
                Items = dtos,
                HasMoreItems = count > searchParam.PageSize,
            };
        }
    }
}
