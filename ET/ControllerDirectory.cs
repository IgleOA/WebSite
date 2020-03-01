using System.ComponentModel.DataAnnotations;

namespace ET
{
    public class ControllerDirectory
    {
        [Key]
        public int CTRRightID { get; set; }

        [Required]
        public int ControllerID { get; set; }

        [Required]
        [Display(Name ="Controlador")]
        public string ControllerName { get; set; }

        [Required]
        [Display(Name ="Lectura")]
        public bool ReadFlag { get; set; }

        [Required]
        [Display(Name = "Escritura")]
        public bool WriteFlag { get; set; }

    }
}
