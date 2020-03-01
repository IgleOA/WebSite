using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace ET
{
    public class EventTypes
    {
        [Key]
        public int EventTypeID { get; set; }

        [Display(Name ="Tipo de Evento")]
        public string EventTypeName { get; set; }

        public string ThemeColor { get; set; }
    }
}
