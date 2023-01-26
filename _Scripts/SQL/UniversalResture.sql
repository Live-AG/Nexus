-------------------------------------------
-- НАСТРАИВАЕМЫЕ ПЕРЕМЕННЫЕ
-- База данных источник						
DECLARE @DBName_From as nvarchar(40) = 'ERP' -- ИЗ
-- База данных назначения
DECLARE @DBName_To as nvarchar(40) = 'ERP_TEST2' -- В
-- Каталог для резервной копии
DECLARE @Path as nvarchar(400) = 'H:\Backup'
-- Имя почтового профиля, для отправки электонной почты									
DECLARE @profile_name as nvarchar(100) = ''
-- Получатели сообщений электронной почты, разделенные знаком ";"				
DECLARE @recipients as nvarchar(500) = ''

-------------------------------------------
-- СЛУЖЕБНЫЕ ПЕРЕМЕННЫЕ	
DECLARE @SQLString NVARCHAR(4000)
DECLARE @backupfile NVARCHAR(500)
DECLARE @physicalName NVARCHAR(500), @logicalName NVARCHAR(500)
DECLARE @out as int = 0
DECLARE @subject as NVARCHAR(100) = ''
DECLARE @finalmassage as NVARCHAR(1000) = ''

-------------------------------------------
-- ТЕЛО СКРИПТА
USE [master]

-- 1. Создаем резервную копию с флагом "Только резервное копирование" ----------------------------------------------------------------------------------------------------------
-- Формируем строку для исполнения
SET @backupfile = @Path + '\' + @DBName_From + '_' + Replace(CONVERT(nvarchar, GETDATE(), 126),':','-') + '.bak'
SET @SQLString = 
	N'BACKUP DATABASE [' + @DBName_From + ']
	TO DISK = N''' + @backupfile + '''  
	WITH NOFORMAT, NOINIT,
	SKIP, NOREWIND, NOUNLOAD, STATS = 10, COPY_ONLY'

-- Выводим и выполняем полученную инструкцию
PRINT @SQLString
BEGIN TRY 
	EXEC sp_executesql @SQLString
END TRY
BEGIN CATCH  
	-- Ошбика выполнения операции
	SET @subject = 'ОШИБКА Создания резервной копии базы ' + @DBName_From
	SET @finalmassage = 'Ошибка создания резервной копии базы ' + @DBName_From + ' в каталог ' + @Path + CHAR(13) + CHAR(13)
		+ 'Код ошибки: ' + CAST(ERROR_NUMBER() as nvarchar(10)) + CHAR(13) + CHAR(13)
		+ 'Текст ошибки: ' + ERROR_MESSAGE()  + CHAR(13) + CHAR(13)
		+ 'Текст T-SQL:' + CHAR(13) + @SQLString  
END CATCH;

-- 2.1. Перевод в однопользовательский режим ----------------------------------------------------------------------------------------------------------
IF @subject = '1'
BEGIN	
	USE [master]
	-- Формируем строку для исполнения
	SET @SQLString = 'ALTER DATABASE [' + @DBName_To + '] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;'
	
	-- Выводим и выполняем полученную инструкцию
	PRINT @SQLString
	BEGIN TRY 
		EXEC sp_executesql @SQLString
	END TRY
	BEGIN CATCH  
		-- Ошбика выполнения операции
		SET @subject = 'ОШИБКА ВОССТАНОВЛЕНИЯ базы данных - 3 ' + @DBName_To
		SET @finalmassage = 'Ошибка перевода в простую модель восстановления базы данных ' + @DBName_To + CHAR(13) + CHAR(13)
			+ 'Код ошибки: ' + CAST(ERROR_NUMBER() as nvarchar(10)) + CHAR(13) + CHAR(13)
			+ 'Текст ошибки: ' + ERROR_MESSAGE()  + CHAR(13) + CHAR(13)
			+ 'Текст T-SQL:' + CHAR(13) + @SQLString  
	END CATCH;
END

-- 2.2. Загружаем полученный файл резервной копии ----------------------------------------------------------------------------------------------------------
IF @subject = ''
BEGIN
	
	-- Формируем строку для исполнения	
	SET @SQLString = 
	N'RESTORE DATABASE [' + @DBName_To + ']
	FROM DISK = N''' + @backupfile + '''   
	WITH  
	FILE = 1,'

	-- Переименуем файлы базы данных на исходные
	-- Новый цикл по всем файлам базы данных
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
	NOUNLOAD,
	REPLACE,
	STATS = 5'

	-- Выводим и выполняем полученную инструкцию
	PRINT @SQLString
	BEGIN TRY 
		EXEC sp_executesql @SQLString
	END TRY
	BEGIN CATCH  
		-- Ошбика выполнения операции
		SET @subject = 'ОШИБКА ВОССТАНОВЛЕНИЯ базы данных - 2 ' + @DBName_To
			SET @finalmassage = 'Ошибка восстановления полной резервной копии для базы данных ' + @DBName_To + CHAR(13) + CHAR(13)
			+ 'Код ошибки: ' + CAST(ERROR_NUMBER() as nvarchar(10)) + CHAR(13) + CHAR(13)
			+ 'Текст ошибки: ' + ERROR_MESSAGE()  + CHAR(13) + CHAR(13)
			+ 'Текст T-SQL:' + CHAR(13) + @SQLString  
	END CATCH;
