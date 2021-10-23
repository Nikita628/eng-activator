using AutoMapper;
using EngActivator.APP.DataBase;
using EngActivator.APP.Dtos;
using EngActivator.APP.Interfaces;
using EngActivator.APP.Shared.Dtos;
using EngActivator.APP.Shared.Enums;
using EngActivator.APP.Shared.Exceptions;
using EngActivator.APP.Shared.Interfaces;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace EngActivator.APP.Services
{
    public class ActivityResponseService : IActivityResponseService
    {
        private readonly EngActivatorContext _db;
        private readonly IMapper _mapper;
        private readonly ICurrentUserService _currentUser;

        public ActivityResponseService(EngActivatorContext db, IMapper m, ICurrentUserService c)
        {
            _db = db;
            _mapper = m;
            _currentUser = c;
        }

        public async Task<int> CreateAsync(ActivityResponseForCreate dto)
        {
            var entity = _mapper.Map<DataBase.Entities.ActivityResponse>(dto);

            entity.CreatedDate = DateTime.UtcNow;
            entity.CreatedById = _currentUser.CurrentUserId;

            await _db.ActivityResponses.AddAsync(entity);

            await _db.SaveChangesAsync();

            return entity.Id;
        }

        public async Task<ActivityResponseForDetails> GetForDetailsAsync(int id)
        {
            var query =
                from ar in _db.ActivityResponses
                let averageScore = (from arr in _db.ActivityResponseReviews
                                    where arr.ActivityResponseId == id
                                    select arr.Score).Average()
                where ar.Id == id
                select new ActivityResponseForDetails
                {
                    Id = ar.Id,
                    Score = averageScore,
                    Activity = ar.Activity,
                    ActivityTypeId = (ActivityTypeEnum)ar.ActivityTypeId,
                    Answer = ar.Answer,
                };

            var dto = await query.AsNoTracking().FirstOrDefaultAsync();

            if (dto is null)
            {
                throw new AppNotFoundException($"Activity response with id {id} was not found");
            }

            return dto;
        }

        /// <summary>
        /// Get an anctivity response which has a smallest number of reviews
        /// and not created by the current user, and not already reviewd by the current user
        /// </summary>
        /// <returns></returns>
        public async Task<ActivityResponseForReview> GetForReviewAsync()
        {
            var leastReviewed_notCreatedByUser_notAlreadyReviewedByUser =
                from ar in _db.ActivityResponses

                let isAlreadyReviewedByCurrentUser = (from arr in _db.ActivityResponseReviews
                                                      where arr.CreatedById == _currentUser.CurrentUserId && arr.ActivityResponseId == ar.Id
                                                      select arr.Id).Any()

                let isCreatedByCurrentUser = ar.CreatedById != _currentUser.CurrentUserId

                where !isAlreadyReviewedByCurrentUser && !isCreatedByCurrentUser
                orderby ar.ReviewsCount ascending
                select new ActivityResponseForReview
                {
                    Activity = ar.Activity,
                    ActivityTypeId = (ActivityTypeEnum)ar.ActivityTypeId,
                    Answer = ar.Answer,
                    CreatedBy = new User
                    {
                        Id = ar.CreatedBy.Id,
                        Name = ar.CreatedBy.Name,
                    },
                    Id = ar.Id,
                };

            var dto = await leastReviewed_notCreatedByUser_notAlreadyReviewedByUser
                .AsNoTracking()
                .FirstOrDefaultAsync();

            return dto;
        }

        public async Task<PageResponse<ActivityResponseForPreview>> SearchForPreviewAsync(ActivityResponseSearchParam searchParam)
        {
            return new PageResponse<ActivityResponseForPreview>
            {
                TotalCount = await GetCount(searchParam),
                Items = await GetItems(searchParam),
            };
        }

        private async Task<int> GetCount(ActivityResponseSearchParam searchParam)
        {
            var countQuery = _db.ActivityResponses
                .AsNoTracking()
                .Where(ar => ar.CreatedById == _currentUser.CurrentUserId);

            if (searchParam.CreatedDateEquals.HasValue)
            {
                countQuery = countQuery.Where(ar =>
                    ar.CreatedDate.Year == searchParam.CreatedDateEquals.Value.Year
                    && ar.CreatedDate.Month == searchParam.CreatedDateEquals.Value.Month
                    && ar.CreatedDate.Day == searchParam.CreatedDateEquals.Value.Day);
            }

            return await countQuery.CountAsync();
        }

        private async Task<List<ActivityResponseForPreview>> GetItems(ActivityResponseSearchParam searchParam)
        {
            var searchQuery =
                from ar in _db.ActivityResponses

                let hasUnreadReviews = (from review in _db.ActivityResponseReviews
                                        where review.ActivityResponseId == ar.Id && !review.IsViewed
                                        select review.Id).Any()

                where (!searchParam.CreatedDateEquals.HasValue
                    || (ar.CreatedDate.Year == searchParam.CreatedDateEquals.Value.Year
                        && ar.CreatedDate.Month == searchParam.CreatedDateEquals.Value.Month
                        && ar.CreatedDate.Day == searchParam.CreatedDateEquals.Value.Day))
                        && ar.CreatedById == _currentUser.CurrentUserId

                orderby ar.Id, hasUnreadReviews descending

                select new ActivityResponseForPreview
                {
                    Id = ar.Id,
                    Answer = ar.Answer,
                    ActivityTypeId = (Shared.Enums.ActivityTypeEnum)ar.ActivityTypeId,
                    CreatedDate = ar.CreatedDate,
                    HasUnreadReviews = hasUnreadReviews
                };

            return await searchQuery
                .AsNoTracking()
                .Skip((searchParam.PageNumber - 1) * searchParam.PageSize)
                .Take(searchParam.PageSize)
                .ToListAsync();
        }
    }
}
