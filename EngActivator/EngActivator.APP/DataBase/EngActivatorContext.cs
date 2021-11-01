using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace EngActivator.APP.DataBase
{
    public class EngActivatorContext : DbContext
    {
        public static readonly ILoggerFactory _loggerFactory = LoggerFactory.Create(builder => { builder.AddConsole(); });

        public EngActivatorContext(DbContextOptions<EngActivatorContext> opts) : base(opts)
        {
            
        }

        #region For Package Manager Console (need this at design time)
        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            optionsBuilder
                .UseLoggerFactory(_loggerFactory)
                .UseSqlServer("Server=(localdb)\\mssqllocaldb;Database=eng_activator;Trusted_Connection=True");

            base.OnConfiguring(optionsBuilder);
        }
        #endregion

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            // activity response
            modelBuilder.Entity<Entities.ActivityResponse>()
                .Property(a => a.Answer)
                .IsRequired()
                .HasMaxLength(1000);

            modelBuilder.Entity<Entities.ActivityResponse>()
                .Property(a => a.Activity)
                .IsRequired();

            modelBuilder.Entity<Entities.ActivityResponse>()
                .HasIndex(a => a.ReviewsCount);

            modelBuilder.Entity<Entities.ActivityResponse>()
                .HasIndex(a => a.LastUpdatedDate);

            modelBuilder.Entity<Entities.ActivityResponse>()
                .HasOne(a => a.CreatedBy)
                .WithMany(u => u.ActivityResponses)
                .HasForeignKey(a => a.CreatedById)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<Entities.ActivityResponse>()
                .HasOne(a => a.ActivityType)
                .WithMany(a => a.ActivityResponses)
                .HasForeignKey(a => a.ActivityTypeId)
                .OnDelete(DeleteBehavior.Restrict);

            // activity response review
            modelBuilder.Entity<Entities.ActivityResponseReview>()
                .Property(a => a.Text)
                .IsRequired()
                .HasMaxLength(1000);

            modelBuilder.Entity<Entities.ActivityResponseReview>()
                .HasOne(a => a.CreatedBy)
                .WithMany(u => u.ActivityResponseReviews)
                .HasForeignKey(a => a.CreatedById)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<Entities.ActivityResponseReview>()
                .HasOne(a => a.ActivityResponse)
                .WithMany(a => a.ActivityResponseReviews)
                .HasForeignKey(a => a.ActivityResponseId)
                .OnDelete(DeleteBehavior.Restrict);

            // activity type
            modelBuilder.Entity<Entities.ActivityType>()
               .Property(a => a.Name)
               .IsRequired()
               .HasMaxLength(100);

            modelBuilder.Entity<Entities.ActivityType>()
              .Property(a => a.Id)
              .ValueGeneratedNever();

            // user
            modelBuilder.Entity<Entities.AppUser>()
                .Property(u => u.Name)
                .IsRequired()
                .HasMaxLength(200);
        }

        public DbSet<Entities.ActivityResponse> ActivityResponses { get; set; }
        public DbSet<Entities.ActivityResponseReview> ActivityResponseReviews { get; set; }
        public DbSet<Entities.ActivityType> ActivityTypes { get; set; }
        public DbSet<Entities.AppUser> Users { get; set; }
    }
}
