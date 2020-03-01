using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace ET
{
    public class Users
    {
        public string ActionType { get; set; }

        [Key]
        [Required]
        public int UserID { get; set; }

        [Required(ErrorMessage = "Este campo es obligatorio")]
        [Display(Name = "Nombre Completo")]
        public string FullName { get; set; }

        [Required(ErrorMessage = "Este campo es obligatorio")]
        [Display(Name = "Usuario")]
        public string UserName { get; set; }

        [Required(ErrorMessage = "Este campo es obligatorio")]
        [EmailAddress(ErrorMessage = "Formato de correo invalido. Por favor ingrese un correo electrónico valido")]
        [Display(Name = "Email")]
        public string Email { get; set; }

        [Required]
        [Display(Name = "Status")]
        public bool ActiveFlag { get; set; }

        [Required]
        [Display(Name = "Usuario Autorizado")]
        public bool AuthorizationFlag { get; set; }

        [Display(Name = "Rol")]
        public int? RoleID { get; set; }

        public int MainAreaID { get; set; }

        [Display(Name = "Area Principal")]
        public string MainArea { get; set; }

        [Required(ErrorMessage = "Este campo es obligatorio")]
        [RegularExpression(@"^(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z].*[a-z].*[a-z]).{6,20}$", ErrorMessage = "Contraseña invalida, debe tener entre 6 - 20 caracteres y contener al menos un número y una mayúscula")]
        [DataType(DataType.Password)]
        [Display(Name = "Contraseña")]
        public string Password { get; set; }

        public List<Roles> RolesList { get; set; }

        public Roles RolesData { get; set; }

        public Users()
        {
            RolesData = new Roles();
        }
    }
}
