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
    public class WebDirectoryDAL
    {
        public List<WebDirectory> ProfilebyUser(string UserName, int AppID)
        {
            var Profile = new List<WebDirectory>();

            try
            {
                using (var SqlCon = new SqlConnection(ConfigurationManager.ConnectionStrings["DB_MDA_CR_OA_Connection"].ToString()))
                {
                    SqlCon.Open();
                    var SqlCmd = new SqlCommand("[adm].[uspReadWebDirectorybyUser]", SqlCon);
                    SqlCmd.CommandType = CommandType.StoredProcedure;

                    //Insert Parameters 
                    SqlParameter ParAppID = new SqlParameter
                    {
                        ParameterName = "@AppID",
                        SqlDbType = SqlDbType.Int,
                        Value = AppID
                    };
                    SqlCmd.Parameters.Add(ParAppID);

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
                        while (dr.Read())
                        {
                            var app = new WebDirectory
                            {
                                ProfileID = Convert.ToInt32(dr["ProfileID"]),
                                MainClass = dr["MainClass"].ToString(),
                                WebName = dr["WebName"].ToString(),
                                Controller = dr["Controller"].ToString(),
                                ViewPage = dr["ViewPage"].ToString(),
                                Parameter = dr["Parameter"].ToString()
                            };

                            Profile.Add(app);

                        }
                    }
                    if (SqlCon.State == ConnectionState.Open) SqlCon.Close();
                }
            }
            catch (Exception ex)
            {
                throw;
            }
            return Profile;
        }

        public List<WebDirectory> ProfilebyRole(int RoleID)
        {
            var Profile = new List<WebDirectory>();

            try
            {
                using (var SqlCon = new SqlConnection(ConfigurationManager.ConnectionStrings["DB_MDA_CR_OA_Connection"].ToString()))
                {
                    SqlCon.Open();
                    var SqlCmd = new SqlCommand("[adm].[uspReadWebDirectorybyRole]", SqlCon);
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
                            var app = new WebDirectory
                            {
                                ProfileID = Convert.ToInt32(dr["ProfileID"]),
                                WebID = Convert.ToInt32(dr["WebID"]),
                                MainClass = dr["MainClass"].ToString(),
                                WebName = dr["WebName"].ToString(),
                                Status = Convert.ToBoolean(dr["ActiveFlag"])
                            };

                            Profile.Add(app);

                        }
                    }
                    if (SqlCon.State == ConnectionState.Open) SqlCon.Close();
                }
            }
            catch (Exception ex)
            {
                throw;
            }
            return Profile;
        }

        public string LabelMenu(string MainClass, string UserName, int AppID)
        {
            string label = null;

            try
            {
                using (var SqlCon = new SqlConnection(ConfigurationManager.ConnectionStrings["DB_MDA_CR_OA_Connection"].ToString()))
                {
                    SqlCon.Open();
                    var SqlCmd = new SqlCommand("[adm].[uspReadLabelMainMenu]", SqlCon);
                    SqlCmd.CommandType = CommandType.StoredProcedure;

                    //Insert Parameters 
                    SqlParameter ParAppID = new SqlParameter
                    {
                        ParameterName = "@AppID",
                        SqlDbType = SqlDbType.Int,
                        Value = AppID
                    };
                    SqlCmd.Parameters.Add(ParAppID);

                    SqlParameter ParMainClass = new SqlParameter
                    {
                        ParameterName = "@MainClass",
                        SqlDbType = SqlDbType.VarChar,
                        Size = 50,
                        Value = MainClass
                    };
                    SqlCmd.Parameters.Add(ParMainClass);

                    SqlParameter ParUserName = new SqlParameter
                    {
                        ParameterName = "@UserName",
                        SqlDbType = SqlDbType.VarChar,
                        Size = 50,
                        Value = UserName
                    };
                    SqlCmd.Parameters.Add(ParUserName);

                    //EXEC Command
                    label = SqlCmd.ExecuteScalar().ToString();

                    if (SqlCon.State == ConnectionState.Open) SqlCon.Close();
                }
            }
            catch (Exception ex)
            {
                throw;
            }
            return label;
        }

        public bool Update(WebDirectory Web, int RoleID, string InsertUser)
        {
            bool rpta = false;

            try
            {
                using (var SqlCon = new SqlConnection(ConfigurationManager.ConnectionStrings["DB_MDA_CR_OA_Connection"].ToString()))
                {
                    SqlCon.Open();
                    var SqlCmd = new SqlCommand(null, SqlCon);

                    if (Web.ProfileID == 0)
                    {
                        SqlCmd = new SqlCommand("[adm].[uspInsertWebDirectorybyRole]", SqlCon);
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
                            ParameterName = "@WebID",
                            SqlDbType = SqlDbType.Int,
                            Value = Web.WebID
                        };
                        SqlCmd.Parameters.Add(ParAppID);
                    }
                    else
                    {
                        SqlCmd = new SqlCommand("[adm].[uspUpdateWebDirectorybyRole]", SqlCon);
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

                        SqlParameter ParProfileID = new SqlParameter
                        {
                            ParameterName = "@ProfileID",
                            SqlDbType = SqlDbType.Int,
                            Value = Web.ProfileID
                        };
                        SqlCmd.Parameters.Add(ParProfileID);

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
    }
}
