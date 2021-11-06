using EngActivator.APP.Shared.Dtos;
using System;

namespace EngActivator.APP.Dtos
{
    public class  ActivityResponseSearchParam : KeysetPageRequest
    {
        public DateTime? CreatedDateEquals { get; set; }
        public DateTime? LastUpdatedDateLessThan { get; set; }
    }
}
