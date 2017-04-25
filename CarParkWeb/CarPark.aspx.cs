using System;
using System.IO;
using System.Text;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Collections.Generic;
using System.Linq;
using CarParkWeb.Car_park;
using CarParkWeb.Support;

namespace CarParkWeb
{
    public partial class CarPark : System.Web.UI.Page
    {

        #region Private Variables

        //private Support oSupport = new Support();
        //private Argonaut.Car_Park.Car_Park _carpark = new Argonaut.Car_Park.Car_Park();
        //Argonaut.Support.support _support = new Argonaut.Support.support();
        private Car_park.Car_Park _carpark = new Car_park.Car_Park();
        Support.support _support = new Support.support();

        private string objectName = "car_park";
        private string systemCodeNumber = string.Empty;

        #endregion

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
                //Common.LoadSession();

            if (!IsPostBack)
            {
                //btnSaveAndSetOpeningTime.Visible = (null != ConfigurationManager.AppSettings["SaveAndSetOpeningTimeRequired"] && ConfigurationManager.AppSettings["SaveAndSetOpeningTimeRequired"].ToLower().Equals("true") && Common.IsOperationEnabled(GuidMapper.Object.CarParks, GuidMapper.Operation.EditOpeningTime, (int)Common.ObjectID.CarParks, (int)Common.EventID.OpeningTime));
                FillDropDown();
                if (null != Request["id"])
                {
                    if (null != Request["type"])
                    {
                        if (Request["type"] == "definition")
                        {
                            lblPageHeading.Text = "Edit Car Park";
                            AssignValues();
                            //fieldsetConfiguration.Visible = false;
                            //fieldsetDefinition.Visible = true;
                            fieldsetConfiguration.Style["Display"] = "none";
                            fieldsetDefinition.Style["Display"] = "inline";
                            hdnSave.Value = "Edit_CP";
                        }
                        else
                        {
                            lblPageHeading.Text = "Edit Configuration";
                            AssignconfigurationValues();
                            //fieldsetConfiguration.Visible = true;
                            //fieldsetDefinition.Visible = false;
                            fieldsetConfiguration.Style["Display"] = "inline";
                            fieldsetDefinition.Style["Display"] = "none";
                            hdnSave.Value = "Edit_CP_Configuration";
                            btnSaveAndSetLocation.Visible = false;
                            btnSaveAndSetOpeningTime.Visible = false;
                            btnSave.Text = "Save Configuration";
                        }
                    }
                }
                else
                {
                    hdnSave.Value = "New_CP";

                    if (ConfigurationManager.AppSettings["SystemCodeNumberRequired"] != null && ConfigurationManager.AppSettings["SystemCodeNumberRequired"].ToLower() == "true")
                        trSCN.Visible = true;
                }
            }
        }

        protected void CustomDdl_ServerValidate(object sender, ServerValidateEventArgs e)
        {
            CustomValidator custom = new CustomValidator();
            string ctrlName = string.Empty;

            custom = (CustomValidator)sender;

            DropDownList ddl = (DropDownList)FindControl(custom.ControlToValidate);
            if (null != ddl)
            {
                if (ddl.SelectedItem.Text == "Please Select")
                {
                    string source = string.Empty;
                    switch (ddl.ID)
                    {

                        case "ddlDataSource":
                            source = "data source";
                            break;
                        case "ddlType":
                            source = "type";
                            break;
                        case "ddlQualityStatement":
                            source = "quality statement";
                            break;
                    }
                    custom.ErrorMessage = "Please select " + source;
                    e.IsValid = false;
                }
                else
                    e.IsValid = true;
            }
        }

        protected void btnSaveAndSetLocation_Click(object sender, EventArgs e)
        {
            Page.Validate();
            if (Page.IsValid)
            {
                string scn = SaveCarpark();
                if (string.IsNullOrEmpty(scn))
                    return;

                if (scn == "SCN Exists")
                    lblSCN.Visible = true;
                else
                {
                    lblSCN.Visible = false;
                    //ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "Close", "CloseWindow('" + scn + "');", true);
                    //tblRecord.Visible = false;
                    tbl_Result.Visible = true;
                }
            }
        }

