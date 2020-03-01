using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web.Mvc;
using BL;
using ET;
using Microsoft.AspNet.Identity;
using PagedList;

namespace MDA_IgleOA.Controllers
{
    public class PreachesController : Controller
    {
        private PreachesBL PBL = new PreachesBL();
        private ControllerDirectoryBL CDBL = new ControllerDirectoryBL();
        private MinistersBL MBL = new MinistersBL();
        private int AppID = 1;

        // GET: Preaches
        public ActionResult Index(string sortOrder, string currentFilter, string searchString, int? page)
        {
            if (Request.IsAuthenticated)
            {
                ControllerDirectory val = CDBL.Validation(this.ControllerContext.RouteData.Values["controller"].ToString(), User.Identity.Name, AppID);

                if (val.ReadFlag == true)
                {
                    ViewBag.WriteFlag = val.WriteFlag;

                    ViewBag.CurrentSort = sortOrder;
                    ViewBag.NameSortParm = String.IsNullOrEmpty(sortOrder) ? "name_desc" : "name_asc";
                    ViewBag.DateSortParm = sortOrder == "Date" ? "date_asc" : "Date";

                    if (searchString != null)
                    {
                        page = 1;
                    }
                    else
                    {
                        searchString = currentFilter;
                    }

                    ViewBag.CurrentFilter = searchString;

                    var preaches = from s in PBL.List()
                                   select s;

                    if(!String.IsNullOrEmpty(searchString))
                    {
                        preaches = preaches.Where(s => s.Description.Contains(searchString)
                                                  || s.Tags.Contains(searchString)
                                                  || s.Title.Contains(searchString));
                    }

                    switch(sortOrder)
                    {
                        case "name_desc":
                            preaches = preaches.OrderByDescending(s => s.Title);
                            break;
                        case "name_asc":
                            preaches = preaches.OrderBy(s => s.Title);
                            break;
                        case "date_asc":
                            preaches = preaches.OrderBy(s => s.PreachingDate);
                            break;
                        default:
                            preaches = preaches.OrderByDescending(s => s.PreachingDate);
                            break;
                    }

                    int pageSize = 10;
                    int pageNumber = (page ?? 1);

                    return View(preaches.ToPagedList(pageNumber, pageSize));
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
        // GET: /Authors/Create
        public ActionResult Create()
        {
            if (Request.IsAuthenticated)
            {
                Preaches Preach = new Preaches();

                Preach.MinistersList = MBL.List();

                return View(Preach);
            }
            else
            {
                return this.RedirectToAction("Login", "Account");
            }
        }

        //
        // POST: /Authors/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create(Preaches Preach)
        {
            String FileExt = Path.GetExtension(Preach.files.FileName).ToUpper();

            if (FileExt == ".MP3" || FileExt == ".MP4")
            {
                Stream str = Preach.files.InputStream;
                BinaryReader Br = new BinaryReader(str);
                byte[] FileDet = Br.ReadBytes((int)str.Length);

                Preach.FileData = FileDet;
                Preach.FileType = FileExt;
                string InsertUser = User.Identity.GetUserName();

                Preach.Tags = Preach.Tags.Replace(",", ", ");

                var r = PBL.AddNew(Preach, InsertUser);

                if (!r)
                {
                    ViewBag.Mensaje = "Ha ocurrido un error inesperado.";
                    return View("~/Views/Shared/Error.cshtml");
                }
                else
                {
                    Preach.ActionType = "CREATE";

                    Preach.MinistersList = MBL.List();

                    return View(Preach);
                }
            }
            else
            {

                ViewBag.FileStatus = "Archivo de formato Invalido, solo es permitido subir audios MP3 o videos MP4.";
                return View();

            }
        }

        public ActionResult GetFile(int id = 0)
        {
            var FileById = PBL.Details(id);

            string strFile = FileById.Title.ToString() + "_" + FileById.PreachingDate.ToString("dd_MM_yyyy") + FileById.FileType;

            return File(FileById.FileData, System.Net.Mime.MediaTypeNames.Application.Octet, strFile);
        }

        public ActionResult Details (int id)
        {
            if ((Request.IsAuthenticated))
            {
                var detail = PBL.Details(id);

                return View(detail);
            }
            else
            {
                return this.RedirectToAction("Login", "Account");
            }
        }
    }
}