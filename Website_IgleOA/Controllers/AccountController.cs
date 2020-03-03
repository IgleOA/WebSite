using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;
using Website_IgleOA.Models;
using System.Net;
using System.Net.Mail;
using BL;
using ET;
using System.Text;

namespace Website_IgleOA.Controllers
{
    [Authorize]
    public class AccountController : Controller
    {
        private MainPageBL MPBL = new MainPageBL();
        private UsersBL UserBL = new UsersBL();

        //
        // GET: /Account/Login
        [AllowAnonymous]
        public ActionResult Login(string returnUrl)
        {
            if ((Request.IsAuthenticated))
            {
                return this.RedirectToAction("Index", "MainPage");
            }
            else
            {
                return this.View();
            }
        }

        //
        // POST: /Account/Login
        [HttpPost]
        [AllowAnonymous]
        [ValidateAntiForgeryToken]
        public ActionResult Login(LoginModel model, string returnUrl)
        {
            if (!ModelState.IsValid)
            {
                return View(model);
            }

            int userid = UserBL.Login(model.UserName, model.Password);

            if (userid >= 1)
            {
                FormsAuthentication.SetAuthCookie(model.UserName, model.RememberMe);
                if (this.Url.IsLocalUrl(returnUrl) && returnUrl.Length > 1 && returnUrl.StartsWith("/")
                    && !returnUrl.StartsWith("//") && !returnUrl.StartsWith("/\\"))
                {
                    return this.Redirect(returnUrl);
                }

                ViewBag.UserName = model.UserName;
                return RedirectToAction("Home", "Home");
            }
            else
            {
                if (userid == 0)
                {
                    this.ModelState.AddModelError(String.Empty, "El usuario no tiene acceso a esta aplicación.");
                }
                else
                {
                    if (userid == -1)
                    {
                        this.ModelState.AddModelError(String.Empty, "El nombre de usuario o Password es incorrecto.");
                    }
                    else
                    {
                        this.ModelState.AddModelError(String.Empty, "El usuario tiene pendiente su autorización.");
                    }
                }
            }
            return this.View(model);
        }

        //
        // GET: /Account/Register
        [AllowAnonymous]
        public ActionResult Register()
        {
            return View();
        }

        [HttpPost]
        [AllowAnonymous]
        [ValidateAntiForgeryToken]
        public ActionResult Register(RegisterModel model)
        {
            var ValidationUserName = UserBL.CheckUserNameAvailability(model.UserName);
            var ValidationEmail = UserBL.CheckEmailAvailability(model.Email);

            if (ValidationUserName.Count == 0 && ValidationEmail.Count == 0)
            {
                Users user = new Users();

                user.FullName = model.FullName;
                user.UserName = model.UserName;
                user.Email = model.Email;
                user.Password = model.Password;
                user.RoleID = null;

                var r = UserBL.AddNewUser(user, model.UserName);

                if (!r)
                {
                    ViewBag.Mensaje = "Ha ocurrido un error inesperado";
                    return View("~/Views/Shared/Error.cshtml");
                }
                else
                {
                    Emails Email = new Emails();

                    Email.FromEmail = "johmstone@gmail.com";
                    Email.ToEmail = model.Email;
                    Email.SubjectEmail = "Oasis Alajuela - Registro satisfactorio";
                    Email.BodyEmail = "Gracias " + model.FullName + " por registrarse, tenemos muchas cosas y grandes de camino. Gracias por ser parte de nuestra Familia. Bendiciones...";

                    MailMessage mm = new MailMessage(Email.FromEmail, Email.ToEmail);
                    mm.Subject = Email.SubjectEmail;
                    mm.Body = Email.BodyEmail;
                    mm.IsBodyHtml = false;

                    SmtpClient smtp = new SmtpClient();
                    smtp.Send(mm);

                    return this.RedirectToAction("RegisterConfirmation", "Account", new { FullName = model.FullName });
                }
            }
            else
            {
                if (ValidationUserName.Count > 0 && ValidationEmail.Count > 0)
                {
                    this.ModelState.AddModelError(String.Empty, "Este nombre de usuario y este correo electrónico ya se encuentran registrados, por favor intente con otro correo y otro nombre de usuario.");
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

            return View(model);
        }

                //
        // GET: /Account/ConfirmEmail
        [AllowAnonymous]
        public ActionResult RegisterConfirmation(string FullName)
        {
            ViewBag.FullName = FullName;

            return View();
        }

        //
        // GET: /Account/ForgotPassword
        [AllowAnonymous]
        public ActionResult ForgotPassword()
        {
            return View();
        }

        //
        // POST: /Account/ForgotPassword
        [HttpPost]
        [AllowAnonymous]
        [ValidateAntiForgeryToken]
        public ActionResult ForgotPassword(ForgotPasswordModel model)
        {
            AuthorizationCode Code = UserBL.AuthCode(model.Email);

            if (Code.UserID >= 1)
            {
                Emails Email = new Emails();

                Email.FromEmail = "johmstone@gmail.com";
                Email.ToEmail = model.Email;
                Email.SubjectEmail = Code.FullName + " - Restablecer contraseña";
                Email.BodyEmail = "Para restablecer su contraseña, utilice el siguiente link http://localhost:61214/Account/ResetPassword?GUID=" + Code.GUID;
                //Email.BodyEmail = "Para restablecer su contraseña, utilice el siguiente link http://localhost:61214/Account/ResetPassword?GUID=" + Code.GUID;

                MailMessage mm = new MailMessage(Email.FromEmail, Email.ToEmail);
                mm.Subject = Email.SubjectEmail;
                mm.Body = Email.BodyEmail;
                mm.IsBodyHtml = false;

                SmtpClient smtp = new SmtpClient();
                smtp.Send(mm);

                ViewBag.GUID = Code.GUID;
                return this.RedirectToAction("ForgotPasswordConfirmation", "Account");
            }
            else
            {
                this.ModelState.AddModelError(String.Empty, "Este correo no esta registrado en la aplicación.");
            }

            return this.View(model);
        }

        //
        // GET: /Account/ForgotPasswordConfirmation
        [AllowAnonymous]
        public ActionResult ForgotPasswordConfirmation()
        {
            return View();
        }

        //
        // GET: /Account/ResetPassword
        [AllowAnonymous]
        public ActionResult ResetPassword(string GUID)
        {
            int validation = UserBL.ValidateGUID(GUID);

            if (validation == 0 || GUID == null)
            {
                return View("Este codigo de autorización es invalido o ya fue utilizado y esta obsoleto.");
            }

            return View();

        }

        //
        // POST: /Account/ResetPassword
        [HttpPost]
        [AllowAnonymous]
        [ValidateAntiForgeryToken]
        public ActionResult ResetPassword(ResetPasswordModel model)
        {
            var r = UserBL.ResetPassword(model.GUID, model.ConfirmPassword);

            if (!r)
            {
                ViewBag.Mensaje = "Ha ocurrido un error inesperado.";
                return View("~/Views/Shared/Error.cshtml");
            }
            else
            {
                return this.RedirectToAction("ResetPasswordConfirmation", "Account");
            }

        }

        //
        // GET: /Account/ResetPasswordConfirmation
        [AllowAnonymous]
        public ActionResult ResetPasswordConfirmation()
        {
            return View();
        }


        //
        // POST: /Account/LogOff
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult LogOff()
        {
            FormsAuthentication.SignOut();
            return RedirectToAction("Home", "Home");
        }
    }
}