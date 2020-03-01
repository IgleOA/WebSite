using System.Collections.Generic;
using System.Web.Mvc;
using BL;
using ET;
using Microsoft.AspNet.Identity;

namespace MDA_IgleOA.Controllers
{
    public class MinistersController : Controller
    {
        private MinistersBL MBL = new MinistersBL();

        //
        // GET: /Ministers/Create
        public ActionResult Create()
        {
            if (Request.IsAuthenticated)
            {
                Ministers Minister = new Ministers();

                return View(Minister);
            }
            else
            {
                return this.RedirectToAction("Login", "Account");
            }
        }

        //
        // POST: /Authors/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create(Ministers Minister)
        {
            if (Request.IsAuthenticated)
            {
                Minister.ActionType = "CREATE";

                string InsertUser = User.Identity.GetUserName();

                var r = MBL.AddNew(Minister, InsertUser);

                if (!r)
                {
                    ViewBag.Mensaje = "Ha ocurrido un error inesperado.";
                    return View("~/Views/Shared/Error.cshtml");
                }
                else
                {
                    return View(Minister);
                }
            }
            else
            {
                return this.RedirectToAction("Login", "Account");
            }
        }

        
    }
}