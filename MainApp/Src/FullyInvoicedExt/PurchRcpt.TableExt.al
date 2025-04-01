tableextension 55300 "NVR Purch. Rcpt." extends "Purch. Rcpt. Line"
{
    fields
    {
        field(55300; "NVR Fully Invoiced"; Boolean)
        {
            Caption = 'Fully Invoiced';
            ToolTip = 'Specifies if the purchase receipt is fully invoiced.';
            Editable = false;
        }

    }
}