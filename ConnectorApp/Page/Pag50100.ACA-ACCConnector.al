page 50100 "ACA - ACC Connector"
{
    Caption = 'acadon_client.connector';

    layout
    {
        area(content)
        {
            usercontrol(Connector; ConnectorControl)
            {
                trigger ControlAddInReady()
                begin
                    SetPageData();
                    Invoke();
                end;

                trigger OnEndInvokeFunction(response: JsonObject)
                begin
                    ResponseBuffer := response;
                    EndInvokeCalled := true;
                    CurrPage.Close();
                end;

                trigger KeepAlive()
                var
                    Company: Text;
                begin
                    Company := CompanyName();
                end;
            }
        }
    }

    var
        RequestBuffer: JsonObject;
        ResponseBuffer: JsonObject;
        AlternativeDescription: Text;
        EndInvokeCalled: Boolean;
        InstallTxt: Label 'acadon_client.connector is not running. Please start the acadon_client.connector and try again.<br /><br /><b>acadon_client.connector not installed?</b><br />You can simply install the acadon_client.connector from <a href="https://distribution.acadon.de/acadon_client.connector/">here</a>!';

    procedure SetRequest(Request: JsonObject)
    begin
        RequestBuffer := Request;
    end;

    procedure SetAlternativeDescription(Description: Text)
    begin
        AlternativeDescription := Description;
    end;

    procedure GetResponse(): JsonObject
    begin
        exit(ResponseBuffer);
    end;

    procedure HasResponseReceived(): Boolean
    begin
        exit(EndInvokeCalled);
    end;

    local procedure Invoke()
    begin
        EndInvokeCalled := false;
        CurrPage.Connector.InvokeFunctionAsync(RequestBuffer);
    end;

    local procedure SetPageData()
    begin
        CurrPage.Connector.SetInstallContent(InstallTxt);
        CurrPage.Connector.SetAlternativeDescription(AlternativeDescription);
    end;
}