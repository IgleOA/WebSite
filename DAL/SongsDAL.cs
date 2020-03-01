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
    public class SongsDAL
    {
        public List<Songs> Repertoires (int AuthorID)
        {
            List<Songs> Repertoire = new List<Songs>();

            try
            {
                using (var SqlCon = new SqlConnection(ConfigurationManager.ConnectionStrings["DB_MDA_CR_OA_Connection"].ToString()))
                {
                    SqlCon.Open();
                    var SqlCmd = new SqlCommand("[music].[uspSongsbyAuthor]", SqlCon)
                    {
                        CommandType = CommandType.StoredProcedure
                    };

                    //Insert Parameters
                    SqlParameter ParAuthorID = new SqlParameter
                    {
                        ParameterName = "@AuthorID",
                        SqlDbType = SqlDbType.Int,
                        Value = AuthorID
                    };
                    SqlCmd.Parameters.Add(ParAuthorID);

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

                            Repertoire.Add(song);

                        }
                    }

                    foreach (var u in Repertoire)
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
                                u.AuthorsData.ProfileLink = dr["ProfileLink"].ToString();
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
            return Repertoire;
        }

        public List<Songs> SongList()
        {
            List<Songs> List = new List<Songs>();

            try
            {
                using (var SqlCon = new SqlConnection(ConfigurationManager.ConnectionStrings["DB_MDA_CR_OA_Connection"].ToString()))
                {
                    SqlCon.Open();
                    var SqlCmd = new SqlCommand("[music].[uspReadSongs]", SqlCon)
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
                    foreach(var u in List)
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
                                u.AuthorsData.ProfileLink = dr["ProfileLink"].ToString();
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

        public bool AddNew(Songs Song, string InsertUser)
        {
            bool rpta = false;
            try
            {
                using (var SqlCon = new SqlConnection(ConfigurationManager.ConnectionStrings["DB_MDA_CR_OA_Connection"].ToString()))
                {
                    SqlCon.Open();
                    var SqlCmd = new SqlCommand("[music].[uspAddSong]", SqlCon)
                    {
                        CommandType = CommandType.StoredProcedure
                    };

                    //Insert Parameters
                    SqlParameter ParInsertUser = new SqlParameter
                    {
                        ParameterName = "@InsertUser",
                        SqlDbType = SqlDbType.VarChar,
                        Size = 50,
                        Value = InsertUser
                    };
                    SqlCmd.Parameters.Add(ParInsertUser);

                    SqlParameter ParFullName = new SqlParameter
                    {
                        ParameterName = "@SongName",
                        SqlDbType = SqlDbType.VarChar,
                        Size = 50,
                        Value = Song.SongName
                    };
                    SqlCmd.Parameters.Add(ParFullName);

                    SqlParameter ParRoleID = new SqlParameter
                    {
                        ParameterName = "@AuthorID",
                        SqlDbType = SqlDbType.Int,
                        Value = Song.AuthorID
                    };
                    SqlCmd.Parameters.Add(ParRoleID);

                    //EXEC Command
                    SqlCmd.ExecuteNonQuery();

                    rpta = true;

                    if (SqlCon.State == ConnectionState.Open) SqlCon.Close();

                }
            }
            catch (Exception ex)
            {
                throw;
            }
            return rpta;
        }

        public List<Songs> Top10()
        {
            List<Songs> List = new List<Songs>();

            try
            {
                using (var SqlCon = new SqlConnection(ConfigurationManager.ConnectionStrings["DB_MDA_CR_OA_Connection"].ToString()))
                {
                    SqlCon.Open();
                    var SqlCmd = new SqlCommand("[music].[uspReadTop10Songs]", SqlCon)
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
                                AuthorID = Convert.ToInt32(dr["AuthorID"]),
                                RowNumber = Convert.ToInt32(dr["RowNumber"]),
                                Times = Convert.ToInt32(dr["Times"])
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
