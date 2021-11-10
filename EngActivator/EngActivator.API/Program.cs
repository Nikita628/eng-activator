using EngActivator.API.Utils;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Hosting;
using System.Collections.Generic;
using System.IO;
using System.Threading.Tasks;

namespace EngActivator.API
{
    public class Program
    {
        public static async Task Main(string[] args)
        {
            var host = CreateHostBuilder(args).Build();

            await DbSeeder.MigrateAndSeedDb(host);

            //var files = Directory.GetFiles("StaticFiles/wordPics");

            //var res = new List<string>();

            //foreach (var f in files)
            //{
            //    res.Add(@"<None Update=""StaticFiles\wordPics\" + Path.GetFileName(f) + "\">\n"+ 
            //                "<CopyToOutputDirectory>Always</CopyToOutputDirectory>\n" +
            //        "</None>");
            //}

            //string resa = string.Join('\n', res.ToArray());

            host.Run();

            
        }

        public static IHostBuilder CreateHostBuilder(string[] args) =>
            Host.CreateDefaultBuilder(args)
                .ConfigureWebHostDefaults(webBuilder =>
                {
                    webBuilder.UseStartup<Startup>();
                });
    }
}
