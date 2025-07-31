OBJECT Table 50000 Auto Setup
{
  OBJECT-PROPERTIES
  {
    Date=     01/01/23;
    Time=     12:00:00;
  }
  PROPERTIES
  {
    DataPerCompany=No;
  }
  FIELDS
  {
    FIELD(1; "Primary Key"; Code[20])
    {
      DataClassification=ToBeClassified;
      // === Caption & Instr. text kaip Label’ai ===
      CaptionML=
        ENU='Primary Key';
      InstructionalTextML=
        ENU='';
    }
    FIELD(2; "Automobile No. Series"; Code[10])
    {
      DataClassification=ToBeClassified;
      CaptionML=
        ENU='Automobile No. Series';
      InstructionalTextML=
        ENU='';
    }
    FIELD(3; "Rental Card Series"; Code[10])
    {
      DataClassification=ToBeClassified;
      CaptionML=
        ENU='Rental Card Series';
      InstructionalTextML=
        ENU='';
    }
    FIELD(4; "Location Code"; Code[10])
    {
      DataClassification=ToBeClassified;
      CaptionML=
        ENU='Location';
      InstructionalTextML=
        ENU='';
      TableRelation=Location.Code WHERE (Status=CONST(Active));
    }
  }
  KEYS
  {
    // pirminis raktas
    KEY(Key1; "Primary Key")
    {
      Clustered=Yes;
    }
  }
}
ENDOBJECT


OBJECT Page 50001 "Auto Setup Card"
{
  OBJECT-PROPERTIES
  {
    Date=     01/01/23;
    Time=     12:05:00;
  }
  PROPERTIES
  {
    PageType=Card;
    SourceTable=Auto Setup;
    ApplicationArea=All;
    UsageCategory=Administration;
  }
  CONTROLS
  {
    GROUP(Group)
    {
      // grupės pavadinimas kaip Label
      CaptionML=
        ENU='General';
      FIELD("Primary Key"; Rec."Primary Key")
      {
        ApplicationArea=All;
      }
      FIELD("Automobile No. Series"; Rec."Automobile No. Series")
      {
        ApplicationArea=All;
      }
      FIELD("Rental Card Series"; Rec."Rental Card Series")
      {
        ApplicationArea=All;
      }
      FIELD("Location Code"; Rec."Location Code")
      {
        ApplicationArea=All;
      }
    }
  }
}
ENDOBJECT
