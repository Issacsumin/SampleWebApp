<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="SampleWebApp.Dashboard" %>

<!DOCTYPE html>

<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/jqueryui/1.13.2/themes/base/jquery-ui.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/free-jqgrid/4.15.5/css/ui.jqgrid.min.css" rel="stylesheet" />
    <link href="Content/Site.css" rel="stylesheet" />
</head>
<body class="bg-light">
    <form id="Dashboard" runat="server">
        <nav class="navbar navbar-dark bg-primary px-3">
            <span class="navbar-brand mb-0 h1">Dashboard</span>
            <div class="d-flex align-items-center text-white gap-3">
                <span>Hello, <strong><asp:Label ID="lblUser" runat="server" /></strong></span>
                <asp:Button ID="btnLogout" runat="server" Text="Logout" CssClass="btn btn-light btn-sm" OnClick="btnLogout_Click" CausesValidation="false" />
            </div>
        </nav>

        <div class="container-fluid py-4">
            <h2 class="h5 mb-3">Users</h2>
            <div class="grid-wrapper" id="gridWrapper">
                <table id="gridUsers"></table>
                <div id="gridPager"></div>
            </div>
        </div>
    </form>
    <script src="https://cdn.jsdelivr.net/npm/jquery@3.7.1/dist/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/free-jqgrid/4.15.5/jquery.jqgrid.min.js"></script>
    <script>
        (function ($) {
            'use strict';

            function resizeGrid() {
                $('#gridUsers').jqGrid('setGridWidth', $('#gridWrapper').width(), true);
            }

            $(function () {
                $.ajax({
                    type: 'POST',
                    url: 'Dashboard.aspx/GetUsers',
                    contentType: 'application/json; charset=utf-8',
                    dataType: 'json',
                    data: '{}'
                }).done(function (res) {
                    $('#gridUsers').jqGrid({
                        datatype: 'local',
                        data: res.d,
                        colModel: [
                            { name: 'UserId', label: 'ID', width: 60, key: true, align: 'center' },
                            { name: 'Username', label: 'Username', width: 140 },
                            { name: 'Email', label: 'Email', width: 220 },
                            { name: 'IsActive', label: 'Active', width: 80, align: 'center', formatter: 'checkbox' },
                            { name: 'LastLoginOn', label: 'Last Login', width: 150 },
                            { name: 'CreatedOn', label: 'Created', width: 150 }
                        ],
                        pager: '#gridPager',
                        rowNum: 10,
                        rowList: [10, 20, 50],
                        sortname: 'UserId',
                        viewrecords: true,
                        autowidth: true,
                        shrinkToFit: true,
                        height: 'auto',
                        caption: 'Registered Users'
                    });
                    $('#gridUsers').jqGrid('filterToolbar', { searchOnEnter: false, defaultSearch: 'cn' });
                }).fail(function () {
                    $('#gridWrapper').html('<div class="alert alert-danger">Unable to load users.</div>');
                });

                $(window).on('resize', resizeGrid);
            });
        })(jQuery);
    </script>
</body>
</html>
