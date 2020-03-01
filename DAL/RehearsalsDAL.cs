using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using System.Data.Sql;
using System.Data.SqlClient;
using System.Configuration;
using ET;

namespace DAL
{
    public class RehearsalsDAL
    {
        public List<Songs> Rehearsal()
        {
            List<Songs> List = new List<Songs>();

            try
            {
                using (var SqlCon = new SqlConnection(ConfigurationManager.ConnectionStrings["DB_MDA_CR_OA_Connection"].ToString()))
                {
                    SqlCon.Open();
                    var SqlCmd = new SqlCommand("[music].[uspReadNextRehearsal]", SqlCon)
                    {
                        CommandType = CommandType.StoredProcedure
                    };

                    using (var dr = SqlCmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            var song = new Songs
                            {
                                SongID = Convert.ToInt32(dr["SongID"]),
                                SongName = dr["SongName"].ToString(),
                                AuthorID = Convert.ToInt32(dr["AuthorID"])
                            };

                            List.Add(song);

                        }
                    }
                    foreach (var u in List)
                    {
                        SqlCmd = new SqlCommand("[music].[uspSearchAuthor]", SqlCon)
                        {
                            CommandType = CommandType.StoredProcedure
                        };

                        SqlCmd.Parameters.AddWithValue("@AuthorID", u.AuthorID);

                        using (var dr = SqlCmd.ExecuteReader())
                        {
                            dr.Read();
                            if (dr.HasRows)
                            {
                                u.AuthorsData.AuthorID = Convert.ToInt32(dr["AuthorID"]);
                                u.AuthorsData.AuthorName = dr["AuthorName"].ToString();
                            }
                        }
                    }

                    if (SqlCon.State == ConnectionState.Open) SqlCon.Close();
                }
            }
            catch (Exception ex)
            {
                throw;
            }
            return List;
        }
    }
}
