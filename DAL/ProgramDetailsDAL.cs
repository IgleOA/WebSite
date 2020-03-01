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
    public class ProgramDetailsDAL
    {
        public List<ProgramDetails> Details(int ProgramID)
        {
            List<ProgramDetails> List = new List<ProgramDetails>();
            try
            {
                using (var SqlCon = new SqlConnection(ConfigurationManager.ConnectionStrings["DB_MDA_CR_OA_Connection"].ToString()))
                {
                    SqlCon.Open();
                    var SqlCmd = new SqlCommand("[music].[uspSearchProgramDetails]", SqlCon)
                    {
                        CommandType = CommandType.StoredProcedure
                    };

                    SqlParameter ParPID = new SqlParameter
                    {
                        ParameterName = "@ProgramID",
                        SqlDbType = SqlDbType.Int,
                        Value = ProgramID
                    };
                    SqlCmd.Parameters.Add(ParPID);

                    using (var dr = SqlCmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            var Song = new ProgramDetails
                            {
                                SPID = Convert.ToInt32(dr["SPID"]),
                                ProgramID = Convert.ToInt32(dr["ProgramID"]),
                                SongID = Convert.ToInt32(dr["SongID"]),
                                AuthorID = Convert.ToInt32(dr["AuthorID"]),
                                ActiveFlag = Convert.ToBoolean(dr["ActiveFlag"])
                            };

                            List.Add(Song);

                        }
                    }
                    foreach(var u in List)
                    {
                        SqlCmd = new SqlCommand("[music].[uspSearchSong]", SqlCon)
                        {
                            CommandType = CommandType.StoredProcedure
                        };

                        SqlCmd.Parameters.AddWithValue("@SongID", u.SongID);
                        using (var dr = SqlCmd.ExecuteReader())
                        {
                            dr.Read();
                            if (dr.HasRows)
                            {
                                u.SongsData.SongID = Convert.ToInt32(dr["SongID"]);
                                u.SongsData.SongName = dr["SongName"].ToString();
                            }
                        }

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

        public bool AddSong (ProgramDetails PD, string InsertUser)
        {
            bool rpta = false;

            try
            {
                using (var SqlCon = new SqlConnection(ConfigurationManager.ConnectionStrings["DB_MDA_CR_OA_Connection"].ToString()))
                {
                    SqlCon.Open();
                    var SqlCmd = new SqlCommand("[music].[uspAddSongbyProgram]", SqlCon)
                    {
                        CommandType = CommandType.StoredProcedure
                    };

                    //Insert Parameters
                    SqlParameter ParName = new SqlParameter
                    {
                        ParameterName = "@ProgramID",
                        SqlDbType = SqlDbType.Int,
                        Value = PD.ProgramID
                    };
                    SqlCmd.Parameters.Add(ParName);

                    SqlParameter ParProfile = new SqlParameter
                    {
                        ParameterName = "@SongID",
                        SqlDbType = SqlDbType.Int,
                        Value = PD.SongID
                    };
                    SqlCmd.Parameters.Add(ParProfile);

                    SqlParameter ParInsertUser = new SqlParameter
                    {
                        ParameterName = "@InsertUser",
                        SqlDbType = SqlDbType.VarChar,
                        Size = 50,
                        Value = InsertUser
                    };
                    SqlCmd.Parameters.Add(ParInsertUser);

                    //Exec Command
                    SqlCmd.ExecuteNonQuery();

                    rpta = true;

                    if (SqlCon.State == ConnectionState.Open) SqlCon.Close();
                }
            }
            catch(Exception ex)
            {
                throw;
            }
            return rpta;
        }

        public int Disable (int id, string InsertUser)
        {
            int rpta = 0;

            try
            {
                using (var SqlCon = new SqlConnection(ConfigurationManager.ConnectionStrings["DB_MDA_CR_OA_Connection"].ToString()))
                {
                    SqlCon.Open();
                    var SqlCmd = new SqlCommand("[music].[uspUpdateSongbyProgram]", SqlCon)
                    {
                        CommandType = CommandType.StoredProcedure
                    };

                    //Insert Parameters
                    SqlParameter ParSPID = new SqlParameter
                    {
                        ParameterName = "@SPID",
                        SqlDbType = SqlDbType.Int,
                        Value = id
                    };
                    SqlCmd.Parameters.Add(ParSPID);

                    SqlParameter ParInsertUser = new SqlParameter
                    {
                        ParameterName = "@InsertUser",
                        SqlDbType = SqlDbType.VarChar,
                        Size = 50,
                        Value = InsertUser
                    };
                    SqlCmd.Parameters.Add(ParInsertUser);

                    //Exec Command
                    rpta = Convert.ToInt32(SqlCmd.ExecuteScalar());

                    if (SqlCon.State == ConnectionState.Open) SqlCon.Close();
                }
            }
            catch(Exception ex)
            {
                throw;
            }
            return rpta;
        }
    }
}
