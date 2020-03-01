using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ET;
using BL;
using Microsoft.AspNet.Identity;

namespace MDA_IgleOA.Controllers
{
    public class SongsController : Controller
    {
        private SongsBL SongsBL = new SongsBL();
        private AuthorsBL AuthorsBL = new AuthorsBL();
        private ControllerDirectoryBL CDBL = new ControllerDirectoryBL();
        private int AppID = 2;

        // GET: Songs
        public ActionResult Index()
        {
            if (Request.IsAuthenticated)
            {
                ControllerDirectory val = CDBL.Validation(this.ControllerContext.RouteData.Values["controller"].ToString(), User.Identity.Name,AppID);

                if (val.ReadFlag == true)
                {
                    ViewBag.WriteFlag = val.WriteFlag;
                    return View(SongsBL.SongList().ToList());
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

        public ActionResult Create()
        {
            if (Request.IsAuthenticated)
            {
                Songs Song = new Songs();

                Song.AuthorList = AuthorsBL.AuthorList();

                return View(Song);
            }
            else
            {
                return this.RedirectToAction("Login", "Account");
            }

        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create(Songs Song)
        {
            if (Request.IsAuthenticated)
            {

                string InsertUser = User.Identity.GetUserName();

                var r = SongsBL.AddNew(Song, InsertUser);

                if (!r)
                {
                    ViewBag.Mensaje = "Ha ocurrido un error inesperado.";
                    return View("~/Views/Shared/Error.cshtml");
                }
                else
                {
                    Song.ActionType = "CREATE";

                    Song.AuthorList = AuthorsBL.AuthorList();

                    return View(Song);
                }
            }
            else
            {
                return this.RedirectToAction("Login", "Account");
            }
        }
        public ActionResult CreatebyAuthor(int id)
        {
            if (Request.IsAuthenticated)
            {
                Songs Song = new Songs();

                var aut = from a in AuthorsBL.AuthorList()
                          where a.AuthorID == id
                          select a;

                Song.AuthorList = aut.ToList();

                return View(Song);
            }
            else
            {
                return this.RedirectToAction("Login", "Account");
            }

        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult CreatebyAuthor(Songs Song)
        {
            if (Request.IsAuthenticated)
            {

                string InsertUser = User.Identity.GetUserName();

                var r = SongsBL.AddNew(Song, InsertUser);

                if (!r)
                {
                    ViewBag.Mensaje = "Ha ocurrido un error inesperado.";
                    return View("~/Views/Shared/Error.cshtml");
                }
                else
                {
                    Song.ActionType = "CREATE";

                    Song.AuthorList = AuthorsBL.AuthorList();

                    return View(Song);
                }
            }
            else
            {
                return this.RedirectToAction("Login", "Account");
            }
        }

        public ActionResult Top10()
        {
            if (Request.IsAuthenticated)
            {
                return View(SongsBL.Top10().ToList());
            }
            else
            {
                return this.RedirectToAction("Login", "Account");
            }
        }
    }
}