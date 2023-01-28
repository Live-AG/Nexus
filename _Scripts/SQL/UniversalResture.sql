-------------------------------------------
<<<<<<< .merge_file_a38816
-- ÍÀÑÒÐÀÈÂÀÅÌÛÅ ÏÅÐÅÌÅÍÍÛÅ
-- Áàçà äàííûõ èñòî÷íèê						
DECLARE @DBName_From as nvarchar(40) = 'ShipLoadingDesign' -- ÈÇ
-- Áàçà äàííûõ íàçíà÷åíèÿ
DECLARE @DBName_To as nvarchar(40) = 'TestDB_3' -- Â
-- Êàòàëîã äëÿ ðåçåðâíîé êîïèè
DECLARE @Path as nvarchar(400) = 'H:\Backup'
-- Èìÿ ïî÷òîâîãî ïðîôèëÿ, äëÿ îòïðàâêè ýëåêòîííîé ïî÷òû									
DECLARE @profile_name as nvarchar(100) = ''
-- Ïîëó÷àòåëè ñîîáùåíèé ýëåêòðîííîé ïî÷òû, ðàçäåëåííûå çíàêîì ";"				
DECLARE @recipients as nvarchar(500) = ''

-------------------------------------------
-- ÑËÓÆÅÁÍÛÅ ÏÅÐÅÌÅÍÍÛÅ	
=======
-- ÐÐÐ¡Ð¢Ð ÐÐ˜Ð’ÐÐ•ÐœÐ«Ð• ÐŸÐ•Ð Ð•ÐœÐ•ÐÐÐ«Ð•
-- Ð‘Ð°Ð·Ð° Ð´Ð°Ð½Ð½Ñ‹Ñ… Ð¸ÑÑ‚Ð¾Ñ‡Ð½Ð¸Ðº						
DECLARE @DBName_From as nvarchar(40) = 'ERP' -- Ð˜Ð—
-- Ð‘Ð°Ð·Ð° Ð´Ð°Ð½Ð½Ñ‹Ñ… Ð½Ð°Ð·Ð½Ð°Ñ‡ÐµÐ½Ð¸Ñ
DECLARE @DBName_To as nvarchar(40) = 'ERP_TEST2' -- Ð’
-- ÐšÐ°Ñ‚Ð°Ð»Ð¾Ð³ Ð´Ð»Ñ Ñ€ÐµÐ·ÐµÑ€Ð²Ð½Ð¾Ð¹ ÐºÐ¾Ð¿Ð¸Ð¸
DECLARE @Path as nvarchar(400) = 'H:\Backup'
-- Ð˜Ð¼Ñ Ð¿Ð¾Ñ‡Ñ‚Ð¾Ð²Ð¾Ð³Ð¾ Ð¿Ñ€Ð¾Ñ„Ð¸Ð»Ñ, Ð´Ð»Ñ Ð¾Ñ‚Ð¿Ñ€Ð°Ð²ÐºÐ¸ ÑÐ»ÐµÐºÑ‚Ð¾Ð½Ð½Ð¾Ð¹ Ð¿Ð¾Ñ‡Ñ‚Ñ‹									
DECLARE @profile_name as nvarchar(100) = ''
-- ÐŸÐ¾Ð»ÑƒÑ‡Ð°Ñ‚ÐµÐ»Ð¸ ÑÐ¾Ð¾Ð±Ñ‰ÐµÐ½Ð¸Ð¹ ÑÐ»ÐµÐºÑ‚Ñ€Ð¾Ð½Ð½Ð¾Ð¹ Ð¿Ð¾Ñ‡Ñ‚Ñ‹, Ñ€Ð°Ð·Ð´ÐµÐ»ÐµÐ½Ð½Ñ‹Ðµ Ð·Ð½Ð°ÐºÐ¾Ð¼ ";"				
DECLARE @recipients as nvarchar(500) = ''

-------------------------------------------
-- Ð¡Ð›Ð£Ð–Ð•Ð‘ÐÐ«Ð• ÐŸÐ•Ð Ð•ÐœÐ•ÐÐÐ«Ð•	
>>>>>>> .merge_file_a20084
DECLARE @SQLString NVARCHAR(4000)
DECLARE @backupfile NVARCHAR(500)
DECLARE @physicalName NVARCHAR(500), @logicalName NVARCHAR(500)
DECLARE @out as int = 0
DECLARE @subject as NVARCHAR(100) = ''
DECLARE @finalmassage as NVARCHAR(1000) = ''

-------------------------------------------
<<<<<<< .merge_file_a38816
-- ÒÅËÎ ÑÊÐÈÏÒÀ
use master

-- 1. Ñîçäàåì ðåçåðâíóþ êîïèþ ñ ôëàãîì "Òîëüêî ðåçåðâíîå êîïèðîâàíèå"
-- Ôîðìèðóåì ñòðîêó äëÿ èñïîëíåíèÿ
SET @backupfile = @Path + '\\' + @DBName_From + '_' + Replace(CONVERT(nvarchar, GETDATE(), 126),':','-') + '.bak'
=======
-- Ð¢Ð•Ð›Ðž Ð¡ÐšÐ Ð˜ÐŸÐ¢Ð
use master

