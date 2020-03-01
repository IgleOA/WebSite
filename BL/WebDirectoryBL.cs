using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DAL;
using ET;

namespace BL
{
    public class WebDirectoryBL
    {
        private WebDirectoryDAL WebDAL = new WebDirectoryDAL();

        public List<WebDirectory> ProfilebyUser (string username, int appid)
        {
            return WebDAL.ProfilebyUser(username, appid);
        }

        public List<WebDirectory> ProfilebyRole(int id)
        {
            return WebDAL.ProfilebyRole(id);
        }

        public string LabelMenu(string mainclass, string username, int appid)
        {
            return WebDAL.LabelMenu(mainclass, username, appid);
        }


        public bool Update (WebDirectory web, int roleid,string insertuser)
        {
            return WebDAL.Update(web, roleid, insertuser);
        }
    }
}
