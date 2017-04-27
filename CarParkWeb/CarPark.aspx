<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CarPark.aspx.cs" Inherits="CarParkWeb.CarPark" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <style type="text/css">
        html, body {
            overflow-x: hidden;
            overflow-y: auto;
        }

        

        fieldset {
            background-color: #fff !important;
        }

        table {
            table-layout: fixed;
            width: 100%;
        }

            table tr td {
                padding: 4px;
            }

        div.ajax-loading {
            border: 1px solid #000;
            white-space: nowrap;
            position: fixed;
            left: 2px;
            top: 100%;
            margin-top: -32px;
            color: #444444;
            z-index: 1000;
            padding: 8px 10px 8px 28px;
            font-size: 95%;
            font-weight: 600;
            background: #fff url( '../images/ajax-load-red.gif' ) 6px center no-repeat;
        }
    </style>

    <script type="text/javascript" src="../Common/js/jquery/jquery-1.6.2.min.js"></script>

    <script type="text/javascript" src="../Common/js/jquery/jquery-ui-1.8.16.custom.min.js"></script>

    <script type="text/javascript" src="../Common/js/jquery/jquery.utility.js"></script>

    <link href="App_Themes/Default/Default.css"  rel="stylesheet" type="text/css" />
    <link href="/App_Themes/jqueryui/ui-lightness/jquery-ui-1.8.13.custom.css" rel="stylesheet"
    type="text/css" />
    <script>
        function ValidateText() {
            ClearAlerts();
            var isValid = true;

            if (document.getElementById("fieldsetDefinition").style.display == "inline") {
                if (document.getElementById("txtShortDescription").value.trim() == "") {
                    document.getElementById("lblShortDescription").innerText = "Enter short description";
                    isValid = false;
                }
                if (document.getElementById("ddlDataSource").selectedIndex == 0) {
                    document.getElementById("lblDataSource").innerText = "Please  select  data source";
                    isValid = false;
                }
                if (document.getElementById("ddlType").selectedIndex == 0) {
                    document.getElementById("lblType").innerText = "Please  select  type";
                    isValid = false;
                }
                if (document.getElementById("ddlQualityStatement").selectedIndex == 0) {
                    document.getElementById("lblQualityStatement").innerText = "Please select quality statement";
                    isValid = false;
                }
            }

            if (document.getElementById("fieldsetConfiguration").style.display == "inline") {
                if (document.getElementById("txtCapacity").value.trim() == "") {
                    document.getElementById("lblCapacity").innerText = "Enter capacity";
                    isValid = false;
                }
                else if ((parseInt(document.getElementById("txtCapacity").value.trim()) < 0) || document.getElementById("txtCapacity").value.trim().indexOf('.') >= 0 || isNaN(document.getElementById("txtCapacity").value.trim())) {
                    document.getElementById("lblCapacity").innerText = "Enter valid capacity";
                    isValid = false;
                }


                if (document.getElementById("txtDisabledCapacity").value.trim() == "") {
                    document.getElementById("lblDisabledCapacity").innerText = "Enter disabled capacity";
                    isValid = false;
                }
                else if (isNaN(document.getElementById("txtDisabledCapacity").value) || parseInt(document.getElementById("txtDisabledCapacity").value) < 0 || document.getElementById("txtDisabledCapacity").value.trim().indexOf('.') >= 0) {
                    document.getElementById("lblDisabledCapacity").innerText = "Enter valid disabled capacity";
                    isValid = false;
                }

                else if (parseInt(document.getElementById("txtDisabledCapacity").value) > parseInt(document.getElementById("txtCapacity").value)) {
                    document.getElementById("lblDisabledCapacity").innerText = "Enter disabled capacity lesser than or equal to capacity";
                    isValid = false;
                }

                if (document.getElementById("txtAlmostfullincreasing").value.trim() == "") {
                    document.getElementById("lblAlmostFullIncreasing").innerText = "Enter almost full increasing";
                    isValid = false;
                }
                else if (isNaN(document.getElementById("txtAlmostfullincreasing").value.trim()) || parseInt(document.getElementById("txtAlmostfullincreasing").value.trim()) < 0 || document.getElementById("txtAlmostfullincreasing").value.trim().indexOf('.') >= 0) {
                    document.getElementById("lblAlmostFullIncreasing").innerText = "Enter valid almost full increasing";
                    isValid = false;
                }

                else if (parseInt(document.getElementById("txtAlmostfullincreasing").value) >= parseInt(document.getElementById("txtCapacity").value)) {
                    document.getElementById("lblAlmostFullIncreasing").innerText = "Enter almost full increasing less than capacity";
                    isValid = false;
                }

                if (document.getElementById("txtAlmostFullDecreasing").value.trim() == "") {
                    document.getElementById("lblAlmostFullDecreasing").innerText = "Enter almost full decreasing";
                    isValid = false;
                }
                else if (isNaN(document.getElementById("txtAlmostFullDecreasing").value.trim()) || parseInt(document.getElementById("txtAlmostFullDecreasing").value.trim()) < 0 || document.getElementById("txtAlmostFullDecreasing").value.trim().indexOf('.') >= 0) {
                    document.getElementById("lblAlmostFullDecreasing").innerText = "Enter valid almost full decreasing";
                    isValid = false;
                }

                else if (parseInt(document.getElementById("txtAlmostFullDecreasing").value) >= parseInt(document.getElementById("txtCapacity").value)) {
                    document.getElementById("lblAlmostFullDecreasing").innerText = "Enter almost full decreasing less than capacity";
                    isValid = false;
                }

                if (document.getElementById("txtFullIncreasing").value.trim() == "") {
                    document.getElementById("lblFullIncreasing").innerText = "Enter full increasing";
                    isValid = false;
                }
                else if (isNaN(document.getElementById("txtFullIncreasing").value.trim()) || parseInt(document.getElementById("txtFullIncreasing").value.trim()) < 0 || document.getElementById("txtFullIncreasing").value.trim().indexOf('.') >= 0) {
                    document.getElementById("lblFullIncreasing").innerText = "Enter valid full increasing";
                    isValid = false;
                }

                else if (parseInt(document.getElementById("txtFullIncreasing").value) >= parseInt(document.getElementById("txtCapacity").value)) {
                    document.getElementById("lblFullIncreasing").innerText = "Enter  full increasing less than capacity";
                    isValid = false;
                }

                if (document.getElementById("txtFullDecreasing").value.trim() == "") {
                    document.getElementById("lblFullDecreasing").innerText = "Enter full decreasing";
                    isValid = false;
                }
                else if (isNaN(document.getElementById("txtFullDecreasing").value.trim()) || parseInt(document.getElementById("txtFullDecreasing").value.trim()) < 0 || document.getElementById("txtFullDecreasing").value.trim().indexOf('.') >= 0) {
                    document.getElementById("lblFullDecreasing").innerText = "Enter valid full decreasing";
                    isValid = false;
                }

                else if (parseInt(document.getElementById("txtFullDecreasing").value) >= parseInt(document.getElementById("txtCapacity").value)) {
                    document.getElementById("lblFullDecreasing").innerText = "Enter  full decreasing less than capacity";
                    isValid = false;
                }


            }

            if (isValid == false)
                return false;
            else
                return true;
        }

        function ClearAlerts() {
            document.getElementById("lblShortDescription").innerText = "";
            document.getElementById("lblDataSource").innerText = "";
            document.getElementById("lblType").innerText = "";
            document.getElementById("lblQualityStatement").innerText = "";
            document.getElementById("lblCapacity").innerText = "";
            document.getElementById("lblDisabledCapacity").innerText = "";
            document.getElementById("lblAlmostFullIncreasing").innerText = "";
            document.getElementById("lblAlmostFullDecreasing").innerText = "";
            document.getElementById("lblFullIncreasing").innerText = "";
            document.getElementById("lblFullDecreasing").innerText = "";
        }
        function CloseWindow(scn, isSetOpeningTime) {
            if (parent) {
                if (parent.window != null && parent.document.getElementById("ctl00_Content_hdnMoveToLocation") != null && scn) {
                    parent.document.getElementById("ctl00_Content_hdnMoveToLocation").value = "Car_Park";
                }
                window.parent.Refresh();
                if (parent.windows) {
                    parent.windows.hide();
                    if (scn && (isSetOpeningTime == undefined || isSetOpeningTime != "true")) {
                        window.parent.MoveToLocation(scn);
                    }
                    else if (scn && isSetOpeningTime == 'true') {
                        window.parent.MoveToOpeningTime(scn);
                    }
                    else
                        parent.windows.dispose();
                }

            }

        }

        function ShowWait() {
            document.getElementById('waitImage').style.display = '';
            document.body.style.cursor = 'wait';
        }

        function HideWait() {
            document.getElementById('waitImage').style.visibility = 'hidden';
            document.body.style.cursor = 'default';
        }
        $(function () {
            $('#txtLongDescription').keyup(function (e) {
                var max = 255;
                var len = $(this)[0].value.length;
                if (len > max) {
                    this.value = this.value.substr(0, max);
                    return false;
                }
            });
            $('.alpha-Numeric').alphaNumeric();
            $('.input-SCN').inputSCN();
        });

    </script>

