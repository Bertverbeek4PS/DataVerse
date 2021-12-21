pageextension 50202 EmployeeListExt extends "Employee List"
{
    actions
    {
        addlast(processing)
        {
            action("Get Data From Dataverse")
            {
                ApplicationArea = All;
                Caption = 'Get Data From Dataverse';
                Image = Download;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = DataverseVisible;

                trigger OnAction()
                begin
                    GetDataVerse;
                end;
            }
            action("Sync Data From Dataverse")
            {
                ApplicationArea = All;
                Caption = 'Sync Data From Dataverse';
                Image = Download;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = DataverseVisible;

                trigger OnAction()
                begin
                    SyncDataVerse;
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        HumanResourceSetup: Record "Human Resources Setup";
    begin
        if HumanResourceSetup."Central Company" = false then
            DataverseVisible := true
        else
            DataverseVisible := false;
    end;

    var
        DataverseVisible: Boolean;

    local procedure SyncDataVerse()
    var
        HumanResourceSetup: Record "Human Resources Setup";
        CRMIntegrationManagement: Codeunit "CRM Integration Management";
        Employee: Record Employee;
        EmployeeVariant: Variant;
    begin
        If HumanResourceSetup."Central Company" = false then begin
            Codeunit.Run(Codeunit::"CRM Integration Management");
            Employee.Reset;
            EmployeeVariant := Employee;
            CRMIntegrationManagement.UpdateMultipleNow(EmployeeVariant);
        end;
    end;

    local procedure GetDataVerse()
    var
        HumanResourceSetup: Record "Human Resources Setup";
        CRMIntegrationManagement: Codeunit "CRM Integration Management";
        DataVerseEmployee: Record "CDS new_employee";
        CRMIntegrationRecord: record "CRM Integration Record";
        Employee: Record Employee;
    begin
        If HumanResourceSetup."Central Company" = false then begin
            Codeunit.Run(Codeunit::"CRM Integration Management");
            CRMIntegrationRecord.Reset;
            CRMIntegrationRecord.SetRange("Table Id", rec.RecordId.TableNo);
            if CRMIntegrationRecord.FindSet then
                repeat
                    Employee.Reset;
                    Employee.SetRange(SystemId, CRMIntegrationRecord."Integration ID");
                    If Employee.FindFirst() then begin
                        //Insert
                        DataVerseEmployee.Get(CRMIntegrationRecord."CRM ID");
                        CRMIntegrationManagement.CreateNewRecordsFromCRM(DataVerseEmployee);
                    end;
                until CRMIntegrationRecord.Next = 0;
        end;
    end;
}