OBJECT Page 50018 "Issued Auto Contracts"
{
  OBJECT-PROPERTIES
  {
    Date=     01/07/23;
    Time=     09:30:00;
  }
  PROPERTIES
  {
    PageType=List;
    SourceTable="Auto Rent Header";
    ApplicationArea=All;
    UsageCategory=Lists;
    Editable=No;        // tik rodymas
  }
  CONTROLS
  {
    AREA(Content)
    {
      GROUP(General)
      {
        CaptionML=ENU='Issued Auto Contracts';
        FIELD(No; Rec.No) { ApplicationArea=All; }
        FIELD("Customer No."; Rec."Customer No.") { ApplicationArea=All; }
        FIELD("Rent Date"; Rec."Rent Date") { ApplicationArea=All; }
        FIELD("Automobile No."; Rec."Automobile No.") { ApplicationArea=All; }
        FIELD(Sum; Rec.Sum) { ApplicationArea=All; }
      }
    }
  }
  CODE
  {
    TRIGGER OnOpenPage()
    BEGIN
      // Rodyti tik tuos dokumentus, kurių Status = Issued
      CurrPage.SETFILTER(Status, '=%1', Status::Issued);
    END;
  }
}
ENDOBJECT
