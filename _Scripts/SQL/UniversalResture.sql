-------------------------------------------
-- ������������� ����������
-- ���� ������ ��������						
DECLARE @DBName_From as nvarchar(40) = 'ShipLoadingDesign' -- ��
-- ���� ������ ����������
DECLARE @DBName_To as nvarchar(40) = 'TestDB_3' -- �
-- ������� ��� ��������� �����
DECLARE @Path as nvarchar(400) = 'H:\Backup'
-- ��� ��������� �������, ��� �������� ���������� �����									
DECLARE @profile_name as nvarchar(100) = ''
-- ���������� ��������� ����������� �����, ����������� ������ ";"				
DECLARE @recipients as nvarchar(500) = ''

-------------------------------------------
-- ��������� ����������	
DECLARE @SQLString NVARCHAR(4000)
DECLARE @backupfile NVARCHAR(500)
DECLARE @physicalName NVARCHAR(500), @logicalName NVARCHAR(500)
DECLARE @out as int = 0
DECLARE @subject as NVARCHAR(100) = ''
DECLARE @finalmassage as NVARCHAR(1000) = ''

-------------------------------------------
-- ���� �������
use master

-- 1. ������� ��������� ����� � ������ "������ ��������� �����������"
-- ��������� ������ ��� ����������
SET @backupfile = @Path + '\\' + @DBName_From + '_' + Replace(CONVERT(nvarchar, GETDATE(), 126),':','-') + '.bak'
SET @SQLString = 
	N'BACKUP DATABASE [' + @DBName_From + ']
	TO DISK = N''' + @backupfile + '''  
	WITH NOFORMAT, NOINIT,
	SKIP, NOREWIND, NOUNLOAD, STATS = 10, COPY_ONLY'

-- ������� � ��������� ���������� ����������
PRINT @SQLString
BEGIN TRY 
	EXEC sp_executesql @SQLString
END TRY
BEGIN CATCH  
	-- ������ ���������� ��������
	SET @subject = '������ �������� ��������� ����� ���� ' + @DBName_From
	SET @finalmassage = '������ �������� ��������� ����� ���� ' + @DBName_From + ' � ������� ' + @Path + CHAR(13) + CHAR(13)
		+ '��� ������: ' + CAST(ERROR_NUMBER() as nvarchar(10)) + CHAR(13) + CHAR(13)
		+ '����� ������: ' + ERROR_MESSAGE()  + CHAR(13) + CHAR(13)
		+ '����� T-SQL:' + CHAR(13) + @SQLString  
END CATCH;

-- 2. ��������� ���������� ���� ��������� �����
IF @subject = ''
BEGIN
	
	-- ��������� ������ ��� ����������	
	SET @SQLString = 
	N'RESTORE DATABASE [' + @DBName_To + ']
	FROM DISK = N''' + @backupfile + '''   
	WITH  
	FILE = 1,'

	-- ����������� ����� ���� ������ �� ��������
	-- ����� ���� �� ���� ������ ���� ������
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
	RECOVERY,
	REPLACE,
	STATS = 5'

	-- ������� � ��������� ���������� ����������
	PRINT @SQLString
	BEGIN TRY 
		EXEC sp_executesql @SQLString
	END TRY
	BEGIN CATCH  
		-- ������ ���������� ��������
		SET @subject = '������ �������������� ���� ������ ' + @DBName_To
			SET @finalmassage = '������ �������������� ������ ��������� ����� ��� ���� ������ ' + @DBName_To + CHAR(13) + CHAR(13)
			+ '��� ������: ' + CAST(ERROR_NUMBER() as nvarchar(10)) + CHAR(13) + CHAR(13)
			+ '����� ������: ' + ERROR_MESSAGE()  + CHAR(13) + CHAR(13)
			+ '����� T-SQL:' + CHAR(13) + @SQLString  
	END CATCH;
END

-- 3. ��������� ���� � ������� ������ ��������������
IF @subject = '2'
BEGIN	
	
	-- ��������� ������ ��� ����������
	SET @SQLString = 'ALTER DATABASE ' + @DBName_To + ' SET RECOVERY SIMPLE;'
	
	-- ������� � ��������� ���������� ����������
	PRINT @SQLString
	BEGIN TRY 
		EXEC sp_executesql @SQLString
	END TRY
	BEGIN CATCH  
		-- ������ ���������� ��������
		SET @subject = '������ �������������� ���� ������ ' + @DBName_To
		SET @finalmassage = '������ �������� � ������� ������ �������������� ���� ������ ' + @DBName_To + CHAR(13) + CHAR(13)
			+ '��� ������: ' + CAST(ERROR_NUMBER() as nvarchar(10)) + CHAR(13) + CHAR(13)
			+ '����� ������: ' + ERROR_MESSAGE()  + CHAR(13) + CHAR(13)
			+ '����� T-SQL:' + CHAR(13) + @SQLString  
	END CATCH;
END

-- 4. ��������� ������ ���� ������
IF @subject = '2'
BEGIN

	-- ��������� ������ ��� ����������
	SET @SQLString = 'DBCC SHRINKDATABASE(N''' + @DBName_To + ''');'
					
	-- ������� � ��������� ���������� ����������
	PRINT @SQLString
	BEGIN TRY 
		EXEC sp_executesql @SQLString
	END TRY
	BEGIN CATCH  
		-- ������ ���������� ��������
		SET @subject = '������ �������������� ���� ������ ' + @DBName_To
		SET @finalmassage = '������ ������ ���� ������ ' + @DBName_To + CHAR(13) + CHAR(13)
			+ '��� ������: ' + CAST(ERROR_NUMBER() as nvarchar(10)) + CHAR(13) + CHAR(13)
			+ '����� ������: ' + ERROR_MESSAGE()  + CHAR(13) + CHAR(13)
			+ '����� T-SQL:' + CHAR(13) + @SQLString  
	END CATCH;
END	

-- 5. ���� ���� ��� ������, ������ ���� ��������� �����
BEGIN TRY
	EXEC master.dbo.xp_fileexist @backupfile, @out out
	IF @out = 1 EXEC master.dbo.xp_delete_file 0, @backupfile
END TRY
BEGIN CATCH  
	-- ������ ���������� ��������
	SET @subject = '������ �������������� ���� ������ ' + @DBName_To
	SET @finalmassage = '������ �������� ����� ��������� ����� ' + @backupfile + CHAR(13) + CHAR(13)
		+ '��� ������: ' + CAST(ERROR_NUMBER() as nvarchar(10)) + CHAR(13) + CHAR(13)
		+ '����� ������: ' + ERROR_MESSAGE()  + CHAR(13) + CHAR(13)
		+ '����� T-SQL:' + CHAR(13) + 'master.dbo.xp_delete_file 0, ' + @backupfile  
END CATCH;
	
-- ���� ������ �� ����, ���������� ����� ���������
IF @subject = ''
BEGIN
	-- �������� ���������� ���� ��������
	SET @subject = '�������� �������������� ���� ������ ' + @DBName_To
	SET @finalmassage = '�������� �������������� ���� ������ ' + @DBName_To + ' �� ��������� ����� ���� ������ ' + @DBName_From
END

-- 6. ���� ����� ������� ����������� �����, �������� ���������
IF @profile_name <> ''
EXEC msdb.dbo.sp_send_dbmail
    @profile_name = @profile_name,
    @recipients = @recipients,
    @body = @finalmassage,
    @subject = @subject;

-- ������� ��������� � ����������
SELECT
	@subject as subject,
	@finalmassage as finalmassage

GO