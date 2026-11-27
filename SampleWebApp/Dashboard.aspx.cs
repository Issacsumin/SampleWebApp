using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SampleWebApp
{
    public partial class Dashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            lblUser.Text = Session[AppConstants.SessionUsername].ToString();
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            // The "Remember me" cookie is kept on purpose so the username is pre-filled next time.
            Response.Redirect("~/Login.aspx", false);
            Context.ApplicationInstance.CompleteRequest();
        }

        /// <summary>Feeds jqGrid. Requires a signed-in session.</summary>
        [WebMethod(EnableSession = true)]
        public static List<UserGridRow> GetUsers()
        {
            if (HttpContext.Current.Session[AppConstants.SessionUsername] == null)
            {
                throw new UnauthorizedAccessException("Not signed in.");
            }
            return DataAccess.GetUsers();
        }
    }
}