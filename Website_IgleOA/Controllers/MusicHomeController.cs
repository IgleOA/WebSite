using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using BL;
using ET;

namespace Website_IgleOA.Controllers
{
    public class MusicHomeController : Controller
    {
        private ControllerDirectoryBL CDBL = new ControllerDirectoryBL();
        private WebDirectoryBL WebBL = new WebDirectoryBL();
        private int AppID = 2;

        // GET: MusicHome
        public ActionResult Index()
        {
            if (Request.IsAuthenticated)
            {
                ControllerDirectory val = CDBL.Validation(this.ControllerContext.RouteData.Values["controller"].ToString(), User.Identity.Name, AppID);

                if (val.ReadFlag == true)
                {
                    var data = from p in WebBL.ProfilebyUser(User.Identity.Name, AppID)
                               select p.MainClass;

                    var FinalData = data.Distinct();

                    List<WebDirectory> MainMenu = new List<WebDirectory>();

                    foreach (var item in FinalData)
                    {
                        WebDirectory r = new WebDirectory();
                        r.ProfileID = Convert.ToInt32(MainMenu.Count()) + 2;
                        r.MainClass = item;
                        MainMenu.Add(r);
                    }

                    return View(MainMenu.ToList());
                }
                else
                {
                    ViewBag.Mensaje = "Usted no tiene accesso a este sección, solicítelo a un administrador.";
                    return View("~/Views/Shared/Error.cshtml");
                }

            }
            else
            {
                return this.RedirectToAction("Login", "Account");
            }
        }

        public ActionResult _MainMenu(string MainClass, int ImagePathNumber)
        {
            var data = from p in WebBL.ProfilebyUser(User.Identity.Name, AppID)
                       where p.MainClass == MainClass
                       select p;

            if (data.FirstOrDefault() == null)
            {
                ViewBag.Class = null;
            }
            else
            {
                ViewBag.Class = MainClass;
                ViewBag.LabelMenu = WebBL.LabelMenu(MainClass, User.Identity.Name, AppID).ToString();

                if (ImagePathNumber >= 10)
                {
                    ViewBag.ImagePath = "pic" + ImagePathNumber.ToString() + ".jpg";
                }
                else
                {
                    ViewBag.ImagePath = "pic0" + ImagePathNumber.ToString() + ".jpg";
                }
            }
            return View(data.ToList());

        }
    }
}