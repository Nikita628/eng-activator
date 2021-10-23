using EngActivator.APP.Dtos;
using System.Threading.Tasks;

namespace EngActivator.APP.Interfaces
{
    public interface IDictionaryService
    {
        Task<DictionaryResponse> SearchAsync(DictionarySearchParam param);
    }
}
