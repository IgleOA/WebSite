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
    public class RolesDAL
    {
        public List<Roles> List (int AppID)
        {
            var RolesList = new List<Roles>();

            try
            {
                using (var SqlCon = new SqlConnection(ConfigurationManager.ConnectionStrings["DB_MDA_CR_OA_Connection"].ToString()))
                {
                    SqlCon.Open();
                    var SqlCmd = new SqlCommand("[adm].[uspReadRoles]", SqlCon)
                    {
                        CommandType = CommandType.StoredProcedure
                    };
                    //Add Parameters
                    SqlParameter ParAppID = new SqlParameter
                    {
                        ParameterName = "@AppID",
                        SqlDbType = SqlDbType.Int,
                        Value = AppID
                    };
                    SqlCmd.Parameters.Add(ParAppID);

                    //Execute the SQL command
                    using (var dr = SqlCmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            var role = new Roles
                            {
                                RoleID = Convert.ToInt32(dr["RoleID"]),
                                RoleName = dr["RoleName"].ToString(),
                                RoleDescription = dr["RoleDescription"].ToString(),
                                ActiveFlag = Convert.ToBoolean(dr["ActiveFlag"]),
                                ApplicationID = AppID
                            };

                            RolesList.Add(role);

                        }
                    }
                    if (SqlCon.State == ConnectionState.Open) SqlCon.Close();
                }

            }
            catch (Exception ex)
            {
                throw;
            }

            return RolesList;
        }

        public bool Create(Roles Role, string InsertUser)
        {
            bool rpta = false;

            try
            {
                using (var SqlCon = new SqlConnection(ConfigurationManager.ConnectionStrings["DB_MDA_CR_OA_Connection"].ToString()))
                {
                    SqlCon.Open();
                    var SqlCmd = new SqlCommand("[adm].[uspCreateRole]", SqlCon)
                    {
                        CommandType = CommandType.StoredProcedure
                    };

                    //Add Parameters
                    SqlParameter ParAppID = new SqlParameter
                    {
                        ParameterName = "@AppID",
                        SqlDbType = SqlDbType.Int,
                        Value = Role.ApplicationID
                    };
                    SqlCmd.Parameters.Add(ParAppID);

                    SqlParameter ParName = new SqlParameter
                    {
                        ParameterName = "@RoleName",
                        SqlDbType = SqlDbType.VarChar,
                        Size = 50,
                        Value = Role.RoleName
                    };
                    SqlCmd.Parameters.Add(ParName);

                    SqlParameter ParDescription = new SqlParameter
                    {
                        ParameterName = "@Description",
                        SqlDbType = SqlDbType.VarChar,
                        Value = Role.RoleDescription
                    };
                    SqlCmd.Parameters.Add(ParDescription);

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
            catch (Exception ex)
            {
                throw;
            }
            return rpta;
        }

        public Roles Details(int id)
        {
            Roles role = new Roles();

            try
            {
                using (var SqlCon = new SqlConnection(ConfigurationManager.ConnectionStrings["DB_MDA_CR_OA_Connection"].ToString()))
                {
                    SqlCon.Open();
                    var SqlCmd = new SqlCommand("[adm].[uspSearchRole]", SqlCon)
                    {
                        CommandType = CommandType.StoredProcedure
                    };

                    //Insert Parameters
                    SqlParameter ParUserID = new SqlParameter
                    {
                        ParameterName = "@RoleID",
                        SqlDbType = SqlDbType.Int,
                        Value = id
                    };
                    SqlCmd.Parameters.Add(ParUserID);

                    using (var dr = SqlCmd.ExecuteReader())
                    {
                        dr.Read();
                        if (dr.HasRows)
                        {
                            role.RoleID = Convert.ToInt32(dr["RoleID"]);
                            role.ApplicationID = Convert.ToInt32(dr["ApplicationID"]);
                            role.RoleName = dr["RoleName"].ToString();
                            role.RoleDescription = dr["RoleDescription"].ToString();
                            role.ActiveFlag = Convert.ToBoolean(dr["ActiveFlag"]);
                        }
                    }
                    if (SqlCon.State == ConnectionState.Open) SqlCon.Close();
                }
            }
            catch(Exception ex)
            {
                throw;
            }

            return role;
        }

        public bool Update(string ActionType, Roles Role, string InsertUser)
        {
            bool rpta = false;

            try
            {
                using (var SqlCon = new SqlConnection(ConfigurationManager.ConnectionStrings["DB_MDA_CR_OA_Connection"].ToString()))
                {
                    SqlCon.Open();
                    var SqlCmd = new SqlCommand("[adm].[uspUpdateRole]", SqlCon)
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

                    SqlParameter ParActionType = new SqlParameter
                    {
                        ParameterName = "@ActionType",
                        SqlDbType = SqlDbType.VarChar,
                        Size = 50,
                        Value = ActionType
                    };
                    SqlCmd.Parameters.Add(ParActionType);

                    SqlParameter ParRoleID = new SqlParameter
                    {
                        ParameterName = "@RoleID",
                        SqlDbType = SqlDbType.Int,
                        Value = Role.RoleID
                    };
                    SqlCmd.Parameters.Add(ParRoleID);

                    SqlParameter ParName = new SqlParameter
                    {
                        ParameterName = "@RoleName",
                        SqlDbType = SqlDbType.VarChar,
                        Size = 50,
                        Value = Role.RoleName
                    };
                    SqlCmd.Parameters.Add(ParName);

                    SqlParameter ParDescription = new SqlParameter
                    {
                        ParameterName = "@Description",
                        SqlDbType = SqlDbType.VarChar,
                        Value = Role.RoleDescription
                    };
                    SqlCmd.Parameters.Add(ParDescription);

                    SqlParameter ParActiveFlag = new SqlParameter
                    {
                        ParameterName = "@ActiveFlag",
                        SqlDbType = SqlDbType.Bit,
                        Value = Role.ActiveFlag
                    };
                    SqlCmd.Parameters.Add(ParActiveFlag);


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
