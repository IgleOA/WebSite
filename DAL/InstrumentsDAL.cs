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
    public class InstrumentsDAL
    {
        public List<Instruments> InstrumentList()
        {
            var List = new List<Instruments>();

            try
            {
                using (var SqlCon = new SqlConnection(ConfigurationManager.ConnectionStrings["DB_MDA_CR_OA_Connection"].ToString()))
                {
                    SqlCon.Open();
                    var SqlCmd = new SqlCommand("[music].[uspReadInstruments]", SqlCon)
                    {
                        CommandType = CommandType.StoredProcedure
                    };

                    using (var dr = SqlCmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            var Instrument = new Instruments
                            {
                                InstrumentID = Convert.ToInt32(dr["InstrumentID"]),
                                Instrument = dr["Instrument"].ToString()
                            };

                            List.Add(Instrument);

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
    }
}
