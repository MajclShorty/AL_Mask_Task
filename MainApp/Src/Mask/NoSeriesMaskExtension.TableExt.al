tableextension 55306 "NVR No Series Mask Extension" extends "No. Series"
{
    fields
    {
        field(55300; "NVR No. Series Mask"; Text[30])
        {
            Caption = 'Mask';
            DataClassification = SystemMetadata;
            Editable = true;
        }
    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
}