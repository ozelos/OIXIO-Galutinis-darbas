OBJECT Table 50013 "Auto Damage"
{
  OBJECT-PROPERTIES
  {
    Date=     01/06/23;
    Time=     10:00:00;
  }
  PROPERTIES
  {
    DataPerCompany=No;
  }
  FIELDS
  {
    FIELD(1; "Automobile No."; Code[20])
    {
      DataClassification=CustomerContent;
      CaptionML=ENU='Automobile No.';
      InstructionalTextML=ENU='';
      TableRelation=Auto."No.";
    }
    FIELD(2; "Line No."; Integer)
    {
      DataClassification=CustomerContent;
      CaptionML=ENU='Line No.';
      InstructionalTextML=ENU='';
    }
    FIELD(3; Date; Date)
    {
      DataClassification=CustomerContent;
      CaptionML=ENU='Date';
      InstructionalTextML=ENU='';
    }
    FIELD(4; Description; Text[100])
    {
      DataClassification=CustomerContent;
      CaptionML=ENU='Description';
      InstructionalTextML=ENU='Enter damage details';
    }
    FIELD(5; Status; Option)
    {
      DataClassification=CustomerContent;
      CaptionML=ENU='Status';
      InstructionalTextML=ENU='';
      OptionMembers=Current,Removed;
      OptionCaptionML=ENU='Current,Removed';
    }
  }
  KEYS
  {
    KEY(PK; "Automobile No.","Line No.")
    {
      Clustered=Yes;
    }
  }
  CODE
  {
    LOCAL PROCEDURE OnInsertTrigger@1000000000()
    BEGIN
      IF Rec."Line No." = 0 THEN
        Rec."Line No." := GetLastLineNo(Rec."Automobile No.") + 1;
    END;

    LOCAL PROCEDURE GetLastLineNo@1000000001(AutoNo: Code[20]): Integer
    VAR
      TempDam@1000000002 : Record "Auto Damage";
      LastNo@1000000003 : Integer;
    BEGIN
      TempDam.SETRANGE("Automobile No.", AutoNo);
      IF TempDam.FINDLAST THEN
        LastNo := TempDam."Line No.";
      EXIT(LastNo);
    END;
  }
}
ENDOBJECT


OBJECT Page 50014 "Auto Damage List"
{
  OBJECT-PROPERTIES
  {
    Date=     01/06/23;
    Time=     10:05:00;
  }
  PROPERTIES
  {
    PageType=List;
    SourceTable="Auto Damage";
    ApplicationArea=All;
    UsageCategory=Lists;
    Editable=Yes;
  }
  CONTROLS
  {
    AREA(Content)
    {
      GROUP(Group)
      {
        CaptionML=ENU='Auto Damages';
        FIELD("Automobile No."; Rec."Automobile No.")
        {
          ApplicationArea=All;
        }
        FIELD("Line No."; Rec."Line No.")
        {
          ApplicationArea=All;
        }
        FIELD(Date; Rec.Date)
        {
          ApplicationArea=All;
        }
        FIELD(Description; Rec.Description)
        {
          ApplicationArea=All;
        }
        FIELD(Status; Rec.Status)
        {
          ApplicationArea=All;
        }
      }
    }
  }
}
ENDOBJECT
