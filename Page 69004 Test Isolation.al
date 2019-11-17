page 69004 "Test Isolation"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field(Name; 'Nothing box')
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ExecuteRight)
            {
                ApplicationArea = All;
                Caption = 'Execute ok';
                Image = Post;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                trigger OnAction()
                begin
                    ExecuteTestRunner(false);

                end;
            }
            action(ExecuteWrong)
            {
                Caption = 'Execute error';
                ApplicationArea = All;
                Image = Error;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                trigger OnAction()
                begin
                    ExecuteTestRunner(true);

                end;
            }
            action(ExecuteRightWithoutMessa)
            {
                ApplicationArea = All;
                Caption = 'Execute ok Without Success Messsage';
                Image = Post;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                trigger OnAction()
                begin
                    ExecuteTestRunnerWithoutSuccessMessa(false);

                end;
            }
            action(ExecuteWrongWhitout)
            {
                Caption = 'Execute errorWithout Success Messsage';
                ApplicationArea = All;
                Image = Error;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                trigger OnAction()
                begin
                    ExecuteTestRunnerWithoutSuccessMessa(true);

                end;
            }
            action(ViewEntries)
            {
                Caption = 'View Entries';
                ApplicationArea = All;
                Image = Entries;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Report;
                RunObject = page "Resource Ledger Entries";
                trigger OnAction()
                begin
                end;
            }


        }
    }
    local procedure ExecuteTestRunner(WrongDate: Boolean)
    var
        TestRunnerPost: Codeunit "Test Runner Post Anything";
        PostingDate: date;
        ResJnlLine: Record "Res. Journal Line";
        ResLedgerEntry: Record "Res. Ledger Entry";
        Window: Dialog;
    begin
        Window.open('Please don´t be lazy, use a text const!!');
        ClearLastError();
        if not WrongDate then
            PostingDate := WorkDate();
        CreateJournalWithDate(PostingDate, ResJnlLine);
        TestRunnerPost.SetEnvirontToPost(Codeunit::"Res. Jnl.-Post Line", ResJnlLine);
        TestRunnerPost.run;
        if GetLastErrorText <> '' then
            Error('');
        Window.Close();
        if ResLedgerEntry.FindLast then
            Message(ResLedgerEntry."Document No.")
        else
            message(Format(ResLedgerEntry.IsEmpty));
    end;

    local procedure ExecuteTestRunnerWithoutSuccessMessa(WrongDate: Boolean)
    var
        TestPostAnything: Codeunit "Test Post Anything";
        PostingDate: date;
        ResJnlLine: Record "Res. Journal Line";
        ResLedgerEntry: Record "Res. Ledger Entry";
        CALTestLine: Record "CAL Test Line";
    begin
        ClearLastError();
        if not WrongDate then
            PostingDate := WorkDate();
        CreateJournalWithDate(PostingDate, ResJnlLine);
        TestPostAnything.SetEnvirontToPost(Codeunit::"Res. Jnl.-Post Line", ResJnlLine);
        CreateSuite(CALTestLine);
        Codeunit.Run(Codeunit::"CAL Test Runner", CALTestLine);
        if GetLastErrorText <> '' then
            Error('');
        if ResLedgerEntry.FindLast then
            Message(ResLedgerEntry."Document No.")
        else
            message(Format(ResLedgerEntry.IsEmpty));
    end;

    procedure CreateJournalWithDate(NewPostingDate: Date; var ResJnlLine: Record "Res. Journal line")
    var
    begin
        with ResJnlLine do begin
            "Entry Type" := "Entry Type"::Usage;
            validate("Resource No.", GetRightResource());
            Validate(Quantity, 1);
            Validate("Posting Date", NewPostingDate);
            "Document No." := Format(CurrentDateTime);
        end;
    end;

    procedure GetRightResource(): Code[20]
    var
        Resource: Record Resource;
        GeneralPostingSetup: Record "General Posting Setup";
    begin
        with Resource do begin
            FindFirst();
            if GeneralPostingSetup.get('', "Gen. Prod. Posting Group") then
                exit(Resource."No.");
            GeneralPostingSetup.FindFirst();
            GeneralPostingSetup."Gen. Bus. Posting Group" := '';
            GeneralPostingSetup."Gen. Prod. Posting Group" := "Gen. Prod. Posting Group";
            GeneralPostingSetup.Insert();
            exit("No.");
        end;
    end;

    local procedure CreateSuite(var CALTestLine: Record "CAL Test Line")
    var
        CALTestSuite: Record "CAL Test Suite";
    begin
        with CALTestSuite do begin
            Name := SuiteName;
            Description := SuiteName;
            if Insert() then;
        end;
        with CALTestLine do begin
            "Test Suite" := CALTestSuite.Name;
            "Line No." := 10000;
            if not Insert() then;
            "Line Type" := "Line Type"::Codeunit;
            "Test Codeunit" := Codeunit::"Test Post Anything";
            Run := true;
            Modify();
            SetRecFilter();
        end;
    end;

    var
        CALTestRunner: Codeunit "CAL Test Runner";
        CALTestRunnerPublisher: Codeunit "CAL Test Runner Publisher";
        SuiteName: Label 'POSTANY';
}