using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ET;
using BL;
using Microsoft.AspNet.Identity;
using System.Globalization;

namespace MDA_IgleOA.Controllers
{
    public class RehearsalsController : Controller
    {
        private RehearsalsBL RBL = new RehearsalsBL();
        // GET: Rehearsals
        public ActionResult Index()
        {
            if (Request.IsAuthenticated)
            {
                var r = RBL.Rehearsal().OrderBy(x => x.SongName).ToList();

                ViewBag.Count = r.Count();

                return View(r.ToList());
            }
            else
            {
                return this.RedirectToAction("Login", "Account");
            }
        }
    }
}