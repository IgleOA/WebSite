using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace ET
{
    public class Authors
    {
        [Key]
        [Required]
        public int AuthorID { get; set; }

        [Required(ErrorMessage = "Este campo es obligatorio")]
        [Display(Name ="Autor")]
        public string AuthorName { get; set; }

        [Display(Name ="Perfil")]
        public string  ProfileLink { get; set; }

        public bool ActiveLink { get; set; }

        public string ActionType { get; set; }
    }
}
