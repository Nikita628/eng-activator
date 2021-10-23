namespace EngActivator.APP.Shared.Dtos
{
    public class PageRequest
    {
        public int PageNumber { get; set; } = 1;
        public int PageSize { get; set; } = 10;
        public string SortProp { get; set; } = "id";
        public string SortDirection { get; set; } = "asc";
    }
}
