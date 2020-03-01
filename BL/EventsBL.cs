using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DAL;
using ET;

namespace BL
{
    public class EventsBL
    {
        private EventsDAL EDAL = new EventsDAL();
        public List<Events> List(DateTime date)
        {
            return EDAL.List(date);
        }
    }
}
