using EngActivator.APP.Dtos;
using System.Threading.Tasks;

namespace EngActivator.APP.Interfaces
{
    public interface IAbusiveContentReportService
    {
        Task CreateAsync(AbusiveContentReport dto);
    }
}