-- 1. Ð¡Ð¾Ð·Ð´Ð°ÐµÐ¼ Ñ€ÐµÐ·ÐµÑ€Ð²Ð½ÑƒÑŽ ÐºÐ¾Ð¿Ð¸ÑŽ Ñ Ñ„Ð»Ð°Ð³Ð¾Ð¼ "Ð¢Ð¾Ð»ÑŒÐºÐ¾ Ñ€ÐµÐ·ÐµÑ€Ð²Ð½Ð¾Ðµ ÐºÐ¾Ð¿Ð¸Ñ€Ð¾Ð²Ð°Ð½Ð¸Ðµ" ----------------------------------------------------------------------------------------------------------
-- Ð¤Ð¾Ñ€Ð¼Ð¸Ñ€ÑƒÐµÐ¼ ÑÑ‚Ñ€Ð¾ÐºÑƒ Ð´Ð»Ñ Ð¸ÑÐ¿Ð¾Ð»Ð½ÐµÐ½Ð¸Ñ
SET @backupfile = @Path + '\' + @DBName_From + '_' + Replace(CONVERT(nvarchar, GETDATE(), 126),':','-') + '.bak'
>>>>>>> .merge_file_a20084
SET @SQLString = 
	N'BACKUP DATABASE [' + @DBName_From + ']
	TO DISK = N''' + @backupfile + '''  
	WITH NOFORMAT, NOINIT,
	SKIP, NOREWIND, NOUNLOAD, STATS = 10, COPY_ONLY'

<<<<<<< .merge_file_a38816
-- Âûâîäèì è âûïîëíÿåì ïîëó÷åííóþ èíñòðóêöèþ
=======
-- Ð’Ñ‹Ð²Ð¾Ð´Ð¸Ð¼ Ð¸ Ð²Ñ‹Ð¿Ð¾Ð»Ð½ÑÐµÐ¼ Ð¿Ð¾Ð»ÑƒÑ‡ÐµÐ½Ð½ÑƒÑŽ Ð¸Ð½ÑÑ‚Ñ€ÑƒÐºÑ†Ð¸ÑŽ
>>>>>>> .merge_file_a20084
PRINT @SQLString
BEGIN TRY 
	EXEC sp_executesql @SQLString
END TRY
BEGIN CATCH  
<<<<<<< .merge_file_a38816
	-- Îøáèêà âûïîëíåíèÿ îïåðàöèè
	SET @subject = 'ÎØÈÁÊÀ Ñîçäàíèÿ ðåçåðâíîé êîïèè áàçû ' + @DBName_From
	SET @finalmassage = 'Îøèáêà ñîçäàíèÿ ðåçåðâíîé êîïèè áàçû ' + @DBName_From + ' â êàòàëîã ' + @Path + CHAR(13) + CHAR(13)
		+ 'Êîä îøèáêè: ' + CAST(ERROR_NUMBER() as nvarchar(10)) + CHAR(13) + CHAR(13)
		+ 'Òåêñò îøèáêè: ' + ERROR_MESSAGE()  + CHAR(13) + CHAR(13)
		+ 'Òåêñò T-SQL:' + CHAR(13) + @SQLString  
END CATCH;

-- 2. Çàãðóæàåì ïîëó÷åííûé ôàéë ðåçåðâíîé êîïèè
IF @subject = ''
BEGIN
	
	-- Ôîðìèðóåì ñòðîêó äëÿ èñïîëíåíèÿ	
=======
	-- ÐžÑˆÐ±Ð¸ÐºÐ° Ð²Ñ‹Ð¿Ð¾Ð»Ð½ÐµÐ½Ð¸Ñ Ð¾Ð¿ÐµÑ€Ð°Ñ†Ð¸Ð¸
	SET @subject = 'ÐžÐ¨Ð˜Ð‘ÐšÐ Ð¡Ð¾Ð·Ð´Ð°Ð½Ð¸Ñ Ñ€ÐµÐ·ÐµÑ€Ð²Ð½Ð¾Ð¹ ÐºÐ¾Ð¿Ð¸Ð¸ Ð±Ð°Ð·Ñ‹ ' + @DBName_From
	SET @finalmassage = 'ÐžÑˆÐ¸Ð±ÐºÐ° ÑÐ¾Ð·Ð´Ð°Ð½Ð¸Ñ Ñ€ÐµÐ·ÐµÑ€Ð²Ð½Ð¾Ð¹ ÐºÐ¾Ð¿Ð¸Ð¸ Ð±Ð°Ð·Ñ‹ ' + @DBName_From + ' Ð² ÐºÐ°Ñ‚Ð°Ð»Ð¾Ð³ ' + @Path + CHAR(13) + CHAR(13)
		+ 'ÐšÐ¾Ð´ Ð¾ÑˆÐ¸Ð±ÐºÐ¸: ' + CAST(ERROR_NUMBER() as nvarchar(10)) + CHAR(13) + CHAR(13)
		+ 'Ð¢ÐµÐºÑÑ‚ Ð¾ÑˆÐ¸Ð±ÐºÐ¸: ' + ERROR_MESSAGE()  + CHAR(13) + CHAR(13)
		+ 'Ð¢ÐµÐºÑÑ‚ T-SQL:' + CHAR(13) + @SQLString  
