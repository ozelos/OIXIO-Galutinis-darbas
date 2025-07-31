////////////////////////////////////////////////////////////////////
// Table: Auto Rent Line
OBJECT Table 50009 "Auto Rent Line"
{
  OBJECT-PROPERTIES
  {
    Date=     01/07/23;
    Time=     12:30:00;
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
    FIELD(3; Type; Option)
    {
      DataClassification=CustomerContent;
      CaptionML=ENU='Type';
      OptionMembers=Item,Resource;
      OptionCaptionML=ENU='Item,Resource';
    }
    FIELD(4; No.; Code[20])
    {
      DataClassification=CustomerContent;
      CaptionML=ENU='No.';
      // Relation nustatoma dinaminiu būdu OnValidate
    }
    FIELD(5; Description; Text[100])
    {
      DataClassification=CustomerContent;
      CaptionML=ENU='Description';
    }
    FIELD(6; Quantity; Decimal)
    {
      DataClassification=CustomerContent;
      CaptionML=ENU='Quantity';
    }
    FIELD(7; "Unit Price"; Decimal)
    {
      DataClassification=CustomerContent;
      CaptionML=ENU='Unit Price';
    }
    FIELD(8; "Line Amount"; Decimal)
    {
      DataClassification=CustomerContent;
      CaptionML=ENU='Line Amount';
      CalcFormula=FIELD(Quantity * "Unit Price");
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
    VAR
      HeaderRec@1000000000 : Record "Auto Rent Header";
      ItemRec@1000000001   : Record Item;
      ResRec@1000000002    : Record Resource;

    // Automatinis Line No.
    LOCAL PROCEDURE OnInsertTrigger@1000000003()
    BEGIN
      IF Rec."Line No." = 0 THEN
        Rec."Line No." := GetLastLineNo(Rec."Document No.") + 1;
    END;

    LOCAL PROCEDURE GetLastLineNo@1000000004(DocNo: Code[20]): Integer
    VAR
      Temp@1000000005 : Record "Auto Rent Line";
      Last@1000000006 : Integer;
    BEGIN
      Temp.SETRANGE("Document No.", DocNo);
      IF Temp.FINDLAST THEN
        Last := Temp."Line No.";
      EXIT(Last);
    END;

    // Sukuriame automatinę 1-oji eilutę
    TRIGGER OnAfterInsert()
    BEGIN
      // Jei tai pirmoji eilutė dokumente
      IF Rec."Line No." = 1 THEN BEGIN
        // Perskaitome antraštę, kad paimtume Rental Service
        IF HeaderRec.GET(Rec."Document No.") THEN BEGIN
          Rec.Type := Rec.Type::Resource;
          Rec.No.  := FORMAT(HeaderRec."Rental Service");
          // gauti aprašą ir kainą iš Resource
          IF ResRec.GET(HeaderRec."Rental Service") THEN BEGIN
            Rec.Description := ResRec.Description;
            Rec.Quantity    := 1;
            Rec."Unit Price":= ResRec."Unit Cost"; // ar kitas laukas
          END;
          MODIFY(TRUE);
        END;
      END;
    END;

    // Uždraudžiame ištrinti pirmą eilutę
    TRIGGER OnDelete()
    BEGIN
      IF Rec."Line No." = 1 THEN
        ERROR(Text001); // 'Cannot delete rental service line.'
    END;

    // Dinaminis ryšys ir automatinis užpildymas Validates
    TRIGGER OnValidate@1000000007(FieldNo: Integer)
    BEGIN
      IF FieldNo = FIELDNO(Type) THEN BEGIN
        // pakeitus tipą, išvalom Nr. ir Description/Price
        Rec.No. := '';
        Rec.Description := '';
        Rec."Unit Price" := 0;
        Rec.Quantity := 0;
      END;
      IF FieldNo = FIELDNO(No.) THEN BEGIN
        IF Rec.Type = Rec.Type::Item THEN BEGIN
          IF ItemRec.GET(Rec.No.) THEN BEGIN
            Rec.Description := ItemRec.Description;
            Rec."Unit Price" := ItemRec."Unit Cost"; // arba kaina
            Rec.Quantity := 1;
          END;
        END ELSE BEGIN
          IF ResRec.GET(Rec.No.) THEN BEGIN
            Rec.Description := ResRec.Description;
            Rec."Unit Price" := ResRec."Unit Cost";
            Rec.Quantity := 1;
          END;
        END;
        MODIFY(TRUE);
      END;
    END;
  }
}
ENDOBJECT


////////////////////////////////////////////////////////////////////
// Page: Auto Rent Line Part
OBJECT Page 50010 "Auto Rent Line Part"
{
  OBJECT-PROPERTIES
  {
    Date=     01/07/23;
    Time=     12:40:00;
  }
  PROPERTIES
  {
    PageType=ListPart;
    SourceTable="Auto Rent Line";
    ApplicationArea=All;
    UsageCategory=Lists;
    Editable=TRUE;
    SubPageLink=
      "Document No."=FIELD(No);
  }
  CONTROLS
  {
    AREA(Content)
    {
      GROUP(General)
      {
        CaptionML=ENU='Lines';
        FIELD("Line No."; Rec."Line No.")       { ApplicationArea=All; }
        FIELD(Type; Rec.Type)                   { ApplicationArea=All; }
        FIELD(No.; Rec.No.)                     { ApplicationArea=All; }
        FIELD(Description; Rec.Description)     { ApplicationArea=All; }
        FIELD(Quantity; Rec.Quantity)           { ApplicationArea=All; }
        FIELD("Unit Price"; Rec."Unit Price")   { ApplicationArea=All; }
        FIELD("Line Amount"; Rec."Line Amount") { ApplicationArea=All; }
      }
    }
  }
}
ENDOBJECT
