using EngActivator.APP.Dtos;
using System.Threading.Tasks;

namespace EngActivator.APP.Interfaces
{
    public interface IAuthService
    {
        Task<UserAuthResult> LoginAsync(LoginData loginData);
        Task SignupAsync(SignupData signupData);
        Task DeleteUserAsync(string email);
        Task<bool> ConfirmEmailAsync(string email, string emailConfirmationToken);
    }
}