END CATCH;

-- 2.1. ÐŸÐµÑ€ÐµÐ²Ð¾Ð´ Ð² Ð¾Ð´Ð½Ð¾Ð¿Ð¾Ð»ÑŒÐ·Ð¾Ð²Ð°Ñ‚ÐµÐ»ÑŒÑÐºÐ¸Ð¹ Ñ€ÐµÐ¶Ð¸Ð¼ ----------------------------------------------------------------------------------------------------------
IF @subject = ''
BEGIN	
	
	-- Ð¤Ð¾Ñ€Ð¼Ð¸Ñ€ÑƒÐµÐ¼ ÑÑ‚Ñ€Ð¾ÐºÑƒ Ð´Ð»Ñ Ð¸ÑÐ¿Ð¾Ð»Ð½ÐµÐ½Ð¸Ñ
	SET @SQLString = 'ALTER DATABASE [' + @DBName_To + '] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;'
	
	-- Ð’Ñ‹Ð²Ð¾Ð´Ð¸Ð¼ Ð¸ Ð²Ñ‹Ð¿Ð¾Ð»Ð½ÑÐµÐ¼ Ð¿Ð¾Ð»ÑƒÑ‡ÐµÐ½Ð½ÑƒÑŽ Ð¸Ð½ÑÑ‚Ñ€ÑƒÐºÑ†Ð¸ÑŽ
	PRINT @SQLString
	BEGIN TRY 
		EXEC sp_executesql @SQLString
	END TRY
	BEGIN CATCH  
		-- ÐžÑˆÐ±Ð¸ÐºÐ° Ð²Ñ‹Ð¿Ð¾Ð»Ð½ÐµÐ½Ð¸Ñ Ð¾Ð¿ÐµÑ€Ð°Ñ†Ð¸Ð¸
		SET @subject = 'ÐžÐ¨Ð˜Ð‘ÐšÐ Ð’ÐžÐ¡Ð¡Ð¢ÐÐÐžÐ’Ð›Ð•ÐÐ˜Ð¯ Ð±Ð°Ð·Ñ‹ Ð´Ð°Ð½Ð½Ñ‹Ñ… - 3 ' + @DBName_To
		SET @finalmassage = 'ÐžÑˆÐ¸Ð±ÐºÐ° Ð¿ÐµÑ€ÐµÐ²Ð¾Ð´Ð° Ð² Ð¿Ñ€Ð¾ÑÑ‚ÑƒÑŽ Ð¼Ð¾Ð´ÐµÐ»ÑŒ Ð²Ð¾ÑÑÑ‚Ð°Ð½Ð¾Ð²Ð»ÐµÐ½Ð¸Ñ Ð±Ð°Ð·Ñ‹ Ð´Ð°Ð½Ð½Ñ‹Ñ… ' + @DBName_To + CHAR(13) + CHAR(13)
			+ 'ÐšÐ¾Ð´ Ð¾ÑˆÐ¸Ð±ÐºÐ¸: ' + CAST(ERROR_NUMBER() as nvarchar(10)) + CHAR(13) + CHAR(13)
			+ 'Ð¢ÐµÐºÑÑ‚ Ð¾ÑˆÐ¸Ð±ÐºÐ¸: ' + ERROR_MESSAGE()  + CHAR(13) + CHAR(13)
			+ 'Ð¢ÐµÐºÑÑ‚ T-SQL:' + CHAR(13) + @SQLString  
	END CATCH;
END

-- 2.2. Ð—Ð°Ð³Ñ€ÑƒÐ¶Ð°ÐµÐ¼ Ð¿Ð¾Ð»ÑƒÑ‡ÐµÐ½Ð½Ñ‹Ð¹ Ñ„Ð°Ð¹Ð» Ñ€ÐµÐ·ÐµÑ€Ð²Ð½Ð¾Ð¹ ÐºÐ¾Ð¿Ð¸Ð¸ ----------------------------------------------------------------------------------------------------------
IF @subject = ''
BEGIN
	
	-- Ð¤Ð¾Ñ€Ð¼Ð¸Ñ€ÑƒÐµÐ¼ ÑÑ‚Ñ€Ð¾ÐºÑƒ Ð´Ð»Ñ Ð¸ÑÐ¿Ð¾Ð»Ð½ÐµÐ½Ð¸Ñ	
>>>>>>> .merge_file_a20084
	SET @SQLString = 
	N'RESTORE DATABASE [' + @DBName_To + ']
	FROM DISK = N''' + @backupfile + '''   
	WITH  
	FILE = 1,'

<<<<<<< .merge_file_a38816
	-- Ïåðåèìåíóåì ôàéëû áàçû äàííûõ íà èñõîäíûå
	-- Íîâûé öèêë ïî âñåì ôàéëàì áàçû äàííûõ
