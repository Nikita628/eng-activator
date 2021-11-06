using System.Collections.Generic;

namespace EngActivator.APP.Shared.Dtos
{
    public class KeysetPageResponse<T>
    {
        public List<T> Items { get; set; } = new List<T>();
        public bool HasMoreItems { get; set; }
    }
}
