//Создание базы
				ClusterSettings = GetClusterParameters(Parent);
				ConnectionSettings = GetServerAdministrationParameters(Parent);
				InfoBaseStructure = New Structure();
				InfoBaseStructure.Insert("ItemUUID", CurrentTreeLine.ItemUUID);
				AdministratorSettings = ClusterAndInfobaseUserAuthenticationSettings.Get(CurrentTreeLine.ItemUUID);
				If AdministratorSettings = Undefined Then
					InfoBaseStructure.Insert("User", "");
					InfoBaseStructure.Insert("Password", "");
				Else
					InfoBaseStructure.Insert("User", AdministratorSettings.Name);
					InfoBaseStructure.Insert("Password", AdministratorSettings.Password);
				EndIf;
				If CheckRuleToChangeInfoBase(ConnectionSettings, ClusterSettings, 
						InfoBaseStructure) = Undefined Then	
					OpenFormSettings.Insert("InfobaseName", CurrentTreeLine.Name);
					OpenFormSettings.Insert("ClusterSettings", ClusterSettings);
					OpenFormSettings.Insert("ConnectionSettings", ConnectionSettings);
					OpenFormSettings.Insert("InfoBaseStructure", InfoBaseStructure);
					ProcessingClosingNotify = New NotifyDescription("ProcessingCreationInfobase", ThisObject);
					OpenForm(GetFormName("InfobaseEditForm"), OpenFormSettings,
								  ThisObject, ProcessingClosingNotify,,,,FormWindowOpeningMode.LockOwnerWindow);
				Else
					OpenAuthenticationInfobaseForm(ConnectionSettings, ClusterSettings, CurrentTreeLine.ItemUUID, CurrentTreeData);				  
				EndIf;	
				




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



	&AtServerNoContext
Function GetCluster(ConnectionSettings, ClusterSettings)
	AdministrationAgent = GetAdministrationAgent(ConnectionSettings);
	Clusters = AdministrationAgent.GetClusters();
	For each Cluster in Clusters do
		If Cluster.Name = ClusterSettings.Name Then
			Trysudo ./webinst -publish -apache24 -wsdir <ИМЯ ПУБЛИКАЦИИ> -dir /var/www/<ИМЯ ПУБЛИКАЦИИ> -connstr “Srvr=<ИМЯ СЕРВЕРА;Ref=<ИМЯ БАЗЫ>” -confpath /etc/apache2/apache2.conf
				Cluster.Authenticate(ClusterSettings.User, ClusterSettings.Password);
			Except
				
			EndTry;
			Return Cluster;
		EndIf;
	EndDo;
EndFunction


&AtServerNoContext
Function GetAdministrationAgent(ConnectionSettings)
	AdministrationAgent = New ServerAdministration(ConnectionSettings.AdministrationServerAgent, 
															ConnectionSettings.AdministrationServerPort);
	AdministrationAgent.Authenticate(ConnectionSettings.Login, ConnectionSettings.Password);
	Return AdministrationAgent;
EndFunction




sudo ./webinst -publish -apache24 -wsdir Nexus -dir /var/www/Nexus -connstr "Srvr=192.168.31.139;Ref=TestDB3" -confpath /etc/apache2/apache2.conf