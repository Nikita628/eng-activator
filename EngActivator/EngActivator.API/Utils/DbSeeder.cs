using EngActivator.APP.DataBase;
using EngActivator.APP.DataBase.Entities;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using Newtonsoft.Json.Serialization;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;

namespace EngActivator.API.Utils
{
    class QuestionActivity
    {
        public string Question { get; set; }
        public List<object> WordEntries { get; set; }
    }

    class PictureActivity
    {
        public string PicUrl { get; set; }
        public List<object> WordEntries { get; set; }
    }

    class ActivityWrapper
    {
        public int Type { get; set; }
        public object Activity { get; set; }
    }

    public class DbSeeder
    {
        private static readonly Random _rand = new Random();
        private static readonly JsonSerializerSettings _jsonSerializerSettings = new JsonSerializerSettings
        {
            ContractResolver = new DefaultContractResolver
            {
                NamingStrategy = new CamelCaseNamingStrategy()
            }
        };

        public static async Task MigrateAndSeedDb(IHost host)
        {
            using (var scope = host.Services.CreateScope())
            {
                var services = scope.ServiceProvider;
                var loggerFactory = services.GetRequiredService<ILoggerFactory>();
                var userManager = services.GetRequiredService<UserManager<AppUser>>();
                var logger = loggerFactory.CreateLogger<Program>();

                try
                {
                    var context = services.GetRequiredService<EngActivatorContext>();

                    context.Database.Migrate();

                    await SeedUsers(userManager);

                    Seed(context);

                    logger.LogInformation("---- Migrated db successfully ----");
                }
                catch (Exception e)
                {
                    logger.LogError(e, "---- Error during migration ----");
                }
            }
        }

        private static void Seed(EngActivatorContext context)
        {
            if (!context.ActivityTypes.Any())
            {
                SeedActvityTypes(context);
            }

            if (!context.ActivityResponses.Any())
            {
                SeedActivityResponses(context);
            }

            if (!context.ActivityResponseReviews.Any())
            {
                SeedActivityResponseReviews(context);
            }
        }

        private static async Task SeedUsers(UserManager<AppUser> userManager)
        {
            if (!userManager.Users.Any())
            {
                for (int i = 1; i <= 20; i++)
                {
                    var user = new AppUser
                    {
                        Name = $"Seed {i}",
                        Email = $"seed_{i}@seed.com",
                        UserName = $"seed{i}",
                    };

                    await userManager.CreateAsync(user, "Welcome01!");
                }
            }
        }

        private static void SeedActvityTypes(EngActivatorContext context)
        {
            context.ActivityTypes.Add(new ActivityType
            {
                Id = (int)APP.Shared.Enums.ActivityTypeEnum.Picture,
                Name = "Picture",
            });

            context.ActivityTypes.Add(new ActivityType
            {
                Id = (int)APP.Shared.Enums.ActivityTypeEnum.Question,
                Name = "Question",
            });

            context.SaveChanges();
        }

        private static void SeedActivityResponses(EngActivatorContext context)
        {
            string fullPath = System.Reflection.Assembly.GetAssembly(typeof(Program)).Location;
            string theDirectory = Path.GetDirectoryName(fullPath);
            string filePath = Path.Combine(theDirectory, "Files", "seed.json");
            var seedDataText = System.IO.File.ReadAllText(filePath);
            var activities = JsonConvert.DeserializeObject<List<ActivityWrapper>>(seedDataText);

            var users = context.Users.ToList();

            for (int i = 0; i < 500; i++)
            {
                context.ActivityResponses.Add(new ActivityResponse
                {
                    CreatedDate = DateTime.UtcNow.AddDays(-_rand.Next(5)),
                    Answer = "Woody equal ask saw sir weeks aware decay. Entrance prospect removing we packages strictly is no " +
                    "smallest he. For hopes may chief get hours day rooms. Oh no turned behind polite piqued enough at. " +
                    "Forbade few through inquiry blushes you. Cousin no itself eldest it in dinner latter missed no. " +
                    "Boisterous estimating interested collecting get conviction friendship say boy. Him mrs shy article " +
                    "smiling respect opinion excited. Welcomed humoured rejoiced peculiar to in an.Woody equal ask saw" +
                    " sir weeks aware decay. Entrance prospect removing we packages strictly is no smallest he. For hopes " +
                    "may chief get hours day rooms. Oh no turned behind polite piqued enough at. Forbade few through inquiry " +
                    "blushes you. Cousin no itself eldest it in dinner latter missed no.",
                    Activity = JsonConvert.SerializeObject(activities[_rand.Next(activities.Count)].Activity, _jsonSerializerSettings),
                    ActivityTypeId = (int)APP.Shared.Enums.ActivityTypeEnum.Question,
                    CreatedById = users[_rand.Next(users.Count)].Id,
                });
            }
            
            context.SaveChanges();
        }

        private static void SeedActivityResponseReviews(EngActivatorContext context)
        {
            var activityResponses = context.ActivityResponses
                .Include(ar => ar.ActivityResponseReviews)
                .ToList();

            var users = context.Users.ToList();

            for (int i = 0; i < 9000; i++)
            {
                var review = new ActivityResponseReview
                {
                    CreatedDate = DateTime.UtcNow,
                    Text = "Woody equal ask saw sir weeks aware decay. Entrance prospect removing we packages " +
                    "strictly is no smallest he. For hopes may chief get hours day rooms. Oh no turned behind " +
                    "polite piqued enough at. Forbade few through inquiry blushes you.",
                    Score = _rand.Next(5) + 0.5,
                    CreatedById = users[_rand.Next(users.Count)].Id,
                };

                // get least reviewd activity, which is not created by the current user and not already reviewed by the current user
                var activityResponse = activityResponses
                    .Where(ar => ar.CreatedById != review.CreatedById 
                        && !ar.ActivityResponseReviews.Any(arr => arr.CreatedById == review.CreatedById))
                    .OrderBy(a => a.ReviewsCount)
                    .FirstOrDefault();

                if (activityResponse != null)
                {
                    review.ActivityResponseId = activityResponse.Id;
                    activityResponse.ReviewsCount++;
                    activityResponse.ActivityResponseReviews.Add(review);
                }
            }

            context.SaveChanges();
        }
    }
}