END

-- 2.3. Перевод в многопользовательский режим ----------------------------------------------------------------------------------------------------------
IF @subject = '1'
BEGIN	
	
	-- Формируем строку для исполнения
	SET @SQLString = 'ALTER DATABASE [' + @DBName_To + '] SET MULTI_USER;'
	
	-- Выводим и выполняем полученную инструкцию
	PRINT @SQLString
	BEGIN TRY 
		EXEC sp_executesql @SQLString
	END TRY
	BEGIN CATCH  
		-- Ошбика выполнения операции
		SET @subject = 'ОШИБКА ВОССТАНОВЛЕНИЯ базы данных - 3 ' + @DBName_To
		SET @finalmassage = 'Ошибка перевода в простую модель восстановления базы данных ' + @DBName_To + CHAR(13) + CHAR(13)
			+ 'Код ошибки: ' + CAST(ERROR_NUMBER() as nvarchar(10)) + CHAR(13) + CHAR(13)
			+ 'Текст ошибки: ' + ERROR_MESSAGE()  + CHAR(13) + CHAR(13)
			+ 'Текст T-SQL:' + CHAR(13) + @SQLString  
	END CATCH;
END

-- 3. Переводим базу в простую модель восстановления ----------------------------------------------------------------------------------------------------------
IF @subject = ''
BEGIN	
	
	-- Формируем строку для исполнения
	SET @SQLString = 'ALTER DATABASE ' + @DBName_To + ' SET RECOVERY SIMPLE;'
	
	-- Выводим и выполняем полученную инструкцию
	PRINT @SQLString
	BEGIN TRY 
		EXEC sp_executesql @SQLString
	END TRY
	BEGIN CATCH  
		-- Ошбика выполнения операции
		SET @subject = 'ОШИБКА ВОССТАНОВЛЕНИЯ базы данных - 3 ' + @DBName_To
		SET @finalmassage = 'Ошибка перевода в простую модель восстановления базы данных ' + @DBName_To + CHAR(13) + CHAR(13)
			+ 'Код ошибки: ' + CAST(ERROR_NUMBER() as nvarchar(10)) + CHAR(13) + CHAR(13)
			+ 'Текст ошибки: ' + ERROR_MESSAGE()  + CHAR(13) + CHAR(13)
			+ 'Текст T-SQL:' + CHAR(13) + @SQLString  
	END CATCH;
END

-- 4 Запускаем сжатие базы данных ----------------------------------------------------------------------------------------------------------
IF @subject = ''
BEGIN

	-- Формируем строку для исполнения
	SET @SQLString = 'DBCC SHRINKDATABASE(N''' + @DBName_To + ''');'
					
	-- Выводим и выполняем полученную инструкцию
	PRINT @SQLString
	BEGIN TRY 
		EXEC sp_executesql @SQLString
	END TRY
	BEGIN CATCH  
		-- Ошбика выполнения операции
		SET @subject = 'ОШИБКА ВОССТАНОВЛЕНИЯ базы данных - 4 ' + @DBName_To
		SET @finalmassage = 'Ошибка сжатия базы данных ' + @DBName_To + CHAR(13) + CHAR(13)
			+ 'Код ошибки: ' + CAST(ERROR_NUMBER() as nvarchar(10)) + CHAR(13) + CHAR(13)
			+ 'Текст ошибки: ' + ERROR_MESSAGE()  + CHAR(13) + CHAR(13)
			+ 'Текст T-SQL:' + CHAR(13) + @SQLString  
	END CATCH;
END	

-- 5. Если файл был создан, удалим файл резервной копии ----------------------------------------------------------------------------------------------------------
BEGIN TRY
	EXEC master.dbo.xp_fileexist @backupfile, @out out
	IF @out = 1 EXEC master.dbo.xp_delete_file 0, @backupfile
END TRY
BEGIN CATCH  
	-- Ошбика выполнения операции
	SET @subject = 'ОШИБКА ВОССТАНОВЛЕНИЯ базы данных - 5 ' + @DBName_To
	SET @finalmassage = 'Ошибка удаления файла резервной копии ' + @backupfile + CHAR(13) + CHAR(13)
		+ 'Код ошибки: ' + CAST(ERROR_NUMBER() as nvarchar(10)) + CHAR(13) + CHAR(13)
		+ 'Текст ошибки: ' + ERROR_MESSAGE()  + CHAR(13) + CHAR(13)
		+ 'Текст T-SQL:' + CHAR(13) + 'master.dbo.xp_delete_file 0, ' + @backupfile  
END CATCH;
	
-- Если ошибок не было, сформируем текст сообщения
IF @subject = ''
BEGIN
	-- Успешное выполнение всех операций
	SET @subject = 'Успешное восстановление базы данных ' + @DBName_To
	SET @finalmassage = 'Успешное восстановление базы данных ' + @DBName_To + ' из резервной копии базы данных ' + @DBName_From
END

-- 6. Если задан профиль электронной почты, отправим сообщение ----------------------------------------------------------------------------------------------------------
IF @profile_name <> ''
EXEC msdb.dbo.sp_send_dbmail
    @profile_name = @profile_name,
    @recipients = @recipients,
    @body = @finalmassage,
    @subject = @subject;

-- Выводим сообщение о результате
SELECT
	@subject as subject,
	@finalmassage as finalmassage

GO