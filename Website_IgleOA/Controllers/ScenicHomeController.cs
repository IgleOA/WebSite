using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace MDA_IgleOA.Controllers
{
    public class ScenicHomeController : Controller
    {
        // GET: ScenicHome
        public ActionResult Index()
        {
            if (Request.IsAuthenticated)
            {
                //ControllersDirectory val = CDBL.Validation(this.ControllerContext.RouteData.Values["controller"].ToString(), User.Identity.Name);

                //if (val.ReadFlag == true)
                //{
                //    var data = from p in AppBL.AppProfilebyUser(User.Identity.Name)
                //               select p.MainClass;

                //    var FinalData = data.Distinct();

                //    List<AppDirectory> MainMenu = new List<AppDirectory>();

                //    foreach (var item in FinalData)
                //    {
                //        AppDirectory r = new AppDirectory();
                //        r.RARProfileID = Convert.ToInt32(MainMenu.Count()) + 2;
                //        r.MainClass = item;
                //        MainMenu.Add(r);
                //    }

                //    return View(MainMenu.ToList());
                //}
                //else
                //{
                //    ViewBag.Mensaje = "Usted no tiene accesso a este sección, solicítelo a un administrador.";
                //    return View("~/Views/Shared/Error.cshtml");
                //}

                return View();

            }
            else
            {
                return this.RedirectToAction("Login", "Account");
            }
        }
    }
}