

set workdir="G:\Temp\ShipLoading\"
set appdir="C:\Program Files\1cv8\8.3.20.1613\bin\"

"%appdir%ibcmd" infobase config export objects --data="%workdir%Data" --config="%workdir%config.yml" --user="Администратор" --password="" --out="%workdir%src" "Configuration"

"C:\Program Files\1cv8\8.3.20.1613\bin\ibcmd" infobase config export objects --data="G:\Temp\ShipLoading\Data" --config="G:\Temp\ShipLoading\config.yml" --user="Администратор" --password="" --out="G:\Temp\ShipLoading\src" "Configuration"