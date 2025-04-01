codeunit 55300 "NVR Fully Inv. Upgrade"
{

    Subtype = Upgrade;

    trigger OnUpgradePerCompany()
    begin
        UpdateFullyInvoicedForAllRecs();
    end;

    local procedure UpdateFullyInvoicedForAllRecs()
    var
        PurchRcptLine: Record "Purch. Rcpt. Line";
    begin
        if PurchRcptLine.FindSet() then
            repeat
                UpdateFullyInvoiced(PurchRcptLine);
                PurchRcptLine.Modify(true);
            until PurchRcptLine.Next() = 0;
    end;

    local procedure UpdateFullyInvoiced(var Rec: Record "Purch. Rcpt. Line")
    begin
        if not (Rec."Qty. Rcd. Not Invoiced" = 0) then
            Rec."NVR Fully Invoiced" := false
        else
            Rec."NVR Fully Invoiced" := true;
    end;
}