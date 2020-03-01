using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace ET
{
    public class Songs
    {
        [Key]
        public int SongID { get; set; }

        [Required]
        [Display(Name = "Autor")]
        public int AuthorID { get; set; }

        [Required]
        [Display(Name ="Canción")]
        public string SongName { get; set; }

        public int  RowNumber { get; set; }

        public int Times { get; set; }
        public List<Authors> AuthorList { get; set; }

        public Authors AuthorsData { get; set; }

        public Songs()
        {
            AuthorsData = new Authors();
        }

        public string ActionType { get; set; }
    }
}
