using EngActivator.APP.Shared.Dtos.Settings;
using EngActivator.APP.Shared.Interfaces;
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
        private const string YEAR = "_YEAR_";
        private const string LOGO_URL = "_LOGO_URL_";
        private const string PASSWORD = "_PASSWORD_";
        private const string NAME = "_NAME_";
        private const string SignupSubject = "Exenge Registration";

        private readonly AppSettings _appSettings;

        public EmailConstructor(IOptions<AppSettings> settings)
        {
            _appSettings = settings.Value;
        }

        public Shared.Dtos.Email ConstructSignupEmail(string to, string userName, string emailConfirmationToken)
        {
            var email = new Dtos.Email
            {
                To = to,
            };

            var confirmationLink = $"{_appSettings.ApiUrl}/api/auth/confirm-email?email={HttpUtility.UrlEncode(to)}&token={HttpUtility.UrlEncode(emailConfirmationToken)}";
            var templateText = new StringBuilder(GetEmailTemplateText("signupEmail.html"));
            templateText.Replace(USER_NAME, userName);
            templateText.Replace(CONFIRMATION_LINK, confirmationLink);
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
