codeunit 55341 "NVR No Series Mask Tests"
{
    SubType = Test;
    TestPermissions = Disabled;

    var
        IncorrectStartingDate: Label 'Incorrect starting date';
        IncorrectStartingNo: Label 'Incorrect starting number';
        IncorrectEndingNo: Label 'Incorrect ending number';
        NoSeriesLineNotFound: Label 'No. Series Line not found';
        LibraryUtility: Codeunit "Library - Utility";
        LibraryAssert: Codeunit "Library Assert";

    [Test]
    procedure TestGenerateNoSeriesFromMaskTwoDigitYear()
    var
        NoSeries: Record "No. Series";
        NoSeriesLine: Record "No. Series Line";
        NoSeriesMaskMgmt: Codeunit "NVR NoSeries Mask Mgmt";
    begin
        // [SCENARIO] Generate No. Series Line from mask 'TESTrrccc' and verify correct number generation

        // [GIVEN] - Initialize No. Series Code & No. Series Mask Test Mask 'TESTrrccc'
        NoSeries.Init();
        NoSeries.Code := LibraryUtility.GenerateRandomCode(NoSeries.FieldNo(Code), DATABASE::"No. Series");
        NoSeries."NVR No. Series Mask" := 'TESTrrccc';
        NoSeries.Insert(true);

        // [GIVEN] - Initialize Work Date
        WorkDate := DMY2Date(1, 1, 2025);

        // [WHEN] - Generate No. Series from Mask
        NoSeriesMaskMgmt.GenerateNoSFromMask(NoSeries);

        // [THEN] - Generate No. Series Line with correct values
        NoSeriesLine.SetRange("Series Code", NoSeries.Code);
        LibraryAssert.IsTrue(NoSeriesLine.FindFirst(), NoSeriesLineNotFound);
        LibraryAssert.AreEqual('TEST25000', NoSeriesLine."Starting No.", IncorrectStartingNo);
        LibraryAssert.AreEqual('TEST25999', NoSeriesLine."Ending No.", IncorrectEndingNo);
    end;

    [Test]
    procedure TestGenerateNoSeriesFromMaskFourDigitYear()
    var
        NoSeries: Record "No. Series";
        NoSeriesLine: Record "No. Series Line";
        NoSeriesMaskMgmt: Codeunit "NVR NoSeries Mask Mgmt";
    begin
        // [SCENARIO] Generate No. Series Line from mask 'TESTrrccc' and verify correct number generation

        // [GIVEN] - Initialize No. Series Code & No. Series Mask Test Mask 'TESTrrccc'
        NoSeries.Init();
        NoSeries.Code := LibraryUtility.GenerateRandomCode(NoSeries.FieldNo(Code), DATABASE::"No. Series");
        NoSeries."NVR No. Series Mask" := 'TESTrrrrccc';
        NoSeries.Insert(true);

        // [GIVEN] - Initialize Work Date
        WorkDate := DMY2Date(1, 1, 2025);

        // [WHEN] - Generate No. Series from Mask
        NoSeriesMaskMgmt.GenerateNoSFromMask(NoSeries);

        // [THEN] - Generate No. Series Line with correct values
        NoSeriesLine.SetRange("Series Code", NoSeries.Code);
        LibraryAssert.IsTrue(NoSeriesLine.FindFirst(), NoSeriesLineNotFound);
        LibraryAssert.AreEqual('TEST2025000', NoSeriesLine."Starting No.", IncorrectStartingNo);
        LibraryAssert.AreEqual('TEST2025999', NoSeriesLine."Ending No.", IncorrectEndingNo);
    end;

}