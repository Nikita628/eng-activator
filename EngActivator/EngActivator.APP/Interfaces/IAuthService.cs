using EngActivator.APP.Dtos;
using System.Threading.Tasks;

namespace EngActivator.APP.Interfaces
{
    public interface IAuthService
    {
        Task<UserAuthResult> LoginAsync(LoginData loginData);
        Task<UserAuthResult> SignupAsync(SignupData signupData);
        Task<bool> IsEmailExistsAsync(string email);
    }
}
