////////////////////////////////////////////////////////////////////
// Table: Finished Auto Rent Line
OBJECT Table 50022 "Finished Auto Rent Line"
{
  OBJECT-PROPERTIES
  {
    Date=     01/07/23;
    Time=     10:30:00;
  }
  PROPERTIES
  {
    DataPerCompany=No;
  }
  FIELDS
  {
    // 1) Ryšys į Finished Auto Rent Header
    FIELD(1; "Document No."; Code[20])
    {
      DataClassification=CustomerContent;
      CaptionML=ENU='Document No.';
      InstructionalTextML=ENU='';
      TableRelation="Finished Auto Rent Header".No;
    }
    // 2) Eilutės numeris
    FIELD(2; "Line No."; Integer)
    {
      DataClassification=CustomerContent;
      CaptionML=ENU='Line No.';
      InstructionalTextML=ENU='';
    }
    // 3) Aprašas (pvz., paslaugos / prekės pavadinimas)
    FIELD(3; Description; Text[100])
    {
      DataClassification=CustomerContent;
      CaptionML=ENU='Description';
      InstructionalTextML=ENU='Line description';
    }
    // 4) Kiekis
    FIELD(4; Quantity; Decimal)
    {
      DataClassification=CustomerContent;
      CaptionML=ENU='Quantity';
      InstructionalTextML=ENU='';
    }
    // 5) Vnt. kaina
    FIELD(5; "Unit Price"; Decimal)
    {
      DataClassification=CustomerContent;
      CaptionML=ENU='Unit Price';
      InstructionalTextML=ENU='';
    }
    // 6) Eilutės suma
    FIELD(6; "Line Amount"; Decimal)
    {
      DataClassification=CustomerContent;
      CaptionML=ENU='Line Amount';
      InstructionalTextML=ENU='';
      CalcFormula=FIELD(Quantity * "Unit Price"); // arba kaip buvo Auto Rent Line
    }
  }
  KEYS
  {
    // Sudėtinis pirminis raktas
    KEY(PK; "Document No.","Line No.")
    {
      Clustered=Yes;
    }
  }
}
ENDOBJECT


////////////////////////////////////////////////////////////////////
// Page: Finished Auto Rent Line Part
OBJECT Page 50023 "Finished Auto Rent Line Part"
{
  OBJECT-PROPERTIES
  {
    Date=     01/07/23;
    Time=     10:35:00;
  }
  PROPERTIES
  {
    PageType=ListPart;
    SourceTable="Finished Auto Rent Line";
    ApplicationArea=All;
    UsageCategory=Lists;
    Editable=No;          // laukai nekoreguojami
    SubPageLink=          // susiejame su Finished Auto Rent Header kortele
      Document No.=FIELD(No);
  }
  CONTROLS
  {
    AREA(Content)
    {
      GROUP(General)
      {
        CaptionML=ENU='Lines';
        FIELD("Line No."; Rec."Line No.")       { ApplicationArea=All; }
        FIELD(Description; Rec.Description)     { ApplicationArea=All; }
        FIELD(Quantity; Rec.Quantity)           { ApplicationArea=All; }
        FIELD("Unit Price"; Rec."Unit Price")   { ApplicationArea=All; }
        FIELD("Line Amount"; Rec."Line Amount") { ApplicationArea=All; }
      }
    }
  }
}
ENDOBJECT
