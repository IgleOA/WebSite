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
    public class EventTypesDAL
    {
        public List<EventTypes> List()
        {
            var list = new List<EventTypes>();

            try
            {
                using (var SqlCon = new SqlConnection(ConfigurationManager.ConnectionStrings["DB_MDA_CR_OA_Connection"].ToString()))
                {
                    SqlCon.Open();
                    var SqlCmd = new SqlCommand("[adm].[uspReadEventTypes]", SqlCon)
                    {
                        CommandType = CommandType.StoredProcedure
                    };
                    
                    //Execute the SQL command
                    using (var dr = SqlCmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            var eve = new EventTypes
                            {
                                EventTypeID = Convert.ToInt32(dr["EventTypeID"]),
                                EventTypeName = dr["EventTypeName"].ToString(),
                                ThemeColor = dr["ThemeColor"].ToString()
                            };

                            list.Add(eve);
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

        public EventTypes Details(int id)
        {
            EventTypes ET = new EventTypes();

            try
            {
                using (var SqlCon = new SqlConnection(ConfigurationManager.ConnectionStrings["DB_MDA_CR_OA_Connection"].ToString()))
                {
                    SqlCon.Open();
                    var SqlCmd = new SqlCommand("[adm].[uspSearchEventType]", SqlCon)
                    {
                        CommandType = CommandType.StoredProcedure
                    };

                    //Insert Parameters
                    SqlParameter ParEventTypeID = new SqlParameter
                    {
                        ParameterName = "@EventTypeID",
                        SqlDbType = SqlDbType.Int,
                        Value = id
                    };
                    SqlCmd.Parameters.Add(ParEventTypeID);

                    using (var dr = SqlCmd.ExecuteReader())
                    {
                        dr.Read();
                        if (dr.HasRows)
                        {
                            ET.EventTypeID = Convert.ToInt32(dr["EventTypeID"]);
                            ET.EventTypeName = dr["EventTypeName"].ToString();
                            ET.ThemeColor = dr["ThemeColor"].ToString();
                        }
                    }
                    if (SqlCon.State == ConnectionState.Open) SqlCon.Close();
                }
            }
            catch (Exception ex)
            {
                throw;
            }

            return ET;
        }
    }
}
