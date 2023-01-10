<<<<<<< HEAD
﻿
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ClusterParameters = Parameters.ClusterSettings;
	ConnectionParameters = Parameters.ConnectionSettings;
	InfoBaseStructure = Parameters.InfoBaseStructure;
	// заполняем список выбора безопасности соединения
	Items.ItemSecureConnection.ChoiceList.Add(
		AdministrationConnectionSecurityLevel.Secure, NStr("ru = 'Постоянно'; SYS='EditInfoBaseConnectionType.Secure'", "ru"));
	Items.ItemSecureConnection.ChoiceList.Add(
		AdministrationConnectionSecurityLevel.Unsecure, NStr("ru = 'Выключено'; SYS='EditInfoBaseConnectionType.Unsecure'", "ru"));
	Items.ItemSecureConnection.ChoiceList.Add(
		AdministrationConnectionSecurityLevel.SecureOnConnect, NStr("ru = 'Только соединение'; SYS='EditInfoBaseConnectionType.SecureOnConnect'", "ru"));
	// заполняем список выбора тип СУБД
	Items.ItemDBMSType.ChoiceList.Add("MSSQLServer", "MSSQLServer");
	Items.ItemDBMSType.ChoiceList.Add("PostgreSQL", "PostgreSQL");
	Items.ItemDBMSType.ChoiceList.Add("IBMDB2", "IBMDB2");
	Items.ItemDBMSType.ChoiceList.Add("OracleDatabase", "OracleDatabase");
	ListOfExistingObjectNames = New Structure("ListOfObjects", Parameters.ListOfObjects);
	FillInfobaseProperty(Parameters.InfobaseName);
	ThisStandartProcessing = FormAttributeToValue("object");
	DocumentationLink = ThisStandartProcessing.GetLinkDocumentation("edit infobase");
	If IsBlankString(DocumentationLink) Then
		Items.ItemDocumentationLink.Visible = False;
	EndIf;
EndProcedure

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
Procedure FillInfobaseProperty(InfoBaseName)
	Cluster = GetCluster(ConnectionParameters, ClusterParameters);
	for each InfoBase in Cluster.GetInfoBases() Do
		If InfoBase.Name = InfoBaseName Then
			InfoBase.Authenticate(InfoBaseStructure.User, InfoBaseStructure.Password);
			LockJobRequestsEnabled = InfoBase.LockScheduledJobs;
			SessionStartLockingEnabled = InfoBase.SessionsLockEnabled;
			LockStartTime = InfoBase.LockBeginTime;
			LockTimeEnd = InfoBase.LockEndTime;
			DataBase = InfoBase.DataBaseName;
			PermissonCode = InfoBase.SessionStartPermissionCode;
			SureUseExternalControl = InfoBase.ExternalSessionManagementRequired;
			Description = InfoBase.Description;
			LockParameter = InfoBase.LockParameter;
			DataBaseUserPassword = InfoBase.DataBaseUserPassword;
			DatabaseServerUser = InfoBase.DatabaseUser;
			SecureProfile = InfoBase.SecurityProfile;
			SafeModeSecurityProfile = InfoBase.SafeModeSecurityProfile;
			AllowIssueLicenses = InfoBase.AllowLicenseDistribution;
			DatabaseServer = InfoBase.DataBaseServer;
			PermissionMessage = InfoBase.LockMessage;
			ExternalSessionManagement = InfoBase.ExternalSessionManagementConnectionString;
			DBMSType = InfoBase.DBMS;
			Name = InfoBase.Name;
			SecureConnection = InfoBase.ConnectionsSecurityLevel;
			ReserveWorkingProcesses = InfoBase.ReserveWorkingProcesses;
		EndIf;
	EndDo;
EndProcedure

&AtClient
Function IsInfobaseNameUnique()
	Var Result;
	Result = True;
	For each ExistingObjectName In ListOfExistingObjectNames.ListOfObjects Do
		If (Lower(Name) = Lower(ExistingObjectName)) Then
			Result = False;
			Break;
		EndIf;
	EndDo;
	Return Result;
EndFunction

