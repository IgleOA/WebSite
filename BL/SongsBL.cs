using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DAL;
using ET;

namespace BL
{
    public class SongsBL
    {
        private SongsDAL SongsDAL = new SongsDAL();

        public List<Songs> Reportoires (int authorid)
        {
            return SongsDAL.Repertoires(authorid);
        }

        public List<Songs> SongList ()
        {
            return SongsDAL.SongList();
        }

        public bool AddNew(Songs song, string insertuser)
        {
            return SongsDAL.AddNew(song, insertuser);
        }

        public List<Songs> Top10 ()
        {
            return SongsDAL.Top10();
        }
    }
}
