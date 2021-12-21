pageextension 50201 HumanResourcesSetup extends "Human Resources Setup"
{
    layout
    {
        addlast(Numbering)
        {
            field("Central Company"; rec."Central Company")
            {
                ApplicationArea = All;
            }
        }
    }

}