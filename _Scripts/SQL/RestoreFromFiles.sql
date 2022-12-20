--Здесь ничего не трогаем
declare @SQLString nvarchar(4000), @TableName nvarchar(16)
declare @t table (fname NVARCHAR(50))
DECLARE @counter INT, @backupfile NVARCHAR(50)
SET @counter = 0

---------------------------------------------------------------------------
-- Здесь изменяем имя базы
set @TableName = N'Ins_3_3'
-- Здесь вставляем необходимое количество бекапов.

-- Вначале полный, потом все разностные
INSERT INTO @t (fname) VALUES ('2011-01-16_ins.bak')
INSERT INTO @t (fname) VALUES ('2011-01-17_ins_diff.bak')
INSERT INTO @t (fname) VALUES ('2011-01-18_ins_diff.bak')

---------------------------------------------------------------------------
--Далее ничего не трогаем
DECLARE bkf CURSOR LOCAL FAST_FORWARD FOR SELECT * FROM @t;

OPEN bkf;
FETCH bkf INTO @backupfile;
WHILE @@FETCH_STATUS=0
BEGIN
IF @counter = 0
BEGIN
set @SQLString = N'restore Database ' + @TableName + '
FROM DISK = N''N:\Backup1C\' + @backupfile + '''
with NORECOVERY,
move ''Ins81'' to N''F:\SQLBases\Data\' + @TableName + '.mdf'',
move ''Ins81_log'' to N''F:\SQLBases\Data\' + @TableName + '_Log.ldf'',
STATS = 5'
END
ELSE
BEGIN
set @SQLString = N'restore Database ' + @TableName + '
FROM DISK = N''N:\Backup1C\' + @backupfile + '''
with NORECOVERY'
END
exec sp_executesql @SQLString
set @counter = @counter + 1
FETCH bkf INTO @backupfile;
END;
CLOSE bkf;
DEALLOCATE bkf;
set @SQLString = N'restore Database ' + @TableName + '
with RECOVERY'
exec sp_executesql @SQLString