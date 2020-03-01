using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using BL;
using ET;

namespace Website_IgleOA.Controllers
{
    public class RightsController : Controller
    {
        private ControllerDirectoryBL CDBL = new ControllerDirectoryBL();
        private RolesBL RBL = new RolesBL();

        // GET: Rights
        public ActionResult Index(int id = 0)
        {
            if (Request.IsAuthenticated)
            { 
                var Rights = CDBL.Rights(id);

                Roles role = RBL.Details(id);

                string layout = "~/Views/Shared/_MinistryLayout.cshtml";

                if (role.ApplicationID == 2)
                {
                    layout = "~/Views/Shared/_MusicLayout.cshtml";
                }
                else
                {
                    if (role.ApplicationID == 3)
                    {
                        layout = "~/Views/Shared/_ScenicLayout.cshtml";
                    }
                    else
                    { }
                }

                ViewBag.Layout = layout;
                ViewBag.AppID = role.ApplicationID;
                ViewBag.RoleName = role.RoleName;
                ViewBag.RoleID = id;

                ControllerDirectory val = CDBL.Validation(this.ControllerContext.RouteData.Values["controller"].ToString(), User.Identity.Name, role.ApplicationID);
                if(val.ReadFlag == true)
                {
                    ViewBag.WriteFlag = val.WriteFlag;

                    return View(Rights.ToList());
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

        // Post: /Profiles/ActiveFlag
        [HttpPost]
        public ActionResult ActiveFlag(int roleid, int controllerid, int rightid, string right)
        {
            if ((Request.IsAuthenticated))
            {
                string InsertUser = User.Identity.Name;

                var r = CDBL.Update(roleid, controllerid, rightid, right, InsertUser);

                if (!r)
                {
                    ViewBag.Mensaje = "Ha ocurrido un error inesperado.";
                    return View("~/Views/Shared/Error.cshtml");
                }
                else
                {
                    return RedirectToAction("Index", new { id = roleid });
                }

            }
            else
            {
                return this.RedirectToAction("Login", "Account");
            }
        }
    }
}