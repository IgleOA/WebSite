using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using BL;
using ET;
using System.Text;
using System.Net;
using System.Net.Mail;

namespace MDA_IgleOA.Controllers
{
    public class MainPageController : Controller
    {
        private MainPageBL MPBL = new MainPageBL();
        private UsersBL UserBL = new UsersBL();

        // GET: MainPage
        public ActionResult Index()
        {
            if (Request.IsAuthenticated)
            {
                List<MainPage> list = MPBL.MainPage().ToList();

                return View(list);
            }
            else
            {
                return this.RedirectToAction("Login", "Account");
            }
        }

        public ActionResult Contact(int AppID)
        {
            Contact contact = new Contact()
            {
                ApplicationID = AppID
            };

            string layout = "~/Views/Shared/_MainLayout.cshtml";

            if (AppID == 1)
            {
                layout = "~/Views/Shared/_MinistryLayout.cshtml";
            }
            else
            {
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
            }
            bool InternalFlag = false;


            if (User.Identity.Name.Length >0)
            {
                InternalFlag = true;

                var user = from u in UserBL.List(AppID)
                           where u.UserName == User.Identity.Name
                           select u.Email;

                contact.Email = user.FirstOrDefault().ToString();
            }

            ViewBag.Layout = layout;
            ViewBag.InternalFlag = InternalFlag;

            return View(contact);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Contact(Contact contact)
        {
            var admins = from a in UserBL.AdminList(contact.ApplicationID)
                         select a;

            foreach (var rr in admins)
            {
                Emails Emailadmin = new Emails();

                Emailadmin.FromEmail = "johmstone@gmail.com";
                Emailadmin.ToEmail = rr.Email;
                Emailadmin.SubjectEmail = "MDA Oasis Alajuela - Contacto";
                //Emailadmin.BodyEmail = "Buenas " + rr.FullName + "... Acaba de ingresar una consulta de " + contact.Email + " y es la siguiente: " + contact.Message + " Bendiciones...";

                StringBuilder mailBody = new StringBuilder();

                mailBody.AppendFormat("<h1>MDA - Oasis Alajuela</h1>");
                mailBody.AppendFormat("<hr />");
                mailBody.AppendFormat("Buenas {0}...", rr.FullName);
                mailBody.AppendFormat("<p>Acaba de ingresar una consulta de parte {0}</p>", contact.Email);
                mailBody.AppendFormat("<h3>Mensaje:</h3>");
                mailBody.AppendFormat("<p> {0} </p>", contact.Message);
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

            return this.RedirectToAction("EmailConfirmation" , new { email = contact.Email, AppID = contact.ApplicationID });
        }

        [AllowAnonymous]
        public ActionResult EmailConfirmation(string email, int AppID)
        {
            ViewBag.Email = email;

            string layout = "~/Views/Shared/_MainLayout.cshtml";

            if (AppID == 1)
            {
                layout = "~/Views/Shared/_MinistryLayout.cshtml";
            }
            else
            {
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
            }

            ViewBag.Layout = layout;

            return View();
        }
    }
}