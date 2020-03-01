using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ET;
using DAL;

namespace BL
{
    public class MusicSheetsBL
    {
        private MusicSheetsDAL MSDAL = new MusicSheetsDAL();

        public List<MusicSheets> MusicSheetsbySong (int songid, string user)
        {
            return MSDAL.MusicSheetsbySong(songid,user);
        }

        public bool AddNew (MusicSheets musicsheet, string insertuser)
        {
            return MSDAL.AddNew(musicsheet, insertuser);
        }

        public bool Update(MusicSheets musicsheet, string insertuser)
        {
            return MSDAL.Update(musicsheet, insertuser);
        }

        public List<MusicSheets> MSList (string user)
        {
            return MSDAL.MSList(user);
        }

        public MusicSheets Details(int msid, string user)
        {
            return MSDAL.Details(msid, user);
        }

        public bool UpdateFavorite(int msid, string user)
        {
            return MSDAL.UpdateFavorite(msid, user);
        }
    }
}
