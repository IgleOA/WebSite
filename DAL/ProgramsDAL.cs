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
    public class ProgramsDAL
    {
        public List<Programs> ProgramList()
        {
            List<Programs> List = new List<Programs>();
            try
            {
                using (var SqlCon = new SqlConnection(ConfigurationManager.ConnectionStrings["DB_MDA_CR_OA_Connection"].ToString()))
                {
                    SqlCon.Open();
                    var SqlCmd = new SqlCommand("[music].[uspReadPrograms]", SqlCon)
                    {
                        CommandType = CommandType.StoredProcedure
                    };

                    using (var dr = SqlCmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            var Program = new Programs
                            {
                                ProgramID = Convert.ToInt32(dr["ProgramID"]),
                                ProgramDate = Convert.ToDateTime(dr["ProgramDate"]),
                                ProgramSchedule = dr["ProgramSchedule"].ToString(),
                                CompleteFlag = Convert.ToBoolean(dr["CompleteFlag"]),
                                ActiveFlag = Convert.ToBoolean(dr["ActiveFlag"])
                            };

                            if(!Convert.IsDBNull(dr["NotificationDate"]))
                            {
                                Program.NotificationDate = Convert.ToDateTime(dr["NotificationDate"]);
                            }
                            else
                            {
                                Program.NotificationDate = null;
                            }

                            List.Add(Program);

                        }
                    }
                    if (SqlCon.State == ConnectionState.Open) SqlCon.Close();
                }
            }
            catch(Exception ex)
            {
                throw;
            }
            return List;
        }

        public List<Programs> WeeklyProgram()
        {
            List<Programs> List = new List<Programs>();
            try
            {
                using (var SqlCon = new SqlConnection(ConfigurationManager.ConnectionStrings["DB_MDA_CR_OA_Connection"].ToString()))
                {
                    SqlCon.Open();
                    var SqlCmd = new SqlCommand("[music].[uspReadWeeklyProgram]", SqlCon)
                    {
                        CommandType = CommandType.StoredProcedure
                    };

                    using (var dr = SqlCmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            var Program = new Programs
                            {
                                ProgramID = Convert.ToInt32(dr["ProgramID"]),
                                ProgramDate = Convert.ToDateTime(dr["ProgramDate"]),
                                ProgramSchedule = dr["ProgramSchedule"].ToString(),
                                CompleteFlag = Convert.ToBoolean(dr["CompleteFlag"]),
                                ActiveFlag = Convert.ToBoolean(dr["ActiveFlag"])
                            };

                            if (!Convert.IsDBNull(dr["NotificationDate"]))
                            {
                                Program.NotificationDate = Convert.ToDateTime(dr["NotificationDate"]);
                            }
                            else
                            {
                                Program.NotificationDate = null;
                            }
                            List.Add(Program);

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

        public int AddNew(Programs Program, String InsertUser)
        {
            int ProgramID = 0;
            try
            {
                using (var SqlCon = new SqlConnection(ConfigurationManager.ConnectionStrings["DB_MDA_CR_OA_Connection"].ToString()))
                {
                    SqlCon.Open();
                    var SqlCmd = new SqlCommand("[music].[uspAddProgram]", SqlCon)
                    {
                        CommandType = CommandType.StoredProcedure
                    };

                    //Insert Parameters
                    SqlParameter ParDate = new SqlParameter
                    {
                        ParameterName = "@PDate",
                        SqlDbType = SqlDbType.DateTime,
                        Value = Program.ProgramDate
                    };
                    SqlCmd.Parameters.Add(ParDate);

                    SqlParameter ParSchedule = new SqlParameter
                    {
                        ParameterName = "@PSchedule",
                        SqlDbType = SqlDbType.VarChar,
                        Size = 20,
                        Value = Program.ProgramSchedule
                    };
                    SqlCmd.Parameters.Add(ParSchedule);

                    SqlParameter ParInsertUser = new SqlParameter
                    {
                        ParameterName = "@InsertUser",
                        SqlDbType = SqlDbType.VarChar,
                        Size = 50,
                        Value = InsertUser
                    };
                    SqlCmd.Parameters.Add(ParInsertUser);

                    SqlParameter ParProgramID = new SqlParameter
                    {
                        ParameterName = "@ProgramID",
                        SqlDbType = SqlDbType.Int,
                        Direction = ParameterDirection.Output
                    };
                    SqlCmd.Parameters.Add(ParProgramID);

                    //Exec Command
                    SqlCmd.ExecuteNonQuery();

                    ProgramID = Convert.ToInt32(SqlCmd.Parameters["@ProgramID"].Value);

                    if (SqlCon.State == ConnectionState.Open) SqlCon.Close();
                }
            }
            catch(Exception ex)
            {
                throw;
            }
            return ProgramID;
        }

        public bool CopyProgram(CopyProgram CP, string InsertUser)
        {
            bool rpta = false;

            try
            {
                using (var SqlCon = new SqlConnection(ConfigurationManager.ConnectionStrings["DB_MDA_CR_OA_Connection"].ToString()))
                {
                    SqlCon.Open();
                    var SqlCmd = new SqlCommand("[music].[uspCopyProgram]", SqlCon)
                    {
                        CommandType = CommandType.StoredProcedure
                    };

                    //Insert Parameters
                    SqlParameter Source = new SqlParameter
                    {
                        ParameterName = "@ProgramIDSource",
                        SqlDbType = SqlDbType.Int,
                        Value = CP.ProgramIDSource
                    };
                    SqlCmd.Parameters.Add(Source);

                    SqlParameter ParInsertUser = new SqlParameter
                    {
                        ParameterName = "@InsertUser",
                        SqlDbType = SqlDbType.VarChar,
                        Size = 50,
                        Value = InsertUser
                    };
                    SqlCmd.Parameters.Add(ParInsertUser);

                    SqlParameter ParProgramID = new SqlParameter
                    {
                        ParameterName = "@ProgramIDTarget",
                        SqlDbType = SqlDbType.Int,
                        Value = CP.ProgramIDTarget
                    };
                    SqlCmd.Parameters.Add(ParProgramID);

                    //Exec Command
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

        public List<Programs> AvailableProgramsForCopy(int id)
        {
            List<Programs> List = new List<Programs>();
            try
            {
                using (var SqlCon = new SqlConnection(ConfigurationManager.ConnectionStrings["DB_MDA_CR_OA_Connection"].ToString()))
                {
                    SqlCon.Open();
                    var SqlCmd = new SqlCommand("[music].[uspReadAvailableCopyPrograms]", SqlCon)
                    {
                        CommandType = CommandType.StoredProcedure
                    };

                    SqlParameter ParProgramID = new SqlParameter
                    {
                        ParameterName = "@ProgramID",
                        SqlDbType = SqlDbType.Int,
                        Value = id
                    };
                    SqlCmd.Parameters.Add(ParProgramID);

                    using (var dr = SqlCmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            var Program = new Programs
                            {
                                ProgramID = Convert.ToInt32(dr["ProgramID"]),
                                ProgramDate = Convert.ToDateTime(dr["ProgramDate"]),
                                ProgramSchedule = dr["ProgramSchedule"].ToString(),
                                CompleteFlag = Convert.ToBoolean(dr["CompleteFlag"]),
                                ActiveFlag = Convert.ToBoolean(dr["ActiveFlag"])
                            };

                            if (!Convert.IsDBNull(dr["NotificationDate"]))
                            {
                                Program.NotificationDate = Convert.ToDateTime(dr["NotificationDate"]);
                            }
                            else
                            {
                                Program.NotificationDate = null;
                            }

                            List.Add(Program);

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

        public bool Notification (int PID, string InsertUser)
        {
            bool rpta = false;

            try
            {
                using (var SqlCon = new SqlConnection(ConfigurationManager.ConnectionStrings["DB_MDA_CR_OA_Connection"].ToString()))
                {
                    SqlCon.Open();
                    var SqlCmd = new SqlCommand("[music].[uspInsertNotificationDate]", SqlCon)
                    {
                        CommandType = CommandType.StoredProcedure
                    };

                    //Insert Parameters
                    SqlParameter ParPID = new SqlParameter
                    {
                        ParameterName = "@ProgramID",
                        SqlDbType = SqlDbType.Int,
                        Value = PID
                    };
                    SqlCmd.Parameters.Add(ParPID);

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
    }
}
