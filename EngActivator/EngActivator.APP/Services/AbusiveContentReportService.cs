using EngActivator.APP.DataBase;
using EngActivator.APP.Dtos;
using EngActivator.APP.Interfaces;
using EngActivator.APP.Shared.Interfaces;
using System;
using System.Threading.Tasks;

namespace EngActivator.APP.Services
{
    public class AbusiveContentReportService : IAbusiveContentReportService
    {
        private readonly EngActivatorContext _db;
        private readonly IHttpContextService _http;

        public AbusiveContentReportService(EngActivatorContext db, IHttpContextService c)
        {
            _db = db;
            _http = c;
        }

        public async Task CreateAsync(AbusiveContentReport dto)
        {
            var entity = new DataBase.Entities.AbusiveContentReport
            {
                CreatedById = _http.CurrentUserId,
                CreatedDate = DateTime.UtcNow,
                Report = dto.Report,
            };

            _db.AbusiveContentReports.Add(entity);

            await _db.SaveChangesAsync();
        }
    }
}
