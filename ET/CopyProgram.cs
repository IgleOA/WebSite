using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace ET
{
    public class CopyProgram
    {
        [Display(Name ="Copiar del programa:")]
        public int ProgramIDSource { get; set; }

        public int ProgramIDTarget { get; set; }

        public List<Programs> ProgramList { get; set; }

        public Programs ProgramsData { get; set; }

        public CopyProgram()
        {
            ProgramsData = new Programs();
        }

        public string ActionType { get; set; }
    }
}
