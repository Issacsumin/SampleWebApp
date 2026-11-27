<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ForgotPassword.aspx.cs" Inherits="SampleWebApp.ForgotPassword" %>

<!DOCTYPE html>

<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Forgot Password</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="Content/Site.css" rel="stylesheet" />
</head>
<body class="login-body">
    <form id="ForgotPassword" runat="server" class="w-100 d-flex justify-content-center">
        <div class="card login-card">
            <div class="card-body p-4 p-md-5">
                <h1 class="h4 mb-2">Forgot password?</h1>

                <asp:Panel ID="pnlMessage" runat="server" Visible="false" CssClass="alert alert-info" role="alert">
                    <asp:Label ID="lblMessage" runat="server" />
                </asp:Panel>

                <%-- ===== MODE 1: DIRECT RESET (no email). Remove this panel when email is ready. ===== --%>
                <asp:Panel ID="pnlDirectReset" runat="server">
                    <p class="text-muted">Enter your username and registered email, then choose a new password.</p>

                    <div class="mb-3">
                        <label class="form-label">Username</label>
                        <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" MaxLength="50" ClientIDMode="Static" autocomplete="username" />
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtUsername" ValidationGroup="Direct"
                            ErrorMessage="Username is required." Display="Dynamic" CssClass="text-danger validation-text" />
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Registered email</label>
                        <asp:TextBox ID="txtResetEmail" runat="server" TextMode="Email" CssClass="form-control" MaxLength="100" ClientIDMode="Static" />
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtResetEmail" ValidationGroup="Direct"
                            ErrorMessage="Email is required." Display="Dynamic" CssClass="text-danger validation-text" />
                    </div>

                    <div class="mb-3">
                        <label class="form-label">New password</label>
                        <asp:TextBox ID="txtNewPassword" runat="server" TextMode="Password" CssClass="form-control" MaxLength="100"
                            ClientIDMode="Static" autocomplete="new-password" />
                        <div class="form-text">At least 8 characters with upper case, lower case and a number.</div>
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtNewPassword" ValidationGroup="Direct"
                            ErrorMessage="New password is required." Display="Dynamic" CssClass="text-danger validation-text" />
                        <asp:RegularExpressionValidator runat="server" ControlToValidate="txtNewPassword" ValidationGroup="Direct"
                            ValidationExpression="^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,100}$"
                            ErrorMessage="Password does not meet the rules." Display="Dynamic" CssClass="text-danger validation-text" />
                    </div>

                    <div class="mb-4">
                        <label class="form-label">Confirm password</label>
                        <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" CssClass="form-control" MaxLength="100"
                            ClientIDMode="Static" autocomplete="new-password" />
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtConfirmPassword" ValidationGroup="Direct"
                            ErrorMessage="Please confirm the password." Display="Dynamic" CssClass="text-danger validation-text" />
                        <asp:CompareValidator runat="server" ControlToValidate="txtConfirmPassword" ControlToCompare="txtNewPassword"
                            ValidationGroup="Direct" ErrorMessage="Passwords do not match." Display="Dynamic" CssClass="text-danger validation-text" />
                    </div>

                    <asp:Button ID="btnReset" runat="server" Text="Reset password" CssClass="btn btn-primary w-100 mb-3"
                        ValidationGroup="Direct" OnClick="btnReset_Click" />
                </asp:Panel>

                <%-- ===== MODE 2: EMAIL RESET LINK. Used when ResetMode = Email in Web.config. ===== --%>
                <asp:Panel ID="pnlEmailReset" runat="server" Visible="false">
                    <p class="text-muted">Enter your registered email and we'll send a reset link.</p>
                    <div class="mb-3">
                        <label class="form-label">Email</label>
                        <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" CssClass="form-control" MaxLength="100" ClientIDMode="Static" />
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtEmail" ValidationGroup="Email"
                            ErrorMessage="Email is required." Display="Dynamic" CssClass="text-danger validation-text" />
                        <asp:RegularExpressionValidator runat="server" ControlToValidate="txtEmail" ValidationGroup="Email"
                            ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$" ErrorMessage="Enter a valid email."
                            Display="Dynamic" CssClass="text-danger validation-text" />
                    </div>
                    <asp:Button ID="btnSend" runat="server" Text="Send reset link" CssClass="btn btn-primary w-100 mb-3"
                        ValidationGroup="Email" OnClick="btnSend_Click" />
                </asp:Panel>

                <div class="text-center"><a href="Login.aspx" class="small text-decoration-none">Back to login</a></div>
            </div>
        </div>
    </form>
</body>
</html>
