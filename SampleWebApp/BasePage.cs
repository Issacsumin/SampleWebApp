using SampleWebApp;
using System;
using System.Web.UI;

/// <summary>Base class for every page that requires a logged-in user.</summary>
public class BasePage
{
    protected string CurrentUsername
    {
        get { return Session[AppConstants.SessionUsername] as string; }
    }

    protected override void OnInit(EventArgs e)
    {
        if (string.IsNullOrEmpty(CurrentUsername))
        {
            Response.Redirect("~/Login.aspx", true);
        }
        // Stop browsers from showing secured pages from cache after logout.
        Response.Cache.SetCacheability(System.Web.HttpCacheability.NoCache);
        Response.Cache.SetNoStore();
        base.OnInit(e);
    }
}
