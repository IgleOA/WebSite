using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ET;
using DAL;

namespace BL
{
    public class ProgramDetailsBL
    {
        private ProgramDetailsDAL PDDAL = new ProgramDetailsDAL();

        public List<ProgramDetails> Details (int programid)
        {
            return PDDAL.Details(programid);
        }

        public bool AddSong(ProgramDetails pd, string insertuser)
        {
            return PDDAL.AddSong(pd, insertuser);
        }

        public int Disable (int id, string insertuser)
        {
            return PDDAL.Disable(id, insertuser);
        }
    }
}
