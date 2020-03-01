using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace ET
{
    public class Roles
    {
        [Key]
        [Required]
        public int RoleID { get; set; }

        public int ApplicationID { get; set; }

        [Required]
        [Display(Name = "Rol")]
        public string RoleName { get; set; }

        [Required]
        [Display(Name = "Descripcion")]
        public string RoleDescription { get; set; }

        [Required]
        [Display(Name = "Status")]
        public bool ActiveFlag { get; set; }
    }

}
