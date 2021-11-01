namespace EngActivator.APP.Shared.Interfaces
{
    public interface IHttpContextService
    {
        public int CurrentUserId { get; }
        public int UtcOffset { get;  }
    }
}
