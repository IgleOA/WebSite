using System.Collections.Generic;
using DAL;
using ET;

namespace BL
{
    public class MinistersBL
    {
        private MinistersDAL MDAL = new MinistersDAL();

        public List<Ministers> List()
        {
            return MDAL.List();
        }

        public bool AddNew (Ministers minister, string insertuser)
        {
            return MDAL.AddNew(minister, insertuser);
        }
    }
}
