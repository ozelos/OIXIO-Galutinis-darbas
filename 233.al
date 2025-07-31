OBJECT Table 50004 Auto Model
{
  OBJECT-PROPERTIES
  {
    Date=     01/03/23;
    Time=     09:00:00;
  }
  PROPERTIES
  {
    DataPerCompany=No;
  }
  FIELDS
  {
    FIELD(1; "Mark Code"; Code[10])
    {
      DataClassification=CustomerContent;
      CaptionML=ENU='Mark Code';
      InstructionalTextML=ENU='';
      TableRelation="Auto Mark".Code;
    }

    FIELD(2; "Model Code"; Code[10])
    {
      DataClassification=CustomerContent;
      CaptionML=ENU='Model Code';
      InstructionalTextML=ENU='';
    }

    FIELD(3; Description; Text[100])
    {
      DataClassification=CustomerContent;
      CaptionML=ENU='Description';
      InstructionalTextML=ENU='Defines the automobile model description';
    }
  }

  KEYS
  {
    KEY(PK; "Mark Code", "Model Code")
    {
      Clustered=Yes;
    }
  }
}
ENDOBJECT
OBJECT Page 50005 "Auto Model List"
{
  OBJECT-PROPERTIES
  {
    Date=     01/03/23;
    Time=     09:05:00;
  }
  PROPERTIES
  {
    PageType=List;
    SourceTable=Auto Model;
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
        CaptionML=ENU='Auto Models';
        FIELD("Mark Code"; Rec."Mark Code")
        {
          ApplicationArea=All;
        }
        FIELD("Model Code"; Rec."Model Code")
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
