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
    public class PreachesDAL
    {
        public List<Preaches> List()
        {
            List<Preaches> List = new List<Preaches>();

            try
            {
                using (var SqlCon = new SqlConnection(ConfigurationManager.ConnectionStrings["DB_MDA_CR_OA_Connection"].ToString()))
                {
                    SqlCon.Open();
                    var SqlCmd = new SqlCommand("[ministry].[uspReadPreaches]", SqlCon)
                    {
                        CommandType = CommandType.StoredProcedure
                    };

                    using (var dr = SqlCmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            var preach = new Preaches
                            {
                                PreachID = Convert.ToInt32(dr["PreachID"]),
                                MinisterID = Convert.ToInt32(dr["MinisterID"]),
                                MinisterName = dr["MinisterName"].ToString(),
                                Title = dr["Title"].ToString(),
                                Description = dr["Description"].ToString(),
                                Tags = dr["Tags"].ToString(),
                                //FileData = (byte[])(dr["FileData"]),
                                PreachingDate = Convert.ToDateTime(dr["PreachingDate"])
                            };

                            List.Add(preach);

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

        public bool AddNew(Preaches Preach, string InsertUser)
        {
            bool rpta = false;

            try
            {
                DynamicParameters Parm = new DynamicParameters();
                Parm.Add("@InsertUser", InsertUser);
                Parm.Add("@MinisterID", Preach.MinisterID);
                Parm.Add("@Title", Preach.Title);
                Parm.Add("@Description", Preach.Description);
                Parm.Add("@Tags", Preach.Tags);
                Parm.Add("@FileData", Preach.FileData);
                Parm.Add("@FileType", Preach.FileType);
                Parm.Add("@Date", Preach.PreachingDate);

                var SqlCon = new SqlConnection(ConfigurationManager.ConnectionStrings["DB_MDA_CR_OA_Connection"].ToString());

                SqlCon.Open();

                SqlCon.Execute("[ministry].[uspAddPreach]", Parm, commandType: CommandType.StoredProcedure);

                rpta = true;

                if (SqlCon.State == ConnectionState.Open) SqlCon.Close();

            }
            catch (Exception ex)
            {
                throw;
            }

            return rpta;
        }

        public Preaches Details(int PreachID)
        {
            Preaches Preach = new Preaches();

            try
            {
                using (var SqlCon = new SqlConnection(ConfigurationManager.ConnectionStrings["DB_MDA_CR_OA_Connection"].ToString()))
                {
                    SqlCon.Open();
                    var SqlCmd = new SqlCommand("[ministry].[uspSearchPreach]", SqlCon)
                    {
                        CommandType = CommandType.StoredProcedure
                    };

                    //Insert Parameters
                    SqlParameter ParID = new SqlParameter
                    {
                        ParameterName = "@PreachID",
                        SqlDbType = SqlDbType.Int,
                        Value = PreachID
                    };
                    SqlCmd.Parameters.Add(ParID);

                    using (var dr = SqlCmd.ExecuteReader())
                    {
                        dr.Read();
                        if(dr.HasRows)
                        {
                            Preach.PreachID = Convert.ToInt32(dr["PreachID"]);
                            Preach.MinisterID = Convert.ToInt32(dr["MinisterID"]);
                            Preach.MinisterName = dr["MinisterName"].ToString();
                            Preach.Title = dr["Title"].ToString();
                            Preach.Description = dr["Description"].ToString();
                            Preach.Tags = dr["Tags"].ToString();
                            Preach.FileData = (byte[])(dr["FileData"]);
                            Preach.FileType = dr["FileType"].ToString();
                            Preach.PreachingDate = Convert.ToDateTime(dr["PreachingDate"]);
                            Preach.SubmittedDate = Convert.ToDateTime(dr["InsertDate"]);
                        }                        
                    }
                    if (SqlCon.State == ConnectionState.Open) SqlCon.Close();
                }
            }
            catch(Exception ex)
            {
                throw;
            }
            return Preach;
        }
    }
}