&AtServer
Procedure UpdateInfobaseSettingsInCluster()
	Cluster = GetCluster(ConnectionParameters, ClusterParameters);
	For each InfoBase In Cluster.GetInfoBases() Do
		If InfoBase.Name = Name Then
			InfoBase.Authenticate(InfoBaseStructure.User, InfoBaseStructure.Password);
			InfoBase.LockScheduledJobs = LockJobRequestsEnabled;
			InfoBase.SessionsLockEnabled = SessionStartLockingEnabled;
			InfoBase.LockBeginTime = LockStartTime;
			InfoBase.LockEndTime = LockTimeEnd;
			InfoBase.DataBaseName = DataBase;
			InfoBase.SessionStartPermissionCode = PermissonCode;
			InfoBase.ExternalSessionManagementRequired = SureUseExternalControl;
			InfoBase.Description = Description;
			InfoBase.LockParameter = LockParameter;
			InfoBase.DataBaseUserPassword = DataBaseUserPassword;
			InfoBase.DatabaseUser = DatabaseServerUser;
			InfoBase.SecurityProfile = SecureProfile;
			InfoBase.SafeModeSecurityProfile = SafeModeSecurityProfile;
			InfoBase.AllowLicenseDistribution = AllowIssueLicenses;
			InfoBase.DataBaseServer = DatabaseServer;
			InfoBase.LockMessage = PermissionMessage;
			InfoBase.ExternalSessionManagementConnectionString = ExternalSessionManagement;
			InfoBase.DBMS = DBMSType;
			InfoBase.ReserveWorkingProcesses = ReserveWorkingProcesses;
			InfoBase.Write();
		EndIf;
	EndDo;
EndProcedure

