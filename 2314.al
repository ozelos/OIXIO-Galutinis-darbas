OBJECT Report 50025 "Rental Issuance Report"
{
  OBJECT-PROPERTIES
  {
    Date=     01/07/23;
    Time=     11:00:00;
  }
  PROPERTIES
  {
    ProcessingOnly=No;
    RDLCLayout=Yes;
    UsageCategory=Reports;
  }
  DATAITEM("AutoRentHeader"; "Auto Rent Header")
  {
    DataItemTableView=WHERE(Status=CONST(Issued));
    ColumnCaptionML=ENU='Document No.';
  }
  DATAITEM("AutoRentLine"; "Auto Rent Line")
  {
    DataItemLink=Document No.=FIELD("AutoRentHeader"."No.");
    ColumnCaptionML=ENU='Lines';
  }
  // -- kintamieji sumavimui
  CODE
  {
    VAR
      RentalSum@1000000000    : Decimal;
      ServicesSum@1000000001  : Decimal;
      GrandTotal@1000000002   : Decimal;
    BEGIN
      //--) rinkti duomenis
    END;

    // surenka eilučių sumas
    LOCAL [EventSubscriber(Object="AutoRentLine", Integration=false)] PROCEDURE AutoRentLineOnAfterGetRecord@1000000003();
    BEGIN
      // pirmoji eilutė – nuomos kaina
      IF "AutoRentLine"."Line No." = 1 THEN BEGIN
        RentalSum := "AutoRentLine"."Line Amount";
        GrandTotal := RentalSum;
      END ELSE BEGIN
        ServicesSum += "AutoRentLine"."Line Amount";
        GrandTotal += "AutoRentLine"."Line Amount";
      END;
    END;

    // pateikia laukus RDLC dizainui
    LOCAL PROCEDURE GetRentalSum@1000000004(): Decimal;
    BEGIN
      EXIT(RentalSum);
    END;
    LOCAL PROCEDURE GetServicesSum@1000000005(): Decimal;
    BEGIN
      EXIT(ServicesSum);
    END;
    LOCAL PROCEDURE GetGrandTotal@1000000006(): Decimal;
    BEGIN
      EXIT(GrandTotal);
    END;
  }
}
ENDOBJECT
