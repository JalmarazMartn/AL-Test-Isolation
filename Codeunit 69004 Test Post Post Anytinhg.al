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

    var
        CodeunitNo: Integer;
        RecordToPost: Variant;
}