&AtClient
Procedure WriteInfobaseAndClose(Command)
	If CheckFilling() Then
		If IsInfobaseNameUnique() Then
			UpdateInfobaseSettingsInCluster();
			Close();
		Else
			Message(Nstr("ru = 'Информационная база с таким именем уже существует.
					|Введите уникальное имя или перейдите к изменению существующей информационной базы.';SYS='EditInfobase.InfobaseAlreadyExists'", "ru"));
		EndIf;
	EndIf;
EndProcedure

&AtClient
Procedure ItemDocumentationLinkClick(Item)
	GotoURL(DocumentationLink);
EndProcedure

&AtClient
Procedure DocumentationHelp(Command)
	GotoURL(DocumentationLink);
EndProcedure


=======
﻿
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ClusterParameters = Parameters.ClusterSettings;
	ConnectionParameters = Parameters.ConnectionSettings;
	InfoBaseStructure = Parameters.InfoBaseStructure;
	// заполняем список выбора безопасности соединения
	Items.ItemSecureConnection.ChoiceList.Add(
		AdministrationConnectionSecurityLevel.Secure, NStr("ru = 'Постоянно'; SYS='EditInfoBaseConnectionType.Secure'", "ru"));
	Items.ItemSecureConnection.ChoiceList.Add(
		AdministrationConnectionSecurityLevel.Unsecure, NStr("ru = 'Выключено'; SYS='EditInfoBaseConnectionType.Unsecure'", "ru"));
	Items.ItemSecureConnection.ChoiceList.Add(
		AdministrationConnectionSecurityLevel.SecureOnConnect, NStr("ru = 'Только соединение'; SYS='EditInfoBaseConnectionType.SecureOnConnect'", "ru"));
	// заполняем список выбора тип СУБД
	Items.ItemDBMSType.ChoiceList.Add("MSSQLServer", "MSSQLServer");
	Items.ItemDBMSType.ChoiceList.Add("PostgreSQL", "PostgreSQL");
	Items.ItemDBMSType.ChoiceList.Add("IBMDB2", "IBMDB2");
	Items.ItemDBMSType.ChoiceList.Add("OracleDatabase", "OracleDatabase");
	ListOfExistingObjectNames = New Structure("ListOfObjects", Parameters.ListOfObjects);
	FillInfobaseProperty(Parameters.InfobaseName);
	ThisStandartProcessing = FormAttributeToValue("object");
	DocumentationLink = ThisStandartProcessing.GetLinkDocumentation("edit infobase");
	If IsBlankString(DocumentationLink) Then
		Items.ItemDocumentationLink.Visible = False;
	EndIf;
EndProcedure

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
Procedure FillInfobaseProperty(InfoBaseName)
	Cluster = GetCluster(ConnectionParameters, ClusterParameters);
	for each InfoBase in Cluster.GetInfoBases() Do
		If InfoBase.Name = InfoBaseName Then
			InfoBase.Authenticate(InfoBaseStructure.User, InfoBaseStructure.Password);
			LockJobRequestsEnabled = InfoBase.LockScheduledJobs;
			SessionStartLockingEnabled = InfoBase.SessionsLockEnabled;
			LockStartTime = InfoBase.LockBeginTime;
			LockTimeEnd = InfoBase.LockEndTime;
			DataBase = InfoBase.DataBaseName;
			PermissonCode = InfoBase.SessionStartPermissionCode;
			SureUseExternalControl = InfoBase.ExternalSessionManagementRequired;
			Description = InfoBase.Description;
			LockParameter = InfoBase.LockParameter;
			DataBaseUserPassword = InfoBase.DataBaseUserPassword;
			DatabaseServerUser = InfoBase.DatabaseUser;
			SecureProfile = InfoBase.SecurityProfile;
			SafeModeSecurityProfile = InfoBase.SafeModeSecurityProfile;
			AllowIssueLicenses = InfoBase.AllowLicenseDistribution;
			DatabaseServer = InfoBase.DataBaseServer;
			PermissionMessage = InfoBase.LockMessage;
			ExternalSessionManagement = InfoBase.ExternalSessionManagementConnectionString;
			DBMSType = InfoBase.DBMS;
			Name = InfoBase.Name;
			SecureConnection = InfoBase.ConnectionsSecurityLevel;
			ReserveWorkingProcesses = InfoBase.ReserveWorkingProcesses;
		EndIf;
	EndDo;
EndProcedure

&AtClient
Function IsInfobaseNameUnique()
	Var Result;
	Result = True;
	For each ExistingObjectName In ListOfExistingObjectNames.ListOfObjects Do
		If (Lower(Name) = Lower(ExistingObjectName)) Then
			Result = False;
			Break;
		EndIf;
	EndDo;
	Return Result;
EndFunction

&AtServer
Procedure UpdateInfobaseSettingsInCluster()
	Cluster = GetCluster(ConnectionParameters, ClusterParameters);
	For each InfoBase In Cluster.GetInfoBases() Do
		If InfoBase.Name = Name Then
			InfoBase.Authenticate(InfoBaseStructure.User, InfoBaseStructure.Password);
			InfoBase.LockScheduledJobs = LockJobRequestsEnabled;
			InfoBase.SessionsLockEnabled = SessionStartLockingEnabled;
			InfoBase.LockBeginTime = LockStartTime;
			InfoBase.LockEndTime = LockTimeEnd;
			InfoBase.DataBaseName = DataBase;
			InfoBase.SessionStartPermissionCode = PermissonCode;
			InfoBase.ExternalSessionManagementRequired = SureUseExternalControl;
			InfoBase.Description = Description;
			InfoBase.LockParameter = LockParameter;
			InfoBase.DataBaseUserPassword = DataBaseUserPassword;
			InfoBase.DatabaseUser = DatabaseServerUser;
			InfoBase.SecurityProfile = SecureProfile;
			InfoBase.SafeModeSecurityProfile = SafeModeSecurityProfile;
			InfoBase.AllowLicenseDistribution = AllowIssueLicenses;
			InfoBase.DataBaseServer = DatabaseServer;
			InfoBase.LockMessage = PermissionMessage;
			InfoBase.ExternalSessionManagementConnectionString = ExternalSessionManagement;
			InfoBase.DBMS = DBMSType;
			InfoBase.ReserveWorkingProcesses = ReserveWorkingProcesses;
			InfoBase.Write();
		EndIf;
	EndDo;
EndProcedure

&AtClient
Procedure WriteInfobaseAndClose(Command)
	If CheckFilling() Then
		If IsInfobaseNameUnique() Then
			UpdateInfobaseSettingsInCluster();
			Close();
		Else
			Message(Nstr("ru = 'Информационная база с таким именем уже существует.
					|Введите уникальное имя или перейдите к изменению существующей информационной базы.';SYS='EditInfobase.InfobaseAlreadyExists'", "ru"));
		EndIf;
	EndIf;
EndProcedure

&AtClient
Procedure ItemDocumentationLinkClick(Item)
	GotoURL(DocumentationLink);
EndProcedure

&AtClient
Procedure DocumentationHelp(Command)
	GotoURL(DocumentationLink);
EndProcedure


>>>>>>> f3f19a63ed53bdfa614d9191f48ffaf36859af97
