using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace SampleWebApp
{
    public class UserRecord
    {
        public int UserId { get; set; }
        public string Username { get; set; }
        public byte[] PasswordHash { get; set; }
        public string PasswordSalt { get; set; }
        public bool IsActive { get; set; }
    }
    public class UserGridRow
    {
        public int UserId { get; set; }
        public string Username { get; set; }
        public string Email { get; set; }
        public bool IsActive { get; set; }
        public string LastLoginOn { get; set; }
        public string CreatedOn { get; set; }
    }
    public static class DataAccess
    {
        private static string ConnectionString
        {
            get { return ConfigurationManager.ConnectionStrings["MySqlDb"].ConnectionString; }
        }
        public static UserRecord GetUserByUsername(string username)
        {
            using (SqlConnection con = new SqlConnection(ConnectionString))
            using (SqlCommand cmd = new SqlCommand("dbo.usp_GetUserByUsername", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@Username", SqlDbType.NVarChar, 50).Value = username;
                con.Open();
                using (SqlDataReader rdr = cmd.ExecuteReader())
                {
                    if (!rdr.Read()) return null;
                    return new UserRecord
                    {
                        UserId = rdr.GetInt32(0),
                        Username = rdr.GetString(1),
                        PasswordHash = (byte[])rdr["PasswordHash"],
                        PasswordSalt = rdr.GetString(3),
                        IsActive = rdr.GetBoolean(4)
                    };
                }
            }
        }
        public static void UpdateLastLogin(int userId)
        {
            using (SqlConnection con = new SqlConnection(ConnectionString))
            using (SqlCommand cmd = new SqlCommand("dbo.usp_UpdateLastLogin", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@UserId", SqlDbType.Int).Value = userId;
                con.Open();
                cmd.ExecuteNonQuery();
            }
        }

        /// <summary>Sets a new password when username and email match an active user. Returns true on success.</summary>
        public static bool ResetPassword(string username, string email, byte[] passwordHash, string passwordSalt)
        {
            using (SqlConnection con = new SqlConnection(ConnectionString))
            using (SqlCommand cmd = new SqlCommand("dbo.usp_ResetPassword", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@Username", SqlDbType.NVarChar, 50).Value = username;
                cmd.Parameters.Add("@Email", SqlDbType.NVarChar, 100).Value = email;
                cmd.Parameters.Add("@PasswordHash", SqlDbType.VarBinary, 32).Value = passwordHash;
                cmd.Parameters.Add("@PasswordSalt", SqlDbType.VarChar, 36).Value = passwordSalt;
                con.Open();
                return Convert.ToInt32(cmd.ExecuteScalar()) > 0;
            }
        }

        /// <summary>Returns a reset token, or null when the email is unknown.</summary>
        public static Guid? CreatePasswordResetToken(string email)
        {
            using (SqlConnection con = new SqlConnection(ConnectionString))
            using (SqlCommand cmd = new SqlCommand("dbo.usp_CreatePasswordResetToken", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@Email", SqlDbType.NVarChar, 100).Value = email;
                con.Open();
                object result = cmd.ExecuteScalar();
                return result == null ? (Guid?)null : (Guid)result;
            }
        }

        public static List<UserGridRow> GetUsers()
        {
            List<UserGridRow> list = new List<UserGridRow>();
            using (SqlConnection con = new SqlConnection(ConnectionString))
            using (SqlCommand cmd = new SqlCommand("dbo.usp_GetUsers", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                con.Open();
                using (SqlDataReader rdr = cmd.ExecuteReader())
                {
                    while (rdr.Read())
                    {
                        list.Add(new UserGridRow
                        {
                            UserId = rdr.GetInt32(0),
                            Username = rdr.GetString(1),
                            Email = rdr.GetString(2),
                            IsActive = rdr.GetBoolean(3),
                            LastLoginOn = rdr.IsDBNull(4) ? "" : rdr.GetDateTime(4).ToString("yyyy-MM-dd HH:mm"),
                            CreatedOn = rdr.GetDateTime(5).ToString("yyyy-MM-dd HH:mm")
                        });
                    }
                }
            }
            return list;
        }
    }
}