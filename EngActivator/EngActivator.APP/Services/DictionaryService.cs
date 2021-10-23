using EngActivator.APP.DataBase;
using EngActivator.APP.Dtos;
using EngActivator.APP.Interfaces;
using System.Threading.Tasks;

namespace EngActivator.APP.Services
{
    public class DictionaryService : IDictionaryService
    {
        private readonly EngActivatorContext _db;
        private readonly AppDictionary _dict;

        public DictionaryService(EngActivatorContext c, AppDictionary dict)
        {
            _db = c;
            _dict = dict;
        }

        public async Task<DictionaryResponse> SearchAsync(DictionarySearchParam param)
        {
            var dictResult = await Task.Run(() => _dict.SearchWord(param.SearchTerm));

            return dictResult;
        }
    }
}
