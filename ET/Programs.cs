using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace ET
{
    public class Programs
    {
        [Key]
        public int ProgramID { get; set; }

        [Required(ErrorMessage ="Este campo es obligatorio")]
        [Display(Name ="Fecha")]
        [DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:yyyy/MM/dd}")]
        [DataType(DataType.Date, ErrorMessage ="Esta campo debe contener una fecha valida")]
        public DateTime ProgramDate { get; set; }

        //[Required(ErrorMessage ="Este campo es obligratorio")]
        [Display(Name ="Horario")]
        public string ProgramSchedule { get; set; }

        [Display(Name ="Estado")]
        public bool CompleteFlag { get; set; }

        public bool ActiveFlag { get; set; }

        public DateTime? NotificationDate { get; set; } 

        public List<string> PSchedules()
        {
            return new List<string>
            {
                "7:30 AM",
                "10:00 AM",
                "7:00 PM"
            };            
        }
    }
}
