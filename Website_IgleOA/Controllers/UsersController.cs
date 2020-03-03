using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using BL;
using ET;
using Microsoft.AspNet.Identity;
using System.Net.Mail;

namespace Website_IgleOA.Controllers
{
    public class UsersController : Controller
    {
        private ControllerDirectoryBL CDBL = new ControllerDirectoryBL();
        private UsersBL UBL = new UsersBL();
        private RolesBL RBL = new RolesBL();

        // GET: Users
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

                    return View(UBL.List(id).ToList());
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


        // GET: Users/Create
        public ActionResult Create(int id)
        {
            if (Request.IsAuthenticated)
            {
                Users User = new Users();

                var Roles = from r in RBL.List(id)
                            where r.ActiveFlag == true
                            select r;

                User.RolesList = Roles.ToList();

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

                return View(User);
            }
            else
            {
                return this.RedirectToAction("Login", "Account");
            }
        }

        // POST: Users/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create(Users NewUser)
        {

            var ValidationUserName = UBL.CheckUserNameAvailability(NewUser.UserName);
            var ValidationEmail = UBL.CheckEmailAvailability(NewUser.Email);

            if (ValidationUserName.Count == 0 && ValidationEmail.Count == 0)
            {
                int role = NewUser.RoleID ?? default;

                Roles rol = RBL.Details(role);

                NewUser.Password = "Wxyz1234";

                string InsertUser = User.Identity.GetUserName();

                var r = UBL.AddNewUser(NewUser, InsertUser);

                if (!r)
                {
                    ViewBag.Mensaje = "Ha ocurrido un error inesperado";
                    return View("~/Views/Shared/Error.cshtml");
                }
                else
                {
                    return RedirectToAction("Index", new { id = rol.ApplicationID });
                }
            }
            else
            {
                if (ValidationUserName.Count > 0 && ValidationEmail.Count > 0)
                {
                    this.ModelState.AddModelError(String.Empty, "Este nombre de usuario y este email ya se encuentran registrados, por favor intente con otro correo y otro nombre de usuario.");
                }
                else
                {
                    if (ValidationUserName.Count > 0)
                    {
                        this.ModelState.AddModelError(String.Empty, "Este nombre de usuario ya se encuentra registrado, por favor intente con otro nombre de usuario.");
                    }
                    else
                    {
                        this.ModelState.AddModelError(String.Empty, "Este correo electrónico ya se encuentra registrado, por favor intente con otro email.");
                    }
                }
            }
            return View(NewUser);
        }

        // GET: Users/Edit/1
        public ActionResult Edit(int id, int AppID)
        {
            if ((Request.IsAuthenticated))
            {
                Users User = UBL.Details(id,AppID);

                var Roles = from r in RBL.List(AppID)
                            where r.ActiveFlag == true
                            select r;

                User.RolesList = Roles.ToList();

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

                ViewBag.UserName = User.UserName.ToString();

                return View(User);
            }
            else
            {
                return this.RedirectToAction("Login", "Account");
            }
        }

        // POST: User/Edit/1
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit(Users UserEdit)
        {
            UserEdit.ActionType = "GUDP";

            int role = UserEdit.RoleID ?? default;

            Roles rol = RBL.Details(role);

            string InsertUser = User.Identity.GetUserName();

            var r = UBL.UpdateUser(UserEdit, InsertUser, rol.ApplicationID);

            if (!r)
            {
                ViewBag.Mensaje = "Ha ocurrido un error inesperado";
                return View("~/Views/Shared/Error.cshtml");
            }
            else
            {
                return RedirectToAction("Index", new { id = rol.ApplicationID });
            }
        }

        // POST: User/ActiveFlag
        public ActionResult ActiveFlag(int id, bool status, int AppID)
        {
            if ((Request.IsAuthenticated))
            {
                Users UserEdit = new Users();

                UserEdit.UserID = id;

                UserEdit.ActionType = "MS";

                if (status == true)
                {
                    UserEdit.ActiveFlag = false;
                }
                else
                {
                    UserEdit.ActiveFlag = true;
                }

                string InsertUser = User.Identity.GetUserName();

                var r = UBL.UpdateUser(UserEdit, InsertUser, AppID);

                if (!r)
                {
                    ViewBag.Mensaje = "Ha ocurrido un error inesperado";
                    return View("~/Views/Shared/Error.cshtml");
                }
                else
                {
                    return this.RedirectToAction("Index", new { id = AppID });
                }
            }
            else
            {
                return this.RedirectToAction("Login", "Account");
            }
        }

        // GET: User/Authorize/1
        public ActionResult Authorize(int userid, int AppID)
        {
            if ((Request.IsAuthenticated))
            {
                Users UserEdit = UBL.Details(userid, AppID);

                UserAuthorization UserAuth = new UserAuthorization();

                UserAuth.UserID = userid;

                var Roles = from r in RBL.List(AppID)
                            where r.ActiveFlag == true
                            select r;

                UserAuth.RolesList = Roles.ToList();

                ViewBag.UserName = UserEdit.UserName.ToString();

                string layout = "~/Views/Shared/_PupopMinistryLayout.cshtml";

                if (AppID == 2)
                {
                    layout = "~/Views/Shared/_PupopMusicLayout.cshtml";
                }
                else
                {
                    if (AppID == 3)
                    {
                        layout = "~/Views/Shared/_PupopScenicLayout.cshtml";
                    }
                    else
                    { }
                }

                ViewBag.Layout = layout;

                return View(UserAuth);
            }
            else
            {
                return this.RedirectToAction("Login", "Account");
            }
        }

        // POST: User/Authorize/1
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Authorize(UserAuthorization UserAuth)
        {
            if ((Request.IsAuthenticated))
            {
                Roles rol = RBL.Details(UserAuth.RoleID);

                Users UserEdit = UBL.Details(UserAuth.UserID, rol.ApplicationID);

                UserEdit.RoleID = UserAuth.RoleID;
                UserEdit.ActionType = "AUTH";
                UserAuth.ActionType = "AUTH";

                string InsertUser = User.Identity.GetUserName();

                var r = UBL.UpdateUser(UserEdit, InsertUser, rol.ApplicationID);

                if (!r)
                {
                    ViewBag.Mensaje = "Ha ocurrido un error inesperado";
                    return View("~/Views/Shared/Error.cshtml");
                }
                else
                {
                    var Roles = from rl in RBL.List(rol.ApplicationID)
                                where rl.ActiveFlag == true
                                select rl;

                    UserAuth.RolesList = Roles.ToList();

                    Emails Email = new Emails();

                    Email.FromEmail = "johmstone@gmail.com";
                    Email.ToEmail = UserEdit.Email;
                    Email.SubjectEmail = "Ministerio de Artes Oasis Alajuela - Usuario Autorizado";
                    Email.BodyEmail = "Hola " + UserEdit.FullName + "!!! Su cuenta ha sido autorizada y puede ingresar desde este momento a https://mdaigleoa.azurewebsites.net/. Bendiciones...";

                    MailMessage mm = new MailMessage(Email.FromEmail, Email.ToEmail);
                    mm.Subject = Email.SubjectEmail;
                    mm.Body = Email.BodyEmail;
                    mm.IsBodyHtml = false;

                    SmtpClient smtp = new SmtpClient();
                    smtp.Send(mm);

                    return View(UserAuth);


                }
            }
            else
            {
                return this.RedirectToAction("Login", "Account");
            }
        }

    }
}