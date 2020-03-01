using System.Collections.Generic;
using DAL;
using ET;

namespace BL
{
    public class PreachesBL
    {
        private PreachesDAL PDAL = new PreachesDAL();

        public List<Preaches> List()
        {
            return PDAL.List();
        }

        public bool AddNew (Preaches preach, string insertuser)
        {
            return PDAL.AddNew(preach, insertuser);
        }

        public Preaches Details (int preachid)
        {
            return PDAL.Details(preachid);
        }
    }
}
