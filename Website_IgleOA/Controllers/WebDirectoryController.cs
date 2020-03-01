using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using BL;
using ET;

namespace MDA_IgleOA.Controllers
{
    public class WebDirectoryController : Controller
    {
        private WebDirectoryBL WebBL = new WebDirectoryBL();
        private RolesBL RBL = new RolesBL();

        // GET: WebDirectory
        public ActionResult Index(int RoleID)
        {
            if (Request.IsAuthenticated)
            {

                //ControllersDirectory val = CDBL.Validation(this.ControllerContext.RouteData.Values["controller"].ToString(), User.Identity.Name);

                //if (val.ReadFlag == true)
                //{
                    var Profile = WebBL.ProfilebyRole(RoleID);

                    Roles role = RBL.Details(RoleID);

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
                    ViewBag.RoleName = role.RoleName.ToString();
                    ViewBag.AppID = role.ApplicationID;
                    ViewBag.RoleID = RoleID;

                    return View(Profile.ToList());
                //}
                //else
                //{
                //    ViewBag.Mensaje = "Usted no tiene accesso a este sección, solicítelo a un administrador.";
                //    return View("~/Views/Shared/Error.cshtml");
                //}
            }
            else
            {
                return this.RedirectToAction("Login", "Account");
            }

        }

        // Post: /Profiles/ActiveFlag
        [HttpPost]
        public ActionResult ActiveFlag(int id, int RoleID, int WebID)
        {
            if ((Request.IsAuthenticated))
            {
                WebDirectory Web = new WebDirectory
                {
                    ProfileID = id,
                    WebID = WebID
                };

                string InsertUser = User.Identity.Name;

                var r = WebBL.Update(Web, RoleID, InsertUser);

                if (!r)
                {
                    ViewBag.Mensaje = "Ha ocurrido un error inesperado.";
                    return View("~/Views/Shared/Error.cshtml");
                }
                else
                {
                    return RedirectToAction("Index", new { RoleID = RoleID });
                }

            }
            else
            {
                return this.RedirectToAction("Login", "Account");
            }
        }
    }
}