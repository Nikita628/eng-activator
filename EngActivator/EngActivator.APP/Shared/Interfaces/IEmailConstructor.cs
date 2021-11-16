namespace EngActivator.APP.Shared.Interfaces
{
    public interface IEmailConstructor
    {
        public Shared.Dtos.Email ConstructSignupEmail(string to, string userName, string emailConfirmationToken);
    }
}
