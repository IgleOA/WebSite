using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace ET
{
    public class Contact
    {
        [Required(ErrorMessage = "Este campo es obligatorio")]
        [EmailAddress(ErrorMessage = "Formato de correo invalido. Por favor ingrese un correo electrónico valido")]
        [Display(Name = "Correo electrónico")]
        public string Email { get; set; }

        [Required(ErrorMessage = "Este campo es obligatorio")]
        [Display(Name = "Mensaje")]
        public string Message { get; set; }

        public int ApplicationID { get; set; }
    }
}
