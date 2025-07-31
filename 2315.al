OBJECT Report 50026 "Auto Rental History Report"
{
  OBJECT-PROPERTIES
  {
    Date=     01/07/23;
    Time=     12:00:00;
  }
  PROPERTIES
  {
    ProcessingOnly=No;
    RDLCLayout=Yes;
    UsageCategory=Reports;
  }

  REQUESTPAGE
  {
    CONTROL(AutomobileNo; Code[20])
    {
      CaptionML=
        ENU='Automobile No.';
      SourceExpr=AutomobileNo;
    }
    CONTROL(FromDate; Date)
    {
      CaptionML=
        ENU='From Date';
      SourceExpr=FromDate;
    }
    CONTROL(ToDate; Date)
    {
      CaptionML=
        ENU='To Date';
      SourceExpr=ToDate;
    }
  }

  DATAITEM(Auto; Auto)
  {
    // Report kviečiamas iš Auto kortelės ar sąrašo, tai reikia nurodyti Auto No.
    DataItemTableView=WHERE("No."=FILTER(&AutomobileNo));
    ColumnCaptionML=ENU='Auto';
  }

  DATAITEM(FinHeader; "Finished Auto Rent Header")
  {
    DataItemTableView=WHERE(
      "Automobile No."=FIELD(Auto."No."),
      "Reservation From"=FILTER(&FromDate..&ToDate));
    ColumnCaptionML=ENU='Finished Rents';
  }

  // Kintamieji sumavimui
  CODE
  {
    VAR
      TotalAll@1000000000 : Decimal;

    BEGIN
      TotalAll := 0;
    END;

    // Kaskart perskaitant kiekvieną rentą, kaupame bendrą sumą
    LOCAL [EventSubscriber(Object=FinHeader, Integration=false)]
    PROCEDURE OnAfterGetFinHeader@1000000001();
    BEGIN
      TotalAll += FinHeader.Sum;
    END;

    // Funkcija RDLC dizainui bendrai sumai
    LOCAL PROCEDURE GetTotalAll@1000000002(): Decimal;
    BEGIN
      EXIT(TotalAll);
    END;
  }
}
ENDOBJECT
