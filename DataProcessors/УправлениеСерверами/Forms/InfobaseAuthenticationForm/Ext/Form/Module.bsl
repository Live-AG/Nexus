&AtServerNoContext
Function GetAdministrationAgent(ConnectionSettings)
	AdministrationAgent = New ServerAdministration(ConnectionSettings.AdministrationServerAgent, 
															ConnectionSettings.AdministrationServerPort);
	AdministrationAgent.Authenticate(ConnectionSettings.Login, ConnectionSettings.Password);
	Return AdministrationAgent;
EndFunction

&AtServerNoContext
Function GetCluster(ConnectionSettings, ClusterSettings)
	AdministrationAgent = GetAdministrationAgent(ConnectionSettings);
	Clusters = AdministrationAgent.GetClusters();
	For each Cluster in Clusters do
		If Cluster.Name = ClusterSettings.Name Then
			Try
				Cluster.Authenticate(ClusterSettings.User, ClusterSettings.Password);
			Except
				
			EndTry;
			Return Cluster;
		EndIf;
	EndDo;
EndFunction

&AtServer
Procedure InfobaseAuthenticationAtServer()
	Cluster = GetCluster(ConnectionParameters, ClusterParameters);
	Infobases = Cluster.GetInfoBases();
	For each Infobase In Infobases Do
		If Infobase.InfobaseID = InfobaseID Then
			Infobase.Authenticate(Name, Password);
			Break;
		EndIf;
	EndDo;	
EndProcedure

&AtClient
Procedure InfobaseAuthentication(Command)
	InfobaseAuthenticationAtServer();
	ClosingSettings = New Structure();
	ClosingSettings.Insert("Name", Name);
	ClosingSettings.Insert("Password", Password);
	ClosingSettings.Insert("Line", TreeLine);
	Close(ClosingSettings);	
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ConnectionParameters = Parameters.ConnectionSettings;
	ClusterParameters = Parameters.ClusterSettings;
	InfobaseID = Parameters.InfoBaseID;
	TreeLine = Parameters.Line;
EndProcedure

&AtClient
Procedure DocumentationHelp(Command)
	// Вставить содержимое обработчика.
EndProcedure
