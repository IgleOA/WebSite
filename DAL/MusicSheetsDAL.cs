using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Dapper;
using System.Data;
using System.Data.Sql;
using System.Data.SqlClient;
using System.Configuration;
using ET;          

namespace DAL
{
    public class MusicSheetsDAL
    {
        public List<MusicSheets> MusicSheetsbySong (int SongID, string User)
        {
            List<MusicSheets> Charts = new List<MusicSheets>();

            try
            {
                var SqlCon = new SqlConnection(ConfigurationManager.ConnectionStrings["DB_MDA_CR_OA_Connection"].ToString());

                SqlCon.Open();

                DynamicParameters parameters = new DynamicParameters();

                parameters.Add("@SongID", SongID, DbType.Int32, ParameterDirection.Input);
                parameters.Add("@User", User, DbType.String, ParameterDirection.Input);

                Charts = SqlMapper.Query<MusicSheets>(SqlCon, "[music].[uspReadMusicSheetsbySong]", parameters, commandType: CommandType.StoredProcedure).ToList();

                foreach(var u in Charts)
                {
                    // Insert Music Types Information
                    var SqlCmd = new SqlCommand("[music].[uspSearchMSTypes]", SqlCon)
                    {
                        CommandType = CommandType.StoredProcedure
                    };

                    SqlCmd.Parameters.AddWithValue("@MSTypeID", u.MSTypeID);

                    using (var dr = SqlCmd.ExecuteReader())
                    {
                        dr.Read();
                        if (dr.HasRows)
                        {
                            u.MSTypesData.MSTypeID = Convert.ToInt32(dr["MSTypeID"]);
                            u.MSTypesData.MSTypeName = dr["MSTypeName"].ToString();
                        }
                    }
                    
                    // Insert Instrument information
                    SqlCmd = new SqlCommand("[music].[uspSearchInstrument]", SqlCon)
                    {
                        CommandType = CommandType.StoredProcedure
                    };

                    SqlCmd.Parameters.AddWithValue("@InstrumentID", u.InstrumentID);

                    using (var dr = SqlCmd.ExecuteReader())
                    {
                        dr.Read();
                        if (dr.HasRows)
                        {
                            u.InstrumentsData.InstrumentID = Convert.ToInt32(dr["InstrumentID"]);
                            u.InstrumentsData.Instrument = dr["Instrument"].ToString();
                        }
                    }

                }

                if (SqlCon.State == ConnectionState.Open) SqlCon.Close();

            }
            catch (Exception ex)
            {
                throw;
            }
            return Charts;
        }

        public bool AddNew (MusicSheets musicSheets, string InserUser)
        {
            bool rpta = false;

            try
            {
                DynamicParameters Parm = new DynamicParameters();
                Parm.Add("@InsertUser", InserUser);
                Parm.Add("@MSTypeID", musicSheets.MSTypeID);
                Parm.Add("@SongID", musicSheets.SongID);
                Parm.Add("@Version", musicSheets.Version);
                Parm.Add("@InstrumentID", musicSheets.InstrumentID);
                Parm.Add("@Tonality", musicSheets.Tonality);
                Parm.Add("@FileName", musicSheets.FileName);
                Parm.Add("@FileData", musicSheets.FileData);

                var SqlCon = new SqlConnection(ConfigurationManager.ConnectionStrings["DB_MDA_CR_OA_Connection"].ToString());

                SqlCon.Open();

                SqlCon.Execute("[music].[uspAddMusicSheet]", Parm, commandType: CommandType.StoredProcedure);

                rpta = true;

                if (SqlCon.State == ConnectionState.Open) SqlCon.Close();

            }
            catch(Exception ex)
            {
                throw;
            }

            return rpta;
        }

