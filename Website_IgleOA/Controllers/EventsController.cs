using System;
using System.Globalization;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using BL;
using ET;

namespace Website_IgleOA.Controllers
{
    public class EventsController : Controller
    {
        private EventsBL EBL = new EventsBL();

        // GET: Events
        public ActionResult Index(int id, DateTime? date)
        {
            if (Request.IsAuthenticated)
            {
                DateTime FinalDate = DateTime.Now;

                if (date == null)
                {
                    FinalDate = DateTime.Now;
                }
                else
                {
                    FinalDate = Convert.ToDateTime(date);
                }

                ViewBag.NextMonth = FinalDate.AddMonths(1);
                ViewBag.PrevMonth = FinalDate.AddMonths(-1);

                CultureInfo ci = new CultureInfo("Es-Es");

                string month = ci.DateTimeFormat.GetMonthName(FinalDate.Month).ToString();

                string year = FinalDate.Year.ToString();

                string monthname = month.First().ToString().ToUpper() + month.Substring(1);

                ViewBag.LabelMonth = monthname + " " + year;

                List<Events> EventList = EBL.List(FinalDate).OrderBy(x => x.StartDate).ToList();

                List<Agenda> AgendaList = new List<Agenda>();

                foreach (var r in EventList)
                {
                    string time1 = r.StartDate.ToShortTimeString();
                    string time2 = "";
                    string time = time1;

                    if (r.EndDate == null)
                    {
                        time2 = "";
                    }
                    else
                    {
                        time2 = Convert.ToDateTime(r.EndDate).ToShortTimeString();
                        time = time + " - " + time2;
                    }


                    if (r.IsFullDay == true)
                    {
                        time = "Todo el dia";
                    }

                    Agenda eve = new Agenda
                    {
                        EventID = r.EventID,
                        DayofMonth = r.StartDate.Day,
                        DayofWeek = ci.DateTimeFormat.GetDayName(r.StartDate.DayOfWeek).ToString(),
                        Date = r.StartDate.ToShortDateString(),
                        Time = time,
                        EventType = r.EventTypeData.EventTypeName,
                        Title = r.Subject,
                        Description = r.Description
                    };

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

                    AgendaList.Add(eve);
                }


                return View(AgendaList.ToList());
            }
            else
            {
                return this.RedirectToAction("Login", "Account");
            }
        }
    }
}