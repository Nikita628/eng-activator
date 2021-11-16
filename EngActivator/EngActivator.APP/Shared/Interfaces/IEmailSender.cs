using System.Threading.Tasks;

namespace EngActivator.APP.Shared.Interfaces
{
    public interface IEmailSender
    {
        Task SendEmailAsync(Shared.Dtos.Email emailDto);
    }
}
