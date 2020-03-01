using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ET;
using BL;
using Microsoft.AspNet.Identity;
using System.Globalization;
using System.Net.Mail;
using System.Text;

namespace MDA_IgleOA.Controllers
{
    public class ProgramsController : Controller
    {
        private ProgramsBL PBL = new ProgramsBL();
        private ProgramDetailsBL PDBL = new ProgramDetailsBL();
        private SongsBL SBL = new SongsBL();
        private ControllerDirectoryBL CDBL = new ControllerDirectoryBL();
        private UsersBL UBL = new UsersBL();
        private int AppID = 2;

        // GET: Programs
        public ActionResult Index()
        {
            if (Request.IsAuthenticated)
            {
                ControllerDirectory val = CDBL.Validation(this.ControllerContext.RouteData.Values["controller"].ToString(), User.Identity.Name, AppID);

                if (val.ReadFlag == true)
                {
                    ViewBag.WriteFlag = val.WriteFlag;

                    return View(PBL.ProgramList().ToList());
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
                Programs Program = new Programs();
                Program.ProgramDate = DateTime.Today;

                return View(Program);
            }
            else
            {
                return this.RedirectToAction("Login", "Account");
            }

        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create(Programs Pgrm)
        {
            if (ModelState.IsValid)
            {
                string InsertUser = User.Identity.GetUserName();

                int r = PBL.AddNew(Pgrm, InsertUser);

                if (r > 0)
                {
                    return this.RedirectToAction("Details", "Programs", new { id = r });
                }
                else
                {

                    ViewBag.Mensaje = "Ha ocurrido un error inesperado.";
                    return View("~/Views/Shared/Error.cshtml");
                }
            }

            return View(Pgrm);

        }

        public ActionResult Details(int id)
        {
            if (Request.IsAuthenticated)
            {
                var details = from p in PBL.ProgramList()
                              where p.ProgramID == id
                              select p;
                Programs Program = details.FirstOrDefault();

                CultureInfo ci = new CultureInfo("Es-Es");

                string day = ci.DateTimeFormat.GetDayName(Program.ProgramDate.DayOfWeek).ToString();

                ViewBag.DayName = day.First().ToString().ToUpper() + day.Substring(1);

                ViewBag.PDate = Program.ProgramDate.ToString("dd/MM/yyyy");

                ViewBag.PSchedule = Program.ProgramSchedule;

                ViewBag.Status = Program.CompleteFlag;

                ViewBag.PID = id;

                ViewBag.ND = Program.NotificationDate;

                ControllerDirectory val = CDBL.Validation(this.ControllerContext.RouteData.Values["controller"].ToString(), User.Identity.Name, AppID);

                ViewBag.WriteFlag = val.WriteFlag;

                List<ProgramDetails> PDetails = new List<ProgramDetails>();

                PDetails = PDBL.Details(id).OrderBy(x => x.SongsData.SongName).ToList();

                foreach (var r in PDetails)
                {
                    r.Status = Program.CompleteFlag;
                }

                ViewBag.Rows = PDetails.Count;

                return View(PDetails);
            }
            else
            {
                return this.RedirectToAction("Login", "Account");
            }
        }

        public ActionResult AddSong(int id = 0)
        {
            ProgramDetails PD = new ProgramDetails();

            var details = from p in PBL.ProgramList()
                          where p.ProgramID == id
                          select p;

            Programs Program = details.FirstOrDefault();

            CultureInfo ci = new CultureInfo("Es-Es");

            string day = ci.DateTimeFormat.GetDayName(Program.ProgramDate.DayOfWeek).ToString();

            ViewBag.DayName = day.First().ToString().ToUpper() + day.Substring(1);

            ViewBag.PDate = Program.ProgramDate.ToString("dd/MM/yyyy");

            ViewBag.PSchedule = Program.ProgramSchedule;

            ViewBag.PID = id;

            PD.SongsList = SBL.SongList().OrderBy(x => x.SongName).ToList();

            PD.ProgramID = id;

            return View(PD);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult AddSong(ProgramDetails PD, string SongsList)
        {
            if (Request.IsAuthenticated)
            {
                if(SongsList.Length >1 )
                {
                    string[] songs = SongsList.Split(',');
                    foreach (var i in songs)
                    {
                        string InsertUser = User.Identity.GetUserName();

                        PD.ActionType = "CREATE";

                        PD.SongID = Convert.ToInt32(i);

                        var r = PDBL.AddSong(PD, InsertUser);                       

                    }

                    PD.ActionType = "CREATE";

                    PD.SongsList = SBL.SongList().OrderBy(x => x.SongName).ToList();

                    return View(PD);
                }
                else
                {
                    return View(PD);
                }
            }
            else
            {
                return this.RedirectToAction("Login", "Account");
            }
        }

        public ActionResult Disable(int id)
        {
            string InsertUser = User.Identity.GetUserName();

            int r = PDBL.Disable(id, InsertUser);

            if (r == 0)
            {
                ViewBag.Mensaje = "Ha ocurrido un error inesperado.";
                return View("~/Views/Shared/Error.cshtml");
            }
            else
            {
                //ViewBag.SongID = MS.SongID;
                return this.RedirectToAction("Details", "Programs", new { id = r });
                //return View();
            }
        }

        public ActionResult WeeklyProgram()
        {
            if (Request.IsAuthenticated)
            {
                ControllerDirectory val = CDBL.Validation(this.ControllerContext.RouteData.Values["controller"].ToString(), User.Identity.Name, AppID);

                if (val.ReadFlag == true)
                {
                    ViewBag.WriteFlag = val.WriteFlag;
                    return View(PBL.WeeklyProgram().ToList());
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

        public ActionResult _Details(int id)
        {
            var details = from p in PBL.WeeklyProgram()
                          where p.ProgramID == id
                          select p;

            Programs Program = details.FirstOrDefault();

            CultureInfo ci = new CultureInfo("Es-Es");

            string day = ci.DateTimeFormat.GetDayName(Program.ProgramDate.DayOfWeek).ToString();

            ViewBag.DayName = day.First().ToString().ToUpper() + day.Substring(1);

            ViewBag.PDate = Program.ProgramDate.ToString("dd/MM/yyyy");

            ViewBag.PSchedule = Program.ProgramSchedule;

            ViewBag.Status = Program.CompleteFlag;

            ViewBag.PID = id;

            ViewBag.ND = Program.NotificationDate;

            

            ControllerDirectory val = CDBL.Validation(this.ControllerContext.RouteData.Values["controller"].ToString(), User.Identity.Name, AppID);

            ViewBag.WriteFlag = val.WriteFlag;

            List<ProgramDetails> PDetails = new List<ProgramDetails>();

            PDetails = PDBL.Details(id).OrderBy(x => x.SongsData.SongName).ToList();

            foreach (var r in PDetails)
            {
                r.Status = Program.CompleteFlag;
            }

            ViewBag.Rows = PDetails.Count;

            return View(PDetails);
        }

        public ActionResult CopyProgram(int id)
        {
            if (Request.IsAuthenticated)
            {
                var details = from p in PBL.WeeklyProgram()
                              where p.ProgramID == id
                              select p;

                Programs Program = details.FirstOrDefault();

                CultureInfo ci = new CultureInfo("Es-Es");

                string day = ci.DateTimeFormat.GetDayName(Program.ProgramDate.DayOfWeek).ToString();

                ViewBag.DayName = day.First().ToString().ToUpper() + day.Substring(1);

                ViewBag.PDate = Program.ProgramDate.ToString("dd/MM/yyyy");

                ViewBag.PSchedule = Program.ProgramSchedule;

                ViewBag.PID = id;

                var ProgramsList = from p in PBL.AvailableProgramsForCopy(id)
                                  select p;

                CopyProgram CP = new CopyProgram()
                {
                    ProgramIDTarget = id,
                    ProgramList = ProgramsList.ToList()
                };

                return View(CP);
            }
            else
            {
                return this.RedirectToAction("Login", "Account");
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult CopyProgram(CopyProgram CP)
        {
            if(ModelState.IsValid)
            {
                string InsertUser = User.Identity.GetUserName();

                PBL.CopyProgram(CP, InsertUser);

                CP.ActionType = "CREATE";

                CP.ProgramList = PBL.AvailableProgramsForCopy(CP.ProgramIDTarget).ToList();

                return View(CP);
            }
            return View(CP);

        }

        public ActionResult NotificationEmail(int id)
        {
            List<ProgramDetails> PDetails = new List<ProgramDetails>();

            PDetails = PDBL.Details(id).OrderBy(x => x.SongsData.SongName).ToList();

            var details = from p in PBL.ProgramList()
                          where p.ProgramID == id
                          select p;

            Programs Program = details.FirstOrDefault();

            CultureInfo ci = new CultureInfo("Es-Es");

            string day = ci.DateTimeFormat.GetDayName(Program.ProgramDate.DayOfWeek).ToString();

            string Weekday = day.First().ToString().ToUpper() + day.Substring(1);

            string PDate = Program.ProgramDate.ToString("dd/MM/yyyy");

            string PSchedule = Program.ProgramSchedule;

            string label = "Ya se encuentra disponible el programa para el próximo " + Weekday + " " + PDate + " a las " + PSchedule;

            StringBuilder mailBody = new StringBuilder();
            mailBody.AppendFormat("<div><h2>Ministerio de Artes - Oasis Alajuela</h2><h2>Area Musical</h2></div><hr />");
            mailBody.AppendFormat("<h3>Buenas...</h3>");
            mailBody.AppendFormat("<p>" + label + "</p>");
            mailBody.AppendFormat("<h3>Programa:</h3>");
            foreach (var r in PDetails)
            {
                mailBody.AppendFormat("<p style=\"padding - left: 15px;\">- " + r.SongsData.SongName + " (" + r.AuthorsData.AuthorName + ")</p>");
            }
            mailBody.AppendFormat("<p>Toda la información necesaria esta a su disposición en http://mdaigleoa.azurewebsites.net/ </p>");
            mailBody.AppendFormat("<h3>Bendiciones...</h3>");

            var users = from u in UBL.List(AppID)
                        where u.ActiveFlag == true
                        select u;

            foreach (var model in users)
            {
                Emails Email = new Emails();

                Email.FromEmail = "johmstone@gmail.com";
                Email.ToEmail = model.Email;
                Email.SubjectEmail = "MDA - Oasis Alajuela - Area Musical - Programa: " + PDate + " - " + PSchedule;
                Email.BodyEmail = mailBody.ToString();

                MailMessage mmm = new MailMessage(Email.FromEmail, Email.ToEmail);
                mmm.Subject = Email.SubjectEmail;
                mmm.Body = Email.BodyEmail;
                mmm.IsBodyHtml = true;

                SmtpClient smtp = new SmtpClient();
                smtp.Send(mmm);
            }

            string InsertUser = User.Identity.GetUserName();

            var rpta = PBL.Notification(id, InsertUser);

            if (!rpta)
            {
                ViewBag.Mensaje = "Ha ocurrido un error inesperado.";
                return View("~/Views/Shared/Error.cshtml");
            }
            else
            {
                return this.RedirectToAction("Details", "Programs", new { id = id });
                
            }
        }
    }
}