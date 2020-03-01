using System.ComponentModel.DataAnnotations;

namespace ET
{
    public class Ministers
    {
        [Key]
        [Required]
        public int MinisterID { get; set; }

        [Required(ErrorMessage = "Este campo es obligatorio")]
        [Display(Name = "Nombre")]
        public string MinisterName { get; set; }

        public string ActionType { get; set; }

    }
}
