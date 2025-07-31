OBJECT Table 50015 "Auto Rent Header"
{
  OBJECT-PROPERTIES
  {
    Date=     01/07/23;
    Time=     09:00:00;
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
      TableRelation="Auto Rent Header"."No."; // Noseries group
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
    FIELD(9; Status; Option)
    {
      DataClassification=CustomerContent;
      CaptionML=ENU='Status';
      OptionMembers=Open,Issued;
      OptionCaptionML=ENU='Open,Issued';
    }
  }
  KEYS
  {
    KEY(PK; No)
    {
      Clustered=Yes;
    }
  }
  CODE
  {
    // 1) Autonumeracija ir pradinė būsena
    TRIGGER OnInsert()
    BEGIN
      "Status" := Status::Open;
    END;

    // 2) Pagrindinės operacijos
    LOCAL PROCEDURE Issue@1000000000();
    BEGIN
      IF "Status" = "Status"::Open THEN BEGIN
        VALIDATE("Status", "Status"::Issued);
        MODIFY(TRUE);
      END;
    END;

    LOCAL PROCEDURE ReturnCar@1000000001();
    BEGIN
      IF "Status" = "Status"::Issued THEN BEGIN
        // čia galėtumėte pridėti grąžinimo logiką (pvz., skaičiuoti faktinį laiką, baudas ir t.t.)
        MESSAGE('Car returned.'); 
      END;
    END;

    // 3) Nuotraukos importas/ištrynimas
    LOCAL PROCEDURE UploadPhoto@1000000002();
    BEGIN
      // Paprastas BLOB importas per Dialogą
      CALCFIELDS("Driver License Photo");
      IF IMPORTSTREAM('Select image','Image files|*.jpg;*.png', "Driver License Photo") THEN
        MODIFY(TRUE);
    END;

    LOCAL PROCEDURE DeletePhoto@1000000003();
    BEGIN
      CLEAR("Driver License Photo");
      MODIFY(TRUE);
    END;
    
    // 4) Blokuoti redagavimą, kai status Issued
    TRIGGER OnAfterGetRecord()
    BEGIN
      CurrPage.Editable := ("Status" = "Status"::Open);
    END;
  }
}
ENDOBJECT


OBJECT Page 50016 "Auto Rent Header List"
{
  OBJECT-PROPERTIES
  {
    Date=     01/07/23;
    Time=     09:10:00;
  }
  PROPERTIES
  {
    PageType=List;
    SourceTable="Auto Rent Header";
    ApplicationArea=All;
    UsageCategory=Lists;
    Editable=Yes;
  }
  CONTROLS
  {
    AREA(Content)
    {
      GROUP(General)
      {
        CaptionML=ENU='Rent Headers';
        FIELD(No; Rec.No) { ApplicationArea=All; }
        FIELD("Customer No."; Rec."Customer No.") { ApplicationArea=All; }
        FIELD("Rent Date"; Rec."Rent Date") { ApplicationArea=All; }
        FIELD("Automobile No."; Rec."Automobile No.") { ApplicationArea=All; }
        FIELD(Sum; Rec.Sum) { ApplicationArea=All; }
        FIELD(Status; Rec.Status) { ApplicationArea=All; }
      }
    }
    AREA(Actions)
    {
      GROUP(StatusGroup)
      {
        CAPTIONML=ENU='Status';
        ACTION(Issue)
        {
          CaptionML=ENU='Issue';
          ApplicationArea=All;
          Image=OpenInNewWindow;
          Promoted=Yes; PromotedCategory=Process;
          Enabled=Rec.Status=Rec.Status::Open;
          trigger OnAction()
          begin
            Rec.Issue();
            CurrPage.UPDATE(FALSE);
          end;
        }
        ACTION(ReturnCar)
        {
          CaptionML=ENU='Return Car';
          ApplicationArea=All;
          Image=OpenInNewWindow;
          Promoted=Yes; PromotedCategory=Process;
          Enabled=Rec.Status=Rec.Status::Issued;
          trigger OnAction()
          begin
            Rec.ReturnCar();
          end;
        }
      }
    }
  }
}
ENDOBJECT


OBJECT Page 50017 "Auto Rent Header Card"
{
  OBJECT-PROPERTIES
  {
    Date=     01/07/23;
    Time=     09:20:00;
  }
  PROPERTIES
  {
    PageType=Card;
    SourceTable="Auto Rent Header";
    ApplicationArea=All;
    UsageCategory=Administration;
    Editable=TRUE;
  }
  CONTROLS
  {
    GROUP(General)
    {
      CaptionML=ENU='General';
      FIELD(No; Rec.No) { ApplicationArea=All; }
      FIELD("Customer No."; Rec."Customer No.") { ApplicationArea=All; }
      FIELD("Rent Date"; Rec."Rent Date") { ApplicationArea=All; }
      FIELD("Automobile No."; Rec."Automobile No.") { ApplicationArea=All; }
      FIELD("Reservation From"; Rec."Reservation From") { ApplicationArea=All; }
      FIELD("Reservation To"; Rec."Reservation To") { ApplicationArea=All; }
      FIELD(Sum; Rec.Sum) { ApplicationArea=All; }
      FIELD(Status; Rec.Status) { ApplicationArea=All; }
    }
    GROUP(Photo)
    {
      CaptionML=ENU='Driver License';
      CONTROL(UploadPhoto; ACTION)
      {
        CaptionML=ENU='Upload Photo';
        ApplicationArea=All;
        trigger OnAction()
        begin
          Rec.UploadPhoto();
        end;
      }
      CONTROL(DeletePhoto; ACTION)
      {
        CaptionML=ENU='Delete Photo';
        ApplicationArea=All;
        trigger OnAction()
        begin
          Rec.DeletePhoto();
        end;
      }
    }
  }
}
ENDOBJECT
