using AutoMapper;
using EngActivator.APP.DataBase;
using EngActivator.APP.Dtos;
using EngActivator.APP.Dtos.ActivityResponseReview;
using EngActivator.APP.Interfaces;
using EngActivator.APP.Shared.Dtos;
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

        public ActivityResponseReviewService(EngActivatorContext db, IMapper m)
        {
            _db = db;
            _mapper = m;
        }

        public async Task<int> CreateAsync(ActivityResponseReviewForCreate dto)
        {
            var entitiy = _mapper.Map<DataBase.Entities.ActivityResponseReview>(dto);

            using (var transaction = _db.Database.BeginTransaction())
            {
                try
                {
                    _db.ActivityResponseReviews.Add(entitiy);

                    await _db.SaveChangesAsync();

                    var affectedRowsCount = await _db.Database.ExecuteSqlInterpolatedAsync(@$"
                        UPDATE dbo.ActivityResponses 
                        SET ReviewsCount = ReviewsCount + 1  
                        WHERE Id = ({dto.ActivityResponseId});
                    ");

                    if (affectedRowsCount <= 0)
                        throw new Exception("Could not update reviews count");

                    await transaction.CommitAsync();
                }
                catch (Exception)
                {
                    await transaction.RollbackAsync();
                    throw;
                }
            }

            return entitiy.Id;
        }

        public async Task<bool> MarkAsViewedAsync(int id)
        {
            var affectedRowsCount = await _db.Database.ExecuteSqlInterpolatedAsync(@$"
                UPDATE dbo.ActivityResponseReviews 
                SET IsViewed = 1 
                WHERE Id = ({id});
            ");

            return affectedRowsCount > 0;
        }

        public async Task<PageResponse<ActivityResponseReviewForSearch>> SearchAsync(ActivityResponseReviewSearchParam searchParam)
        {
            var count = await _db.ActivityResponseReviews
                .Where(arr => arr.ActivityResponseId == searchParam.ActivityResponseIdEquals)
                .CountAsync();

            var searchQuery = from arr in _db.ActivityResponseReviews
                              where arr.ActivityResponseId == searchParam.ActivityResponseIdEquals
                              orderby arr.Id descending
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
                              };

            var dtos = await searchQuery
                .AsNoTracking()
                .Take(searchParam.PageSize)
                .Skip((searchParam.PageNumber - 1) * searchParam.PageSize)
                .ToListAsync();

            return new PageResponse<ActivityResponseReviewForSearch>
            {
                Items = dtos,
                TotalCount = count,
            };
        }
    }
}
