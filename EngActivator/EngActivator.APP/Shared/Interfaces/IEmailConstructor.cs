using EngActivator.APP.Shared.Models;

namespace EngActivator.APP.Shared.Interfaces
{
    public interface IEmailConstructor
    {
        public Email ConstructSignupEmail(string emailTo, string userName, string emailConfirmationToken);
        Email ConstructResetPasswordEmail(string emailTo, string userName, string resetPasswordToken);
    }
}
