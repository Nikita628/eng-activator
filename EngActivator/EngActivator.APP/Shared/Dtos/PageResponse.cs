using System.Collections.Generic;

namespace EngActivator.APP.Shared.Dtos
{
    public class PageResponse<T>
    {
        public int TotalCount { get; set; }
        public List<T> Items { get; set; }
    }
}
