using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace ET
{
    public class MusicSheetTypes
    {
        [Key]
        public int MSTypeID { get; set; }

        [Required]
        [Display(Name ="Tipo de documento")]
        public string MSTypeName { get; set; }

    }
}