=======
	-- ÐŸÐµÑ€ÐµÐ¸Ð¼ÐµÐ½ÑƒÐµÐ¼ Ñ„Ð°Ð¹Ð»Ñ‹ Ð±Ð°Ð·Ñ‹ Ð´Ð°Ð½Ð½Ñ‹Ñ… Ð½Ð° Ð¸ÑÑ…Ð¾Ð´Ð½Ñ‹Ðµ
	-- ÐÐ¾Ð²Ñ‹Ð¹ Ñ†Ð¸ÐºÐ» Ð¿Ð¾ Ð²ÑÐµÐ¼ Ñ„Ð°Ð¹Ð»Ð°Ð¼ Ð±Ð°Ð·Ñ‹ Ð´Ð°Ð½Ð½Ñ‹Ñ…
>>>>>>> .merge_file_a20084
	DECLARE fnc CURSOR LOCAL FAST_FORWARD FOR 
	(
		SELECT
			t_From.name,
			t_To.physical_name
		FROM sys.master_files as t_To 
			join sys.master_files as t_From 
			on t_To.file_id = t_From.file_id
		WHERE t_To.database_id = DB_ID(@DBName_To) 
			and t_From.database_id = DB_ID(@DBName_From)
	)
	OPEN fnc;
	FETCH fnc INTO @logicalName, @physicalName;
	WHILE @@FETCH_STATUS=0
		BEGIN
			SET @SQLString = @SQLString + '
			MOVE N''' + @logicalName + ''' TO N''' + @physicalName + ''','
			FETCH fnc INTO @logicalName, @physicalName;
		END;
	CLOSE fnc;
	DEALLOCATE fnc;

	SET @SQLString = @SQLString + '
<<<<<<< .merge_file_a38816
	RECOVERY,
	REPLACE,
	STATS = 5'

	-- Âûâîäèì è âûïîëíÿåì ïîëó÷åííóþ èíñòðóêöèþ
=======
	NOUNLOAD,
	REPLACE,
	STATS = 5'

	-- Ð’Ñ‹Ð²Ð¾Ð´Ð¸Ð¼ Ð¸ Ð²Ñ‹Ð¿Ð¾Ð»Ð½ÑÐµÐ¼ Ð¿Ð¾Ð»ÑƒÑ‡ÐµÐ½Ð½ÑƒÑŽ Ð¸Ð½ÑÑ‚Ñ€ÑƒÐºÑ†Ð¸ÑŽ
	PRINT @SQLString
	BEGIN TRY 
		EXEC sp_executesql @SQLString
	END TRY
	BEGIN CATCH  
		-- ÐžÑˆÐ±Ð¸ÐºÐ° Ð²Ñ‹Ð¿Ð¾Ð»Ð½ÐµÐ½Ð¸Ñ Ð¾Ð¿ÐµÑ€Ð°Ñ†Ð¸Ð¸
		SET @subject = 'ÐžÐ¨Ð˜Ð‘ÐšÐ Ð’ÐžÐ¡Ð¡Ð¢ÐÐÐžÐ’Ð›Ð•ÐÐ˜Ð¯ Ð±Ð°Ð·Ñ‹ Ð´Ð°Ð½Ð½Ñ‹Ñ… - 2 ' + @DBName_To
			SET @finalmassage = 'ÐžÑˆÐ¸Ð±ÐºÐ° Ð²Ð¾ÑÑÑ‚Ð°Ð½Ð¾Ð²Ð»ÐµÐ½Ð¸Ñ Ð¿Ð¾Ð»Ð½Ð¾Ð¹ Ñ€ÐµÐ·ÐµÑ€Ð²Ð½Ð¾Ð¹ ÐºÐ¾Ð¿Ð¸Ð¸ Ð´Ð»Ñ Ð±Ð°Ð·Ñ‹ Ð´Ð°Ð½Ð½Ñ‹Ñ… ' + @DBName_To + CHAR(13) + CHAR(13)
			+ 'ÐšÐ¾Ð´ Ð¾ÑˆÐ¸Ð±ÐºÐ¸: ' + CAST(ERROR_NUMBER() as nvarchar(10)) + CHAR(13) + CHAR(13)
			+ 'Ð¢ÐµÐºÑÑ‚ Ð¾ÑˆÐ¸Ð±ÐºÐ¸: ' + ERROR_MESSAGE()  + CHAR(13) + CHAR(13)
			+ 'Ð¢ÐµÐºÑÑ‚ T-SQL:' + CHAR(13) + @SQLString  
	END CATCH;
END

-- 2.3. ÐŸÐµÑ€ÐµÐ²Ð¾Ð´ Ð² Ð¼Ð½Ð¾Ð³Ð¾Ð¿Ð¾Ð»ÑŒÐ·Ð¾Ð²Ð°Ñ‚ÐµÐ»ÑŒÑÐºÐ¸Ð¹ Ñ€ÐµÐ¶Ð¸Ð¼ ----------------------------------------------------------------------------------------------------------
IF @subject = ''
BEGIN	
	
	-- Ð¤Ð¾Ñ€Ð¼Ð¸Ñ€ÑƒÐµÐ¼ ÑÑ‚Ñ€Ð¾ÐºÑƒ Ð´Ð»Ñ Ð¸ÑÐ¿Ð¾Ð»Ð½ÐµÐ½Ð¸Ñ
	SET @SQLString = 'ALTER DATABASE [' + @DBName_To + '] SET MULTI_USER;'
	
	-- Ð’Ñ‹Ð²Ð¾Ð´Ð¸Ð¼ Ð¸ Ð²Ñ‹Ð¿Ð¾Ð»Ð½ÑÐµÐ¼ Ð¿Ð¾Ð»ÑƒÑ‡ÐµÐ½Ð½ÑƒÑŽ Ð¸Ð½ÑÑ‚Ñ€ÑƒÐºÑ†Ð¸ÑŽ
