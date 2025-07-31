OBJECT Table 50015 "Auto Rent Header"
...
  CODE
  {
    LOCAL PROCEDURE ReturnCar@1000000001();
    VAR
      FinHeader   : Record "Finished Auto Rent Header";
      RentLine    : Record "Auto Rent Line";
      FinLine     : Record "Finished Auto Rent Line";
      AutoDam     : Record "Auto Damage";
      FinDam      : Record "Finished Auto Damage";
    BEGIN
      // ▶ 1. Sukuriame Finished Header
      FinHeader := Rec;             // nukopijuojam laukus
      FinHeader.INSERT;

      // ▶ 2a. Perkeliam Auto Rent Lines
      RentLine.SETRANGE("Document No.", Rec.No);
      IF RentLine.FINDSET THEN
        REPEAT
          FinLine.INIT;
          FinLine."Document No." := FinHeader.No;
          FinLine."Line No."     := RentLine."Line No.";
          FinLine.Description    := RentLine.Description;
          FinLine.Quantity       := RentLine.Quantity;
          FinLine."Unit Price"   := RentLine."Unit Price";
          FinLine."Line Amount"  := RentLine."Line Amount";
          FinLine.INSERT;
        UNTIL RentLine.NEXT = 0;

      // ▶ 2b. Perkeliam Auto Damages
      AutoDam.SETRANGE("Automobile No.", Rec."Automobile No.");
      IF AutoDam.FINDSET THEN
        REPEAT
          FinDam.INIT;
          FinDam := AutoDam;            // nukopijuojam visus laukus
          FinDam.INSERT;
          AutoDam.DELETE;               // pašalinam iš originalo
        UNTIL AutoDam.NEXT = 0;

      // ▶ 3. Ištrinam rent lines ir header
      RentLine.DELETEALL;  
      Rec.DELETE;                         

      MESSAGE('Car %1 successfully returned.', FinHeader.No);
    END;
  }
ENDOBJECT
