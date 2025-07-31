OBJECT Table 50006 Auto
{
  OBJECT-PROPERTIES
  {
    Date=     01/04/23;
    Time=     11:00:00;
  }
  PROPERTIES
  {
    DataPerCompany=No;
  }
  FIELDS
  {
    // Nr. — pirminis raktas, serijinio numerio valdymas per NoSeries
    FIELD(1; "No."; Code[20])
    {
      DataClassification=SystemMetadata;
      CaptionML=ENU='No.';
      InstructionalTextML=ENU='';
      // numerio serija pagal Auto Setup
      TableRelation= "Auto Setup"."Primary Key";
    }
    FIELD(2; Name; Text[100])
    {
      DataClassification=CustomerContent;
      CaptionML=ENU='Name';
      InstructionalTextML=ENU='Automobile name';
    }
    FIELD(3; "Mark Code"; Code[10])
    {
      DataClassification=CustomerContent;
      CaptionML=ENU='Mark';
      InstructionalTextML=ENU='Choose from Auto Mark';
      TableRelation= "Auto Mark".Code;
    }
    FIELD(4; "Model Code"; Code[10])
    {
      DataClassification=CustomerContent;
      CaptionML=ENU='Model';
      InstructionalTextML=ENU='Choose from Auto Model for selected Mark';
      TableRelation= "Auto Model".Mark Code WHERE ( "Mark Code" = field("Mark Code") );
    }
    FIELD(5; "Manufacture Year"; Integer)
    {
      DataClassification=CustomerContent;
      CaptionML=ENU='Manufacture Year';
      InstructionalTextML=ENU='';
    }
    FIELD(6; "Insurance Expiry"; Date)
    {
      DataClassification=CustomerContent;
      CaptionML=ENU='Civil Insurance Valid Until';
      InstructionalTextML=ENU='';
    }
    FIELD(7; "TA Expiry"; Date)
    {
      DataClassification=CustomerContent;
      CaptionML=ENU='Technical Approval Valid Until';
      InstructionalTextML=ENU='';
    }
    FIELD(8; "Location Code"; Code[10])
    {
      DataClassification=CustomerContent;
      CaptionML=ENU='Location';
      InstructionalTextML=ENU='';
      TableRelation=Location.Code WHERE (Status=CONST(Active));
    }
    FIELD(9; "Rental Service"; Code[20])
    {
      DataClassification=CustomerContent;
      CaptionML=ENU='Rental Service';
      InstructionalTextML=ENU='';
      TableRelation=Resource."No.";
    }
    // Rental Price — flowfield iš Resource (ar kitos lentelės) pagal pasirinktos paslaugos kainą
    FIELD(10; "Rental Price"; Decimal)
    {
      DataClassification=CustomerContent;
      CaptionML=ENU='Rental Price';
      InstructionalTextML=ENU='Calculated from selected Rental Service';
      CalcFormula=FIELD("Resource"."Unit Price" WHERE ( "No."=FIELD("Rental Service") ));
    }
  }
  KEYS
  {
    KEY(PK; "No.")
    {
      Clustered=Yes;
    }
  }

  // autogeneruoti Nr. per Auto Setup No. seriją
  CODE
  {
    LOCAL PROCEDURE OnInsertTrigger@1000000000();
    BEGIN
      IF "No." = '' THEN
        "No." := NoSeriesMgt.GetNextNo(
                  Database::"Auto Setup",
                  'Primary Key',
                  WORKDATE,
                  Rec);
    END;
  }
}
ENDOBJECT


OBJECT Page 50007 "Auto List"
{
  OBJECT-PROPERTIES
  {
    Date=     01/04/23;
    Time=     11:10:00;
  }
  PROPERTIES
  {
    PageType=List;
    SourceTable=Auto;
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
        CaptionML=ENU='Autos';
        FIELD("No."; Rec."No.")
        {
          ApplicationArea=All;
        }
        FIELD(Name; Rec.Name)
        {
          ApplicationArea=All;
        }
        FIELD("Mark Code"; Rec."Mark Code")
        {
          ApplicationArea=All;
        }
        FIELD("Model Code"; Rec."Model Code")
        {
          ApplicationArea=All;
        }
        FIELD("Rental Price"; Rec."Rental Price")
        {
          ApplicationArea=All;
        }
      }
    }
  }
}
ENDOBJECT


OBJECT Page 50008 "Auto Card"
{
  OBJECT-PROPERTIES
  {
    Date=     01/04/23;
    Time=     11:15:00;
  }
  PROPERTIES
  {
    PageType=Card;
    SourceTable=Auto;
    ApplicationArea=All;
    UsageCategory=Administration;
  }
  CONTROLS
  {
    GROUP(General)
    {
      CaptionML=ENU='General';
      FIELD("No."; Rec."No.") { ApplicationArea=All; }
      FIELD(Name; Rec.Name) { ApplicationArea=All; }
      FIELD("Mark Code"; Rec."Mark Code") { ApplicationArea=All; }
      FIELD("Model Code"; Rec."Model Code") { ApplicationArea=All; }
      FIELD("Manufacture Year"; Rec."Manufacture Year") { ApplicationArea=All; }
      FIELD("Insurance Expiry"; Rec."Insurance Expiry") { ApplicationArea=All; }
      FIELD("TA Expiry"; Rec."TA Expiry") { ApplicationArea=All; }
      FIELD("Location Code"; Rec."Location Code") { ApplicationArea=All; }
      FIELD("Rental Service"; Rec."Rental Service") { ApplicationArea=All; }
      FIELD("Rental Price"; Rec."Rental Price") { ApplicationArea=All; }
    }
  }
}
ENDOBJECT
