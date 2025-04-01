codeunit 55340 "NVR Purch. Rcpt. Tests"
{
    Subtype = Test;
    TestPermissions = Disabled;

    var
        GenBusPostingGroup: Record "Gen. Business Posting Group";
        GenProdPostingGroup: Record "Gen. Product Posting Group";
        InventoryPostingGroup: Record "Inventory Posting Group";
        Location: Record Location;
        LibraryRandom: Codeunit "Library - Random";
        LibraryUtility: Codeunit "Library - Utility";
        LibraryInventory: Codeunit "Library - Inventory";
        LibraryPurchase: Codeunit "Library - Purchase";

        Assert: Codeunit "Assert";
        FullyInvoicedFalseLbl: Label 'Receipt is not Fully Invoiced';
        FullyInvoicedTrueLbl: Label 'Receipt is Fully Invoiced';
        WasInitialized: Boolean;

    [Test]
    procedure TestReceiptNotFullyInvoiced()
    var
        PurchLine: Record "Purchase Line";
        PurchRcptLine: Record "Purch. Rcpt. Line";
        PurchHeader: Record "Purchase Header";
        Vendor: Record Vendor;
        Item: Record Item;
    begin
        // [SCENARIO] - Check if the new order is recieved only



        if not WasInitialized then begin
            // [GIVEN] - Initialize UnitOfMeasure, VAT Period, No. Series etc. 
            Init();
            WasInitialized := true;
        end;


        // [GIVEN] - Create Vendor and Item & Set Item
        LibraryPurchase.CreateVendor(Vendor);
        LibraryInventory.CreateItem(Item);
        Item.Validate("Inventory Posting Group", InventoryPostingGroup.Code);
        Item.Validate("Gen. Prod. Posting Group", GenProdPostingGroup.Code);
        Item.Modify(true);


        // [GIVEN] - Set General Business Posting Group for Vendor
        Vendor."Gen. Bus. Posting Group" := GenBusPostingGroup.Code;
        Vendor.Modify(true);


        // [GIVEN] - Create a new purchase order
        LibraryPurchase.CreatePurchHeader(PurchHeader, PurchHeader."Document Type"::Order, Vendor."No.");
        LibraryPurchase.CreatePurchaseLine(PurchLine, PurchHeader, PurchLine.Type::Item, Item."No.", LibraryRandom.RandIntInRange(1, 10));


        // [GIVEN] - Set Location
        LibraryInventory.UpdateInventoryPostingSetup(Location);


        // [WHEN] - Recieve the order
        LibraryPurchase.PostPurchaseDocument(PurchHeader, true, false);


        // [THEN] - Check if the receipt is not fully invoiced
        PurchRcptLine.SetRange("Document No.", PurchHeader."Last Receiving No.");
        PurchRcptLine.FindFirst();
        Assert.IsFalse(PurchRcptLine."NVR Fully Invoiced", FullyInvoicedFalseLbl);
    end;

    [Test]
    procedure TestReceiptFullyInvoiced()
    var
        PurchLine: Record "Purchase Line";
        PurchRcptLine: Record "Purch. Rcpt. Line";
        PurchHeader: Record "Purchase Header";
        Vendor: Record Vendor;
        Item: Record Item;
    begin
        // [SCENARIO] - Check if the new order is recieved and invoiced

        // Move to Init()
        if not WasInitialized then begin
            // [GIVEN] - Initialize UnitOfMeasure, VAT Period, No. Series etc. 
            Init();
            WasInitialized := true;
        end;


        // [GIVEN] - Create Vendor and Item & Set Item
        LibraryPurchase.CreateVendor(Vendor);
        LibraryInventory.CreateItem(Item);
        Item.Validate("Inventory Posting Group", InventoryPostingGroup.Code);
        Item.Validate("Gen. Prod. Posting Group", GenProdPostingGroup.Code);
        Item.Modify(true);


        // [GIVEN] - Set General Business Posting Group for Vendor
        Vendor."Gen. Bus. Posting Group" := GenBusPostingGroup.Code;


        // [GIVEN] - Create a new purchase order
        LibraryPurchase.CreatePurchHeader(PurchHeader, PurchHeader."Document Type"::Order, Vendor."No.");
        LibraryPurchase.CreatePurchaseLine(PurchLine, PurchHeader, PurchLine.Type::Item, Item."No.", LibraryRandom.RandIntInRange(1, 10));
        PurchHeader.Validate("Original Doc. VAT Date CZL", Today);
        PurchHeader.Modify(true);


        // [WHEN] - Recieve the order
        LibraryPurchase.PostPurchaseDocument(PurchHeader, true, true);


        // [THEN] - Check if the receipt is not fully invoiced
        PurchRcptLine.SetRange("Document No.", PurchHeader."Last Receiving No.");
        PurchRcptLine.FindFirst();
        Assert.IsTrue(PurchRcptLine."NVR Fully Invoiced", FullyInvoicedTrueLbl);
    end;

    local procedure Init()
    var
        InventoryPostingSetup: Record "Inventory Posting Setup";
    begin
        // Create General Business Posting Group & General Product Posting Group
        CreateGenBusPostingGroup(GenBusPostingGroup);
        CreateGenProdPostingGroup(GenProdPostingGroup);

        CreateUnitOfMeasure();
        CreateVATPeriod();

        // Create No. Series and No. Series Line
        CreateNoSeries();

        // Create Inventory Posting Group and Inventory Posting Setup
        CreateInvPostGroup(InventoryPostingGroup);
        LibraryInventory.CreateInventoryPostingSetup(InventoryPostingSetup, Location.Code, InventoryPostingGroup.Code);

        // Create General Posting Setup
        CreateGenPostSetup(GenBusPostingGroup.Code, GenProdPostingGroup.Code);

        // Moved from the test, updating 2x times evokes error
        LibraryInventory.UpdateInventoryPostingSetup(Location);

        LibraryInventory.UpdateGenProdPostingSetup();
    end;

    local procedure CreateInvPostGroup(var InvPostGroup: Record "Inventory Posting Group")
    begin
        InvPostGroup.Init();
        InvPostGroup.Code := 'GROUP1';
        InvPostGroup.Description := 'New Inventory Posting Group';
        InvPostGroup.Insert(true);
    end;

    local procedure CreateGenBusPostingGroup(var GenBusPostGroup: Record "Gen. Business Posting Group")
    begin
        GenBusPostGroup.Init();
        GenBusPostGroup.Code := 'EU_Customers';
        GenBusPostGroup.Description := 'General Business Posting Group';
        GenBusPostGroup.Insert(true);
    end;

    local procedure CreateGenProdPostingGroup(var GenProdPostGroup: Record "Gen. Product Posting Group")
    begin
        GenProdPostGroup.Init();
        GenProdPostGroup.Code := 'Product1';
        GenProdPostGroup.Description := 'General Product Posting Group';
        GenProdPostGroup.Insert(true);
    end;

    // Creating GL Account
    local procedure CreateGLAccount(AccNo: Code[20]; AccName: Text[50])
    var
        GLAccount: Record "G/L Account";
    begin
        if not GLAccount.Get(AccNo) then begin
            GLAccount.Init();
            GLAccount."No." := AccNo;
            GLAccount.Name := AccName;
            GLAccount."Account Type" := GLAccount."Account Type"::Posting;
            GLAccount.Insert(true);
        end;
    end;

    // Creating General Posting Setup & Creating GL Accounts
    local procedure CreateGenPostSetup(GenBusPostingGroupCode: Code[20]; GenProdPostingGroupCode: Code[20])
    var
        GeneralPostingSetup: Record "General Posting Setup";
    begin
        if not GeneralPostingSetup.Get(GenBusPostingGroupCode, GenProdPostingGroupCode) then begin
            CreateGLAccount('40100', 'Sales Account'); // Library for creating GL Account
            CreateGLAccount('50100', 'Purchase Account');
            CreateGLAccount('60100', 'COGS Account');

            GeneralPostingSetup.Init();
            GeneralPostingSetup."Gen. Bus. Posting Group" := GenBusPostingGroupCode;
            GeneralPostingSetup."Gen. Prod. Posting Group" := GenProdPostingGroupCode;
            GeneralPostingSetup."Sales Account" := '40100';
            GeneralPostingSetup."Purch. Account" := '50100';
            GeneralPostingSetup."COGS Account" := '60100';
            GeneralPostingSetup.Insert(true);
        end;
    end;

    local procedure CreateNoSeries()
    var
        NoSeries: Record "No. Series";
        NoSeriesLine: Record "No. Series Line";
        PurchSetup: Record "Purchases & Payables Setup";
    begin
        LibraryUtility.CreateNoSeries(NoSeries, true, false, false);
        LibraryUtility.CreateNoSeriesLine(NoSeriesLine, NoSeries.Code, '', '');

        PurchSetup.Get();
        PurchSetup."Order Nos." := NoSeries.Code;
        PurchSetup."Posted Receipt Nos." := NoSeries.Code;
        PurchSetup."Posted Invoice Nos." := NoSeries.Code;
        PurchSetup.Modify(true);
    end;

    local procedure CreateUnitOfMeasure()
    var
        UnitMeasure: Record "Unit of Measure";
    begin
        UnitMeasure.Init();
        UnitMeasure.Code := 'Pcs';
        UnitMeasure.Description := 'Unit of Measure defines in pieces';
        UnitMeasure.Insert();
    end;

    local procedure CreateVATPeriod()
    var
        VATPeriod: Record "VAT Period CZL";
    begin
        VATPeriod.Init();
        VATPeriod."Starting Date" := DMY2Date(1, 1, Date2DMY(WorkDate(), 3));
        VATPeriod.Insert();
    end;
}