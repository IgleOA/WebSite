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
    public class MSTypesDAL
    {
        public List<MusicSheetTypes> MSTypeList ()
        {
            var List = new List<MusicSheetTypes>();

            try
            {
                using (var SqlCon = new SqlConnection(ConfigurationManager.ConnectionStrings["DB_MDA_CR_OA_Connection"].ToString()))
                {
                    SqlCon.Open();
                    var SqlCmd = new SqlCommand("[music].[uspReadMSTypes]", SqlCon)
                    {
                        CommandType = CommandType.StoredProcedure
                    };

                    using (var dr = SqlCmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            var MSType = new MusicSheetTypes
                            {
                                MSTypeID = Convert.ToInt32(dr["MSTypeID"]),
                                MSTypeName = dr["MSTypeName"].ToString()
                            };

                            List.Add(MSType);

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
