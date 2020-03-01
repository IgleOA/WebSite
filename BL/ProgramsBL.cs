using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ET;
using DAL;

namespace BL
{
    public class ProgramsBL
    {
        private ProgramsDAL PDAL = new ProgramsDAL();

        public List<Programs> ProgramList()
        {
            return PDAL.ProgramList();
        }
        public List<Programs> WeeklyProgram()
        {
            return PDAL.WeeklyProgram();
        }

        public int AddNew(Programs program, string insertuser)
        {
            return PDAL.AddNew(program, insertuser);
        }

        public bool  CopyProgram (CopyProgram CP, string insertuser)
        {
            return PDAL.CopyProgram(CP, insertuser);
        }

        public List<Programs> AvailableProgramsForCopy(int id)
        {
            return PDAL.AvailableProgramsForCopy(id);
        }

        public bool Notification(int pid, string insertuser)
        {
            return PDAL.Notification(pid, insertuser);
        }
    }
}
