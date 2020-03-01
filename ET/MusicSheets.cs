using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;
using System.Web;


namespace ET
{
    public class MusicSheets
    {
        [Key]
        public int MSID { get; set; }

        [Required]
        [Display(Name ="Tipo")]
        public int MSTypeID { get; set; }

        [Required]
        [Display(Name ="Canción")]
        public int SongID { get; set; }

        [Required]
        [Display(Name = "Versión")]
        public string Version { get; set; }

        [Required]
        [Display(Name ="Instrumento")]
        public int InstrumentID { get; set; }

        [Required]
        [Display(Name ="Tonalidad")]
        public string Tonality { get; set; }

        [Required]
        [Display(Name ="Nombre")]
        public string FileName { get; set; }

        public bool ActiveFlag { get; set; }

        [Display(Name = "Favorito")]
        public bool Favorite { get; set; }

        [Required]
        [Display(Name = "Archivo")]
        public byte[] FileData { get; set; }

        [Required(ErrorMessage = "Por favor seleccione el archivo")]
        [DataType(DataType.Upload)]
        [Display(Name = "Archivo")]
        public HttpPostedFileBase files { get; set; }

        public MusicSheetTypes MSTypesData { get; set; }

        public Songs SongsData { get; set; }

        public Instruments InstrumentsData { get; set; }

        public MusicSheets()
        {
            MSTypesData = new MusicSheetTypes();
            SongsData = new Songs();
            InstrumentsData = new Instruments();
        }

        public List<MusicSheetTypes> MSTypeList { get; set; }
        public List<Songs> SongList { get; set; }
        public List<Instruments> InstrumentList { get; set; }

        public List<string> Tonalities()
        {
            return new List<string>
            {
                "C","D","E","F","G","A","B","C#","D#","F#","G#","A#","Db","Eb","Gb","Ab","Bb"

            };
        }

        public string ActionType { get; set; }
    }
}
