OBJECT Table 50010 "Auto Reservation"
{
  OBJECT-PROPERTIES
  {
    Date=     01/05/23;
    Time=     14:00:00;
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
    FIELD(3; "Customer No."; Code[20])
    {
      DataClassification=CustomerContent;
      CaptionML=ENU='Customer No.';
      InstructionalTextML=ENU='';
      TableRelation=Customer."No.";
    }
    FIELD(4; "Reservation From"; DateTime)
    {
      DataClassification=CustomerContent;
      CaptionML=ENU='Reservation From';
      InstructionalTextML=ENU='';
    }
    FIELD(5; "Reservation To"; DateTime)
    {
      DataClassification=CustomerContent;
      CaptionML=ENU='Reservation To';
      InstructionalTextML=ENU='';
    }
  }
  KEYS
  {
    KEY(PK; "Automobile No.","Line No")
    {
      Clustered=Yes;
    }
  }
  CODE
  {
    LOCAL PROCEDURE CheckOverlap@1000000000()
    VAR
      TempRes@1000000001 : Record "Auto Reservation";
    BEGIN
      // Rasti kitus tos pačios auto rezervacijas, kurių laikai kerta mūsų intervalą
      TempRes.SETRANGE("Automobile No.", Rec."Automobile No.");
      TempRes.SETFILTER("Reservation From", '<%1', FORMAT(Rec."Reservation To"));
      TempRes.SETFILTER("Reservation To", '>%1', FORMAT(Rec."Reservation From"));
      // Jei randame bent vieną (išskyrus patį save), klaida
      IF TempRes.FINDSET THEN
        ERROR(Text001, Rec."Automobile No."); // Text001 – per Label
    END;

    // Prieš įrašant naują rezervaciją
    LOCAL [IntegrationEvent(false,false)] OnBeforeInsert@1000000002();
    TRIGGER OnInsert()
    BEGIN
      Rec.Validate("Reservation From");
      Rec.Validate("Reservation To");
    END;

    // Kiekvieną kartą keičiant From arba To, tikrinti persidengimą
    TRIGGER OnValidate@1000000003(FieldNo: Integer)
    BEGIN
      IF FieldNo IN [FIELDNO("Reservation From"), FIELDNO("Reservation To")] THEN
        CheckOverlap();
    END;

    // Autoincrement Line No.
    LOCAL PROCEDURE OnInsertTrigger@1000000004()
    BEGIN
      IF Rec."Line No." = 0 THEN
        Rec."Line No." := GetLastLineNo(Rec."Automobile No.") + 1;
    END;

    LOCAL PROCEDURE GetLastLineNo@1000000005(AutoNo: Code[20]): Integer
    VAR
      TempRes@1000000006 : Record "Auto Reservation";
      LastNo@1000000007 : Integer;
    BEGIN
      TempRes.SETRANGE("Automobile No.", AutoNo);
      IF TempRes.FINDLAST THEN
        LastNo := TempRes."Line No.";
      EXIT(LastNo);
    END;
  }
}
ENDOBJECT


OBJECT Page 50011 "Auto Reservation List"
{
  OBJECT-PROPERTIES
  {
    Date=     01/05/23;
    Time=     14:10:00;
  }
  PROPERTIES
  {
    PageType=List;
    SourceTable="Auto Reservation";
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
        CaptionML=ENU='Reservations';
        FIELD("Automobile No."; Rec."Automobile No.") { ApplicationArea=All; }
        FIELD("Line No."; Rec."Line No.") { ApplicationArea=All; }
        FIELD("Customer No."; Rec."Customer No.") { ApplicationArea=All; }
        FIELD("Reservation From"; Rec."Reservation From") { ApplicationArea=All; }
        FIELD("Reservation To"; Rec."Reservation To") { ApplicationArea=All; }
      }
    }
  }
}
ENDOBJECT


OBJECT Page 50012 "Valid Reservations"
{
  OBJECT-PROPERTIES
  {
    Date=     01/05/23;
    Time=     14:15:00;
  }
  PROPERTIES
  {
    PageType=List;
    SourceTable="Auto Reservation";
    ApplicationArea=All;
    UsageCategory=Lists;
    Editable=No;
  }
  CONTROLS
  {
    AREA(Content)
    {
      GROUP(Group)
      {
        CaptionML=ENU='Upcoming Reservations';
        FIELD("Automobile No."; Rec."Automobile No.") { ApplicationArea=All; }
        FIELD("Customer No."; Rec."Customer No.") { ApplicationArea=All; }
        FIELD("Reservation From"; Rec."Reservation From") { ApplicationArea=All; }
        FIELD("Reservation To"; Rec."Reservation To") { ApplicationArea=All; }
      }
    }
  }
  CODE
  {
    TRIGGER OnOpenPage()
    BEGIN
      // Rodyti tik nuo šiandien (WORKDATE) į priekį esančias rezervacijas
      CurrPage.SETFILTER("Reservation To", '>=%1', WORKDATE);
    END;
  }
}
ENDOBJECT