>>>>>>> .merge_file_a20084
	PRINT @SQLString
	BEGIN TRY 
		EXEC sp_executesql @SQLString
	END TRY
	BEGIN CATCH  
<<<<<<< .merge_file_a38816
		-- Îøáèêà âûïîëíåíèÿ îïåðàöèè
		SET @subject = 'ÎØÈÁÊÀ ÂÎÑÑÒÀÍÎÂËÅÍÈß áàçû äàííûõ ' + @DBName_To
			SET @finalmassage = 'Îøèáêà âîññòàíîâëåíèÿ ïîëíîé ðåçåðâíîé êîïèè äëÿ áàçû äàííûõ ' + @DBName_To + CHAR(13) + CHAR(13)
			+ 'Êîä îøèáêè: ' + CAST(ERROR_NUMBER() as nvarchar(10)) + CHAR(13) + CHAR(13)
			+ 'Òåêñò îøèáêè: ' + ERROR_MESSAGE()  + CHAR(13) + CHAR(13)
			+ 'Òåêñò T-SQL:' + CHAR(13) + @SQLString  
	END CATCH;
END

-- 3. Ïåðåâîäèì áàçó â ïðîñòóþ ìîäåëü âîññòàíîâëåíèÿ
IF @subject = '2'
BEGIN	
	
	-- Ôîðìèðóåì ñòðîêó äëÿ èñïîëíåíèÿ
	SET @SQLString = 'ALTER DATABASE ' + @DBName_To + ' SET RECOVERY SIMPLE;'
	
	-- Âûâîäèì è âûïîëíÿåì ïîëó÷åííóþ èíñòðóêöèþ
=======
		-- ÐžÑˆÐ±Ð¸ÐºÐ° Ð²Ñ‹Ð¿Ð¾Ð»Ð½ÐµÐ½Ð¸Ñ Ð¾Ð¿ÐµÑ€Ð°Ñ†Ð¸Ð¸
		SET @subject = 'ÐžÐ¨Ð˜Ð‘ÐšÐ Ð’ÐžÐ¡Ð¡Ð¢ÐÐÐžÐ’Ð›Ð•ÐÐ˜Ð¯ Ð±Ð°Ð·Ñ‹ Ð´Ð°Ð½Ð½Ñ‹Ñ… - 3 ' + @DBName_To
		SET @finalmassage = 'ÐžÑˆÐ¸Ð±ÐºÐ° Ð¿ÐµÑ€ÐµÐ²Ð¾Ð´Ð° Ð² Ð¿Ñ€Ð¾ÑÑ‚ÑƒÑŽ Ð¼Ð¾Ð´ÐµÐ»ÑŒ Ð²Ð¾ÑÑÑ‚Ð°Ð½Ð¾Ð²Ð»ÐµÐ½Ð¸Ñ Ð±Ð°Ð·Ñ‹ Ð´Ð°Ð½Ð½Ñ‹Ñ… ' + @DBName_To + CHAR(13) + CHAR(13)
			+ 'ÐšÐ¾Ð´ Ð¾ÑˆÐ¸Ð±ÐºÐ¸: ' + CAST(ERROR_NUMBER() as nvarchar(10)) + CHAR(13) + CHAR(13)
			+ 'Ð¢ÐµÐºÑÑ‚ Ð¾ÑˆÐ¸Ð±ÐºÐ¸: ' + ERROR_MESSAGE()  + CHAR(13) + CHAR(13)
			+ 'Ð¢ÐµÐºÑÑ‚ T-SQL:' + CHAR(13) + @SQLString  
	END CATCH;
END

-- 3. ÐŸÐµÑ€ÐµÐ²Ð¾Ð´Ð¸Ð¼ Ð±Ð°Ð·Ñƒ Ð² Ð¿Ñ€Ð¾ÑÑ‚ÑƒÑŽ Ð¼Ð¾Ð´ÐµÐ»ÑŒ Ð²Ð¾ÑÑÑ‚Ð°Ð½Ð¾Ð²Ð»ÐµÐ½Ð¸Ñ ----------------------------------------------------------------------------------------------------------
IF @subject = ''
BEGIN	
	
	-- Ð¤Ð¾Ñ€Ð¼Ð¸Ñ€ÑƒÐµÐ¼ ÑÑ‚Ñ€Ð¾ÐºÑƒ Ð´Ð»Ñ Ð¸ÑÐ¿Ð¾Ð»Ð½ÐµÐ½Ð¸Ñ
	SET @SQLString = 'ALTER DATABASE ' + @DBName_To + ' SET RECOVERY SIMPLE;'
	
	-- Ð’Ñ‹Ð²Ð¾Ð´Ð¸Ð¼ Ð¸ Ð²Ñ‹Ð¿Ð¾Ð»Ð½ÑÐµÐ¼ Ð¿Ð¾Ð»ÑƒÑ‡ÐµÐ½Ð½ÑƒÑŽ Ð¸Ð½ÑÑ‚Ñ€ÑƒÐºÑ†Ð¸ÑŽ