        protected void btnSaveAndSetOpeningTime_Click(object sender, EventArgs e)
        {
            Page.Validate();
            if (Page.IsValid)
            {
                string scn = SaveCarpark();
                if (string.IsNullOrEmpty(scn))
                    return;

                if (scn == "SCN Exists")
                    lblSCN.Visible = true;
                else
                {
                    lblSCN.Visible = false;
                    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "Close", "CloseWindow('" + scn + "','true');", true);
                    //tblRecord.Visible = false;
                    tbl_Result.Visible = true;
                }
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            Page.Validate();
            if (Page.IsValid)
            {
                string scn = SaveCarpark();
                if (string.IsNullOrEmpty(scn))
                    return;

                if (scn == "SCN Exists")
                    lblSCN.Visible = true;
                else
                {
                    lblSCN.Visible = false;
                    //tblRecord.Visible = false;
                    tbl_Result.Visible = true;
                    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "Close", "CloseWindow();", true);
                }
            }
        }

        private void FillDropDown()
        {
            DataSet ds = _support.List_DataSource();
            ddlDataSource.DataSource = ds.Tables[0];
            ddlDataSource.DataValueField = "TypeID";
            ddlDataSource.DataTextField = "DataSource_Description";
            ddlDataSource.DataBind();
            ddlDataSource.Items.Insert(0, "Please Select");

            ds = _support.List_Type(objectName);
            ddlType.DataSource = ds.Tables[0];
            ddlType.DataValueField = "TypeID";
            ddlType.DataTextField = "TypeDescription";
            ddlType.DataBind();
            ddlType.Items.Insert(0, "Please Select");

            ds = _support.List_QualityStatement(objectName);
            ddlQualityStatement.DataSource = ds.Tables[0];
            ddlQualityStatement.DataValueField = "QualityStatementID";
            ddlQualityStatement.DataTextField = "QualityDescription";
            ddlQualityStatement.DataBind();
            ddlQualityStatement.Items.Insert(0, "Please Select");
        }

        private void AssignValues()
        {
            systemCodeNumber = Page.Request["id"].ToString();

            DataSet ds = _carpark.View_DefinitionBySCN(systemCodeNumber);
            if (ds.Tables[0].Rows.Count > 0)
            {
                SetTextByLength(ds.Tables[0].Rows[0]["Short Description"].ToString(), txtShortDescription);
                SetTextByLength(ds.Tables[0].Rows[0]["Long Description"].ToString(), txtLongDescription);
                SetTextByLength(ds.Tables[0].Rows[0]["Ref"].ToString(), txtSCN);
                string modalRestriction = string.Empty;
                if (ds.Tables[0].Rows[0]["Modal_Restrictions"] != null && ds.Tables[0].Rows[0]["Modal_Restrictions"] != DBNull.Value)
                {
                    modalRestriction = ds.Tables[0].Rows[0]["Modal_Restrictions"].ToString();
                }

                if (ddlModalRestrictions.Items.FindByValue(modalRestriction) != null)
                {
                    ddlModalRestrictions.Items.FindByValue(modalRestriction).Selected = true;
                }
                //SetTextByLength(ds.Tables[0].Rows[0]["Modal_Restrictions"].ToString(), txtModalRestrictions);

                ddlType.SelectedValue = ds.Tables[0].Rows[0]["Type ID"].ToString();
                ddlQualityStatement.SelectedValue = ds.Tables[0].Rows[0]["Quality ID"].ToString();
                ddlDataSource.SelectedValue = ds.Tables[0].Rows[0]["Data ID"].ToString();

                hdnExistingSCN.Value = ds.Tables[0].Rows[0]["Ref"].ToString();
            }
        }

        private void AssignconfigurationValues()
        {
            systemCodeNumber = Page.Request["id"].ToString();

            DataSet ds = _carpark.View_ConfigurationBySCN(systemCodeNumber);
            if (ds.Tables[0].Rows.Count > 0)
            {
                SetTextByLength(ds.Tables[0].Rows[0]["Capacity"].ToString(), txtCapacity);
                SetTextByLength(ds.Tables[0].Rows[0]["Disabled Capacity"].ToString(), txtDisabledCapacity);
                SetTextByLength(ds.Tables[0].Rows[0]["AlmostFullIncreasing"].ToString(), txtAlmostfullincreasing);
                SetTextByLength(ds.Tables[0].Rows[0]["AlmostFullDecreasing"].ToString(), txtAlmostFullDecreasing);
                SetTextByLength(ds.Tables[0].Rows[0]["FullIncreasing"].ToString(), txtFullIncreasing);
                SetTextByLength(ds.Tables[0].Rows[0]["FullDecreasing"].ToString(), txtFullDecreasing);
                SetTextByLength(ds.Tables[0].Rows[0]["Ref"].ToString(), txtSCN);


            }
        }

        private void SetTextByLength(string strText, TextBox txtBoxToValidate)
        {
            if (txtBoxToValidate.MaxLength > 0)
            {
                if (strText.Length > txtBoxToValidate.MaxLength)
                {
                    strText = strText.Substring(0, txtBoxToValidate.MaxLength + 1);
                    if (strText.Substring(strText.Length - 1, 1) != " ")
                        strText = strText.Substring(0, (strText.LastIndexOf(" ") > 0) ? strText.LastIndexOf(" ") : txtBoxToValidate.MaxLength - 1);
                    else
                        strText = strText.Substring(0, txtBoxToValidate.MaxLength);
                }
            }
            txtBoxToValidate.Text = strText;
        }

        private string SaveCarpark()
        {

            string UserID = string.Empty;
            string unmappedSCN = string.Empty;

            if (UserID != null)
                UserID = new Random().Next().ToString();//Session["UserID"].ToString();

            if (!string.IsNullOrEmpty(txtSCN.Text.Trim()))
                unmappedSCN = txtSCN.Text.Trim();
            else if (Request["id"] != null)
                unmappedSCN = Page.Request.QueryString["id"].ToString();

            if (hdnSave.Value == "New_CP")
                unmappedSCN = _carpark.New_Car_Park(txtShortDescription.Text.Trim(), txtLongDescription.Text.Trim(),
                                    int.Parse(ddlType.SelectedValue), int.Parse(ddlQualityStatement.SelectedValue),
                                    int.Parse(ddlDataSource.SelectedValue), UserID, unmappedSCN, ddlModalRestrictions.SelectedValue);

            else if (hdnSave.Value == "Edit_CP")
                _carpark.Edit_Car_Park(unmappedSCN, txtShortDescription.Text.Trim(), txtLongDescription.Text.Trim(),
                                    int.Parse(ddlType.SelectedValue), int.Parse(ddlQualityStatement.SelectedValue),
                                    int.Parse(ddlDataSource.SelectedValue), UserID, hdnExistingSCN.Value.Trim(), ddlModalRestrictions.SelectedValue);
            if (unmappedSCN != "SCN Exists")
            {
                if (hdnSave.Value == "New_CP" || hdnSave.Value == "Edit_CP_Configuration")
                    _carpark.New_Configuration(unmappedSCN,
                                            (string.IsNullOrEmpty(txtCapacity.Text) ? 0 : Convert.ToInt32(txtCapacity.Text)),
                                            (string.IsNullOrEmpty(txtDisabledCapacity.Text) ? 0 : Convert.ToInt32(txtDisabledCapacity.Text)),
                                            (string.IsNullOrEmpty(txtAlmostfullincreasing.Text) ? 0 : Convert.ToInt32(txtAlmostfullincreasing.Text)),
                                            (string.IsNullOrEmpty(txtAlmostFullDecreasing.Text) ? 0 : Convert.ToInt32(txtAlmostFullDecreasing.Text)),
                                            (string.IsNullOrEmpty(txtFullIncreasing.Text) ? 0 : Convert.ToInt32(txtFullIncreasing.Text)),
                                            (string.IsNullOrEmpty(txtFullDecreasing.Text) ? 0 : Convert.ToInt32(txtFullDecreasing.Text)),
                                            UserID);
            }
            return unmappedSCN;
        }
    }
}