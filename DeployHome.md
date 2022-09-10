
    set tempdir=C:\Temp1C
    set temletepath=%cd%\empty.cf
    set repository=%cd%

MD %tempdir%

C:
cd "C:\Program Files\1cv8\8.3.20.1613\bin"
ibcmd infobase create --data="%tempdir%\fs-data" --db-path="%tempdir%\file-db\db-data" --load="%temletepath%"
ibcmd infobase config import --data="%tempdir%\fs-data" --db-path="%tempdir%\file-db\db-data" %repository%
ibcmd infobase config save --data="%tempdir%\fs-data" --db-path="%tempdir%\file-db\db-data" %tempdir%\1Cv8.cf

# Загрузка базы из репозитория
"C:\Program Files\1cv8\common\1cestart.exe" DESIGNER /F"G:\1C_Bases\Union_3" /N"Администратор" /LoadConfigFromFiles "G:\_Git\Nexus" -NoCheck /UpdateDBCfg /DisableStartupDialogs /DisableStartupMessages



# Выгрузка базы в репозиторий
"C:\Program Files\1cv8\common\1cestart.exe" DESIGNER /F"G:\1C_Bases\Union_3" /N"Администратор" /DumpConfigToFiles "G:\_Git\Nexus" -update /DisableStartupDialogs /DisableStartupMessages


### Расширение АрхивГазпромСеры 

## Загрузка из репозитория
    "C:\Program Files\1cv8\common\1cestart.exe" DESIGNER /F"G:\1C_Bases\Union_3" /N"Администратор" /LoadConfigFromFiles "G:\_Git\MainBase_Archive\src" -Extension АрхивГазпромСеры -NoCheck /UpdateDBCfg /DisableStartupDialogs /DisableStartupMessages
    
## Выгрузка в репозиторий
"C:\Program Files\1cv8\common\1cestart.exe" DESIGNER /F"G:\1C_Bases\Union_3" /N"Администратор" /DumpConfigToFiles "G:\_Git\MainBase_Archive\src" -Extension АрхивГазпромСеры -update /DisableStartupDialogs /DisableStartupMessages

