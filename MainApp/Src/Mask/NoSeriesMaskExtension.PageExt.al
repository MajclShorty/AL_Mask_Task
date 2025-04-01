pageextension 55302 "NVR No Series Mask Extension" extends "No. Series"
{
    layout
    {
        addlast(Control1)
        {
            field("NVR No. Series Mask"; Rec."NVR No. Series Mask")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the mask for the number series.';
            }
        }
    }

    actions
    {
        addfirst(Processing)
        {
            action("NVR Generate from Mask")
            {
                ApplicationArea = All;
                Caption = 'Generate No. Series from Mask';
                Tooltip = 'Generate number series from the mask.';
                Image = Calculator;

                trigger OnAction()
                var
                    NoSeriesMgmt: Codeunit "NVR NoSeries Mask Mgmt";
                begin
                    NoSeriesMgmt.GenerateNoSFromMask(Rec);
                end;
            }
        }
    }

    var
        myInt: Integer;
}