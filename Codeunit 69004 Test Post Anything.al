codeunit 69004 "Test Post Anything"
{
    Subtype = Test;
    SingleInstance = true;
    trigger OnRun()
    begin

    end;

    [Test]
    procedure PostAnyThingYouSet()
    var
    begin
        Codeunit.Run(CodeunitNo, RecordToPost);
    end;

    procedure SetEnvirontToPost(NewCodeunitNo: Integer; NewRecordToPost: Variant)
    var
    begin
        CodeunitNo := NewCodeunitNo;
        RecordToPost := NewRecordToPost;
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

    procedure RunTheTest(NewCodeunitNo: Integer; NewRecordToPost: Variant)
    var
        CALTestLine: Record "CAL Test Line";
    begin
        SetEnvirontToPost(NewCodeunitNo, NewRecordToPost);
        CreateSuite(CALTestLine);
        ClearLastError();
        Codeunit.Run(Codeunit::"CAL Test Runner", CALTestLine);
        if GetLastErrorText = '' then
            Error('');
    end;

    var
        CodeunitNo: Integer;
        RecordToPost: Variant;
        SuiteName: Label 'POSTANY';
        OtherSytemError: Label 'Error code: 85132273';

}