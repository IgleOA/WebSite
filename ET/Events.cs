using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace ET
{
    public class Events
    {
        [Key]
        public int EventID { get; set; }

        [Required(ErrorMessage = "Este campo es obligatorio")]
        public int EventTypeID { get; set; }

        [Required(ErrorMessage = "Este campo es obligatorio")]
        [Display(Name ="Titulo")]
        public string Subject { get; set; }

        [Required(ErrorMessage = "Este campo es obligatorio")]
        [Display(Name ="Descripción")]
        public string Description { get; set; }

        [Display(Name ="Fecha de Inicio")]
        [DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:yyyy/MM/dd}")]
        [DataType(DataType.Date, ErrorMessage = "Esta campo debe contener una fecha valida")]
        public DateTime StartDate { get; set; }

        public string SDate { get; set; }

        [Display(Name ="Fecha de Termino")]
        [DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:yyyy/MM/dd}")]
        [DataType(DataType.Date, ErrorMessage = "Esta campo debe contener una fecha valida")]
        public Nullable<System.DateTime> EndDate { get; set; }

        [Display(Name ="Dia Completo")]
        public bool IsFullDay { get; set; }

        public List<EventTypes> EventList { get; set; }

        public EventTypes EventTypeData { get; set; }

        public Events()
        {
            EventTypeData = new EventTypes();
        }

    }
}
