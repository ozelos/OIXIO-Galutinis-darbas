OBJECT Table 50019 "Finished Auto Rent Header"
{
  OBJECT-PROPERTIES
  {
    Date=     01/07/23;
    Time=     10:00:00;
  }
  PROPERTIES
  {
    DataPerCompany=No;
  }
  FIELDS
  {
    FIELD(1; "No."; Code[20])
    {
      DataClassification=SystemMetadata;
      CaptionML=ENU='No.';
      NoSeries=Yes;
      NoSeriesGroup='Auto Rent Header';
    }
    FIELD(2; "Customer No."; Code[20])
    {
      DataClassification=CustomerContent;
      CaptionML=ENU='Customer No.';
      TableRelation=Customer."No.";
    }
    FIELD(3; "Driver License Photo"; Blob)
    {
      DataClassification=CustomerContent;
      CaptionML=ENU='Driver License Photo';
    }
    FIELD(4; "Rent Date"; Date)
    {
      DataClassification=CustomerContent;
      CaptionML=ENU='Date';
    }
    FIELD(5; "Automobile No."; Code[20])
    {
      DataClassification=CustomerContent;
      CaptionML=ENU='Automobile No.';
      TableRelation=Auto."No.";
    }
    FIELD(6; "Reservation From"; DateTime)
    {
      DataClassification=CustomerContent;
      CaptionML=ENU='Reserved From';
    }
    FIELD(7; "Reservation To"; DateTime)
    {
      DataClassification=CustomerContent;
      CaptionML=ENU='Reserved To';
    }
    FIELD(8; Sum; Decimal)
    {
      DataClassification=CustomerContent;
      CaptionML=ENU='Total Amount';
      CalcFormula=SUM("Auto Rent Line"."Line Amount" WHERE("Document No."=FIELD(No)));
    }
  }
  KEYS
  {
    KEY(PK; No)
    {
      Clustered=Yes;
    }
  }
}
ENDOBJECT


OBJECT Page 50020 "Finished Auto Rent List"
{
  OBJECT-PROPERTIES
  {
    Date=     01/07/23;
    Time=     10:05:00;
  }
  PROPERTIES
  {
    PageType=List;
    SourceTable="Finished Auto Rent Header";
    ApplicationArea=All;
    UsageCategory=Lists;
    Editable=No;
  }
  CONTROLS
  {
    AREA(Content)
    {
      GROUP(General)
      {
        CaptionML=ENU='Finished Auto Rents';
        FIELD(No; Rec.No) { ApplicationArea=All; }
        FIELD("Customer No."; Rec."Customer No.") { ApplicationArea=All; }
        FIELD("Rent Date"; Rec."Rent Date") { ApplicationArea=All; }
        FIELD("Automobile No."; Rec."Automobile No.") { ApplicationArea=All; }
        FIELD(Sum; Rec.Sum) { ApplicationArea=All; }
      }
    }
  }
}
ENDOBJECT


OBJECT Page 50021 "Finished Auto Rent Card"
{
  OBJECT-PROPERTIES
  {
    Date=     01/07/23;
    Time=     10:10:00;
  }
  PROPERTIES
  {
    PageType=Card;
    SourceTable="Finished Auto Rent Header";
    ApplicationArea=All;
    UsageCategory=Administration;
    Editable=No;
  }
  CONTROLS
  {
    GROUP(General)
    {
      CaptionML=ENU='Finished Auto Rent';
      FIELD(No; Rec.No) { ApplicationArea=All; }
      FIELD("Customer No."; Rec."Customer No.") { ApplicationArea=All; }
      FIELD("Driver License Photo"; Rec."Driver License Photo") { ApplicationArea=All; }
      FIELD("Rent Date"; Rec."Rent Date") { ApplicationArea=All; }
      FIELD("Automobile No."; Rec."Automobile No.") { ApplicationArea=All; }
      FIELD("Reservation From"; Rec."Reservation From") { ApplicationArea=All; }
      FIELD("Reservation To"; Rec."Reservation To") { ApplicationArea=All; }
      FIELD(Sum; Rec.Sum) { ApplicationArea=All; }
    }
  }
}
ENDOBJECT
