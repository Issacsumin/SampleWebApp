using System;
using System.Security.Cryptography;
using System.Text;

namespace SampleWebApp
{
    public static class PasswordHelper
    {
        /// <summary>Creates a 36-character salt (fits VARCHAR(36) in the Users table).</summary>
        public static string GenerateSalt()
        {
            return Guid.NewGuid().ToString();
        }
        public static byte[] ComputeHash(string salt, string password)
        {
            using (SHA256 sha = SHA256.Create())
            {
                return sha.ComputeHash(Encoding.UTF8.GetBytes(salt + password));
            }
        }
        public static bool Verify(string password, string salt, byte[] storedHash)
        {
            byte[] computed = ComputeHash(salt, password);
            if (storedHash == null || computed.Length != storedHash.Length) return false;

            int diff = 0;
            for (int i = 0; i < computed.Length; i++) diff |= computed[i] ^ storedHash[i];
            return diff == 0;
        }
    }
}