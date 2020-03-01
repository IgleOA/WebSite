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
    public class EventsDAL
    {
        public List<Events> List(DateTime Date)
        {
            var list = new List<Events>();

            try
            {
                using (var SqlCon = new SqlConnection(ConfigurationManager.ConnectionStrings["DB_MDA_CR_OA_Connection"].ToString()))
                {
                    SqlCon.Open();
                    var SqlCmd = new SqlCommand("[adm].[uspReadEvents]", SqlCon)
                    {
                        CommandType = CommandType.StoredProcedure
                    };

                    SqlParameter ParDate = new SqlParameter
                    {
                        ParameterName = "@Date",
                        SqlDbType = SqlDbType.DateTime,
                        Value = Date
                    };
                    SqlCmd.Parameters.Add(ParDate);

                    //Execute the SQL command
                    using (var dr = SqlCmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            var eve = new Events
                            {
                                EventID = Convert.ToInt32(dr["EventID"]),
                                EventTypeID = Convert.ToInt32(dr["EventTypeID"]),
                                Subject = dr["Subject"].ToString(),
                                Description = dr["Description"].ToString(),
                                StartDate = Convert.ToDateTime(dr["StartDate"]),
                                IsFullDay = Convert.ToBoolean(dr["IsFullDay"]),
                                SDate = dr["StartDate"].ToString()
                            };

                            if(!Convert.IsDBNull(dr["EndDate"]))
                            {
                                eve.EndDate = Convert.ToDateTime(dr["EndDate"]);
                            }
                            else
                            {
                                eve.EndDate = null;
                            }

                            list.Add(eve);
                        }
                    }

                    //Add Event Type Info
                    foreach(var r in list)
                    {
                        SqlCmd = new SqlCommand("[adm].[uspSearchEventType]", SqlCon)
                        {
                            CommandType = CommandType.StoredProcedure
                        };

                        SqlCmd.Parameters.AddWithValue("@TypeID", r.EventTypeID);

                        using (var dr = SqlCmd.ExecuteReader())
                        {
                            dr.Read();
                            if(dr.HasRows)
                            {
                                r.EventTypeData.EventTypeID = Convert.ToInt32(dr["EventTypeID"]);
                                r.EventTypeData.EventTypeName = dr["EventTypeName"].ToString();
                                r.EventTypeData.ThemeColor = dr["ThemeColor"].ToString();
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

            return list;
        }
    }
}
