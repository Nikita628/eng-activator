using EngActivator.APP.Shared.Interfaces;
using EngActivator.APP.Shared.Models;
using EngActivator.APP.Shared.Models.Settings;
using Microsoft.Extensions.Options;
using System;
using System.IO;
using System.Text;
using System.Web;

namespace EngActivator.APP.Shared.Services
{
    public class EmailConstructor : IEmailConstructor
    {
        private const string USER_NAME = "_USER_NAME_";
        private const string CONFIRMATION_LINK = "_CONFIRMATION_LINK_";
        private const string RESET_PASSWORD_LINK = "_RESET_PASSWORD_LINK_";
        private const string YEAR = "_YEAR_";
        private const string SignupSubject = "Exenge Registration";

        private readonly AppSettings _appSettings;

        public EmailConstructor(IOptions<AppSettings> settings)
        {
            _appSettings = settings.Value;
        }

        public Email ConstructSignupEmail(string emailTo, string userName, string emailConfirmationToken)
        {
            var email = new Email
            {
                To = emailTo,
            };

            var confirmationLink = $"{_appSettings.ApiUrl}/api/auth/confirm-email?email={HttpUtility.UrlEncode(emailTo)}&token={HttpUtility.UrlEncode(emailConfirmationToken)}";
            var templateText = new StringBuilder(GetEmailTemplateText("signupEmail.html"));
            templateText.Replace(USER_NAME, userName);
            templateText.Replace(CONFIRMATION_LINK, confirmationLink);
            templateText.Replace(YEAR, DateTime.UtcNow.Year.ToString());

            email.Body = templateText.ToString();
            email.Subject = SignupSubject;

            return email;
        }

        public Email ConstructResetPasswordEmail(string emailTo, string userName, string resetPasswordToken)
        {
            var email = new Email
            {
                To = emailTo,
            };

            var resetPasswordLink = $"{_appSettings.ApiUrl}/api/auth/reset-password?email={HttpUtility.UrlEncode(emailTo)}&token={HttpUtility.UrlEncode(resetPasswordToken)}";
            var templateText = new StringBuilder(GetEmailTemplateText("signupEmail.html"));
            templateText.Replace(USER_NAME, userName);
            templateText.Replace(RESET_PASSWORD_LINK, resetPasswordLink);
            templateText.Replace(YEAR, DateTime.UtcNow.Year.ToString());

            email.Body = templateText.ToString();
            email.Subject = SignupSubject;

            return email;
        }

        private string GetEmailTemplateText(string templateName)
        {
            string fullPath = System.Reflection.Assembly.GetAssembly(typeof(EmailConstructor)).Location;
            string theDirectory = Path.GetDirectoryName(fullPath);
            string filePath = Path.Combine(theDirectory, "Files", "Templates", templateName);
            return System.IO.File.ReadAllText(filePath);
        }
    }
}
