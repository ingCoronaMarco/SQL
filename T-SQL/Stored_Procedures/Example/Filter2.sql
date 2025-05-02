USE [Library_Marco_Corona]
GO
/****** Object:  StoredProcedure [dbo].[CalculateQuantityRemainToLibrary]    Script Date: 02/05/2025 15:18:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Marco Corona
-- Create date: 11/12/2024
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[CalculateQuantityRemainToLibrary]
    @bookId INT,
    @qtyRemain INT OUTPUT,
    @isPrenotable BIT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    -- Dichiarazione delle variabili locali
    DECLARE @QuantityTotalLibrary INT = 0;
    DECLARE @QuantityActiveReservation INT = 0;
    DECLARE @QuantityEffective INT = 0;

    -- Validazione dell'input
    IF @bookId IS NULL
    BEGIN
        RAISERROR('Errore: ID del libro non specificato.', 16, 1);
        RETURN;
    END

    -- Recupera la quantità totale della biblioteca per il libro specificato
    SELECT @QuantityTotalLibrary = Quantity
    FROM Books
    WHERE BookId = @bookId;

    -- Se il libro non esiste, interrompi l'esecuzione
    IF @QuantityTotalLibrary IS NULL
    BEGIN
        RAISERROR('Errore: Il libro specificato non esiste.', 16, 1);
        RETURN;
    END

    -- Recupera il numero di prenotazioni attive per quel libro
    SELECT @QuantityActiveReservation = COUNT(*)
    FROM Reservations
    WHERE BookId = @bookId
      AND EndDate > GETDATE();

    -- Calcola la quantità effettiva
    SET @QuantityEffective = @QuantityTotalLibrary - @QuantityActiveReservation;

    -- Imposta i valori di output
    SET @qtyRemain = ISNULL(@QuantityEffective, 0);
    SET @isPrenotable = CASE WHEN @qtyRemain > 0 THEN 1 ELSE 0 END;
END
