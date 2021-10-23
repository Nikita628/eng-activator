using System.Collections.Generic;

namespace EngActivator.APP.Dtos
{
    public class DictionaryResponse
    {
        public List<DictionaryEntry> DictionaryEntries { get; set; } = new List<DictionaryEntry>();
        public List<string> Recommendations { get; set; } = new List<string>();
    }
}
