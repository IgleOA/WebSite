using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using ET;

namespace DAL
{
    public class MinistersDAL
    {
        public List<Ministers> List()
        {
            List<Ministers> List = new List<Ministers>();

            try
            {
                using (var SqlCon = new SqlConnection(ConfigurationManager.ConnectionStrings["DB_MDA_CR_OA_Connection"].ToString()))
                {
                    SqlCon.Open();
                    var SqlCmd = new SqlCommand("[ministry].[uspReadMinisters]", SqlCon)
                    {
                        CommandType = CommandType.StoredProcedure
                    };

                    using (var dr = SqlCmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            var minister = new Ministers
                            {
                                MinisterID = Convert.ToInt32(dr["MinisterID"]),
                                MinisterName = dr["MinisterName"].ToString()
                            };
                            
                            List.Add(minister);

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

        public bool AddNew(Ministers Minister, string InsertUser)
        {
            bool rpta = false;
            try
            {
                using (var SqlCon = new SqlConnection(ConfigurationManager.ConnectionStrings["DB_MDA_CR_OA_Connection"].ToString()))
                {
                    SqlCon.Open();
                    var SqlCmd = new SqlCommand("[ministry].[uspAddMinister]", SqlCon)
                    {
                        CommandType = CommandType.StoredProcedure
                    };

                    //Insert Parameters
                    SqlParameter ParName = new SqlParameter
                    {
                        ParameterName = "@MinisterName",
                        SqlDbType = SqlDbType.VarChar,
                        Size = 50,
                        Value = Minister.MinisterName
                    };
                    SqlCmd.Parameters.Add(ParName);

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
    }
}
