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
    public class MainPageDAL
    {
        public List<MainPage> MainPage()
        {
            List<MainPage> list = new List<MainPage>();

            try
            {
                using (var SqlCon = new SqlConnection(ConfigurationManager.ConnectionStrings["DB_MDA_CR_OA_Connection"].ToString()))
                {
                    SqlCon.Open();
                    var SqlCmd = new SqlCommand("[adm].[uspReadMainPage]", SqlCon);
                    SqlCmd.CommandType = CommandType.StoredProcedure;

                    using (var dr = SqlCmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            var app = new MainPage
                            {
                                ApplicationID = Convert.ToInt32(dr["ApplicationID"]),
                                MainAppName = dr["MainAppName"].ToString(),
                                Controller = dr["Controller"].ToString(),
                                ViewPage = dr["ViewPage"].ToString(),
                                Slide = dr["Slide"].ToString(),
                                PageIndex = Convert.ToInt32(dr["PageIndex"]),
                                Description = dr["Description"].ToString()
                            };

                            list.Add(app);

                        }
                    }
                    if (SqlCon.State == ConnectionState.Open) SqlCon.Close();
                }
            }
            catch (Exception ex)
            {
                throw;
            }
            return list;
        }
    }
}
