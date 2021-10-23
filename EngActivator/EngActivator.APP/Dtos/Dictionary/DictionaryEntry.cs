using System.Collections.Generic;

namespace EngActivator.APP.Dtos
{
    public class DictionaryEntry
    {
        public string Word { get; set; }
        public string PartOfSpeech { get; set; }
        public string Transcript { get; set; }
        public List<string> Meanings { get; set; } = new List<string>();
        public string Details { get; set; }
        public List<string> Examples { get; set; } = new List<string>();
    }
}
