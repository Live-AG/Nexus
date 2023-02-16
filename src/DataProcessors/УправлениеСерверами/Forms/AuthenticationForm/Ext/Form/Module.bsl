&AtServerNoContext
Function GetAdministrationAgent(ConnectionSettings)
	AdministrationAgent = New ServerAdministration(ConnectionSettings.AdministrationServerAgent, 
															ConnectionSettings.AdministrationServerPort);
	AdministrationAgent.Authenticate(ConnectionSettings.Login, ConnectionSettings.Password);
	Return AdministrationAgent;
EndFunction

&AtServer
Function CheckClusterPassword()
	Var AdministrationAgent, Clusters;  
	AdministrationAgent = GetAdministrationAgent(ConnectionParameters);
	Clusters = AdministrationAgent.GetClusters();
	For each Cluster In Clusters Do
		If Cluster.Name = ClusterName Then
			Cluster.Authenticate(Name, Password);
			Cluster.GetClusterAdministrators();
			Return True;
		EndIf;
	EndDo;	
EndFunction 

&AtClient
Procedure AuthenticateAndCloseForm(Command)
	Var CorrectData, ClosingOptions;
	CorrectData = CheckClusterPassword();
	If CorrectData Then
		ClosingOptions = New Structure();
		ClosingOptions.Insert("Name", Name);
		ClosingOptions.Insert("Password", Password);
		ClosingOptions.Insert("CurrentTreeLine", TreeLine);
		Close(ClosingOptions);	
	EndIf;
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ConnectionParameters = Parameters.ConnectionSettings;
	ClusterName = Parameters.ClusterName;
	TreeLine = Parameters.Line;
EndProcedure

&AtClient
Procedure DocumentationHelp(Command)
	// Вставить содержимое обработчика.
EndProcedure
