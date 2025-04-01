codeunit 55304 "NVR NoSeries Mask Mgmt"
{
    procedure GenerateNoSFromMask(var NoSeries: Record "No. Series")
    var
        Mask: Text[30];
        FiscalYear: integer;
        YearText: Text[4];
    begin
        Mask := NoSeries."NVR No. Series Mask";

        if Mask = '' then
            Error('No mask specified for the selected number series.');

        // Get Fiscal Year
        FiscalYear := Date2DMY(WorkDate(), 3);

        // Check if mask contains year in format "rrrr" or "rr"
        if Mask.Contains('rrrr') then begin
            YearText := Format(FiscalYear, 4, 0);
            CreateNewNoSeriesLine(NoSeries, FiscalYear, Mask, YearText);
        end else if Mask.Contains('rr') then begin
            YearText := Format(FiscalYear - 2000, 2, 0);
            CreateNewNoSeriesLine(NoSeries, FiscalYear, Mask, YearText);
        end else
            Message('Mask must contain "rr" or "rrrr" for the year.');
    end;

    local procedure CreateNewNoSeriesLine(NoSeries: Record "No. Series"; FiscalYear: integer; Mask: Text[30]; YearText: Text[4])
    var
        NoSeriesLine: Record "No. Series Line";
    begin
        Mask := Mask.Replace('rrrr', YearText).Replace('rr', YearText);

        NoSeriesLine.Init();
        NoSeriesLine."Series Code" := NoSeries.Code;
        NoSeriesLine.Validate("Starting Date", DMY2Date(1, 1, FiscalYear));
        NoSeriesLine.Validate("Starting No.", Mask.Replace('c', '0'));
        NoSeriesLine.Validate("Ending No.", Mask.Replace('c', '9'));
        NoSeriesLine.Insert(true);
    end;
}