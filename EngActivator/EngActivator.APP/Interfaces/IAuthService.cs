using EngActivator.APP.Dtos;
using EngActivator.APP.Dtos.Auth;
using System.Threading.Tasks;

namespace EngActivator.APP.Interfaces
{
    public interface IAuthService
    {
        Task<UserAuthResult> LoginAsync(LoginData loginData);
        Task SignupAsync(SignupData signupData);
        Task DeleteUserAsync(string email);
        Task<bool> ConfirmEmailAsync(string email, string emailConfirmationToken);
        Task SendResetPasswordEmailAsync(ResetPasswordDto dto);
        Task<bool> ResetPasswordAsync(string email, string token, string password);
    }
}
