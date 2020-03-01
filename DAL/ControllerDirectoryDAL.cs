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
    public class ControllerDirectoryDAL
    {
        public List<ControllerDirectory> Rights (int RoleID)
        {
            var rights = new List<ControllerDirectory>();

            try
            {
                using (var SqlCon = new SqlConnection(ConfigurationManager.ConnectionStrings["DB_MDA_CR_OA_Connection"].ToString()))
                {
                    SqlCon.Open();
                    var SqlCmd = new SqlCommand("[adm].[uspReadControllerRights]", SqlCon);
                    SqlCmd.CommandType = CommandType.StoredProcedure;

                    //Insert Parameters 
                    SqlParameter ParRoleID = new SqlParameter
                    {
                        ParameterName = "@RoleID",
                        SqlDbType = SqlDbType.Int,
                        Value = RoleID
                    };
                    SqlCmd.Parameters.Add(ParRoleID);

                    using (var dr = SqlCmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            var right = new ControllerDirectory
                            {
                                ControllerID = Convert.ToInt32(dr["ControllerID"]),
                                CTRRightID = Convert.ToInt32(dr["CTRRightID"]),
                                ControllerName = dr["ControllerName"].ToString(),
                                ReadFlag = Convert.ToBoolean(dr["ReadFlag"]),
                                WriteFlag = Convert.ToBoolean(dr["WriteFlag"])
                            };

                            rights.Add(right);

                        }
                    }
                    if (SqlCon.State == ConnectionState.Open) SqlCon.Close();
                }
            }
            
            catch(Exception ex)
            {
                throw;
            }

            return rights;
        }

        public bool Update(int RoleID, int ControllerID, int RightID, string Right, string InsertUser)
        {
            bool rpta = false;
            try
            {
                using (var SqlCon = new SqlConnection(ConfigurationManager.ConnectionStrings["DB_MDA_CR_OA_Connection"].ToString()))
                {
                    SqlCon.Open();
                    var SqlCmd = new SqlCommand(null, SqlCon);

                    if (RightID == 0)
                    {
                        SqlCmd = new SqlCommand("[adm].[uspInsertControllerRights]", SqlCon);
                        SqlCmd.CommandType = CommandType.StoredProcedure;

                        //Insert Parameters
                        SqlParameter ParInsertUser = new SqlParameter
                        {
                            ParameterName = "@InsertUser",
                            SqlDbType = SqlDbType.VarChar,
                            Size = 50,
                            Value = InsertUser
                        };
                        SqlCmd.Parameters.Add(ParInsertUser);

                        SqlParameter ParRoleID = new SqlParameter
                        {
                            ParameterName = "@RoleID",
                            SqlDbType = SqlDbType.Int,
                            Value = RoleID
                        };
                        SqlCmd.Parameters.Add(ParRoleID);

                        SqlParameter ParAppID = new SqlParameter
                        {
                            ParameterName = "@ControllerID",
                            SqlDbType = SqlDbType.Int,
                            Value = ControllerID
                        };
                        SqlCmd.Parameters.Add(ParAppID);

                        SqlParameter ParRight = new SqlParameter
                        {
                            ParameterName = "@Right",
                            SqlDbType = SqlDbType.VarChar,
                            Size = 20,
                            Value = Right
                        };
                        SqlCmd.Parameters.Add(ParRight);
                    }
                    else
                    {
                        SqlCmd = new SqlCommand("[adm].[uspUpdateControllerRights]", SqlCon);
                        SqlCmd.CommandType = CommandType.StoredProcedure;

                        //Insert Parameters
                        SqlParameter ParInsertUser = new SqlParameter
                        {
                            ParameterName = "@InsertUser",
                            SqlDbType = SqlDbType.VarChar,
                            Size = 50,
                            Value = InsertUser
                        };
                        SqlCmd.Parameters.Add(ParInsertUser);

                        SqlParameter ParRARProfileID = new SqlParameter
                        {
                            ParameterName = "@CTRRightID",
                            SqlDbType = SqlDbType.Int,
                            Value = RightID
                        };
                        SqlCmd.Parameters.Add(ParRARProfileID);

                        SqlParameter ParRight = new SqlParameter
                        {
                            ParameterName = "@Right",
                            SqlDbType = SqlDbType.VarChar,
                            Size = 20,
                            Value = Right
                        };
                        SqlCmd.Parameters.Add(ParRight);
                    }

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

        public ControllerDirectory Validation(string UserName, string ControllerName,int AppID)
        {
            ControllerDirectory validation = new ControllerDirectory();

            try
            {
                using (var SqlCon = new SqlConnection(ConfigurationManager.ConnectionStrings["DB_MDA_CR_OA_Connection"].ToString()))
                {
                    SqlCon.Open();
                    var SqlCmd = new SqlCommand("[adm].[uspSearchControllerValidation]", SqlCon)
                    {
                        CommandType = CommandType.StoredProcedure
                    };

                    //Insert Parameters
                    SqlParameter ParAppName = new SqlParameter
                    {
                        ParameterName = "@AppID",
                        SqlDbType = SqlDbType.Int,
                        Value = AppID
                    };
                    SqlCmd.Parameters.Add(ParAppName);

                    SqlParameter ParController = new SqlParameter
                    {
                        ParameterName = "@ControllerName",
                        SqlDbType = SqlDbType.VarChar,
                        Size = 50,
                        Value = ControllerName
                    };
                    SqlCmd.Parameters.Add(ParController);

                    SqlParameter ParUserName = new SqlParameter
                    {
                        ParameterName = "@UserName",
                        SqlDbType = SqlDbType.VarChar,
                        Size = 50,
                        Value = UserName
                    };
                    SqlCmd.Parameters.Add(ParUserName);

                    using (var dr = SqlCmd.ExecuteReader())
                    {
                        dr.Read();
                        if (dr.HasRows)
                        {
                            validation.CTRRightID = Convert.ToInt32(dr["CTRRightID"]);
                            validation.ControllerID = Convert.ToInt32(dr["ControllerID"]);
                            validation.ControllerName = dr["ControllerName"].ToString();
                            validation.ReadFlag = Convert.ToBoolean(dr["ReadFlag"]);
                            validation.WriteFlag = Convert.ToBoolean(dr["WriteFlag"]);

                        }
                    }

                    if (SqlCon.State == ConnectionState.Open) SqlCon.Close();
                }
            }
            catch (Exception ex)
            {
                throw;
            }

            return validation;
        }
    }
}
