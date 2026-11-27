using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SampleWebApp
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session[AppConstants.SessionUsername] != null)
            {
                Response.Redirect("~/Dashboard.aspx", true);
            }
            if (!IsPostBack)
            {
                LoadRememberedUser();
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            Page.Validate();
            if (!Page.IsValid) return;

            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text;
            try
            {
                UserRecord user = DataAccess.GetUserByUsername(username);
                if (user == null || !user.IsActive || !PasswordHelper.Verify(password, user.PasswordSalt, user.PasswordHash))
                {
                    ShowMessage("Invalid username or password.");
                    return;
                }
                SignIn(user);
            }
            catch (Exception)
            {
                ShowMessage("Something went wrong. Please try again later.");
            }
        }

        private void LoadRememberedUser()
        {
            HttpCookie cookie = Request.Cookies[AppConstants.RememberCookieName];
            if (cookie != null && !string.IsNullOrWhiteSpace(cookie.Value))
            {
                txtUsername.Text = HttpUtility.UrlDecode(cookie.Value);
                chkRemember.Checked = true;
            }
        }
        private void SignIn(UserRecord user)
        {
            Session.Clear();
            Session[AppConstants.SessionUsername] = user.Username;
            if (chkRemember.Checked) SaveRememberCookie(user.Username);
            else ClearRememberCookie();

            DataAccess.UpdateLastLogin(user.UserId);
            Response.Redirect("~/Dashboard.aspx", false);
            Context.ApplicationInstance.CompleteRequest();
        }
        private void SaveRememberCookie(string username)
        {
            HttpCookie cookie = new HttpCookie(AppConstants.RememberCookieName, HttpUtility.UrlEncode(username))
            {
                Expires = DateTime.Now.AddDays(AppConstants.RememberDays),
                HttpOnly = true,
                Secure = Request.IsSecureConnection
            };
            Response.Cookies.Add(cookie);
        }

        private void ClearRememberCookie()
        {
            if (Request.Cookies[AppConstants.RememberCookieName] == null) return;
            HttpCookie cookie = new HttpCookie(AppConstants.RememberCookieName) { Expires = DateTime.Now.AddDays(-1) };
            Response.Cookies.Add(cookie);
        }

        private void ShowMessage(string message)
        {
            lblMessage.Text = Server.HtmlEncode(message);
            pnlMessage.Visible = true;
        }
    }
}