using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;
using MDA_IgleOA.Models;
using System.Net;
using System.Net.Mail;
using BL;
using ET;
using System.Text;

namespace MDA_IgleOA.Controllers
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
                return RedirectToAction("Index", "MainPage");
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
        public ActionResult RegisterStep1()
        {
            return View();
        }

        [HttpPost]
        [AllowAnonymous]
        [ValidateAntiForgeryToken]
        public ActionResult RegisterStep1(RegisterStep1Model modelstep1)
        {
            var ValidationUserName = UserBL.CheckUserNameAvailability(modelstep1.UserName);
            var ValidationEmail = UserBL.CheckEmailAvailability(modelstep1.Email);

            if (ValidationUserName.Count == 0 && ValidationEmail.Count == 0)
            {
                return RedirectToAction("RegisterStep2", "Account", new { fullname = modelstep1.FullName, username = modelstep1.UserName, email = modelstep1.Email });
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

            return View(modelstep1);
        }

        [AllowAnonymous]
        public ActionResult RegisterStep2(string fullname, string username, string email)
        {
            RegisterStep2Model NewModel = new RegisterStep2Model();
            NewModel.FullName = fullname;
            NewModel.UserName = username;
            NewModel.Email = email;

            NewModel.Applications = MPBL.MainPage().ToList();

            return View(NewModel);
        }
        //
        // POST: /Account/Register
        [HttpPost]
        [AllowAnonymous]
        [ValidateAntiForgeryToken]
        public ActionResult RegisterStep2(RegisterStep2Model model)
        {
            if (ModelState.IsValid)
            {
                Users user = new Users();

                user.FullName = model.FullName;
                user.UserName = model.UserName;
                user.Email = model.Email;
                user.Password = model.Password;
                user.RoleID = null;
                
                var r = UserBL.AddNewUser(user,model.ApplicationID, model.UserName);

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
                    Email.SubjectEmail = "Ministerio de Artes - Oasis Alajuela - Registro satisfactorio";
                    Email.BodyEmail = "Gracias " + model.FullName + " por registrarse, su cuenta aun esta pendiente de autorizar, pero será autorizada en las próximas 24 horas. Bendiciones...";

                    MailMessage mm = new MailMessage(Email.FromEmail, Email.ToEmail);
                    mm.Subject = Email.SubjectEmail;
                    mm.Body = Email.BodyEmail;
                    mm.IsBodyHtml = false;

                    SmtpClient smtp = new SmtpClient();
                    smtp.Send(mm);

                    var admins = from a in UserBL.AdminList(model.ApplicationID)
                                 select a;

                    foreach (var rr in admins)
                    {
                        Emails Emailadmin = new Emails();

                        Emailadmin.FromEmail = "johmstone@gmail.com";
                        Emailadmin.ToEmail = rr.Email;
                        Emailadmin.SubjectEmail = "Ministerio de Artes - Oasis Alajuela - Solicitud de autorización";
                        //Emailadmin.BodyEmail = "Buenas " + rr.FullName + "... Se acaba de registrar " + model.FullName + " y esta pendiente de autorizar, por favor autorizar lo antes posible. http://mmoa.azurewebsites.net Bendiciones...";

                        StringBuilder mailBody = new StringBuilder();

                        mailBody.AppendFormat("<h1>Ministerio de Artes - Oasis Alajuela</h1>");
                        mailBody.AppendFormat("<br />");
                        mailBody.AppendFormat("Buenas {0}...", rr.FullName);
                        mailBody.AppendFormat("<h3>Mensaje:</h3>");
                        mailBody.AppendFormat("<p>Se acaba de registrar {0} y esta pendiente de autorizar, por favor autorizarlo lo antes posible.</p>", model.FullName);
                                                mailBody.AppendFormat("<p>http://mdaigleoa.azurewebsites.net</p>");
                        mailBody.AppendFormat("<br />");
                        mailBody.AppendFormat("<h3>Bendiciones....</h3>");

                        Emailadmin.BodyEmail = mailBody.ToString();

                        MailMessage mmm = new MailMessage(Emailadmin.FromEmail, Emailadmin.ToEmail);
                        mmm.Subject = Emailadmin.SubjectEmail;
                        mmm.Body = Emailadmin.BodyEmail;
                        mmm.IsBodyHtml = true;

                        SmtpClient smtp2 = new SmtpClient();
                        smtp2.Send(mmm);
                    }

                    return this.RedirectToAction("RegisterConfirmation", "Account", new { FullName = model.FullName });
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
            return RedirectToAction("Login", "Account");
        }
    }
}