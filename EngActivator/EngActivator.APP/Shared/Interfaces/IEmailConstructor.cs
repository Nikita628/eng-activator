using EngActivator.APP.Shared.Models;

namespace EngActivator.APP.Shared.Interfaces
{
    public interface IEmailConstructor
    {
        public Email ConstructSignupEmail(string to, string userName, string emailConfirmationToken);
    }
}
