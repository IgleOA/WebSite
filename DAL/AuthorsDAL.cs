using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using ET;

namespace DAL
{
    public class AuthorsDAL
    {
        public List<Authors> AuthorList()
        {
            List<Authors> List = new List<Authors>();

            try
            {
                using (var SqlCon = new SqlConnection(ConfigurationManager.ConnectionStrings["DB_MDA_CR_OA_Connection"].ToString()))
                {
                    SqlCon.Open();
                    var SqlCmd = new SqlCommand("[music].[uspReadAuthors]", SqlCon)
                    {
                        CommandType = CommandType.StoredProcedure
                    };

                    using (var dr = SqlCmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            var author = new Authors
                            {
                                AuthorID = Convert.ToInt32(dr["AuthorID"]),
                                AuthorName = dr["AuthorName"].ToString(),
                                ProfileLink = "\"" + dr["ProfileLink"].ToString() + "\""                            
                            };

                            if(author.ProfileLink.Length>2)
                            {
                                author.ActiveLink = true;
                            }
                            else
                            {
                                author.ActiveLink = false;
                            }

                            List.Add(author);

                        }
                    }
                    if (SqlCon.State == ConnectionState.Open) SqlCon.Close();
                }
            }
            catch(Exception ex)
            {
                throw;
            }
            return List;
        }

        public bool AddNew (Authors Author, string InsertUser)
        {
            bool rpta = false;
            try
            {
                using (var SqlCon = new SqlConnection(ConfigurationManager.ConnectionStrings["DB_MDA_CR_OA_Connection"].ToString()))
                {
                    SqlCon.Open();
                    var SqlCmd = new SqlCommand("[music].[uspAddAuthor]", SqlCon)
                    {
                        CommandType = CommandType.StoredProcedure
                    };

                    //Insert Parameters
                    SqlParameter ParName = new SqlParameter
                    {
                        ParameterName = "@AuthorName",
                        SqlDbType = SqlDbType.VarChar,
                        Size = 50,
                        Value = Author.AuthorName
                    };
                    SqlCmd.Parameters.Add(ParName);

                    SqlParameter ParProfile = new SqlParameter
                    {
                        ParameterName = "@ProfileLink",
                        SqlDbType = SqlDbType.VarChar,
                        Value = Author.ProfileLink
                    };
                    SqlCmd.Parameters.Add(ParProfile);

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

        public Authors Details(int AuthorID)
        {
            Authors Author = new Authors();
            try
            {
                using (var SqlCon = new SqlConnection(ConfigurationManager.ConnectionStrings["DB_MDA_CR_OA_Connection"].ToString()))
                {
                    SqlCon.Open();
                    var SqlCmd = new SqlCommand("[music].[uspSearchAuthor]", SqlCon)
                    {
                        CommandType = CommandType.StoredProcedure
                    };

                    //Insert Parameters
                    SqlParameter ParAuthorID = new SqlParameter
                    {
                        ParameterName = "@AuthorID",
                        SqlDbType = SqlDbType.Int,
                        Value = AuthorID
                    };
                    SqlCmd.Parameters.Add(ParAuthorID);

                    using (var dr = SqlCmd.ExecuteReader())
                    {
                        dr.Read();
                        if (dr.HasRows)
                        {
                            Author.AuthorID = Convert.ToInt32(dr["AuthorID"]);
                            Author.AuthorName = dr["AuthorName"].ToString();
                            Author.ProfileLink = dr["ProfileLink"].ToString();
                        }
                    }
                    if (SqlCon.State == ConnectionState.Open) SqlCon.Close();
                }
            }
            catch (Exception ex)
            {
                throw;
            }
            return Author;
        }

        public bool Update(Authors Author, string InsertUser)
        {
            bool rpta = false;
            try
            {
                using (var SqlCon = new SqlConnection(ConfigurationManager.ConnectionStrings["DB_MDA_CR_OA_Connection"].ToString()))
                {
                    SqlCon.Open();
                    var SqlCmd = new SqlCommand("[music].[uspUpdateAuthor]", SqlCon)
                    {
                        CommandType = CommandType.StoredProcedure
                    };

                    //Insert Parameters
                    SqlParameter ParAuthorID = new SqlParameter
                    {
                        ParameterName = "@AuthorID",
                        SqlDbType = SqlDbType.Int,
                        Value = Author.AuthorID
                    };
                    SqlCmd.Parameters.Add(ParAuthorID);

                    SqlParameter ParName = new SqlParameter
                    {
                        ParameterName = "@AuthorName",
                        SqlDbType = SqlDbType.VarChar,
                        Size = 50,
                        Value = Author.AuthorName
                    };
                    SqlCmd.Parameters.Add(ParName);

                    SqlParameter ParProfile = new SqlParameter
                    {
                        ParameterName = "@ProfileLink",
                        SqlDbType = SqlDbType.VarChar,
                        Value = Author.ProfileLink
                    };
                    SqlCmd.Parameters.Add(ParProfile);

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
