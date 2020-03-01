using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using BL;
using ET;
using Microsoft.AspNet.Identity;

namespace MDA_IgleOA.Controllers
{
    public class RolesController : Controller
    {
        private ControllerDirectoryBL CDBL = new ControllerDirectoryBL();
        private RolesBL RolesBL = new RolesBL();

        // GET: Roles
        public ActionResult Index(int id)
        {
            if (Request.IsAuthenticated)
            {
                ControllerDirectory val = CDBL.Validation(this.ControllerContext.RouteData.Values["controller"].ToString(), User.Identity.Name, id);

                if (val.ReadFlag == true)
                {
                    string layout = "~/Views/Shared/_MinistryLayout.cshtml";

                    if (id == 2)
                    {
                        layout = "~/Views/Shared/_MusicLayout.cshtml";
                    }
                    else
                    {
                        if (id == 3)
                        {
                            layout = "~/Views/Shared/_ScenicLayout.cshtml";
                        }
                        else
                        { }
                    }

                    ViewBag.Layout = layout;
                    ViewBag.AppID = id;
                    ViewBag.WriteFlag = val.WriteFlag;

                    return View(RolesBL.List(id).ToList());
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

        //
        // GET: /Roles/Create
        public ActionResult Create(int AppID)
        {
            if (Request.IsAuthenticated)
            {
                string layout = "~/Views/Shared/_MinistryLayout.cshtml";

                if (AppID == 2)
                {
                    layout = "~/Views/Shared/_MusicLayout.cshtml";
                }
                else
                {
                    if (AppID == 3)
                    {
                        layout = "~/Views/Shared/_ScenicLayout.cshtml";
                    }
                    else
                    { }
                }

                ViewBag.Layout = layout;

                Roles rol = new Roles
                {
                    ApplicationID = AppID
                };

                return View(rol);
            }
            else
            {
                return this.RedirectToAction("Login", "Account");
            }
        }

        //
        // POST: /Roles/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create(Roles BS)
        {
            if (ModelState.IsValid)
            {
                string InsertUser = User.Identity.GetUserName();

                var r = RolesBL.Create(BS, InsertUser);

                if (!r)
                {
                    ViewBag.Mensaje = "Ha ocurrido un error inesperado.";
                    return View("~/Views/Shared/Error.cshtml");
                }
                else
                {
                    return RedirectToAction("Index", new { id = BS.ApplicationID });
                }
            }

            return View(BS);
        }

        //
        // Post: /Roles/ActiveFlag
        [HttpPost]
        public ActionResult ActiveFlag(int id)
        {
            if ((Request.IsAuthenticated))
            {
                Roles role = RolesBL.Details(id);

                if (role.ActiveFlag == true)
                {
                    role.ActiveFlag = false;
                }
                else
                {
                    role.ActiveFlag = true;
                }

                string InsertUser = User.Identity.GetUserName();

                var r = RolesBL.Update("MS", role, InsertUser);

                if (!r)
                {
                    ViewBag.Mensaje = "Ha ocurrido un error inesperado.";
                    return View("~/Views/Shared/Error.cshtml");
                }
                else
                {
                    return RedirectToAction("Index", new { id = role.ApplicationID });
                }
            }
            else
            {
                return this.RedirectToAction("Login", "Account");
            }
        }
    }
}