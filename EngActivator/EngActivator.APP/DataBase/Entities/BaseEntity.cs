using System;

namespace EngActivator.APP.DataBase.Entities
{
    public class BaseEntity
    {
        public int Id { get; set; }
        public DateTime CreatedDate { get; set; }
        public int CreatedById { get; set; }
        public AppUser CreatedBy { get; set; }
    }
}
