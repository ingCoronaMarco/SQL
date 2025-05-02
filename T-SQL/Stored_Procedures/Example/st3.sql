USE [Library_Marco_Corona]
GO
/****** Object:  StoredProcedure [dbo].[CheckBookExists]    Script Date: 02/05/2025 15:20:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 ALTER PROCEDURE [dbo].[CheckBookExists]
    -- Parametri di input --
    @Title NVARCHAR(200),
    @AuthorName NVARCHAR(200),
    @AuthorSurname NVARCHAR(200),
    @Publisher NVARCHAR(200),
    -- Parametro di Output --
    @BookExists BIT OUTPUT
AS
BEGIN
    BEGIN TRY
        -- Evita set di risultati extra
        SET NOCOUNT ON;

        -- VALIDAZIONE PARAMETRI --
        IF (@Title IS NULL OR LEN(LTRIM(RTRIM(@Title))) = 0 OR 
            @AuthorName IS NULL OR LEN(LTRIM(RTRIM(@AuthorName))) = 0 OR 
            @AuthorSurname IS NULL OR LEN(LTRIM(RTRIM(@AuthorSurname))) = 0 OR 
            @Publisher IS NULL OR LEN(LTRIM(RTRIM(@Publisher))) = 0)
        BEGIN
            RAISERROR('Errore: Inserire TUTTI i Parametri.', 16, 1); -- Lancia un errore personalizzato
            RETURN; -- Esci immediatamente
        END;

        -- Controlla se il libro esiste
        IF EXISTS (
            SELECT 1
            FROM Books
            WHERE LTRIM(RTRIM(Title)) COLLATE SQL_Latin1_General_CP1_CI_AS = LTRIM(RTRIM(@Title))
            AND LTRIM(RTRIM(AuthorName)) COLLATE SQL_Latin1_General_CP1_CI_AS = LTRIM(RTRIM(@AuthorName))
            AND LTRIM(RTRIM(AuthorSurname)) COLLATE SQL_Latin1_General_CP1_CI_AS = LTRIM(RTRIM(@AuthorSurname))
            AND LTRIM(RTRIM(Publisher)) COLLATE SQL_Latin1_General_CP1_CI_AS = LTRIM(RTRIM(@Publisher))
        )
        BEGIN
            SET @BookExists = 1; -- Libro trovato (true)
        END
        ELSE
        BEGIN
            SET @BookExists = 0; -- Libro non trovato (false)
        END;
    END TRY
    BEGIN CATCH
        -- Gestione degli errori
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR('Errore durante l''esecuzione: %s', 16, 1, @ErrorMessage);
        RETURN;
    END CATCH
END;
