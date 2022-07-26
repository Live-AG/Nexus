
set tempdir=C:\Temp1C
set temletepath=%cd%\empty.cf
set repository=%cd%

MD %tempdir%

C:
cd "C:\Program Files\1cv8\8.3.20.1613\bin"
ibcmd infobase create --data="%tempdir%\fs-data" --db-path="%tempdir%\file-db\db-data" --load="%temletepath%"
ibcmd infobase config import --data="%tempdir%\fs-data" --db-path="%tempdir%\file-db\db-data" %repository%
ibcmd infobase config save --data="D:\ss-data\cs-data" --db-path="%tempdir%\file-db\db-data" %tempdir%\1Cv8.cf
