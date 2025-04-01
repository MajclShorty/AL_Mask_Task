codeunit 55303 "NVR Subscribers"
{
    [EventSubscriber(ObjectType::Table, Database::"Purch. Rcpt. Line", 'OnBeforeInsertEvent', '', false, false)]
    local procedure OnBeforeInsert_PurchaseReceiptLine(var Rec: Record "Purch. Rcpt. Line")
    begin
        UpdateFullyInvoiced(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purch. Rcpt. Line", 'OnBeforeModifyEvent', '', false, false)]
    local procedure OnAfterModifyEvent_PurchaseReceiptLine(var Rec: Record "Purch. Rcpt. Line")
    begin
        UpdateFullyInvoiced(Rec);
    end;

    local procedure UpdateFullyInvoiced(var Rec: Record "Purch. Rcpt. Line")
    begin
        if not (Rec."Qty. Rcd. Not Invoiced" = 0) then
            Rec."NVR Fully Invoiced" := false
        else
            Rec."NVR Fully Invoiced" := true;
    end;
}