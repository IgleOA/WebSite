using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DAL;
using ET;

namespace BL
{
    public class MainPageBL
    {
        private MainPageDAL MPDAL = new MainPageDAL();

        public List<MainPage> MainPage()
        {
            return MPDAL.MainPage();
        }
    }
}
