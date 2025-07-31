OBJECT Table 50024 "Auto Rent Damage"
{
  OBJECT-PROPERTIES
  {
    Date=     01/07/23;
    Time=     12:50:00;
  }
  PROPERTIES
  {
    DataPerCompany=No;
  }
  FIELDS
  {
    FIELD(1; "Document No."; Code[20])
    {
      DataClassification=CustomerContent;
      CaptionML=ENU='Document No.';
      TableRelation="Auto Rent Header".No;
    }
    FIELD(2; "Line No."; Integer)
    {
      DataClassification=CustomerContent;
      CaptionML=ENU='Line No.';
    }
    FIELD(3; Date; Date)
    {
      DataClassification=CustomerContent;
      CaptionML=ENU='Damage Date';
    }
    FIELD(4; Description; Text[100])
    {
      DataClassification=CustomerContent;
      CaptionML=ENU='Description';
    }
  }
  KEYS
  {
    KEY(PK; "Document No.","Line No.")
    {
      Clustered=Yes;
    }
  }
  CODE
  {
    // Auto-increment Line No.
    LOCAL PROCEDURE OnInsertTrigger@1000000000()
    BEGIN
      IF Rec."Line No." = 0 THEN
        Rec."Line No." := GetLastLineNo(Rec."Document No.") + 1;
    END;

    LOCAL PROCEDURE GetLastLineNo@1000000001(DocNo: Code[20]): Integer
    VAR
      TempDR@1000000002 : Record "Auto Rent Damage";
      Last@1000000003   : Integer;
    BEGIN
      TempDR.SETRANGE("Document No.", DocNo);
      IF TempDR.FINDLAST THEN
        Last := TempDR."Line No.";
      EXIT(Last);
    END;
  }
}
ENDOBJECT

OBJECT Page 50025 "Auto Rent Damage List"
{
  OBJECT-PROPERTIES
  {
    Date=     01/07/23;
    Time=     12:55:00;
  }
  PROPERTIES
  {
    PageType=List;
    SourceTable="Auto Rent Damage";
    ApplicationArea=All;
    UsageCategory=Lists;
    Editable=Yes; // klientas fiksuoja prieš grąžinant
  }
  CONTROLS
  {
    AREA(Content)
    {
      GROUP(General)
      {
        CaptionML=ENU='Rental Damages';
        FIELD("Document No."; Rec."Document No.") { ApplicationArea=All; }
        FIELD("Line No."; Rec."Line No.")       { ApplicationArea=All; }
        FIELD(Date; Rec.Date)                   { ApplicationArea=All; }
        FIELD(Description; Rec.Description)     { ApplicationArea=All; }
      }
    }
  }
}
ENDOBJECT

LOCAL PROCEDURE ReturnCar@1000000001();
VAR
  FinHeader   : Record "Finished Auto Rent Header";
  RentLine    : Record "Auto Rent Line";
  FinLine     : Record "Finished Auto Rent Line";
  RentDam     : Record "Auto Rent Damage";
  FinDam      : Record "Finished Auto Damage"; // ar Auto Damage, jeigu į ją perkeliame
  AutoDam     : Record "Auto Damage";
BEGIN
  // … esami RentLine perkėlimai …

  // ▶ Perkeliam Auto Rent Damage į Auto Damage
  RentDam.SETRANGE("Document No.", Rec.No);
  IF RentDam.FINDSET THEN
    REPEAT
      AutoDam.INIT;
      AutoDam."Automobile No." := Rec."Automobile No.";
      AutoDam."Line No."       := GetNextAutoDamageLine(Rec."Automobile No."); // pvz., helper funkcija
      AutoDam.Date             := RentDam.Date;
      AutoDam.Description      := RentDam.Description;
      AutoDam.STATUS           := AutoDam.Status::Current; // pagal poreikį
      AutoDam.INSERT;
    UNTIL RentDam.NEXT = 0;

  // Ištrinam nuomos trūkumų įrašus
  RentDam.DELETEALL;

  // … Baigiam ReturnCar: delete lines ir header …
END;