        public bool Update(MusicSheets musicSheets, string InserUser)
        {
            bool rpta = false;

            try
            {
                DynamicParameters Parm = new DynamicParameters();
                Parm.Add("@InsertUser", InserUser);
                Parm.Add("@MSID", musicSheets.MSID);
                Parm.Add("@MSTypeID", musicSheets.MSTypeID);
                Parm.Add("@SongID", musicSheets.SongID);
                Parm.Add("@Version", musicSheets.Version);
                Parm.Add("@InstrumentID", musicSheets.InstrumentID);
                Parm.Add("@Tonality", musicSheets.Tonality);
                Parm.Add("@ActiveFlag", musicSheets.ActiveFlag);

                var SqlCon = new SqlConnection(ConfigurationManager.ConnectionStrings["DB_MDA_CR_OA_Connection"].ToString());

                SqlCon.Open();

                SqlCon.Execute("[music].[uspUpdateMusicSheet]", Parm, commandType: CommandType.StoredProcedure);

                rpta = true;

                if (SqlCon.State == ConnectionState.Open) SqlCon.Close();

            }
            catch (Exception ex)
            {
                throw;
            }

            return rpta;
        }

        public List<MusicSheets> MSList(string User)
        {
            List<MusicSheets> Charts = new List<MusicSheets>();

            try
            {
                var SqlCon = new SqlConnection(ConfigurationManager.ConnectionStrings["DB_MDA_CR_OA_Connection"].ToString());

                SqlCon.Open();

                DynamicParameters parameters = new DynamicParameters();

                parameters.Add("@User", User, DbType.String, ParameterDirection.Input);

                Charts = SqlMapper.Query<MusicSheets>(SqlCon, "[music].[uspReadMusicSheets]",parameters ,commandType: CommandType.StoredProcedure).ToList();

                foreach (var u in Charts)
                {
                    // Insert Music Types Information
                    var SqlCmd = new SqlCommand("[music].[uspSearchMSTypes]", SqlCon)
                    {
                        CommandType = CommandType.StoredProcedure
                    };

                    SqlCmd.Parameters.AddWithValue("@MSTypeID", u.MSTypeID);

                    using (var dr = SqlCmd.ExecuteReader())
                    {
                        dr.Read();
                        if (dr.HasRows)
                        {
                            u.MSTypesData.MSTypeID = Convert.ToInt32(dr["MSTypeID"]);
                            u.MSTypesData.MSTypeName = dr["MSTypeName"].ToString();
                        }
                    }
                    // Insert Song Information
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

                    // Insert Instrument information
                    SqlCmd = new SqlCommand("[music].[uspSearchInstrument]", SqlCon)
                    {
                        CommandType = CommandType.StoredProcedure
                    };

                    SqlCmd.Parameters.AddWithValue("@InstrumentID", u.InstrumentID);

                    using (var dr = SqlCmd.ExecuteReader())
                    {
                        dr.Read();
                        if (dr.HasRows)
                        {
                            u.InstrumentsData.InstrumentID = Convert.ToInt32(dr["InstrumentID"]);
                            u.InstrumentsData.Instrument = dr["Instrument"].ToString();
                        }
                    }
                }

                if (SqlCon.State == ConnectionState.Open) SqlCon.Close();

            }
            catch (Exception ex)
            {
                throw;
            }
            return Charts;
        }

