using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ET;
using DAL;

namespace BL
{
    public class RehearsalsBL
    {
        private RehearsalsDAL RDAL = new RehearsalsDAL();

        public List<Songs> Rehearsal()
        {
            return RDAL.Rehearsal();
        }
    }
}
