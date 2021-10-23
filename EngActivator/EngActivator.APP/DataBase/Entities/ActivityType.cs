using System.Collections.Generic;

namespace EngActivator.APP.DataBase.Entities
{
    public class ActivityType
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public List<ActivityResponse> ActivityResponses { get; set; }
    }
}