        public MusicSheets Details(int MSID, string User)
        {
            MusicSheets Chart = new MusicSheets();

            try
            {
                using (var SqlCon = new SqlConnection(ConfigurationManager.ConnectionStrings["DB_MDA_CR_OA_Connection"].ToString()))
                {
                    SqlCon.Open();
                    var SqlCmd = new SqlCommand("[music].[uspSearchMusicSheet]", SqlCon)
                    {
                        CommandType = CommandType.StoredProcedure
                    };

                    //Insert Parameters
                    SqlParameter ParMSID = new SqlParameter
                    {
                        ParameterName = "@MSID",
                        SqlDbType = SqlDbType.Int,
                        Value = MSID
                    };
                    SqlCmd.Parameters.Add(ParMSID);

                    SqlParameter ParUser = new SqlParameter
                    {
                        ParameterName = "@User",
                        SqlDbType = SqlDbType.VarChar,
                        Size = 50,
                        Value = User
                    };
                    SqlCmd.Parameters.Add(ParUser);

                    using (var dr = SqlCmd.ExecuteReader())
                    {
                        dr.Read();
                        if (dr.HasRows)
                        {
                            Chart.MSID = Convert.ToInt32(dr["MSID"]);
                            Chart.MSTypeID = Convert.ToInt32(dr["MSTypeID"]);
                            Chart.SongID = Convert.ToInt32(dr["SongID"]);
                            Chart.Version = dr["Version"].ToString();
                            Chart.InstrumentID = Convert.ToInt32(dr["InstrumentID"]);
                            Chart.Tonality = dr["Tonality"].ToString();
                            Chart.ActiveFlag = Convert.ToBoolean(dr["ActiveFlag"]);
                            Chart.Favorite = Convert.ToBoolean(dr["Favorite"]);
                            Chart.FileData = (byte[])(dr["FileData"]);
                        }
                    }

                    SqlCmd = new SqlCommand("[music].[uspSearchSong]", SqlCon)
                    {
                        CommandType = CommandType.StoredProcedure
                    };

                    SqlCmd.Parameters.AddWithValue("@SongID", Chart.SongID);
                    using (var dr = SqlCmd.ExecuteReader())
                    {
                        dr.Read();
                        if (dr.HasRows)
                        {
                            Chart.SongsData.SongID = Convert.ToInt32(dr["SongID"]);
                            Chart.SongsData.SongName = dr["SongName"].ToString();
                        }
                    }

                    SqlCmd = new SqlCommand("[music].[uspSearchMSTypes]", SqlCon)
                    {
                        CommandType = CommandType.StoredProcedure
                    };

                    SqlCmd.Parameters.AddWithValue("@MSTypeID", Chart.MSTypeID);
                    using (var dr = SqlCmd.ExecuteReader())
                    {
                        dr.Read();
                        if (dr.HasRows)
                        {
                            Chart.MSTypesData.MSTypeID = Convert.ToInt32(dr["MSTypeID"]);
                            Chart.MSTypesData.MSTypeName = dr["MSTypeName"].ToString();
                        }
                    }

                    SqlCmd = new SqlCommand("[music].[uspSearchInstrument]", SqlCon)
                    {
                        CommandType = CommandType.StoredProcedure
                    };

                    SqlCmd.Parameters.AddWithValue("@InstrumentID", Chart.InstrumentID);
                    using (var dr = SqlCmd.ExecuteReader())
                    {
                        dr.Read();
                        if (dr.HasRows)
                        {
                            Chart.InstrumentsData.InstrumentID = Convert.ToInt32(dr["InstrumentID"]);
                            Chart.InstrumentsData.Instrument = dr["Instrument"].ToString();
                        }
                    }

                    if (SqlCon.State == ConnectionState.Open) SqlCon.Close();
                }
            }
            catch(Exception ex)
            {
                throw;
            }
            return Chart;
        }

        public bool UpdateFavorite(int MSID, string User)
        {
            bool rpta = false;

            try
            {
                using (var SqlCon = new SqlConnection(ConfigurationManager.ConnectionStrings["DB_MDA_CR_OA_Connection"].ToString()))
                {
                    SqlCon.Open();
                    var SqlCmd = new SqlCommand("[music].[uspUpdateMSFavorite]", SqlCon)
                    {
                        CommandType = CommandType.StoredProcedure
                    };

                    //Insert Parameters
                    SqlParameter ParInsertUser = new SqlParameter
                    {
                        ParameterName = "@User",
                        SqlDbType = SqlDbType.VarChar,
                        Size = 50,
                        Value = User
                    };
                    SqlCmd.Parameters.Add(ParInsertUser);

                    SqlParameter ParMSID = new SqlParameter
                    {
                        ParameterName = "@MSID",
                        SqlDbType = SqlDbType.Int,
                        Value = MSID
                    };
                    SqlCmd.Parameters.Add(ParMSID);

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
    }
}
