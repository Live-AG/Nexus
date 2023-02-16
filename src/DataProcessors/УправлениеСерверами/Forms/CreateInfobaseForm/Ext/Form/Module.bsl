
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ObjectChange = Parameters.ObjectFieldValues <> Undefined;
	ClusterParameters = Parameters.ClusterSettings;
	ConnectionParameters = Parameters.ConnectionSettings;
	// заполняем список выбора безопасности соединения
	Items.ItemSecureConnection.ChoiceList.Add(
		AdministrationConnectionSecurityLevel.Secure, NStr("ru = 'Постоянно';SYS='CreateInfobaseSecurityLevel.Secure'", "ru"));
	Items.ItemSecureConnection.ChoiceList.Add(
		AdministrationConnectionSecurityLevel.Unsecure, NStr("ru = 'Выключено';SYS='CreateInfobaseSecurityLevel.Unsecure'", "ru"));
	Items.ItemSecureConnection.ChoiceList.Add(
		AdministrationConnectionSecurityLevel.SecureOnConnect, NStr("ru = 'Только соединение';SYS='CreateInfobaseSecurityLevel.SecureOnConnect'", "ru"));
	// заполняем список выбора тип СУБД
	Items.ItemDBMSType.ChoiceList.Add("MSSQLServer", "MSSQLServer");
	Items.ItemDBMSType.ChoiceList.Add("PostgreSQL", "PostgreSQL");
	Items.ItemDBMSType.ChoiceList.Add("IBMDB2", "IBMDB2");
	Items.ItemDBMSType.ChoiceList.Add("OracleDatabase", "OracleDatabase");
	ListOfExistingObjectNames = New Structure("ListOfObjects", Parameters.ListOfObjects);
	ObjectChange = Parameters.ObjectFieldValues <> Undefined;
	SecureConnection = AdministrationConnectionSecurityLevel.Unsecure;
	Language = CurrentLocaleCode();
	Items.ItemDateOffset.ChoiceList.Add(0, "0");
	Items.ItemDateOffset.ChoiceList.Add(2000, "2000");
	DateOffset = 0;
	AllowIssueLicenses = True;
	ThisStandartProcessing = FormAttributeToValue("object");
	DocumentationLink = ThisStandartProcessing.GetLinkDocumentation("create infobase");
	If IsBlankString(DocumentationLink) Then
		Items.ItemDocumentationLink.Visible = False;
	EndIf;
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
Procedure AddInfobaseInCluster()
	Cluster = GetCluster(ConnectionParameters, ClusterParameters);
	NewInfobase = Cluster.CreateInfoBase();
	NewInfobase.Name = Name;
	NewInfobase.ConnectionsSecurityLevel = SecureConnection;
	NewInfobase.Description = Description;
	NewInfobase.DataBaseServer = DataBaseServer;
	NewInfobase.DBMS = DBMSType;
	NewInfobase.DataBaseName = DataBase;
	NewInfobase.DatabaseUser = DataBaseServerUser;
	NewInfobase.DataBaseUserPassword = DataBaseUserPassword;
	NewInfobase.AllowLicenseDistribution = AllowIssueLicenses;
	NewInfobase.LanguageCode = Language;
	NewInfobase.DateOffset = DateOffset;
	NewInfobase.CreateDatabase = CreateDatabase;
	NewInfobase.LockScheduledJobs = SetBlockRoutineTasks;
	NewInfobase.Write();	
EndProcedure

&AtClient
Procedure WriteInfobaseAndCloseForm(Command)
	If CheckFilling() Then
		If IsInfobaseNameUnique() Then
			AddInfobaseInCluster();
			Close();
		Else
			Message(NStr("ru = 'Информационная база с таким именем уже существует.
					|Введите уникальное имя или перейдите к изменению существующей информационной базы.';SYS='CreateInfobase.AlreadyExists'", "ru"));
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