</head>
<body>
    <form method="post" runat="server" id="main" enctype="multipart/form-data">
        <asp:ScriptManager ID="scriptManager1" runat="server">
        </asp:ScriptManager>
        <asp:UpdatePanel ID="updatePanel1" runat="server">
            <ContentTemplate>
                <table cellpadding="0" cellspacing="0" width="100%" id="tblRecord" runat="server">
                    <tr>
                        <td>
                            <h1>
                                <asp:Label ID="lblPageHeading" runat="server" Text="Car Parks - Creationsss"></asp:Label></h1>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <fieldset style="border: 1px solid #FF6600; width: 95%; display: inline;" id="fieldsetDefinition"
                                runat="server">
                                <legend style="font-weight: bold; color: Red">Definition</legend>
                                <table>
                                    <tr id="trSCN" runat="server" visible="false">
                                        <td style="width: 30%">System Code Number
                                        <br />
                                            (Alpha Numeric 32 Chars)
                                        </td>
                                        <td>
                                            <asp:TextBox CssClass="input-SCN" ID="txtSCN" runat="server" MaxLength="32" Width="97%"></asp:TextBox>
                                            <%--<asp:RequiredFieldValidator ID="requiredFieldValidatorShortDesc" runat="server" ControlToValidate="txtShortDescription" ErrorMessage="Enter short description"></asp:RequiredFieldValidator>--%>
                                            <label id="lblSCN" runat="server" class="lblAlert" visible="false">
                                                System Code Number already exists</label>
                                            <input type="hidden" id="hdnExistingSCN" runat="server" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width: 30%">* Description(80 Chars)
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtShortDescription" runat="server" MaxLength="80" Width="97%"></asp:TextBox>
                                            <%--<asp:RequiredFieldValidator ID="requiredFieldValidatorShortDesc" runat="server" ControlToValidate="txtShortDescription" ErrorMessage="Enter short description"></asp:RequiredFieldValidator>--%>
                                            <label id="lblShortDescription" runat="server" class="lblAlert">
                                            </label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Long Description(255 Chars)
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtLongDescription" runat="server" TextMode="MultiLine" MaxLength="255" Width="97%"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>* Data Source
                                        </td>
                                        <td>
                                            <asp:DropDownList ID="ddlDataSource" runat="server" Width="97%">
                                            </asp:DropDownList>
                                            <%-- <asp:CustomValidator ID="customDataSource" runat="server" OnServerValidate="CustomDdl_ServerValidate" ErrorMessage="Please Select" ControlToValidate="ddlDataSource"></asp:CustomValidator>--%>
                                            <label id="lblDataSource" runat="server" class="lblAlert">
                                            </label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>* Type
                                        </td>
                                        <td>
                                            <asp:DropDownList ID="ddlType" runat="server" Width="97%">
                                            </asp:DropDownList>
                                            <%--<asp:CustomValidator ID="customType" runat="server" OnServerValidate="CustomDdl_ServerValidate" ErrorMessage="Please Select" ControlToValidate="ddlType"></asp:CustomValidator>--%>
                                            <label id="lblType" runat="server" class="lblAlert">
                                            </label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>* Quality Statement
                                        </td>
                                        <td>
                                            <asp:DropDownList ID="ddlQualityStatement" runat="server" Width="97%">
                                            </asp:DropDownList>
                                            <%--<asp:customvalidator id="customqualitystatement" runat="server" onservervalidate="customddl_servervalidate" errormessage="please select" controltovalidate="ddlqualitystatement"></asp:customvalidator>--%>
                                            <label id="lblQualityStatement" runat="server" class="lblAlert">
                                            </label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Modal Restrictions</td>
                                        <td>
                                            <asp:DropDownList ID="ddlModalRestrictions" runat="server" Width="97%">
                                                <asp:ListItem Text="No Restriction" Value=""></asp:ListItem>
                                                <asp:ListItem Text="Tram" Value="&quot;Tram&quot;"></asp:ListItem>
                                                <asp:ListItem Text="Rail" Value="&quot;Rail&quot;"></asp:ListItem>
                                                <asp:ListItem Text="Bus" Value="&quot;Bus&quot;"></asp:ListItem>
                                                <asp:ListItem Text="Tram or Rail" Value="&quot;Tram&quot;;&quot;Rail&quot;"></asp:ListItem>
                                                <asp:ListItem Text="Tram or Bus" Value="&quot;Tram&quot;;&quot;Bus&quot;"></asp:ListItem>
                                                <asp:ListItem Text="Rail or Bus" Value="&quot;Rail&quot;;&quot;Bus&quot;"></asp:ListItem>
                                            </asp:DropDownList>
                                            <b>Note : For Park and Ride sites, Please indicate which ongoing travel modes qualify for use of the parking facility.</b>
                                            <%--<asp:TextBox ID="txtModalRestrictions" runat="server" MaxLength="32" 
                                            Width="97%"></asp:TextBox>--%>
                                        </td>
                                    </tr>
                                </table>
                            </fieldset>
                            <fieldset style="border: 1px solid #FF6600; width: 95%; display: inline;" id="fieldsetConfiguration"
                                runat="server">
                                <legend style="font-weight: bold; color: Red">Configurations</legend>
                                <table>
                                    <tr>
                                        <td style="width: 30%">* Capacity Value
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtCapacity" runat="server" Width="97%" MaxLength="9"></asp:TextBox>
                                            <%--<asp:RequiredFieldValidator ID="requiredFieldValidatorCapacity" runat="server" ControlToValidate="txtCapacity" ErrorMessage="Enter capacity"></asp:RequiredFieldValidator>--%>
                                            <label id="lblCapacity" runat="server" class="lblAlert">
                                            </label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>* Disabled Capacity
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtDisabledCapacity" runat="server" Width="97%" MaxLength="9"></asp:TextBox>
                                            <%--<asp:RequiredFieldValidator ID="requiredFieldValidatorDisabledCapacity" runat="server" ControlToValidate="txtDisabledCapacity" ErrorMessage="Enter disabled capacity"></asp:RequiredFieldValidator>--%>
                                            <label id="lblDisabledCapacity" runat="server" class="lblAlert">
                                            </label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>* AlmostFullIncreasing
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtAlmostfullincreasing" runat="server" Width="97%" MaxLength="9"></asp:TextBox>
                                            <%--<asp:RequiredFieldValidator ID="requiredFieldValidatorAlmostfullincreasing" runat="server" ControlToValidate="txtAlmostfullincreasing" ErrorMessage="Enter almost full increasing"></asp:RequiredFieldValidator>--%>
                                            <label id="lblAlmostFullIncreasing" runat="server" class="lblAlert">
                                            </label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>* AlmostFullDecreasing
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtAlmostFullDecreasing" runat="server" Width="97%" MaxLength="9"></asp:TextBox>
                                            <%--<asp:RequiredFieldValidator ID="requiredFieldValidatorAlmostFullDecreasing" runat="server" ControlToValidate="txtAlmostFullDecreasing" ErrorMessage="Enter almost full decreasing"></asp:RequiredFieldValidator>--%>
                                            <label id="lblAlmostFullDecreasing" runat="server" class="lblAlert">
                                            </label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>* FullIncreasing
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtFullIncreasing" runat="server" Width="97%" MaxLength="9"></asp:TextBox>
                                            <%--<asp:RequiredFieldValidator ID="requiredFieldValidatorFullIncreasing" runat="server" ControlToValidate="txtFullIncreasing" ErrorMessage="Enter full increasing"></asp:RequiredFieldValidator>--%>
                                            <label id="lblFullIncreasing" runat="server" class="lblAlert">
                                            </label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>* FullDecreasing
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtFullDecreasing" runat="server" Width="97%" MaxLength="9"></asp:TextBox>
                                            <%--<asp:RequiredFieldValidator ID="requiredFieldValidatorFullDecreasing" runat="server" ControlToValidate="txtFullDecreasing" ErrorMessage="Enter full decreasing"></asp:RequiredFieldValidator>--%>
                                            <label id="lblFullDecreasing" runat="server" class="lblAlert">
                                            </label>
                                        </td>
                                    </tr>
                                </table>
                            </fieldset>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:HiddenField ID="hdnSave" runat="server" Value="" />
                            <asp:Button ID="btnSave" runat="server" Text="Save Carpark"
                                CausesValidation="true" OnClick="btnSave_Click" OnClientClick="return ValidateText();"
                                Width="41%" />
                            &nbsp;
                        <asp:Button ID="btnSaveAndSetLocation" runat="server" Text="Save and set a location"
                            OnClick="btnSaveAndSetLocation_Click" CausesValidation="true" OnClientClick="return ValidateText();"
                            Width="24%" Visible="False" />
                            &nbsp;
                        <asp:Button ID="btnSaveAndSetOpeningTime" runat="server" Text="Save and set opening time"
                            OnClick="btnSaveAndSetOpeningTime_Click" CausesValidation="true" OnClientClick="return ValidateText();"
                            Width="27%" Visible="False" />
                        </td>
                    </tr>
                </table>
                <table id="tbl_Result" style="margin-top: 100px" runat="server" cellpadding="0" align="center"
                    cellspacing="0" width="60%" class="RolesTableBorder" visible="false">
                    <tr>
                        <td align="center" valign="middle" style='text-align: center; vertical-align: middle'>
                            <p>
                                <p style='text-align: center;'>
                                    Car Park saved successfully. You may now close this window.
                                </p>
                        </td>
                    </tr>
                </table>
            </ContentTemplate>
        </asp:UpdatePanel>
        <%--<asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="updatepanel1"
        DisplayAfter="100" DynamicLayout="true">
        <ProgressTemplate>
            <div id="ProgressBar" class="ajax-loading">
                Working on your request...</div>
        </ProgressTemplate>
    </asp:UpdateProgress>--%>
    </form>
</body>

<script type="text/javascript">
    Sys.WebForms.PageRequestManager.getInstance().add_pageLoaded(function (sender, args) {

        $('.alpha-Numeric').alphaNumeric();
        $('.input-SCN').inputSCN();
    });
</script>
</html>
