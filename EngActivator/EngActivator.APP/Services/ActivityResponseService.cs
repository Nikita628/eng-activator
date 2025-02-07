﻿using AutoMapper;
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
        private readonly IHttpContextService _http;

        public ActivityResponseService(EngActivatorContext db, IMapper m, IHttpContextService c)
        {
            _db = db;
            _mapper = m;
            _http = c;
        }

        public async Task<int> CreateAsync(ActivityResponseForCreate dto)
        {
            var entity = _mapper.Map<DataBase.Entities.ActivityResponse>(dto);

            var now = DateTime.UtcNow;

            entity.CreatedDate = now;
            entity.LastUpdatedDate = now;
            entity.CreatedById = _http.CurrentUserId;

            await _db.ActivityResponses.AddAsync(entity);

            await _db.SaveChangesAsync();

            return entity.Id;
        }

        public async Task<ActivityResponseForDetails> GetForDetailsAsync(int id)
        {
            var query =
                from ar in _db.ActivityResponses
                where ar.Id == id
                select new ActivityResponseForDetails
                {
                    Id = ar.Id,
                    Activity = ar.Activity,
                    ActivityTypeId = (ActivityTypeEnum)ar.ActivityTypeId,
                    Answer = ar.Answer,
                };

            var dto = await query.AsNoTracking().FirstOrDefaultAsync();

            if (dto is null)
            {
                throw new AppNotFoundException($"Activity response with id {id} was not found");
            }

            var averageScore = await (from arr in _db.ActivityResponseReviews
                                      where arr.ActivityResponseId == id
                                      select arr.Score).DefaultIfEmpty().AverageAsync();

            dto.Score = averageScore;

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
                                                      where arr.CreatedById == _http.CurrentUserId && arr.ActivityResponseId == ar.Id
                                                      select arr.Id).Any()

                let isCreatedByCurrentUser = ar.CreatedById == _http.CurrentUserId

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

            if (dto == null)
            {
                throw new AppNotFoundException("Activity for review not found");
            }

            return dto;
        }

        public async Task<KeysetPageResponse<ActivityResponseForPreview>> SearchForPreviewAsync(ActivityResponseSearchParam searchParam)
        {
            return new KeysetPageResponse<ActivityResponseForPreview>
            {
                HasMoreItems = await GetCount(searchParam) > searchParam.PageSize,
                Items = await GetItems(searchParam),
            };
        }

        private async Task<int> GetCount(ActivityResponseSearchParam searchParam)
        {
            var countQuery = _db.ActivityResponses
                .AsNoTracking()
                .Where(ar => ar.CreatedById == _http.CurrentUserId);

            if (searchParam.CreatedDateEquals.HasValue)
            {
                DateTime dateFrom = searchParam.CreatedDateEquals.Value.Date.AddMinutes(-_http.UtcOffset);
                DateTime dateTo = searchParam.CreatedDateEquals.Value.Date.AddDays(1);

                countQuery = countQuery.Where(ar => ar.CreatedDate >= dateFrom && ar.CreatedDate < dateTo);
            }

            if (searchParam.LastUpdatedDateLessThan.HasValue)
            {
                var lastUpdatedDateLessThan = searchParam.LastUpdatedDateLessThan.Value.AddMinutes(-_http.UtcOffset);
                countQuery = countQuery.Where(ar => ar.LastUpdatedDate < lastUpdatedDateLessThan);
            }

            return await countQuery.CountAsync();
        }

        private async Task<List<ActivityResponseForPreview>> GetItems(ActivityResponseSearchParam searchParam)
        {
            var dateFrom = DateTime.MinValue;
            var dateTo = DateTime.MaxValue;
            var lastUpdatedDateLessThan = DateTime.MaxValue;

            if (searchParam.CreatedDateEquals.HasValue)
            {
                dateFrom = searchParam.CreatedDateEquals.Value.Date.AddMinutes(-_http.UtcOffset);
                dateTo = searchParam.CreatedDateEquals.Value.Date.AddDays(1);
            }

            if (searchParam.LastUpdatedDateLessThan.HasValue)
            {
                lastUpdatedDateLessThan = searchParam.LastUpdatedDateLessThan.Value.AddMinutes(-_http.UtcOffset);
            }

            var searchQuery =
                from ar in _db.ActivityResponses

                let hasUnreadReviews = (from review in _db.ActivityResponseReviews
                                        where review.ActivityResponseId == ar.Id && !review.IsViewed
                                        select review.Id).Any()

                where (ar.CreatedById == _http.CurrentUserId)
                    && (!searchParam.CreatedDateEquals.HasValue || (ar.CreatedDate >= dateFrom && ar.CreatedDate < dateTo))
                    && (!searchParam.LastUpdatedDateLessThan.HasValue || (ar.LastUpdatedDate < lastUpdatedDateLessThan))

                orderby ar.LastUpdatedDate descending

                select new ActivityResponseForPreview
                {
                    Id = ar.Id,
                    Answer = ar.Answer,
                    ActivityTypeId = (Shared.Enums.ActivityTypeEnum)ar.ActivityTypeId,
                    CreatedDate = ar.CreatedDate,
                    HasUnreadReviews = hasUnreadReviews,
                    LastUpdatedDate = ar.LastUpdatedDate,
                };

            var items = await searchQuery
                .AsNoTracking()
                .Take(searchParam.PageSize)
                .ToListAsync();

            return items;
        }
    }
}
