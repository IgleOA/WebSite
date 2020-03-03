using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ET;
using DAL;

namespace BL
{
    public class UsersBL
    {
        private UsersDAL UDAL = new UsersDAL();

        public int Login(string username, string password)
        {
            return UDAL.Login(username, password);
        }

        public List<Users> CheckUserNameAvailability(string UserName)
        {
            return UDAL.CheckUserNameAvailability(UserName);
        }

        public List<Users> CheckEmailAvailability(string Email)
        {
            return UDAL.CheckEmailAvailability(Email);
        }

        public List<Users> AdminList(int appid)
        {
            return UDAL.AdminList(appid);
        }

        public AuthorizationCode AuthCode(string email)
        {
            return UDAL.AuthCode(email);
        }

        public int ValidateGUID(string guid)
        {
            return UDAL.ValidateGUID(guid);
        }

        public bool ResetPassword(string guid, string password)
        {
            return UDAL.ResetPassword(guid, password);
        }

        public List<Users> List (int AppID)
        {
            return UDAL.List(AppID);
        }

        public bool AddNewUser(Users user, string insertuser)
        {
            return UDAL.AddNewUser(user, insertuser);
        }

        public Users Details(int id, int appid)
        {
            return UDAL.Details(id,appid);
        }

        public bool UpdateUser(Users user, string insertuser, int appid)
        {
            return UDAL.UpdateUser(user, insertuser, appid);
        }
    }
}
