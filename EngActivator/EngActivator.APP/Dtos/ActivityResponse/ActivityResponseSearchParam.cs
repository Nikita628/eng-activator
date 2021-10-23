using EngActivator.APP.Shared.Dtos;
using System;
using System.Collections.Generic;
using System.Text;

namespace EngActivator.APP.Dtos
{
    public class  ActivityResponseSearchParam : PageRequest
    {
        public DateTime? CreatedDateEquals { get; set; }
    }
}
