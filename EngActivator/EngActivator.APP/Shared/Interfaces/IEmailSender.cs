using EngActivator.APP.Shared.Models;
using System.Threading.Tasks;

namespace EngActivator.APP.Shared.Interfaces
{
    public interface IEmailSender
    {
        Task SendEmailAsync(Email emailDto);
    }
}
