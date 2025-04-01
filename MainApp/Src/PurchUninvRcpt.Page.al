page 55300 "NVR Purch. Uninv. Rcpt."
{
    PageType = List;
    Caption = 'Purch. Uninvoiced receipts';
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Purch. Rcpt. Line";
    SourceTableView = WHERE("NVR Fully Invoiced" = filter(false));
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                Caption = 'Uninvoiced receipts';
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the posting date.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the document number.';
                }
                field("Order No."; Rec."Order No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the order number.';
                }
                field("Buy-from Vendor No."; Rec."Buy-from Vendor No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the buy-from vendor number.';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type.';
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description.';
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unit of measure code.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the quantity.';
                }
                field("Quantity Invoiced"; Rec."Quantity Invoiced")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the quantity invoiced.';
                }
                field("Qty. Rcd. Not Invoiced"; Rec."Qty. Rcd. Not Invoiced")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the quantity received not invoiced.';
                }
                field("NVR Fully Invoiced"; Rec."NVR Fully Invoiced")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies if the purchase receipt is fully invoiced.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ShowDocument)
            {
                ApplicationArea = All;
                Caption = 'Show document';
                ToolTip = 'Open the document assigned to the document number.';
                Image = Document;
                RunObject = Page "Purch. Receipt Lines";
                RunPageLink = "Document No." = field("Document No.");
            }
            action(ShowOrder)
            {
                ApplicationArea = All;
                Caption = 'Show order';
                ToolTip = 'Open the order assigned to the order number.';
                Image = Order;
                RunObject = Page "Purchase Order List";
                RunPageLink = "No." = field("Order No.");
            }
            action(ShowDimension)
            {
                ApplicationArea = All;
                Caption = 'Dimensions';
                ToolTip = 'Open the dimensions assigned to the purch. uninv. receipt.';
                Image = Dimensions;
                trigger OnAction()
                begin
                    Rec.ShowDimensions();
                end;
            }
            action(ShowTrackingLine)
            {
                ApplicationArea = All;
                Caption = 'Tracking lines';
                ToolTip = 'Open the tracked items.';
                Image = Track;
                trigger OnAction()
                begin
                    Rec.ShowItemTrackingLines();
                end;
            }

        }
        area(Promoted)
        {
            actionref(ShowDocument_Promoted; ShowDocument)
            {

            }
            actionref(ShowOrder_Promoted; ShowOrder)
            {

            }
            actionref(ShowDimension_Promoted; ShowDimension)
            {

            }
            actionref(ShowTrackingLine_Promoted; ShowTrackingLine)
            {

            }
        }
    }
}