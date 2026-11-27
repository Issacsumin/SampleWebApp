<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="SampleWebApp.Login" %>

<!DOCTYPE html>

<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Login</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet" />
    <link href="Content/Site.css" rel="stylesheet" />
</head>
<body class="login-body">
    <form id="Login" runat="server" class="w-100 d-flex justify-content-center" autocomplete="on">
        <div class="card login-card">
            <div class="card-body p-4 p-md-5">
                <div class="text-center mb-4">
                    <span class="brand-icon"><i class="bi bi-person-lock"></i></span>
                    <h1 class="h4 mt-3 mb-1">Welcome Back</h1>
                    <p class="text-muted mb-0">Sign in to continue</p>
                </div>
                <asp:Panel ID="pnlMessage" runat="server" Visible="false" CssClass="alert alert-danger" role="alert">
                    <asp:Label ID="lblMessage" runat="server" />
                </asp:Panel>
                <div class="mb-3">
                    <label class="form-label">Username</label>
                    <div class="input-group">
                        <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" placeholder="Enter username"></asp:TextBox>
                    </div>
                    <asp:RequiredFieldValidator ID="rfvUsername" runat="server" ControlToValidate="txtUsername" ErrorMessage="Username is required."
                        Display="Dynamic" CssClass="text-danger validation-text"></asp:RequiredFieldValidator>
                </div>
                <div class="mb-3">
                    <label class="form-label">Password</label>
                    <div class="input-group">
                        <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control"
                            placeholder="Enter password" autocomplete="current-password" />
                        <button type="button" id="btnTogglePassword" class="btn btn-outline-secondary">
                            <i class="bi bi-eye"></i>
                        </button>
                    </div>
                    <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ControlToValidate="txtPassword"
                        ErrorMessage="Password is required." Display="Dynamic" CssClass="text-danger validation-text" />
                </div>
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div class="form-check">
                        <asp:CheckBox ID="chkRemember" runat="server" CssClass="form-check-input" />
                        <label class="form-check-label" for="chkRemember">Remember me</label>
                    </div>
                    <a href="ForgotPassword.aspx" class="small text-decoration-none">Forgot password?</a>
                </div>

                <asp:Button ID="btnLogin" runat="server" Text="Login" CssClass="btn btn-primary w-100"
                    OnClick="btnLogin_Click" />
            </div>
        </div>
    </form>
    <script src="https://cdn.jsdelivr.net/npm/jquery@3.7.1/dist/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="Scripts/login.js"></script>
</body>
</html>
