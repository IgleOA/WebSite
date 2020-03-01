using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Web;

namespace ET
{
    public class Preaches
    {
        [Key]
        [Required]
        public int PreachID { get; set; }

        [Required(ErrorMessage = "Este campo es obligatorio")]
        [Display(Name = "Ministro")]
        public int MinisterID { get; set; }

        [Display(Name = "Ministro")]
        public string MinisterName { get; set; }

        [Required(ErrorMessage = "Este campo es obligatorio")]
        [Display(Name = "Título")]
        public string Title { get; set; }

        [Display(Name = "Reseña")]
        public string Description { get; set; }

        [Display(Name = "Etiquetas")]
        public string Tags { get; set; }

        
        [Display(Name = "Archivo")]
        public byte[] FileData { get; set; }

        [Required]
        public string FileType { get; set; }

        [Required(ErrorMessage = "Por favor seleccione el archivo")]
        [DataType(DataType.Upload)]
        [Display(Name = "Archivo")]
        public HttpPostedFileBase files { get; set; }

        [Required(ErrorMessage = "Este campo es obligatorio")]
        [Display(Name = "Fecha de la Predica")]
        [DataType(DataType.Date)]
        [DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:dd/MM/yyyy}")]
        public DateTime PreachingDate { get; set; }

        public DateTime SubmittedDate { get; set; }

        public bool ActiveFlag { get; set; }

        public string ActionType { get; set; }

        public List<Ministers> MinistersList { get; set; }
    }
}
