using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace ET
{
    public class WebDirectory
    {
        public int ProfileID { get; set; }

        [Required]
        public int WebID { get; set; }

        [Required]
        [Display(Name = "Clase Principal")]
        public string MainClass { get; set; }

        [Display(Name = "Nombre")]
        public string WebName { get; set; }

        public string Controller { get; set; }

        [Display(Name = "Página")]
        public string ViewPage { get; set; }

        public string Parameter { get; set; }

        [Display(Name = "Acceso")]
        public bool Status { get; set; }
    }
}
