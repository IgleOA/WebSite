using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ET;
using DAL;

namespace BL
{
    public class InstrumentsBL
    {
        private InstrumentsDAL IDAL = new InstrumentsDAL();

        public List<Instruments> InstrumentList ()
        {
            return IDAL.InstrumentList();
        }
    }
}
