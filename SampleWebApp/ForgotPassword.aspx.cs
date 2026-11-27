using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SampleWebApp
{
    public partial class ForgotPassword : System.Web.UI.Page
    {
        private const int MaxResetAttempts = 5;
        private const string AttemptsSessionKey = "ResetAttempts";
        private static readonly Regex PasswordRule = new Regex(@"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,100}$", RegexOptions.Compiled);

        /// <summary>Web.config: ResetMode = Direct (default) or Email.</summary>
        private static bool IsDirectMode
        {
            get
            {
                string mode = ConfigurationManager.AppSettings["ResetMode"];
                return !string.Equals(mode, "Email", StringComparison.OrdinalIgnoreCase);
            }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            pnlDirectReset.Visible = IsDirectMode;
            pnlEmailReset.Visible = !IsDirectMode;
        }

        protected void btnSend_Click(object sender, EventArgs e)
        {
            Page.Validate("Email");
            if (!Page.IsValid) return;

            try
            {
                Guid? token = DataAccess.CreatePasswordResetToken(txtEmail.Text.Trim());
                if (token.HasValue)
                {
                    // TODO: email a link such as https://yoursite/ResetPassword.aspx?token={token}
                }
            }
            catch (Exception)
            {
                // TODO: log the exception
            }
            ShowMessage("If that email is registered, a reset link has been sent.", "alert-info");
        }

        protected void btnReset_Click(object sender, EventArgs e)
        {
            Page.Validate("Direct");
            if (!Page.IsValid) return;
            int attempts = (Session[AttemptsSessionKey] as int?) ?? 0;
            if (attempts >= MaxResetAttempts)
            {
                ShowMessage("Too many attempts. Please try again later.", "alert-danger");
                return;
            }
            Session[AttemptsSessionKey] = attempts + 1;

            string username = txtUsername.Text.Trim();
            string email = txtResetEmail.Text.Trim();
            string newPassword = txtNewPassword.Text;
            if (newPassword != txtConfirmPassword.Text || !PasswordRule.IsMatch(newPassword))
            {
                ShowMessage("Password does not meet the rules or does not match.", "alert-danger");
                return;
            }

            try
            {
                string salt = PasswordHelper.GenerateSalt();
                byte[] hash = PasswordHelper.ComputeHash(salt, newPassword);

                if (DataAccess.ResetPassword(username, email, hash, salt))
                {
                    Session.Remove(AttemptsSessionKey);
                    ShowMessage("Password changed successfully. You can now log in.", "alert-success");
                    pnlDirectReset.Visible = false;
                }
                else
                {
                    ShowMessage("Unable to reset. Please check the username and email entered.", "alert-danger");
                }
            }
            catch (Exception)
            {
                ShowMessage("Something went wrong. Please try again later.", "alert-danger");
            }
        }
        private void ShowMessage(string message, string cssClass)
        {
            lblMessage.Text = Server.HtmlEncode(message);
            pnlMessage.CssClass = "alert " + cssClass;
            pnlMessage.Visible = true;
        }
    }
}