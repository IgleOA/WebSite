using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace ET
{
    public class Agenda
    {
        [Key]
        public int EventID { get; set; }
        
        public int DayofMonth { get; set; }

        public string DayofWeek { get; set; }

        [Display(Name ="Fecha")]
        public string Date { get; set; }

        [Display(Name ="Hora")]
        public string Time { get; set; }

        [Display(Name ="Tipo")]
        public string EventType { get; set; }

        [Display(Name ="Titulo")]
        public string Title { get; set; }

        [Display(Name ="Detalle")]
        public string Description { get; set; }
    }
}
