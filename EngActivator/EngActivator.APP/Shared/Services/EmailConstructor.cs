using EngActivator.APP.Shared.Interfaces;
using System.IO;

namespace EngActivator.APP.Shared.Services
{
    public class EmailConstructor : IEmailConstructor
    {
        public Shared.Dtos.Email ConstructSignupEmail(string to, string userName)
        {
            var email = new Dtos.Email
            {
                To = to,
            };

            var templateText = GetEmailTemplateText("signupEmail.html");
            templateText = templateText.Replace("USER_NAME", userName);

            email.Body = templateText;
            email.Subject = "Exenge Registration";

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
