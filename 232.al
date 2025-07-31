OBJECT Table 50002 Auto Mark
{
  OBJECT-PROPERTIES
  {
    Date=     01/02/23;
    Time=     10:00:00;
  }
  PROPERTIES
  {
    DataPerCompany=No;
  }
  FIELDS
  {
    FIELD(1; Code; Code[10])
    {
      DataClassification=CustomerContent;
      CaptionML=
        ENU='Code';
      InstructionalTextML=
        ENU='';
    }
    FIELD(2; Description; Text[100])
    {
      DataClassification=CustomerContent;
      CaptionML=
        ENU='Description';
      InstructionalTextML=
        ENU='Defines the automobile make';
    }
  }
  KEYS
  {
    KEY(Key1; Code)
    {
      Clustered=Yes;
    }
  }
}
ENDOBJECT


OBJECT Page 50003 "Auto Mark List"
{
  OBJECT-PROPERTIES
  {
    Date=     01/02/23;
    Time=     10:05:00;
  }
  PROPERTIES
  {
    PageType=List;
    SourceTable=Auto Mark;
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
        CaptionML=
          ENU='Auto Marks';
        FIELD(Code; Rec.Code)
        {
          ApplicationArea=All;
        }
        FIELD(Description; Rec.Description)
        {
          ApplicationArea=All;
        }
      }
    }
  }
}
ENDOBJECT
