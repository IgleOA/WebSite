using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;
namespace ET
{
    public class UserAuthorization
    {
        public string ActionType { get; set; }

        [Key]
        [Required]
        public int UserID { get; set; }

        [Required(ErrorMessage ="Este campo es obligatorio")]
        [Display(Name = "Rol")]
        public int RoleID { get; set; }
                
        public List<Roles> RolesList { get; set; }

        public Roles RolesData { get; set; }

        public UserAuthorization()
        {
            RolesData = new Roles();
        }
    }
}
