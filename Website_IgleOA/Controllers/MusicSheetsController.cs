using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;
using System.IO;
using ET;
using BL;
using Microsoft.AspNet.Identity;

namespace MDA_IgleOA.Controllers
{
    public class MusicSheetsController : Controller
    {
        private MusicSheetsBL MSBL = new MusicSheetsBL();
        private SongsBL SongsBL = new SongsBL();
        private MSTypesBL MSTBL = new MSTypesBL();
        private InstrumentsBL IBL = new InstrumentsBL();
        private ControllerDirectoryBL CDBL = new ControllerDirectoryBL();
        private int AppID = 2;

        // GET: MusicSheets
        public ActionResult Index()
        {
            if (Request.IsAuthenticated)
            {
                ControllerDirectory val = CDBL.Validation(this.ControllerContext.RouteData.Values["controller"].ToString(), User.Identity.Name, AppID);

                if (val.ReadFlag == true)
                {
                    string InsertUser = User.Identity.GetUserName();

                    ViewBag.WriteFlag = val.WriteFlag;

                    List<MusicSheets> Charts = MSBL.MSList(InsertUser);
                    return View(Charts.ToList());
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

        public ActionResult MusicSheetsbySong(int SongID)
        {
            if (Request.IsAuthenticated)
            {
                ControllerDirectory val = CDBL.Validation(this.ControllerContext.RouteData.Values["controller"].ToString(), User.Identity.Name, AppID);

                if (val.ReadFlag == true)
                {
                    string InsertUser = User.Identity.GetUserName();

                    ViewBag.WriteFlag = val.WriteFlag;

                    List<MusicSheets> Charts = MSBL.MusicSheetsbySong(SongID, InsertUser);

                    var songname = from s in SongsBL.SongList()
                                   where s.SongID == SongID
                                   select s.SongName;

                    ViewBag.SongID = SongID;
                    ViewBag.SongName = songname.FirstOrDefault().ToString();

                    return View(Charts.ToList());
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

        public ActionResult CreatebySong(int SongID)
        {
            if (Request.IsAuthenticated)
            {
                MusicSheets Chart = new MusicSheets();

                var songlist = from s in SongsBL.SongList()
                               where s.SongID == SongID
                               select s;

                Chart.SongID = SongID;

                Chart.SongList = songlist.ToList();

                Chart.MSTypeList = MSTBL.MSTypeList().ToList();

                Chart.InstrumentList = IBL.InstrumentList().ToList();

                var SongName = from s in SongsBL.SongList()
                               where s.SongID == SongID
                               select s.SongName;

                ViewBag.SongName = SongName.FirstOrDefault().ToString();

                return View(Chart);
            }
            else
            {
                return this.RedirectToAction("Login", "Account");
            }

        }

        [HttpPost]
        public ActionResult CreatebySong(MusicSheets MS)
        {

            String FileExt = Path.GetExtension(MS.files.FileName).ToUpper();

            if (FileExt == ".PDF")
            {
                Stream str = MS.files.InputStream;
                BinaryReader Br = new BinaryReader(str);
                Byte[] FileDet = Br.ReadBytes((Int32)str.Length);

                MS.FileName = MS.files.FileName;
                MS.FileData = FileDet;

                string InsertUser = User.Identity.GetUserName();

                var r = MSBL.AddNew(MS, InsertUser);

                if (!r)
                {
                    ViewBag.Mensaje = "Ha ocurrido un error inesperado.";
                    return View("~/Views/Shared/Error.cshtml");
                }
                else
                {
                    return RedirectToAction("MusicSheetsbySong", new { SongID = MS.SongID });
                }
            }
            else
            {

                ViewBag.FileStatus = "Archivo de formato Invalido.";
                return View();

            }

        }

        [HttpGet]
        public FileResult DownLoadFile(int id)
        {
            string InsertUser = User.Identity.GetUserName();

            List<MusicSheets> ObjFiles = MSBL.MSList(InsertUser);

            var FileById = (from FC in ObjFiles
                            where FC.MSID.Equals(id)
                            select new { FC.FileName, FC.FileData }).ToList().FirstOrDefault();

            return File(FileById.FileData, "application/pdf", FileById.FileName);


        }

        public ActionResult Create()
        {
            if (Request.IsAuthenticated)
            {
                MusicSheets Chart = new MusicSheets();

                Chart.SongList = SongsBL.SongList().ToList();

                Chart.MSTypeList = MSTBL.MSTypeList().ToList();

                Chart.InstrumentList = IBL.InstrumentList().ToList();

                return View(Chart);
            }
            else
            {
                return this.RedirectToAction("Login", "Account");
            }

        }

        [HttpPost]
        public ActionResult Create(MusicSheets MS)
        {

            String FileExt = Path.GetExtension(MS.files.FileName).ToUpper();

            if (FileExt == ".PDF")
            {
                Stream str = MS.files.InputStream;
                BinaryReader Br = new BinaryReader(str);
                Byte[] FileDet = Br.ReadBytes((Int32)str.Length);

                MS.FileName = MS.files.FileName;
                MS.FileData = FileDet;

                string InsertUser = User.Identity.GetUserName();

                var r = MSBL.AddNew(MS, InsertUser);

                if (!r)
                {
                    ViewBag.Mensaje = "Ha ocurrido un error inesperado.";
                    return View("~/Views/Shared/Error.cshtml");
                }
                else
                {
                    MS.ActionType = "CREATE";

                    MS.SongList = SongsBL.SongList().ToList();

                    MS.MSTypeList = MSTBL.MSTypeList().ToList();

                    MS.InstrumentList = IBL.InstrumentList().ToList();

                    return View(MS);
                }
            }
            else
            {

                ViewBag.FileStatus = "Archivo de formato Invalido.";
                return View();

            }

        }

        public ActionResult Edit(int id = 0)
        {
            if ((Request.IsAuthenticated))
            {
                string InsertUser = User.Identity.GetUserName();

                MusicSheets MS = MSBL.Details(id, InsertUser);

                MS.SongList = SongsBL.SongList().ToList();

                MS.MSTypeList = MSTBL.MSTypeList().ToList();

                MS.InstrumentList = IBL.InstrumentList().ToList();

                ViewBag.MSID = id;

                return View(MS);
            }
            else
            {
                return this.RedirectToAction("Login", "Account");
            }
        }

        //[HttpPost]
        public ActionResult Disable(int id)
        {
            string InsertUser = User.Identity.GetUserName();

            MusicSheets MS = MSBL.Details(id, InsertUser);

            MS.ActiveFlag = false;

            var r = MSBL.Update(MS, InsertUser);

            if (!r)
            {
                ViewBag.Mensaje = "Ha ocurrido un error inesperado.";
                return View("~/Views/Shared/Error.cshtml");
            }
            else
            {
                //ViewBag.SongID = MS.SongID;
                return this.RedirectToAction("MusicSheetsbySong", "MusicSheets", new { SongID = MS.SongID });
                //return View();
            }
        }


        public ActionResult ChangeFavorite(int id)
        {
            string InsertUser = User.Identity.GetUserName();

            MusicSheets MS = MSBL.Details(id, InsertUser);

            var r = MSBL.UpdateFavorite(id, InsertUser);

            if (!r)
            {
                ViewBag.Mensaje = "Ha ocurrido un error inesperado.";
                return View("~/Views/Shared/Error.cshtml");
            }
            else
            {
                //ViewBag.SongID = MS.SongID;
                return this.RedirectToAction("MusicSheetsbySong", "MusicSheets", new { SongID = MS.SongID });
                //return View();
            }
        }

        public ActionResult AddVersion(int id = 0)
        {
            if ((Request.IsAuthenticated))
            {
                string InsertUser = User.Identity.GetUserName();

                MusicSheets MS = MSBL.Details(id, InsertUser);

                return View(MS);
            }
            else
            {
                return this.RedirectToAction("Login", "Account");
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult AddVersion(MusicSheets MS)
        {
            string InsertUser = User.Identity.GetUserName();

            var r = MSBL.Update(MS, InsertUser);

            if (!r)
            {
                ViewBag.Mensaje = "Ha ocurrido un error inesperado.";
                return View("~/Views/Shared/Error.cshtml");
            }
            else
            {
                MS.ActionType = "CREATE";

                return View(MS);
            }
        }

        public ActionResult Vizor(int id = 0)
        {
            string InsertUser = User.Identity.GetUserName();

            MusicSheets MS = MSBL.Details(id, InsertUser);

            ViewBag.MSType = MS.MSTypesData.MSTypeName.ToString();

            ViewBag.Instrument = MS.InstrumentsData.Instrument.ToString();

            ViewBag.SongName = MS.SongsData.SongName.ToString();

            ViewBag.Label = MS.MSTypesData.MSTypeName.ToString() + " para " + MS.InstrumentsData.Instrument.ToString() + " de " + MS.SongsData.SongName.ToString();

            ViewBag.ID = id;
            return View();
        }

        public ActionResult GetPDF(int id = 0)
        {
            string InsertUser = User.Identity.GetUserName();

            List<MusicSheets> ObjFiles = MSBL.MSList(InsertUser);

            var FileById = (from FC in ObjFiles
                            where FC.MSID.Equals(id)
                            select new { FC.FileName, FC.FileData }).ToList().FirstOrDefault();

            string strFile = FileById.FileName.ToString();

            return File(FileById.FileData, System.Net.Mime.MediaTypeNames.Application.Pdf);
        }

        public ActionResult Details(int id = 0)
        {
            if ((Request.IsAuthenticated))
            {
                string InsertUser = User.Identity.GetUserName();

                MusicSheets MS = MSBL.Details(id, InsertUser);
                MS.Version = MS.Version.Replace("https://youtu.be/", "https://www.youtube.com/embed/");
                MS.Version = MS.Version.Replace("https://www.youtube.com/watch?v=", "https://www.youtube.com/embed/");
                MS.Version = MS.Version.Replace("\"", "");
                MS.Version = MS.Version + "?autoplay=1";
                return View(MS);
            }
            else
            {
                return this.RedirectToAction("Login", "Account");
            }
        }

        public ActionResult Favorites()
        {
            if (Request.IsAuthenticated)
            {
                string InsertUser = User.Identity.GetUserName();

                List<MusicSheets> Charts = MSBL.MSList(InsertUser);

                Charts = Charts.Where(x => x.Favorite.Equals(true)).ToList();

                return View(Charts);
            }
            else
            {
                return this.RedirectToAction("Login", "Account");
            }

        }
    }
}