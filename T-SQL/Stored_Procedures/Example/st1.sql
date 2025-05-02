USE [Library_Marco_Corona]
GO
/****** Object:  StoredProcedure [dbo].[ActiveReservationByBookIdUserId]    Script Date: 02/05/2025 15:16:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Marco Corona
-- Create date: 09/12/2024
-- Description:	Restituisce le prenotazioni attive di un libro o di un utente o di entrambi 
-- =============================================
ALTER PROCEDURE [dbo].[ActiveReservationByBookIdUserId]
	-- Add the parameters for the stored procedure here
	@userId INT = NULL,--Parametro opzionale
	@bookId INT = NULL 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    -- Insert statements for procedure here
	SELECT *
	FROM Reservations
	WHERE (BookId = @bookId OR @bookId IS NULL) -- FILTRA SOLO SE @BookId NON è NULL
	  AND (UserId = @userId OR @userId IS NULL) -- FILTRA SOLO SE @UserId NON è NULL
	  AND (EndDate >= GetDate()) -- Solo prenotazioni attive
END
