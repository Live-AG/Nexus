wmic logicaldisk get description,name
where 1cv8wsrv.lst

"C:\Program Files\1cv8\8.3.20.1613\bin\ibcmd" server config init --dbms="PostgreSQL" --name="ShipLoading" --db-server="192.168.31.139" --db-name="ShipLoading" --db-user="postgres" --db-pwd="postgres" --out="G:\Temp\ShipLoading\config.yml"