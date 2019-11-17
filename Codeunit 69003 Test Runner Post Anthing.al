codeunit 69003 "Test Runner Post Anything"
{
    Subtype = TestRunner;
    TestIsolation = Codeunit;
    trigger OnRun()
    begin
        ExecutePosting();
    end;

    local procedure ExecutePosting()
    var
        TestPostAnything: Codeunit "Test Post Anything";

    begin

        TestPostAnything.SetEnvirontToPost(CodeunitNo, RecordToPost);
        TestPostAnything.Run();
    end;

    procedure SetEnvirontToPost(NewCodeunitNo: Integer; NewRecordToPost: Variant)
    var
    begin
        CodeunitNo := NewCodeunitNo;
        RecordToPost := NewRecordToPost;
    end;

    var
        CodeunitNo: Integer;
        RecordToPost: Variant;
}