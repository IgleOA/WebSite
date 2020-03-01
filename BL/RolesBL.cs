using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DAL;
using ET;

namespace BL
{
    public class RolesBL
    {
        private RolesDAL RDAL = new RolesDAL();

        public List<Roles> List (int appid)
        {
            return RDAL.List(appid);
        }

        public bool Create(Roles role, string insertuser)
        {
            return RDAL.Create(role, insertuser);
        }

        public Roles Details (int id)
        {
            return RDAL.Details(id);
        }

        public bool Update(string actiontype, Roles role, string insertuser)
        {
            return RDAL.Update(actiontype, role, insertuser);
        }
    }
}
