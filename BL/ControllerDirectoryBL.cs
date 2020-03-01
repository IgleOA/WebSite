using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ET;
using DAL;
namespace BL
{
    public class ControllerDirectoryBL
    {
        private ControllerDirectoryDAL CDDAL = new ControllerDirectoryDAL();

        public List<ControllerDirectory> Rights (int roleid)
        {
            return CDDAL.Rights(roleid);
        }

        public bool Update(int roleid, int controllerid, int rightid, string right, string insertuser)
        {
            return CDDAL.Update(roleid, controllerid, rightid, right, insertuser);
        }

        public ControllerDirectory Validation(string controllername, string username, int AppID)
        {
            return CDDAL.Validation(username, controllername, AppID);
        }
    }
}
