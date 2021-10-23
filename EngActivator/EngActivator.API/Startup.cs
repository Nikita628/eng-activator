using EngActivator.API.Middleware;
using EngActivator.APP.DataBase;
using EngActivator.APP.DataBase.Entities;
using EngActivator.APP.Interfaces;
using EngActivator.APP.MapperProfiles;
using EngActivator.APP.Services;
using EngActivator.APP.Shared.Dtos;
using EngActivator.APP.Shared.Interfaces;
using EngActivator.APP.Shared.Services;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.IdentityModel.Tokens;
using System.Linq;
using System.Text;

namespace EngActivator.API
{
    public class Startup
    {
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            services.AddControllers();

            services.AddScoped<IActivityResponseService, ActivityResponseService>();
            services.AddScoped<IActivityResponseReviewService, ActivityResponseReviewService>();
            services.AddScoped<IAuthService, AuthService>();
            services.AddScoped<ICurrentUserService, CurrentUserService>();
            services.AddScoped<IDictionaryService, DictionaryService>();
            services.AddSingleton(typeof(AppDictionary), new AppDictionary());

            services.AddAutoMapper(typeof(ActivityResponseProfile));

            services.AddDbContext<EngActivatorContext>(
                x => x.UseSqlServer(Configuration.GetConnectionString("DefaultConnection"))
            );

            // identity
            var builder = services.AddIdentityCore<AppUser>(o => {
                o.Password.RequiredLength = 6;
                o.Password.RequireNonAlphanumeric = false;
                o.Password.RequireUppercase = false;
                o.Password.RequireLowercase = false;
                o.Password.RequireDigit = false;
            });
            builder = new IdentityBuilder(builder.UserType, builder.Services);
            builder.AddEntityFrameworkStores<EngActivatorContext>();
            builder.AddSignInManager<SignInManager<AppUser>>();
            services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
                .AddJwtBearer(opts =>
                {
                    opts.TokenValidationParameters = new TokenValidationParameters
                    {
                        ValidateIssuerSigningKey = true,
                        IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(Configuration["Token:Key"])),
                        ValidIssuer = Configuration["Token:Issuer"],
                        ValidateIssuer = true,
                        ValidateAudience = false,
                    };
                });

            // validation
            services.Configure<ApiBehaviorOptions>(opts =>
            {
                opts.InvalidModelStateResponseFactory = ctx =>
                {
                    var errors = ctx.ModelState
                        .Where(err => err.Value.Errors.Any())
                        .SelectMany(x => x.Value.Errors)
                        .Select(x => x.ErrorMessage)
                        .ToList();

                    var errorResponse = new ErrorResponse(errors.FirstOrDefault());

                    return new BadRequestObjectResult(errorResponse);
                };
            });

            // cors
            services.AddCors(opts =>
            {
                opts.AddPolicy("CorsPolicy", policy =>
                {
                    policy.AllowAnyHeader().AllowAnyMethod().WithOrigins(Configuration["ApiUrl"]);
                });
            });
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            app.UseMiddleware<ErrorHandler>();

            app.UseStatusCodePagesWithReExecute("/error/{0}");

            app.UseHttpsRedirection();

            app.UseRouting();

            app.UseCors("CorsPolicy");

            app.UseAuthentication();

            app.UseAuthorization();

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllers();
            });
        }
    }
}
