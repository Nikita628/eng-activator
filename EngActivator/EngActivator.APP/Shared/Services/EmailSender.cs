﻿using EngActivator.APP.Shared.Interfaces;
using EngActivator.APP.Shared.Models;
using EngActivator.APP.Shared.Models.Settings;
using MailKit.Net.Smtp;
using MailKit.Security;
using Microsoft.Extensions.Options;
using MimeKit;
using System.IO;
using System.Threading.Tasks;

namespace EngActivator.APP.Shared.Services
{
    public class EmailSender : IEmailSender
    {
        private const string LogoImageContentId = "logo";

        private readonly MailSettings _mailSettings;

        public EmailSender(IOptions<MailSettings> mailSettings)
        {
            _mailSettings = mailSettings.Value;
        }

        public async Task SendEmailAsync(Email emailDto)
        {
            var email = new MimeMessage
            {
                Sender = MailboxAddress.Parse(_mailSettings.Mail)
            };
            email.To.Add(MailboxAddress.Parse(emailDto.To));
            email.Subject = emailDto.Subject;
            email.From.Add(MailboxAddress.Parse(_mailSettings.Mail));

            var builder = new BodyBuilder
            {
                HtmlBody = emailDto.Body
            };

            var logoImage = builder.LinkedResources.Add(GetLogoPath());
            logoImage.ContentId = LogoImageContentId;

            email.Body = builder.ToMessageBody();

            using var smtp = new SmtpClient();
            smtp.CheckCertificateRevocation = false;
            smtp.Connect(_mailSettings.Host, _mailSettings.Port);
            smtp.Authenticate(_mailSettings.Mail, _mailSettings.Password);
            await smtp.SendAsync(email);
            smtp.Disconnect(true);
        }

        private string GetLogoPath()
        {
            string fullPath = System.Reflection.Assembly.GetAssembly(typeof(EmailSender)).Location;
            string theDirectory = Path.GetDirectoryName(fullPath);
            string filePath = Path.Combine(theDirectory, "Files", "logo.png");
            return filePath;
        }
    }
}
