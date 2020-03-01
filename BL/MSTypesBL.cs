using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ET;
using DAL;

namespace BL
{
    public class MSTypesBL
    {
        private MSTypesDAL MSTDAL = new MSTypesDAL();

        public List<MusicSheetTypes> MSTypeList ()
        {
            return MSTDAL.MSTypeList();
        }
    }
}