>>>>>>> .merge_file_a20084
	PRINT @SQLString
	BEGIN TRY 
		EXEC sp_executesql @SQLString
	END TRY
	BEGIN CATCH  
<<<<<<< .merge_file_a38816
		-- Îøáèêà âûïîëíåíèÿ îïåðàöèè
		SET @subject = 'ÎØÈÁÊÀ ÂÎÑÑÒÀÍÎÂËÅÍÈß áàçû äàííûõ ' + @DBName_To
		SET @finalmassage = 'Îøèáêà ïåðåâîäà â ïðîñòóþ ìîäåëü âîññòàíîâëåíèÿ áàçû äàííûõ ' + @DBName_To + CHAR(13) + CHAR(13)
			+ 'Êîä îøèáêè: ' + CAST(ERROR_NUMBER() as nvarchar(10)) + CHAR(13) + CHAR(13)
			+ 'Òåêñò îøèáêè: ' + ERROR_MESSAGE()  + CHAR(13) + CHAR(13)
			+ 'Òåêñò T-SQL:' + CHAR(13) + @SQLString  
	END CATCH;
END

-- 4. Çàïóñêàåì ñæàòèå áàçû äàííûõ
IF @subject = '2'
BEGIN

	-- Ôîðìèðóåì ñòðîêó äëÿ èñïîëíåíèÿ
	SET @SQLString = 'DBCC SHRINKDATABASE(N''' + @DBName_To + ''');'
					
	-- Âûâîäèì è âûïîëíÿåì ïîëó÷åííóþ èíñòðóêöèþ
=======
		-- ÐžÑˆÐ±Ð¸ÐºÐ° Ð²Ñ‹Ð¿Ð¾Ð»Ð½ÐµÐ½Ð¸Ñ Ð¾Ð¿ÐµÑ€Ð°Ñ†Ð¸Ð¸
		SET @subject = 'ÐžÐ¨Ð˜Ð‘ÐšÐ Ð’ÐžÐ¡Ð¡Ð¢ÐÐÐžÐ’Ð›Ð•ÐÐ˜Ð¯ Ð±Ð°Ð·Ñ‹ Ð´Ð°Ð½Ð½Ñ‹Ñ… - 3 ' + @DBName_To
		SET @finalmassage = 'ÐžÑˆÐ¸Ð±ÐºÐ° Ð¿ÐµÑ€ÐµÐ²Ð¾Ð´Ð° Ð² Ð¿Ñ€Ð¾ÑÑ‚ÑƒÑŽ Ð¼Ð¾Ð´ÐµÐ»ÑŒ Ð²Ð¾ÑÑÑ‚Ð°Ð½Ð¾Ð²Ð»ÐµÐ½Ð¸Ñ Ð±Ð°Ð·Ñ‹ Ð´Ð°Ð½Ð½Ñ‹Ñ… ' + @DBName_To + CHAR(13) + CHAR(13)
			+ 'ÐšÐ¾Ð´ Ð¾ÑˆÐ¸Ð±ÐºÐ¸: ' + CAST(ERROR_NUMBER() as nvarchar(10)) + CHAR(13) + CHAR(13)
			+ 'Ð¢ÐµÐºÑÑ‚ Ð¾ÑˆÐ¸Ð±ÐºÐ¸: ' + ERROR_MESSAGE()  + CHAR(13) + CHAR(13)
			+ 'Ð¢ÐµÐºÑÑ‚ T-SQL:' + CHAR(13) + @SQLString  
	END CATCH;
END

-- 4 Ð—Ð°Ð¿ÑƒÑÐºÐ°ÐµÐ¼ ÑÐ¶Ð°Ñ‚Ð¸Ðµ Ð±Ð°Ð·Ñ‹ Ð´Ð°Ð½Ð½Ñ‹Ñ… ----------------------------------------------------------------------------------------------------------
IF @subject = ''
BEGIN

	-- Ð¤Ð¾Ñ€Ð¼Ð¸Ñ€ÑƒÐµÐ¼ ÑÑ‚Ñ€Ð¾ÐºÑƒ Ð´Ð»Ñ Ð¸ÑÐ¿Ð¾Ð»Ð½ÐµÐ½Ð¸Ñ
	SET @SQLString = 'DBCC SHRINKDATABASE(N''' + @DBName_To + ''');'
					
	-- Ð’Ñ‹Ð²Ð¾Ð´Ð¸Ð¼ Ð¸ Ð²Ñ‹Ð¿Ð¾Ð»Ð½ÑÐµÐ¼ Ð¿Ð¾Ð»ÑƒÑ‡ÐµÐ½Ð½ÑƒÑŽ Ð¸Ð½ÑÑ‚Ñ€ÑƒÐºÑ†Ð¸ÑŽ
>>>>>>> .merge_file_a20084
	PRINT @SQLString
	BEGIN TRY 
		EXEC sp_executesql @SQLString
	END TRY
	BEGIN CATCH  
<<<<<<< .merge_file_a38816
		-- Îøáèêà âûïîëíåíèÿ îïåðàöèè
		SET @subject = 'ÎØÈÁÊÀ ÂÎÑÑÒÀÍÎÂËÅÍÈß áàçû äàííûõ ' + @DBName_To
		SET @finalmassage = 'Îøèáêà ñæàòèÿ áàçû äàííûõ ' + @DBName_To + CHAR(13) + CHAR(13)
			+ 'Êîä îøèáêè: ' + CAST(ERROR_NUMBER() as nvarchar(10)) + CHAR(13) + CHAR(13)
			+ 'Òåêñò îøèáêè: ' + ERROR_MESSAGE()  + CHAR(13) + CHAR(13)
			+ 'Òåêñò T-SQL:' + CHAR(13) + @SQLString  
	END CATCH;
END	

-- 5. Åñëè ôàéë áûë ñîçäàí, óäàëèì ôàéë ðåçåðâíîé êîïèè
=======
		-- ÐžÑˆÐ±Ð¸ÐºÐ° Ð²Ñ‹Ð¿Ð¾Ð»Ð½ÐµÐ½Ð¸Ñ Ð¾Ð¿ÐµÑ€Ð°Ñ†Ð¸Ð¸
		SET @subject = 'ÐžÐ¨Ð˜Ð‘ÐšÐ Ð’ÐžÐ¡Ð¡Ð¢ÐÐÐžÐ’Ð›Ð•ÐÐ˜Ð¯ Ð±Ð°Ð·Ñ‹ Ð´Ð°Ð½Ð½Ñ‹Ñ… - 4 ' + @DBName_To
		SET @finalmassage = 'ÐžÑˆÐ¸Ð±ÐºÐ° ÑÐ¶Ð°Ñ‚Ð¸Ñ Ð±Ð°Ð·Ñ‹ Ð´Ð°Ð½Ð½Ñ‹Ñ… ' + @DBName_To + CHAR(13) + CHAR(13)
			+ 'ÐšÐ¾Ð´ Ð¾ÑˆÐ¸Ð±ÐºÐ¸: ' + CAST(ERROR_NUMBER() as nvarchar(10)) + CHAR(13) + CHAR(13)
			+ 'Ð¢ÐµÐºÑÑ‚ Ð¾ÑˆÐ¸Ð±ÐºÐ¸: ' + ERROR_MESSAGE()  + CHAR(13) + CHAR(13)
			+ 'Ð¢ÐµÐºÑÑ‚ T-SQL:' + CHAR(13) + @SQLString  
	END CATCH;
END	

-- 5. Ð•ÑÐ»Ð¸ Ñ„Ð°Ð¹Ð» Ð±Ñ‹Ð» ÑÐ¾Ð·Ð´Ð°Ð½, ÑƒÐ´Ð°Ð»Ð¸Ð¼ Ñ„Ð°Ð¹Ð» Ñ€ÐµÐ·ÐµÑ€Ð²Ð½Ð¾Ð¹ ÐºÐ¾Ð¿Ð¸Ð¸ ----------------------------------------------------------------------------------------------------------
>>>>>>> .merge_file_a20084
BEGIN TRY
	EXEC master.dbo.xp_fileexist @backupfile, @out out
	IF @out = 1 EXEC master.dbo.xp_delete_file 0, @backupfile
END TRY
BEGIN CATCH  
<<<<<<< .merge_file_a38816
	-- Îøáèêà âûïîëíåíèÿ îïåðàöèè
	SET @subject = 'ÎØÈÁÊÀ ÂÎÑÑÒÀÍÎÂËÅÍÈß áàçû äàííûõ ' + @DBName_To
	SET @finalmassage = 'Îøèáêà óäàëåíèÿ ôàéëà ðåçåðâíîé êîïèè ' + @backupfile + CHAR(13) + CHAR(13)
		+ 'Êîä îøèáêè: ' + CAST(ERROR_NUMBER() as nvarchar(10)) + CHAR(13) + CHAR(13)
		+ 'Òåêñò îøèáêè: ' + ERROR_MESSAGE()  + CHAR(13) + CHAR(13)
		+ 'Òåêñò T-SQL:' + CHAR(13) + 'master.dbo.xp_delete_file 0, ' + @backupfile  
END CATCH;
	
-- Åñëè îøèáîê íå áûëî, ñôîðìèðóåì òåêñò ñîîáùåíèÿ
IF @subject = ''
BEGIN
	-- Óñïåøíîå âûïîëíåíèå âñåõ îïåðàöèé
	SET @subject = 'Óñïåøíîå âîññòàíîâëåíèå áàçû äàííûõ ' + @DBName_To
	SET @finalmassage = 'Óñïåøíîå âîññòàíîâëåíèå áàçû äàííûõ ' + @DBName_To + ' èç ðåçåðâíîé êîïèè áàçû äàííûõ ' + @DBName_From
END

-- 6. Åñëè çàäàí ïðîôèëü ýëåêòðîííîé ïî÷òû, îòïðàâèì ñîîáùåíèå
=======
	-- ÐžÑˆÐ±Ð¸ÐºÐ° Ð²Ñ‹Ð¿Ð¾Ð»Ð½ÐµÐ½Ð¸Ñ Ð¾Ð¿ÐµÑ€Ð°Ñ†Ð¸Ð¸
	SET @subject = 'ÐžÐ¨Ð˜Ð‘ÐšÐ Ð’ÐžÐ¡Ð¡Ð¢ÐÐÐžÐ’Ð›Ð•ÐÐ˜Ð¯ Ð±Ð°Ð·Ñ‹ Ð´Ð°Ð½Ð½Ñ‹Ñ… - 5 ' + @DBName_To
	SET @finalmassage = 'ÐžÑˆÐ¸Ð±ÐºÐ° ÑƒÐ´Ð°Ð»ÐµÐ½Ð¸Ñ Ñ„Ð°Ð¹Ð»Ð° Ñ€ÐµÐ·ÐµÑ€Ð²Ð½Ð¾Ð¹ ÐºÐ¾Ð¿Ð¸Ð¸ ' + @backupfile + CHAR(13) + CHAR(13)
		+ 'ÐšÐ¾Ð´ Ð¾ÑˆÐ¸Ð±ÐºÐ¸: ' + CAST(ERROR_NUMBER() as nvarchar(10)) + CHAR(13) + CHAR(13)
		+ 'Ð¢ÐµÐºÑÑ‚ Ð¾ÑˆÐ¸Ð±ÐºÐ¸: ' + ERROR_MESSAGE()  + CHAR(13) + CHAR(13)
		+ 'Ð¢ÐµÐºÑÑ‚ T-SQL:' + CHAR(13) + 'master.dbo.xp_delete_file 0, ' + @backupfile  
END CATCH;
	
-- Ð•ÑÐ»Ð¸ Ð¾ÑˆÐ¸Ð±Ð¾Ðº Ð½Ðµ Ð±Ñ‹Ð»Ð¾, ÑÑ„Ð¾Ñ€Ð¼Ð¸Ñ€ÑƒÐµÐ¼ Ñ‚ÐµÐºÑÑ‚ ÑÐ¾Ð¾Ð±Ñ‰ÐµÐ½Ð¸Ñ
IF @subject = ''
BEGIN
	-- Ð£ÑÐ¿ÐµÑˆÐ½Ð¾Ðµ Ð²Ñ‹Ð¿Ð¾Ð»Ð½ÐµÐ½Ð¸Ðµ Ð²ÑÐµÑ… Ð¾Ð¿ÐµÑ€Ð°Ñ†Ð¸Ð¹
	SET @subject = 'Ð£ÑÐ¿ÐµÑˆÐ½Ð¾Ðµ Ð²Ð¾ÑÑÑ‚Ð°Ð½Ð¾Ð²Ð»ÐµÐ½Ð¸Ðµ Ð±Ð°Ð·Ñ‹ Ð´Ð°Ð½Ð½Ñ‹Ñ… ' + @DBName_To
	SET @finalmassage = 'Ð£ÑÐ¿ÐµÑˆÐ½Ð¾Ðµ Ð²Ð¾ÑÑÑ‚Ð°Ð½Ð¾Ð²Ð»ÐµÐ½Ð¸Ðµ Ð±Ð°Ð·Ñ‹ Ð´Ð°Ð½Ð½Ñ‹Ñ… ' + @DBName_To + ' Ð¸Ð· Ñ€ÐµÐ·ÐµÑ€Ð²Ð½Ð¾Ð¹ ÐºÐ¾Ð¿Ð¸Ð¸ Ð±Ð°Ð·Ñ‹ Ð´Ð°Ð½Ð½Ñ‹Ñ… ' + @DBName_From
END

-- 6. Ð•ÑÐ»Ð¸ Ð·Ð°Ð´Ð°Ð½ Ð¿Ñ€Ð¾Ñ„Ð¸Ð»ÑŒ ÑÐ»ÐµÐºÑ‚Ñ€Ð¾Ð½Ð½Ð¾Ð¹ Ð¿Ð¾Ñ‡Ñ‚Ñ‹, Ð¾Ñ‚Ð¿Ñ€Ð°Ð²Ð¸Ð¼ ÑÐ¾Ð¾Ð±Ñ‰ÐµÐ½Ð¸Ðµ ----------------------------------------------------------------------------------------------------------
>>>>>>> .merge_file_a20084
IF @profile_name <> ''
EXEC msdb.dbo.sp_send_dbmail
    @profile_name = @profile_name,
    @recipients = @recipients,
    @body = @finalmassage,
    @subject = @subject;

<<<<<<< .merge_file_a38816
-- Âûâîäèì ñîîáùåíèå î ðåçóëüòàòå
=======
-- Ð’Ñ‹Ð²Ð¾Ð´Ð¸Ð¼ ÑÐ¾Ð¾Ð±Ñ‰ÐµÐ½Ð¸Ðµ Ð¾ Ñ€ÐµÐ·ÑƒÐ»ÑŒÑ‚Ð°Ñ‚Ðµ
>>>>>>> .merge_file_a20084
SELECT
	@subject as subject,
	@finalmassage as finalmassage

GO