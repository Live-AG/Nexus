&AtClient
Var ConnectionSettingsToAdministrationServers;    

&AtClient
Var ClusterAndInfobaseUserAuthenticationSettings;

&AtClient 
Var ClosingAllowed;

&AtClient
Var ExpandLine;

#Region EventFormRegion

// add new item
&AtClient
Procedure ClusterTreeBeforeAddRow(Item, Cancel, Copying, Parent, Group, Parameter)
	Var OpenFormParameters, ListOfExistingObjects, CurrentTreeData, CurrentTreeLine, 
			TreeObject, ProcessingClosingNotify;
	If ClusterTree.GetItems().Count() > 0 Then
		CurrentTreeData = Items.ClusterTree.CurrentRow;
		CurrentTreeLine = ClusterTree.FindByID(CurrentTreeData);
		ListOfExistingObjects = New Array();
		For each TreeObject In CurrentTreeLine.GetItems() Do
			ListOfExistingObjects.Add(TreeObject.Name);
		EndDo;
		OpenFormParameters = New Structure();
		OpenFormParameters.Insert("ListOfObjects", ListOfExistingObjects);
		OpenFormParameters.Insert("ObjectFieldValues", Undefined); 
		If (CurrentTreeLine.ItemGroup = True) Then
			Cancel = True;
			// New ras connection
			If CurrentTreeLine.AdministrationItemType = "AdministrationCentralServer" Then
				ProcessingClosingNotify = New NotifyDescription("ProcessingAuthenticationCentralServer", ThisObject);
				OpenFormParameters.Insert("ObjectChange", False);
				OpenForm(GetFormName("AuthenticateCentralServerForm"), OpenFormParameters,
							  ThisObject,,,,ProcessingClosingNotify,FormWindowOpeningMode.LockOwnerWindow);	
			EndIf;
			// new limit
			If CurrentTreeLine.AdministrationItemType = "ResourceConsumptionLimits" Then
				ProcessingClosingNotify = New NotifyDescription("ProcessingCreationNewResourceConsumptionLimit", ThisObject);
				OpenForm(GetFormName("ResourceLimitForm"), OpenFormParameters,
							  ThisObject,,,,ProcessingClosingNotify,FormWindowOpeningMode.LockOwnerWindow);
			// new counter	
			ElsIf (CurrentTreeLine.AdministrationItemType = "ResourceConsumptionCounters") Then
				ProcessingClosingNotify = New NotifyDescription("ProcessingCreationResourceConsumptionCounter", ThisObject);
				OpenForm(GetFormName("CounterForm"), OpenFormParameters,
							  ThisObject,,,,ProcessingClosingNotify,FormWindowOpeningMode.LockOwnerWindow);
			// new profile	
			ElsIf (CurrentTreeLine.AdministrationItemType = "SecurityProfiles") Then
				ProcessingClosingNotify = New NotifyDescription("ProcessingCreationSecurityProfile", ThisObject);
				OpenForm(GetFormName("SecurityProfileForm"), OpenFormParameters,
							  ThisObject,,,,ProcessingClosingNotify,FormWindowOpeningMode.LockOwnerWindow);
			// new cluster administration	
			ElsIf (CurrentTreeLine.AdministrationItemType = "ClusterAdministrators") Then
				ProcessingClosingNotify = New NotifyDescription("ProcessingCreationClusterAdministrator", ThisObject);
				OpenForm(GetFormName("AdministratorForm"), OpenFormParameters,
							  ThisObject,,,,ProcessingClosingNotify, FormWindowOpeningMode.LockOwnerWindow);
			// new work server
			ElsIf (CurrentTreeLine.AdministrationItemType = "WorkServers") Then
				ConnectionSettings = GetServerAdministrationParameters(CurrentTreeLine.GetParent());
				ClusterSettings = GetClusterParameters(CurrentTreeLine.GetParent());
				OpenFormParameters.Insert("ClusterSettings", ClusterSettings);
				OpenFormParameters.Insert("ConnectionSettings", ConnectionSettings);
				ProcessingClosingNotify = New NotifyDescription("ProcessingCreationWorkServer", ThisObject);
				OpenForm(GetFormName("WorkServerForm"), OpenFormParameters,
							  ThisObject,,,,ProcessingClosingNotify,FormWindowOpeningMode.LockOwnerWindow);
			// new virtual directory
			ElsIf (CurrentTreeLine.AdministrationItemType = "VirtualDirectories") Then
				ProfileName = CurrentTreeLine.GetParent().Name;
				OpenFormParameters.Insert("ProfileName", ProfileName);
				ProcessingClosingNotify = New NotifyDescription("ProcessingCreationVirtualDirectory", ThisObject);
				OpenForm(GetFormName("AllowedDirectoryForm"), OpenFormParameters,
							  ThisObject,,,,ProcessingClosingNotify,FormWindowOpeningMode.LockOwnerWindow);
			// new COM-class	
			ElsIf (CurrentTreeLine.AdministrationItemType = "AllowedComClasses") Then
				ProfileName = CurrentTreeLine.GetParent().Name;
				OpenFormParameters.Insert("ProfileName", ProfileName);
				ProcessingClosingNotify = New NotifyDescription("ProcessingCreationCOMClass", ThisObject);
				OpenForm(GetFormName("AllowedComObjectForm"), OpenFormParameters,
							  ThisObject,,,,ProcessingClosingNotify,FormWindowOpeningMode.LockOwnerWindow);
			// new addIn	
			ElsIf (CurrentTreeLine.AdministrationItemType = "AllowedAddIns") Then
				ProfileName = CurrentTreeLine.GetParent().Name;
				OpenFormParameters.Insert("ProfileName", ProfileName);
				ProcessingClosingNotify = New NotifyDescription("ProcessingCreationAddIn", ThisObject);
				OpenForm(GetFormName("AllowedExternalComponentForm"), OpenFormParameters,
							  ThisObject,,,,ProcessingClosingNotify,FormWindowOpeningMode.LockOwnerWindow);
			// new external module
			ElsIf (CurrentTreeLine.AdministrationItemType = "ExternalModules") Then
				ProfileName = CurrentTreeLine.GetParent().Name;
				OpenFormParameters.Insert("ProfileName", ProfileName);
				ProcessingClosingNotify = New NotifyDescription("ProcessingCreationExternalModule", ThisObject);
				OpenForm(GetFormName("AllowedModuleForm"), OpenFormParameters,
							  ThisObject,,,,ProcessingClosingNotify,FormWindowOpeningMode.LockOwnerWindow);
			// new alllowed application	
			ElsIf (CurrentTreeLine.AdministrationItemType = "AllowedApplications") Then
				ProfileName = CurrentTreeLine.GetParent().Name;
				OpenFormParameters.Insert("ProfileName", ProfileName);
				ProcessingClosingNotify = New NotifyDescription("ProcessingCreationAllowedApplication", ThisObject);
				OpenForm(GetFormName("AllowedApplicationForm"), OpenFormParameters,
							  ThisObject,,,,ProcessingClosingNotify,FormWindowOpeningMode.LockOwnerWindow);
			// new internet resource	
			ElsIf (CurrentTreeLine.AdministrationItemType = "InternetResources") Then
				ProfileName = CurrentTreeLine.GetParent().Name;
				OpenFormParameters.Insert("ProfileName", ProfileName);
				ProcessingClosingNotify = New NotifyDescription("ProcessingCreationInternetResource", ThisObject);
				OpenForm(GetFormName("AllowedInternetResourceForm"), OpenFormParameters,
							  ThisObject,,,,ProcessingClosingNotify,FormWindowOpeningMode.LockOwnerWindow);
			// new infobase
			ElsIf (CurrentTreeLine.AdministrationItemType = "InfoBases") Then
				ConnectionSettings = GetServerAdministrationParameters(CurrentTreeLine.GetParent());
				ClusterSettings = GetClusterParameters(CurrentTreeLine.GetParent());
				OpenFormParameters.Insert("ClusterSettings", ClusterSettings);
				OpenFormParameters.Insert("ConnectionSettings", ConnectionSettings);
				ProcessingClosingNotify = New NotifyDescription("ProcessingCreationInfobase", ThisObject);
				OpenForm(GetFormName("CreateInfobaseForm"), OpenFormParameters,
							  ThisObject,,,,ProcessingClosingNotify,FormWindowOpeningMode.LockOwnerWindow);
			// new cluster
			ElsIf (CurrentTreeLine.AdministrationItemType = "Clusters") Then
			    ConnectionSettings = GetServerAdministrationParameters(CurrentTreeLine.GetParent());
				OpenFormParameters.Insert("ConnectionSettings", ConnectionSettings);
				ProcessingClosingNotify = New NotifyDescription("ProcessingCreationInfobase", ThisObject);
				OpenForm(GetFormName("ClusterForm"), OpenFormParameters,
							  ThisObject,,,,ProcessingClosingNotify,FormWindowOpeningMode.LockOwnerWindow);				
			// new agent administrator 
			ElsIf (CurrentTreeLine.AdministrationItemType = "CentralServerAdministrators") Then
				ProcessingClosingNotify = New NotifyDescription("ProcessingCreationAgentAdministration", ThisObject);
				OpenForm(GetFormName("AdministratorForm"), OpenFormParameters,
							  ThisObject,,,,ProcessingClosingNotify,FormWindowOpeningMode.LockOwnerWindow);
			EndIf;		  
		Else
			Cancel = True;
			Message(Nstr("ru = 'Невозможно выполнить добавление этого элемента';SYS='MainForm.ErrorAddItem'", "ru"));
		EndIf;
		
	EndIf;
EndProcedure

&AtClient
Procedure HadlerOnActivateRow() Export
	Var CurrentTreeData, CurrentTreeLine, ReturnCode, ListOfExistObject;
	If ClusterTree.GetItems().Count() > 0 Then
		CurrentTreeData = Items.ClusterTree.CurrentRow;
		CurrentTreeLine = ClusterTree.FindByID(CurrentTreeData);
		ListOfExistObject = New Array();
		For each ExistObject in CurrentTreeLine.GetItems() Do
			ListOfExistObject.Add(ExistObject.Name);	
		EndDo;

		ConnectionSettings = GetServerAdministrationParameters(CurrentTreeLine.GetParent());
		ClusterSettings = GetClusterParameters(CurrentTreeLine.GetParent());
		ReturnCode = CheckRuleToChangeAdministrationServer(ConnectionSettings, ClusterSettings);
		If ReturnCode <> "" Then
			If ReturnCode = "CentralAgentAdministratorNotAuthenticated" Then
				OpenAgentAuthenticateForm(ConnectionSettings, CurrentTreeData, ListOfExistObject);
				Cancel = True;
			ElsIf ReturnCode = "ClusterAdministratorNotAuthenticated" Then
				OpenAuthenticationClusterForm(ConnectionSettings, ClusterSettings, CurrentTreeData);
				Cancel = True;	
				Return;
			EndIf;
		EndIf;
		Parent = CurrentTreeLine.GetParent();
		If Parent = Undefined Then
			Parent = CurrentTreeLine;
		EndIf;
		SessionTable.Clear();
		ConnectionsTable.Clear();
		CounterValueTable.Clear();
		DisplayListOfCommands(Parent.AdministrationItemType, CurrentTreeLine.AdministrationItemType, CurrentTreeLine.ItemGroup);
		If CurrentTreeLine.AdministrationItemType = "Connections" Then
			Items.TreeItemTablesGroup.CurrentPage = Items.ConnectionPageGroup;
			ConnectionsTable.Clear();
			FillConnectionsTable(ConnectionSettings, ClusterSettings);
		ElsIf CurrentTreeLine.AdministrationItemType = "Locks" Then
			Items.TreeItemTablesGroup.CurrentPage = Items.LocksPageGroup;
			Items.ItemLocksTable.Visible = True;
			LocksTable.Clear();
			FillLocksTable(ConnectionSettings, ClusterSettings);
		ElsIf CurrentTreeLine.AdministrationItemType = "Sessions" Then
			Items.TreeItemTablesGroup.CurrentPage = Items.SessionPageGroup;
			SessionTable.Clear();
			FillSessionTable(ConnectionSettings, ClusterSettings);
			SetUpSessionButtonsAvailability();
		ElsIf CurrentTreeLine.AdministrationItemType = "ResourceConsumptionLimits" Then
			Items.TreeItemTablesGroup.CurrentPage = Items.LimitPageGroup;
			TableLimits.Clear();
			FillLimitsTable(ConnectionSettings, ClusterSettings);
		ElsIf CurrentTreeLine.AdministrationItemType = "ResourceConsumptionCounters" Then
			Items.TreeItemTablesGroup.CurrentPage = Items.StandartInfoPageGroup;
			StandartInfoTable.Clear();
			FillCounterTable(ConnectionSettings, ClusterSettings);
		ElsIf CurrentTreeLine.AdministrationItemType = "SecurityProfiles" Then
			Items.TreeItemTablesGroup.CurrentPage = Items.StandartInfoPageGroup;
			StandartInfoTable.Clear();
			FillSecurityProfileTable(ConnectionSettings, ClusterSettings);
		ElsIf CurrentTreeLine.AdministrationItemType = "WorkProcesses" Then
			Items.TreeItemTablesGroup.CurrentPage = Items.WorkProcessPageGroup;
			WorkProcessTable.Clear();
			FillWorkProcessTable(ConnectionSettings, ClusterSettings);
		ElsIf CurrentTreeLine.AdministrationItemType = "ClusterManagers" Then
			Items.TreeItemTablesGroup.CurrentPage = Items.ClusterManagerPageGroup;
			ClusterManagerTable.Clear();
			FillClusterManagerTable(ConnectionSettings, ClusterSettings);
		ElsIf CurrentTreeLine.AdministrationItemType = "WorkServers" Then
			Items.TreeItemTablesGroup.CurrentPage = Items.StandartInfoPageGroup;
			StandartInfoTable.Clear();
			FillWorkServerTable(ConnectionSettings, ClusterSettings);
		ElsIf CurrentTreeLine.AdministrationItemType = "InfoBases" Then
			Items.TreeItemTablesGroup.CurrentPage = Items.StandartInfoPageGroup;
			StandartInfoTable.Clear();
			FillInfoBaseTable(ConnectionSettings, ClusterSettings);	
		ElsIf Parent <> Undefined And Parent.AdministrationItemType = "ResourceConsumptionCounters" Then
			Items.TreeItemTablesGroup.CurrentPage = Items.CounterPageGroup;
			CounterValueTable.Clear();
			FillCounterValueTable(ConnectionSettings, ClusterSettings, CurrentTreeLine.Name);	
			SetUpCounterButtonsAvailability();	
		ElsIf Parent <> Undefined And Parent.AdministrationItemType = "ClusterManagers" Then
			Items.TreeItemTablesGroup.CurrentPage = Items.StandartInfoPageGroup;
			StandartInfoTable.Clear();
			FillServiceTable(ConnectionSettings, ClusterSettings, CurrentTreeLine.ItemUUID);			
		ElsIf Parent <> Undefined And Parent.AdministrationItemType = "WorkServers" Then
			Items.TreeItemTablesGroup.CurrentPage = Items.AssignmentRulePageGroup;
			AssignmentRuleTable.Clear();
			FillAssignmentRuleTable(ConnectionSettings, ClusterSettings, CurrentTreeLine.Name);
		ElsIf CurrentTreeLine.AdministrationItemType = "VirtualDirectories" Then
			Items.TreeItemTablesGroup.CurrentPage = Items.StandartInfoPageGroup;
			StandartInfoTable.Clear();
			ProfileName = Parent.Name;
			FillVirtualDirectoryTable(ConnectionSettings, ClusterSettings, ProfileName);
		ElsIf CurrentTreeLine.AdministrationItemType = "AllowedComClasses" Then
			Items.TreeItemTablesGroup.CurrentPage = Items.StandartInfoPageGroup;
			StandartInfoTable.Clear();
			ProfileName = Parent.Name;
			FillAllowedComClassTable(ConnectionSettings, ClusterSettings, ProfileName);
		ElsIf CurrentTreeLine.AdministrationItemType = "AllowedAddIns" Then
			Items.TreeItemTablesGroup.CurrentPage = Items.StandartInfoPageGroup;
			StandartInfoTable.Clear();
			ProfileName = Parent.Name;
			FillAllowedAddInTable(ConnectionSettings, ClusterSettings, ProfileName);
		ElsIf CurrentTreeLine.AdministrationItemType = "ExternalModules" Then
			Items.TreeItemTablesGroup.CurrentPage = Items.StandartInfoPageGroup;
			StandartInfoTable.Clear();
			ProfileName = Parent.Name;
			FillAllowedExternalModuleTable(ConnectionSettings, ClusterSettings, ProfileName);	
		ElsIf CurrentTreeLine.AdministrationItemType = "AllowedApplications" Then
			Items.TreeItemTablesGroup.CurrentPage = Items.StandartInfoPageGroup;
			StandartInfoTable.Clear();
			ProfileName = Parent.Name;
			FillAllowedApplicationTable(ConnectionSettings, ClusterSettings, ProfileName);	
		ElsIf CurrentTreeLine.AdministrationItemType = "InternetResources" Then
			Items.TreeItemTablesGroup.CurrentPage = Items.StandartInfoPageGroup;
			StandartInfoTable.Clear();
			ProfileName = Parent.Name;
			FillInternetResourceTable(ConnectionSettings, ClusterSettings, ProfileName);	
		Else
			Items.TreeItemTablesGroup.CurrentPage = Items.EmptyPageGroup;
		EndIf;
	EndIf;
EndProcedure      

// On activate row
&AtClient
Procedure ClusterTreeOnActivateRow(Item)
	AttachIdleHandler("HadlerOnActivateRow", 0.1, True);
EndProcedure

// Command SaveSettingsInFile
&AtClient
Procedure SaveSettingsInFile(Command)
	ProcessingClosingNotify = New NotifyDescription("ProcessingCloseSaveSettingsForm", ThisObject);
	OpenForm(GetFormName("SaveSettingsForm"),,
							  ThisObject,,,,ProcessingClosingNotify, FormWindowOpeningMode.LockOwnerWindow);	
EndProcedure

// Command LoadSettingsFromFile
&AtClient
Procedure LoadSettingsFromFile(Command)
	ProcessingClosingNotify = New NotifyDescription("ProcessingCloseLoadSettingsForm", ThisObject);
	OpenForm(GetFormName("LoadSettingsForm"),,
							  ThisObject,,,, ProcessingClosingNotify, FormWindowOpeningMode.LockOwnerWindow);	 	
EndProcedure

// Edit existing item
&AtClient
Procedure ClusterTreeBeforeRowChange(Item, Cancel)
	Var OpenFormParameters, TreeObject, CurrentTreeData, CurrentTreeLine, AdministratorSettings,
								ListOfExistingObjects, ParametersStructure, InfoBaseStructure;
	If ClusterTree.GetItems().Count() > 0 Then
		CurrentTreeData = Items.ClusterTree.CurrentRow;
		CurrentTreeLine = ClusterTree.FindByID(CurrentTreeData);
		If (CurrentTreeLine.ItemGroup <> True) Then
			Parent = CurrentTreeLine.GetParent();
			ClusterSettings = GetClusterParameters(Parent);
			ConnectionSettings = GetServerAdministrationParameters(Parent);
			ListOfExistingObjects = New Array();
			For each TreeObject In CurrentTreeLine.GetItems() Do
				ListOfExistingObjects.Add(TreeObject.Name);
			EndDo;
			OpenFormSettings = New Structure();
			OpenFormSettings.Insert("ListOfObjects", ListOfExistingObjects);
			If (CurrentTreeLine.AdministrationItemType) = "Clusters" Then
			// edit limit
			ElsIf Parent.AdministrationItemType = "ResourceConsumptionLimits" Then
				ParametersStructure = GetParameterStructureLimit(ConnectionSettings, ClusterSettings, CurrentTreeLine.Name);	
				OpenFormSettings.Insert("ObjectFieldValues", ParametersStructure); 
				ProcessingClosingNotify = New NotifyDescription("ProcessingCreationNewResourceConsumptionLimit", ThisObject);
				OpenForm(GetFormName("ResourceLimitForm"), OpenFormSettings,
							  ThisObject,,,,ProcessingClosingNotify,FormWindowOpeningMode.LockOwnerWindow);
			// edit counter	
			ElsIf (Parent.AdministrationItemType = "ResourceConsumptionCounters") Then
				ParametersStructure = GetParameterStructureCounter(ConnectionSettings, ClusterSettings, CurrentTreeLine.Name);
				OpenFormSettings.Insert("ObjectFieldValues", ParametersStructure);
				ProcessingClosingNotify = New NotifyDescription("ProcessingCreationResourceConsumptionCounter", ThisObject);
				OpenForm(GetFormName("CounterForm"), OpenFormSettings,
							  ThisObject,,,,ProcessingClosingNotify,FormWindowOpeningMode.LockOwnerWindow);
			// edit profile
			ElsIf (Parent.AdministrationItemType = "SecurityProfiles") Then
				ParametersStructure = GetParameterStructureSecurityProfile(ConnectionSettings, ClusterSettings, CurrentTreeLine.Name);
				OpenFormSettings.Insert("ObjectFieldValues", ParametersStructure);
				ProcessingClosingNotify = New NotifyDescription("ProcessingCreationSecurityProfile", ThisObject);
				OpenForm(GetFormName("SecurityProfileForm"), OpenFormSettings,
							  ThisObject,,,,ProcessingClosingNotify,FormWindowOpeningMode.LockOwnerWindow);
			// edit virtual directory
			ElsIf (Parent.AdministrationItemType = "VirtualDirectories") Then
				ProfileName = Parent.GetParent().Name;
				ParametersStructure = GetParameterStructureVirtualDirectory(ConnectionSettings, ClusterSettings, ProfileName, CurrentTreeLine.Name);
				OpenFormSettings.Insert("ObjectFieldValues", ParametersStructure);
				OpenFormSettings.Insert("ProfileName", ProfileName);
				ProcessingClosingNotify = New NotifyDescription("ProcessingCreationVirtualDirectory", ThisObject);
				OpenForm(GetFormName("AllowedDirectoryForm"), OpenFormSettings,
							  ThisObject,,,,ProcessingClosingNotify,FormWindowOpeningMode.LockOwnerWindow);
			// edit COM-class
			ElsIf (Parent.AdministrationItemType = "AllowedComClasses") Then
				ProfileName = Parent.GetParent().Name;
				ParametersStructure = GetParameterStructureCOMClass(ConnectionSettings, ClusterSettings, ProfileName, CurrentTreeLine.Name);
				OpenFormSettings.Insert("ObjectFieldValues", ParametersStructure);
				OpenFormSettings.Insert("ProfileName", ProfileName);

				ProcessingClosingNotify = New NotifyDescription("ProcessingCreationCOMClass", ThisObject);
				OpenForm(GetFormName("AllowedComObjectForm"), OpenFormSettings,
							  ThisObject,,,,ProcessingClosingNotify,FormWindowOpeningMode.LockOwnerWindow);
			// edit addIn
			ElsIf (Parent.AdministrationItemType = "AllowedAddIns") Then
				ProfileName = Parent.GetParent().Name;
				ParametersStructure = GetParameterStructureAddIn(ConnectionSettings, ClusterSettings, ProfileName, CurrentTreeLine.Name);
				OpenFormSettings.Insert("ObjectFieldValues", ParametersStructure);
				OpenFormSettings.Insert("ProfileName", ProfileName);
				ProcessingClosingNotify = New NotifyDescription("ProcessingCreationAddIn", ThisObject);
				OpenForm(GetFormName("AllowedExternalComponentForm"), OpenFormSettings,
							  ThisObject,,,,ProcessingClosingNotify,FormWindowOpeningMode.LockOwnerWindow);
			// edit external module				  
			ElsIf (Parent.AdministrationItemType = "ExternalModules") Then
				ProfileName = Parent.GetParent().Name;
				ParametersStructure = GetParameterStructureExternalModule(ConnectionSettings, ClusterSettings, ProfileName, CurrentTreeLine.Name);
				OpenFormSettings.Insert("ObjectFieldValues", ParametersStructure);
				OpenFormSettings.Insert("ProfileName", ProfileName);
				ProcessingClosingNotify = New NotifyDescription("ProcessingCreationExternalModule", ThisObject);
				OpenForm(GetFormName("AllowedModuleForm"), OpenFormSettings,
							  ThisObject,,,,ProcessingClosingNotify,FormWindowOpeningMode.LockOwnerWindow);
			// edit application
			ElsIf (Parent.AdministrationItemType = "AllowedApplications") Then
				ProfileName = Parent.GetParent().Name;
				ParametersStructure = GetParameterStructureAllowedApplication(ConnectionSettings, ClusterSettings, ProfileName, CurrentTreeLine.Name);
				OpenFormSettings.Insert("ObjectFieldValues", ParametersStructure);
				OpenFormSettings.Insert("ProfileName", ProfileName);
				ProcessingClosingNotify = New NotifyDescription("ProcessingCreationAllowedApplication", ThisObject);
				OpenForm(GetFormName("AllowedApplicationForm"), OpenFormSettings,
							  ThisObject,,,,ProcessingClosingNotify,FormWindowOpeningMode.LockOwnerWindow);
			// edit internet resource
			ElsIf (Parent.AdministrationItemType = "InternetResources") Then
				ProfileName = Parent.GetParent().Name;
				ParametersStructure = GetParameterStructureInternetResource(ConnectionSettings, ClusterSettings, ProfileName, CurrentTreeLine.Name);
				OpenFormSettings.Insert("ObjectFieldValues", ParametersStructure);
				OpenFormSettings.Insert("ProfileName", ProfileName);
				ProcessingClosingNotify = New NotifyDescription("ProcessingCreationInternetResource", ThisObject);
				OpenForm(GetFormName("AllowedInternetResourceForm"), OpenFormSettings,
							  ThisObject,,,,ProcessingClosingNotify,FormWindowOpeningMode.LockOwnerWindow);
			// edit work process	
			ElsIf (Parent.AdministrationItemType = "WorkProcesses") Then
				ParametersStructure = GetParameterStructureWorkProcess(ConnectionSettings, ClusterSettings, CurrentTreeLine.ItemUUID);
				OpenFormSettings.Insert("ObjectFieldValues", ParametersStructure);
				If (ParametersStructure.Property("ComputerName")) Then
					OpenForm(GetFormName("WorkProcessForm"), OpenFormSettings,
							  ThisObject,,,,,FormWindowOpeningMode.LockOwnerWindow);
				Else
					Message(Nstr("ru = 'Элемент был изменен или удален'; SYS='MainForm.DeleteWorkProcess'", "ru"));
				EndIf;
			// edit cluster manager				  
			ElsIf (Parent.AdministrationItemType = "ClusterManagers") Then
				ParametersStructure = GetParameterStructureClusterManager(ConnectionSettings, ClusterSettings, CurrentTreeLine.Name);
				OpenFormSettings.Insert("ObjectFieldValues", ParametersStructure);
				OpenForm(GetFormName("ClusterManagerForm"), OpenFormSettings,
							  ThisObject,,,,,FormWindowOpeningMode.LockOwnerWindow);
			// edit work server
			ElsIf (Parent.AdministrationItemType = "WorkServers") Then
				ClusterSettings = GetClusterParameters(Parent);
				ConnectionSettings = GetServerAdministrationParameters(Parent);
				ParametersStructure = GetParameterStructureWorkServer(ConnectionSettings, ClusterSettings, CurrentTreeLine.Name);
				OpenFormSettings.Insert("ObjectFieldValues", ParametersStructure);
				OpenFormSettings.Insert("ClusterSettings", ClusterSettings);
				OpenFormSettings.Insert("ConnectionSettings", ConnectionSettings);
				ProcessingClosingNotify = New NotifyDescription("ProcessingCreationWorkServer", ThisObject);
				OpenForm(GetFormName("WorkServerForm"), OpenFormSettings,
							  ThisObject, ProcessingClosingNotify,,,,FormWindowOpeningMode.LockOwnerWindow);
			// edit infobase
			ElsIf (Parent.AdministrationItemType = "InfoBases") Then
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
			// edit cluster
			ElsIf (Parent.AdministrationItemType = "Clusters") Then
				ConnectionSettings = GetServerAdministrationParameters(Parent);
				OpenFormSettings.Insert("ConnectionSettings", ConnectionSettings);
				OpenFormSettings.Insert("ObjectFieldValues", CurrentTreeLine.Name);
				ProcessingClosingNotify = New NotifyDescription("ProcessingCreationInfobase", ThisObject);
				OpenForm(GetFormName("ClusterForm"), OpenFormSettings,
							  ThisObject,,,,ProcessingClosingNotify,FormWindowOpeningMode.LockOwnerWindow);
			// edit agent administrator
			ElsIf (Parent.AdministrationItemType = "CentralServerAdministrators") Then
				ConnectionSettings = GetServerAdministrationParameters(Parent);
				ParametersStructure = GetParameterStructureAgentAdministrator(ConnectionSettings, CurrentTreeLine.Name);
				OpenFormSettings.Insert("ObjectFieldValues", ParametersStructure);
				ProcessingClosingNotify = New NotifyDescription("ProcessingCreationAgentAdministration", ThisObject);
				OpenForm(GetFormName("AdministratorForm"), OpenFormSettings,
							  ThisObject,,,, ProcessingClosingNotify,FormWindowOpeningMode.LockOwnerWindow);	
			// edit cluster administrator
			ElsIf (Parent.AdministrationItemType = "ClusterAdministrators") Then
				ConnectionSettings = GetServerAdministrationParameters(Parent);
				ClusterSettings = GetClusterParameters(Parent);
				ParametersStructure = GetParameterStructureClusterAdministrator(ConnectionSettings, ClusterSettings, CurrentTreeLine.Name);
				OpenFormSettings.Insert("ObjectFieldValues", ParametersStructure);
				ProcessingClosingNotify = New NotifyDescription("ProcessingCreationClusterAdministrator", ThisObject);
				OpenForm(GetFormName("AdministratorForm"), OpenFormSettings,
							  ThisObject,,,, ProcessingClosingNotify,FormWindowOpeningMode.LockOwnerWindow);		
			// edit connection
			ElsIf (CurrentTreeLine.AdministrationItemType = "ServerAdministration") Then
				ProcessingClosingNotify = New NotifyDescription("ProcessingAuthenticationCentralServer", ThisObject);
				ConnectionSettings = GetServerAdministrationParameters(CurrentTreeLine);
				OpenFormParameters = New Structure();
				OpenFormParameters.Insert("ObjectChange", True);
				OpenFormParameters.Insert("AgentConnectionName", ConnectionSettings.Name); 
				OpenFormParameters.Insert("AdministrationServerAgent", ConnectionSettings.AdministrationServerAgent);
				OpenFormParameters.Insert("AdministrationServerPort", ConnectionSettings.AdministrationServerPort);	
				OpenFormParameters.Insert("Login", "");	
				OpenFormParameters.Insert("Password", "");
				OpenFormParameters.Insert("Line", CurrentTreeData); 
				OpenFormParameters.Insert("ListOfObjects", Undefined); 
				OpenForm(GetFormName("AuthenticateCentralServerForm"), OpenFormParameters,
							  ThisObject,,,,ProcessingClosingNotify,FormWindowOpeningMode.LockOwnerWindow);
			EndIf;
		EndIf;
	EndIf;
	Cancel = True;
EndProcedure

// On create at server
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	Var ThisStandartProcessing, SessionTemplate, CounterTemplate, AddressTemplate;
	FillClusterTreeConnectionList();
	// Session template
	ThisStandartProcessing = FormAttributeToValue("Object");
	SessionTemplate = ThisStandartProcessing.GetTemplate("SessionDataCompositionSchema");
	AddressTemplate = PutToTempStorage(SessionTemplate, UUID);
	SessionSettingsLinker.Initialize(New DataCompositionAvailableSettingsSource(AddressTemplate));
	SessionSettingsLinker.LoadSettings(SessionTemplate.DefaultSettings);
	
	// Counter value template
	CounterTemplate = ThisStandartProcessing.GetTemplate("CounterValueDataCompositionSchema");
	AddressTemplate = PutToTempStorage(CounterTemplate, UUID);
	CounterValueSettingsLinker.Initialize(New DataCompositionAvailableSettingsSource(AddressTemplate));
	CounterValueSettingsLinker.LoadSettings(CounterTemplate.DefaultSettings);
	MetaPath = FormAttributeToValue("Object").Metadata().FullName();
	
	SetConnectionTableData();
	
EndProcedure

&AtServer
Процедура SetConnectionTableData()
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	Кластеры1С.Ссылка,
	|	Кластеры1С.Наименование КАК Name,
	|	Кластеры1С.АдресСервераАдминистрирования КАК ServerAdministrationAddress,
	|	Кластеры1С.ПортСервераАдминистрирования КАК ServerAdministrationPort,
	|	Кластеры1С.ИмяАдминистратораКластера КАК Login,
	|	Кластеры1С.ПарольАдминистратораКластера КАК Password
	|ИЗ
	|	Справочник.Кластеры1С КАК Кластеры1С
	|ГДЕ
	|	Кластеры1С.Активен";
	
	Результат = Запрос.Выполнить();
	
	ConnectionTable.Загрузить(Результат.Выгрузить());

КонецПроцедуры

// On open
&AtClient
Procedure OnOpen(Cancel)
	Var RootElements, CentralServer, VertexID, ConnectionLine, NewCentralServer;
	RootElements = ClusterTree.GetItems();
	CentralServer = RootElements.Get(0).GetID();
	VertexID = ClusterTree.FindByID(CentralServer);
	ConnectionSettingsToAdministrationServers = New Map();
	If ClusterUserAuthenticationSettings.ClusterInfoBaseSettings = Undefined Then
		ClusterAndInfobaseUserAuthenticationSettings = New Map();
	Else
		ClusterAndInfobaseUserAuthenticationSettings = ClusterUserAuthenticationSettings.ClusterInfoBaseSettings;
	EndIf;
	For each ConnectionLine In ConnectionTable Do
		ConnectionSettings = New Structure();
		ConnectionSettings.Insert("Name", ConnectionLine.Name);
		ConnectionSettings.Insert("AdministrationServerAgent", ConnectionLine.ServerAdministrationAddress);
		ConnectionSettings.Insert("AdministrationServerPort", ConnectionLine.ServerAdministrationPort);
		ConnectionSettings.Insert("Login", ConnectionLine.Login);
		ConnectionSettings.Insert("Password", ConnectionLine.Password);
		ConnectionSettingsToAdministrationServers.Insert(ConnectionLine.Name, ConnectionSettings);
		NewCentralServer = VertexID.GetItems().Add();
		NewCentralServer.Name = ConnectionLine.Name;
		NewCentralServer.PictureIndex = 1;
		NewCentralServer.ItemGroup = False;
		NewCentralServer.AdministrationItemType = "ServerAdministration";
		NewCentralServer.GetItems().Add();
	EndDo;
EndProcedure

// removing elements
&AtClient
Procedure ClusterTreeBeforeDeleteRow(Item, Cancel)
	If ClusterTree.GetItems().Count() > 0 Then
		CurrentTreeData = Items.ClusterTree.CurrentRow;
		CurrentTreeLine = ClusterTree.FindByID(CurrentTreeData);
		Parent = CurrentTreeLine.GetParent();
		ClusterSettings = GetClusterParameters(Parent);
		ConnectionSettings = GetServerAdministrationParameters(Parent);	
		Cancel = True;
		If (CurrentTreeLine.ItemGroup = True) Then
			Message(Nstr("ru = 'Невозможно выполнить удаление группы элементов'; SYS='MainForm.DeleteGroup'", "ru"));
		Else
			ParametersStructure = New Structure();
			QuestionText = "";
			ParentItemType = CurrentTreeLine.GetParent().AdministrationItemType;
			// removing server
			If ParentItemType = "AdministrationCentralServer" Then
				ConnectionSettingsToAdministrationServers.Delete(CurrentTreeLine.Name);
				Cancel = False;
				Return;
				QuestionText = NStr("ru = 'Вы действительно хотите удалить 
						|соединение с сервером администрирования'; SYS='MainForm.DeleteConnection'", "ru");
			// removing cluster
			ElsIf ParentItemType = "Clusters" Then
				QuestionText = NStr("ru = 'Удаление кластера приведет к удалению его настроек и списка зарегистрированных информационных баз.
					|Вы действительно хотите удалить кластер?'; SYS='MainForm.DeleteCluster'", "ru");
			// removing infobase
			ElsIf ParentItemType = "InfoBases" Then
			    QuestionText = NStr("ru = 'Вы действительно хотите удалить информационную базу?'; SYS='MainForm.DeleteInfobase'", "ru");
			// removing workserver
			ElsIf ParentItemType = "WorkServers" Then
			    QuestionText = NStr("ru = 'После удаления рабочего сервера может потребоваться перезапуск клиентских приложений. 
						|Вы действительно хотите удалить рабочий сервер?'; SYS='MainForm.DeleteConnection'", "ru");
			// removing cluster administrator
			ElsIf ParentItemType = "ClusterAdministrators" Then
				QuestionText = NStr("ru = 'После удаления данные администратора будут потеряны.
							|Вы действительно хотите удалить администратора кластера?'; SYS='MainForm.DeleteClusterAdministrator'", "ru");
			// removing security profile
			ElsIf ParentItemType = "SecurityProfiles" Then
				QuestionText = NStr("ru = 'После удаления данные профиля безопасности будут потеряны.
							|Вы действительно хотите удалить профиль безопасности?'; SYS='MainForm.DeleteConnection'", "ru");
			// removing resource consumption counter
			ElsIf ParentItemType = "ResourceConsumptionCounters" Then
				QuestionText = NStr("ru = 'После удаления данные счетчика потребления ресурсов будут потеряны.
							|Вы действительно хотите удалить счетчик?';SYS='MainForm.DeleteCounter'", "ru");
			// removing resouce consumption limits
			ElsIf ParentItemType = "ResourceConsumptionLimits" Then
				QuestionText = NStr("ru = 'После удаления данные ограничения потребления ресурсов будут потеряны. 
							|Вы действительно хотите удалить ограничение?'; SYS='MainForm.DeleteLimit'", "ru");
			// removing virtual directory
			ElsIf ParentItemType = "VirtualDirectories" Then
				QuestionText = NStr("ru = 'После удаления данные о виртуальном каталоге будут потеряны. 
							|Вы действительно хотите удалить виртуальный каталог?'; SYS='MainForm.DeleteVirtualDirectory'", "ru");
				ProfileName = Parent.GetParent().Name;
			// removing COM-class 
			ElsIf ParentItemType = "AllowedComClasses" Then
				QuestionText = NStr("ru = 'После удаления данные о COM-классе будут потеряны.
							|Вы действительно хотите удалить COM-класс?'; SYS='MainForm.DeleteAllowedComClass'", "ru");
				ProfileName = Parent.GetParent().Name;;
			// removing AddIn 
			ElsIf ParentItemType = "AllowedAddIns" Then
				QuestionText = NStr("ru = 'После удаления данные о внешней компоненте будут потеряны.
						|Вы действительно хотите удалить внешнюю компоненту?'; SYS='MainForm.DeleteAllowedAddIn'", "ru");
				ProfileName = Parent.GetParent().Name;
			// removing external module
			ElsIf ParentItemType = "ExternalModules" Then
				QuestionText = NStr("ru = 'Удаление внешнего модуля приведет к потере данных о внешнем модуле. ,
						|Вы действительно хотите удалить внешний модуль'; SYS='MainForm.DeleteAllowedAddIn'", "ru");
				ProfileName = Parent.GetParent().Name;
			// removing allowed application
			ElsIf ParentItemType = "AllowedApplications" Then
				QuestionText = NStr("ru = 'Удаление приложения приведет к потере данных о приложении.
						|Вы действительно хотите удалить приложение?'; SYS='MainForm.DeleteAllowedApplication'", "ru");
				ProfileName = Parent.GetParent().Name;
			// removing internet resource
			ElsIf ParentItemType = "InternetResources" Then
				QuestionText = NStr("ru = 'Удаление ресурса интернет приведет к потере данных о ресурсе.
						|Вы действительно хотите удалить ресурс интернет'; SYS='MainForm.DeleteInternetResource'", "ru");
				ProfileName = Parent.GetParent().Name;
			// removing cluster admin
			ElsIf ParentItemType = "CentralServerAdministrators" Then
				QuestionText = NStr("ru = 'После удаления данные администратора будут потеряны.
							|Вы действительно хотите удалить администратора кластера?'; SYS='MainForm.DeleteServerAdministrator'", "ru");	
			EndIf;
			If Not IsBlankString(QuestionText) Then
				ParametersStructure.Insert("ParentItemType", ParentItemType);
				ParametersStructure.Insert("ConnectionSettings", ConnectionSettings);
				ParametersStructure.Insert("ClusterSettings", ClusterSettings);
				ParametersStructure.Insert("ObjectName", CurrentTreeLine.Name);
				ParametersStructure.Insert("ProfileName", ProfileName);
				ParametersStructure.Insert("ItemUUID", CurrentTreeLine.ItemUUID);
				ShowQueryBox(New NotifyDescription("GetUserDeletionApproval", 
					ThisObject, ParametersStructure), QuestionText, QuestionDialogMode.YesNo); 	
			EndIf;
		EndIf;
	EndIf;
EndProcedure

&AtClient
Procedure ClusterTreeSelection(Item, SelectedLine, Field, StandardProcessing)
	DisplayListOfTreeObjects(SelectedLine);
	Items.ClusterTree.Expand(SelectedLine, False);
EndProcedure

&AtClient
Function GetServerAdministrationParameters(val ParentObject)
	Var ConnectionSettings;
	ConnectionSettings = New Structure();
	While ParentObject <> Undefined Do
		If ParentObject.AdministrationItemType = "ServerAdministration" Then
			ConnectionSettings = ConnectionSettingsToAdministrationServers.Get(
					ParentObject.Name);
			Break;
		EndIf;
		ParentObject = ParentObject.GetParent();
	EndDo;
	Return ConnectionSettings;
EndFunction
	
&AtClient
Function GetClusterParameters(val ParentObject)
	Var ClusterSettings, AuthenticationData;
	ClusterSettings = New Structure();
	While ParentObject <> Undefined Do
		If ParentObject.AdministrationItemType = "Cluster" Then
			ClusterSettings.Insert("Name", ParentObject.Name);
			AuthenticationData = ClusterAndInfobaseUserAuthenticationSettings.Get(ParentObject.ItemUUID);
			If AuthenticationData = Undefined Then
				ClusterSettings.Insert("User", "");
				ClusterSettings.Insert("Password", "");
			Else
				ClusterSettings.Insert("User", AuthenticationData.Name);
				ClusterSettings.Insert("Password", AuthenticationData.Password);
			EndIf;
			ClusterSettings.Insert("AuthenticationCompleted", ParentObject.AuthenticationCompleted);
			Break;
		EndIf;
		ParentObject = ParentObject.GetParent();
	EndDo;
	Return ClusterSettings;
EndFunction

&AtClient
Procedure SaveAgentPassword(val Parent, AdministratorSettings)
	While Parent <> Undefined Do
 		If Parent.AdministrationItemType = "ServerAdministration" Then
			Parent.Login = AdministratorSettings.Name;
			Parent.Password = AdministratorSettings.Password;
			Parent.AuthenticationCompleted = True;
			Break;
		EndIf;
		Parent = Parent.GetParent();
	EndDo;	
EndProcedure

&AtClient
Procedure SaveClusterPassword(val Parent, AdministratorSettings)
	While Parent <> Undefined Do
 		If Parent.AdministrationItemType = "Cluster" Then
			Parent.Login = AdministratorSettings.Name;
			Parent.Password = AdministratorSettings.Password;
			Parent.AuthenticationCompleted = True;
			ClusterAndInfobaseUserAuthenticationSettings.Insert(
				Parent.ItemUUID, AdministratorSettings); 
			Break;
		EndIf;
		Parent = Parent.GetParent();
	EndDo;
EndProcedure

&AtClient
Procedure SaveInfobasePassword(val CurrentTreeLine, AdministratorSettings)
	
	While CurrentTreeLine <> Undefined Do
		
		If TypeOf(CurrentTreeLine) = Type("FormDataCollectionItem") Then
			ClusterAndInfobaseUserAuthenticationSettings.Insert(
				CurrentTreeLine.InfobaseID, AdministratorSettings);	
			Break;
		EndIf;		
		
		Parent = CurrentTreeLine.GetParent();
		
		If Parent = Undefined Then
			Break;
		EndIf;
		
		If Parent.AdministrationItemType = "InfoBases" Then
			ClusterAndInfobaseUserAuthenticationSettings.Insert(
				CurrentTreeLine.ItemUUID, AdministratorSettings); 
			Break;
		EndIf; 
		
		CurrentTreeLine = Parent;
	EndDo;	
	
EndProcedure

&AtClient
Procedure DisplayListOfTreeObjects(TreeLine)
	Var CurrentTreeLine, GroupItems, Parent, ListOfTreeObjects, ListOfObjectNames, 
		ObjectName, ClusterGroupItems, NewCluster; 
	CurrentTreeLine = ClusterTree.FindByID(TreeLine);
	GroupElements = CurrentTreeLine.GetItems();
	If GroupElements.Count() = 1 Then
		If GroupElements.Get(0).Name = "" Then
			GroupElements.Clear();
		EndIf;
	EndIf;
	Parent = CurrentTreeLine.GetParent();
	If Parent <> Undefined Then
		ClusterSettings = GetClusterParameters(CurrentTreeLine);	
		ConnectionSettings = GetServerAdministrationParameters(CurrentTreeLine);
		ParentItemType = CurrentTreeLine.GetParent().AdministrationItemType;
		If CurrentTreeLine.AdministrationItemType = "ResourceConsumptionLimits" Then
			ListOfTreeObjects = CurrentTreeLine.GetItems();
			ListOfTreeObjects.Clear();
			ListOfObjectNames = GetListOfLimitNames(ConnectionSettings, ClusterSettings);
			For each ObjectName In ListOfObjectNames Do
				AddItemToClusterTreeAtClient(ListOfTreeObjects, ObjectName, 39, False);
			EndDo;
		ElsIf CurrentTreeLine.AdministrationItemType = "ResourceConsumptionCounters" Then
			ListOfTreeObjects = CurrentTreeLine.GetItems();
			ListOfTreeObjects.Clear();
			ListOfObjectNames = GetListOfCounterNames(ConnectionSettings, ClusterSettings);
			For each ObjectName In ListOfObjectNames Do
				AddItemToClusterTreeAtClient(ListOfTreeObjects, ObjectName, 37, False);
			EndDo;
		ElsIf CurrentTreeLine.AdministrationItemType = "SecurityProfiles" Then
			ListOfTreeObjects = CurrentTreeLine.GetItems();
			ListOfTreeObjects.Clear();
	        ListOfObjectNames = GetSecurityProfileNames(ConnectionSettings, ClusterSettings);
			For each ObjectName In ListOfObjectNames Do
				AddSecurityProfileToClusterTreeAtClient(ListOfTreeObjects, "SecurityProfile", ObjectName, 23);
			EndDo;	
		ElsIf CurrentTreeLine.AdministrationItemType = "WorkProcesses" Then
			ListOfTreeObjects = CurrentTreeLine.GetItems();
			ListOfTreeObjects.Clear();
	        ListOfObjectNames = GetListOfWorkProcessNames(ConnectionSettings, ClusterSettings);
			Number = 0;
			If (ListOfObjectNames.Count() > 0) Then
				LastName = ListOfObjectNames[0].Name;
			EndIf;
			For each ObjectName In ListOfObjectNames Do
				If (LastName = ObjectName.Name) Then
					Number = Number + 1;
				Else
					LastName = ObjectName.Name;
					Number = 1;
				EndIf;
				AddItemToClusterTreeAtClient(ListOfTreeObjects, ObjectName.Name + " " + Number, 14, False,, ObjectName.ItemUUID);
			EndDo;
		ElsIf CurrentTreeLine.AdministrationItemType = "WorkServers" Then
			ListOfTreeObjects = CurrentTreeLine.GetItems();
			ListOfTreeObjects.Clear();
	        ListOfObjectNames = GetListOfWorkServerNames(ConnectionSettings, ClusterSettings);
			For each ObjectName In ListOfObjectNames Do
				AddItemToClusterTreeAtClient(ListOfTreeObjects, ObjectName, 7, False);
			EndDo;	
		ElsIf CurrentTreeLine.AdministrationItemType = "ClusterAdministrators" Then
			ListOfTreeObjects = CurrentTreeLine.GetItems();
			ListOfTreeObjects.Clear();
	        ListOfObjectNames = GetListOfClusterAdministratorNames(ConnectionSettings, ClusterSettings);
			For each ObjectName In ListOfObjectNames Do
				AddItemToClusterTreeAtClient(ListOfTreeObjects, ObjectName, 10, False);
			EndDo;
		ElsIf CurrentTreeLine.AdministrationItemType = "InfoBases" Then
			ListOfTreeObjects = CurrentTreeLine.GetItems();
			ListOfTreeObjects.Clear();
	        ListOfObjectNames = GetListOfInfoBaseNames(ConnectionSettings, ClusterSettings);
			For each ObjectName In ListOfObjectNames Do
				AddItemToClusterTreeAtClient(ListOfTreeObjects, ObjectName.Name, 5, False, "InformationBase", ObjectName.ItemUUID);
			EndDo;
		ElsIf CurrentTreeLine.AdministrationItemType = "ClusterManagers" Then
			ListOfTreeObjects = CurrentTreeLine.GetItems();
			ListOfTreeObjects.Clear();
	        ListOfObjectNames = GetListOfClusterManagerNames(ConnectionSettings, ClusterSettings);
			For each ObjectName In ListOfObjectNames Do
				AddItemToClusterTreeAtClient(ListOfTreeObjects, 
					ObjectName.Name, 12, False, ObjectName.ItemUUID);
			EndDo; 
		ElsIf CurrentTreeLine.AdministrationItemType = "SecurityProfile" Then
			ListOfTreeObjects = CurrentTreeLine.GetItems();
			ListOfTreeObjects.Clear();
			AddItemToClusterTreeAtClient(ListOfTreeObjects, NStr("ru = 'Виртуальные каталоги'; SYS = 'MainForm.VirtualDirectoriesName'", "ru"), 24, True, "VirtualDirectories");
			AddItemToClusterTreeAtClient(ListOfTreeObjects, NStr("ru = 'Разрешенные COM-классы'; SYS = 'MainForm.AllowedCOMClassesName'", "ru"), 26, True, "AllowedComClasses");
			AddItemToClusterTreeAtClient(ListOfTreeObjects, NStr("ru = 'Внешние компоненты'; SYS = 'MainForm.AddInsName'", "ru"), 28, True, "AllowedAddIns");
			AddItemToClusterTreeAtClient(ListOfTreeObjects, NStr("ru = 'Внешние модули'; SYS = 'MainForm.ExternalModulesName'", "ru"), 30, True, "ExternalModules");
			AddItemToClusterTreeAtClient(ListOfTreeObjects, NStr("ru = 'Разрешенные приложения'; SYS = 'MainForm.AllowedApplicationsName'", "ru"), 32, True, "AllowedApplications");
			AddItemToClusterTreeAtClient(ListOfTreeObjects, NStr("ru = 'Ресурсы интернет'; SYS = 'MainForm.InternetResourcesName'", "ru"), 34, True, "InternetResources");
		ElsIf CurrentTreeLine.AdministrationItemType = "VirtualDirectories" Then
			ProfileName = CurrentTreeLine.GetParent().Name;
			ListOfTreeObjects = CurrentTreeLine.GetItems();
			ListOfTreeObjects.Clear();
	        ListOfObjectNames = GetListOfVirtualDirectoryNames(ConnectionSettings, ClusterSettings, ProfileName);
			For each ObjectName In ListOfObjectNames Do
				AddItemToClusterTreeAtClient(ListOfTreeObjects, ObjectName, 25, False);
			EndDo;
		ElsIf CurrentTreeLine.AdministrationItemType = "AllowedComClasses" Then
			ProfileName = CurrentTreeLine.GetParent().Name;
			ListOfTreeObjects = CurrentTreeLine.GetItems();
			ListOfTreeObjects.Clear();
	        ListOfObjectNames = GetListOfCOMClassNames(ConnectionSettings, ClusterSettings, ProfileName);
			For each ObjectName In ListOfObjectNames Do
				AddItemToClusterTreeAtClient(ListOfTreeObjects, ObjectName, 27, False);
			EndDo;
		ElsIf CurrentTreeLine.AdministrationItemType = "AllowedAddIns" Then
			ProfileName = CurrentTreeLine.GetParent().Name;
			ListOfTreeObjects = CurrentTreeLine.GetItems();
			ListOfTreeObjects.Clear();
	        ListOfObjectNames = GetListOfAddInNames(ConnectionSettings, ClusterSettings, ProfileName);
			For each ObjectName In ListOfObjectNames Do
				AddItemToClusterTreeAtClient(ListOfTreeObjects, ObjectName, 29, False);
			EndDo;
		ElsIf CurrentTreeLine.AdministrationItemType = "ExternalModules" Then
			ProfileName = CurrentTreeLine.GetParent().Name;
			ListOfTreeObjects = CurrentTreeLine.GetItems();
			ListOfTreeObjects.Clear();
	        ListOfObjectNames = GetListOfExternalModuleNames(ConnectionSettings, ClusterSettings, ProfileName);
			For each ObjectName In ListOfObjectNames Do
				AddItemToClusterTreeAtClient(ListOfTreeObjects, ObjectName, 31, False);
			EndDo;
		ElsIf CurrentTreeLine.AdministrationItemType = "AllowedApplications" Then
			ProfileName = CurrentTreeLine.GetParent().Name;
			ListOfTreeObjects = CurrentTreeLine.GetItems();
			ListOfTreeObjects.Clear();
	        ListOfObjectNames = GetListOfAllowedApplicationNames(ConnectionSettings, ClusterSettings, ProfileName);
			For each ObjectName In ListOfObjectNames Do
				AddItemToClusterTreeAtClient(ListOfTreeObjects, ObjectName, 33, False);
			EndDo;
		ElsIf CurrentTreeLine.AdministrationItemType = "InternetResources" Then
			ProfileName = CurrentTreeLine.GetParent().Name;
			ListOfTreeObjects = CurrentTreeLine.GetItems();
			ListOfTreeObjects.Clear();
	        ListOfObjectNames = GetListOfInternetResourceNames(ConnectionSettings, ClusterSettings, ProfileName);
			For each ObjectName In ListOfObjectNames Do
				AddItemToClusterTreeAtClient(ListOfTreeObjects, ObjectName, 35, False);
			EndDo;
		ElsIf CurrentTreeLine.AdministrationItemType = "Clusters" Then
			ListOfTreeObjects = CurrentTreeLine.GetItems();
			ListOfTreeObjects.Clear();
	        ListOfObjectNames = GetListOfClusterNames(ConnectionSettings);
			For each ObjectName In ListOfObjectNames Do
				NewCluster = ListOfTreeObjects.Add();
				NewCluster.Name = ObjectName.Name;
				NewCluster.PictureIndex = 3;
				NewCluster.AdministrationItemType = "Cluster";
				NewCluster.ItemUUID = ObjectName.ItemUUID;
				ClusterGroupItems = NewCluster.GetItems();
				AddItemToClusterTreeAtClient(ClusterGroupItems, NStr("ru = 'Информационные базы'; SYS = 'MainForm.InfobaseNames'", "ru"), 4, True, "InfoBases");
				AddItemToClusterTreeAtClient(ClusterGroupItems, NStr("ru = 'Рабочие серверы'; SYS = 'MainForm.WorkServersNames'", "ru"), 6, True, "WorkServers");
				AddItemToClusterTreeAtClient(ClusterGroupItems, NStr("ru = 'Администраторы кластера'; SYS = 'MainForm.ClusterAdministratorNames'", "ru"), 9, True, "ClusterAdministrators");
				AddItemToClusterTreeAtClient(ClusterGroupItems, NStr("ru = 'Менеджеры кластера'; SYS = 'MainForm.ClusterManagerNames'", "ru"), 11, True, "ClusterManagers");
				AddItemToClusterTreeAtClient(ClusterGroupItems, NStr("ru = 'Рабочие процессы'; SYS = 'MainForm.WorkProcessNames'", "ru"), 13, True, "WorkProcesses");
				AddItemToClusterTreeAtClient(ClusterGroupItems, NStr("ru = 'Сеансы'; SYS = 'MainForm.SessionNames'", "ru"), 15, True, "Sessions");
				AddItemToClusterTreeAtClient(ClusterGroupItems, NStr("ru = 'Блокировки'; SYS = 'MainForm.LockNames'", "ru"), 17, True, "Locks");
				AddItemToClusterTreeAtClient(ClusterGroupItems, NStr("ru = 'Соединения'; SYS = 'MainForm.ConnectionNames'", "ru"), 20, True, "Connections");
				AddItemToClusterTreeAtClient(ClusterGroupItems, NStr("ru = 'Профили безопасности'; SYS = 'MainForm.SecurityProfileNames'", "ru"), 22, True, "SecurityProfiles");
				AddItemToClusterTreeAtClient(ClusterGroupItems, NStr("ru = 'Счетчики потребления ресурсов'; SYS = 'MainForm.CounterNames'", "ru"), 36, True, "ResourceConsumptionCounters");
				AddItemToClusterTreeAtClient(ClusterGroupItems, NStr("ru = 'Ограничения потребления ресурсов'; SYS = 'MainForm.LimitNames'", "ru"), 38, True, "ResourceConsumptionLimits");
			EndDo;
		ElsIf CurrentTreeLine.AdministrationItemType = "CentralServerAdministrators" Then
			ListOfTreeObjects = CurrentTreeLine.GetItems();
			ListOfTreeObjects.Clear();
			ListOfObjectNames = GetListOfServerAdministratorNames(ConnectionSettings);
			For each ObjectName In ListOfObjectNames Do
				AddItemToClusterTreeAtClient(ListOfTreeObjects, ObjectName, 10, False);
			EndDo;
		ElsIf CurrentTreeLine.AdministrationItemType = "ServerAdministration" Then
			ListOfTreeObjects = CurrentTreeLine.GetItems();
			ListOfTreeObjects.Clear();
			AddServerStructure(ConnectionSettings, TreeLine);
		EndIf;
	EndIf;
EndProcedure

&AtServerNoContext
Function CheckRuleToChangeAdministrationServer(ConnectionSettings, ClusterSettings)
	Var AdministrationAgent, Clusters, Cluster;
	If ConnectionSettings <> Undefined Then
		If ConnectionSettings.Count() > 0 Then
			AdministrationAgent = New ServerAdministration(ConnectionSettings.AdministrationServerAgent, 
																	ConnectionSettings.AdministrationServerPort);
			Try														
				AdministrationAgent.Authenticate(ConnectionSettings.Login, ConnectionSettings.Password);
			Except
				Return "CentralAgentAdministratorNotAuthenticated";
			EndTry;
			Clusters = AdministrationAgent.GetClusters();
			If ClusterSettings.Count() > 0 Then
				For each Cluster In Clusters Do
					If Cluster.Name = ClusterSettings.Name Then
						Break;
					EndIf;
				EndDo;
				Try
					Cluster.Authenticate(ClusterSettings.User, ClusterSettings.Password);
				Except
					Return "ClusterAdministratorNotAuthenticated";
				EndTry;
			EndIf;
		EndIf;
	EndIf;
EndFunction

&AtServerNoContext
Function CheckRuleToChangeInfoBase(ConnectionSettings, ClusterSettings, InfoBaseSettings)
	Var Cluster, InfoBase;
	Cluster = GetAdministrationCluster(ConnectionSettings, ClusterSettings);
	InfoBase = Cluster.GetInfoBases();
	For each InfoBase In InfoBase Do
		If InfoBase.InfoBaseID = InfoBaseSettings.ItemUUID Then
			Try
				InfoBase.Authenticate(InfoBaseSettings.User, InfoBaseSettings.Password);
			Except
				Return "InfobaseAdministratorNotAuthenticated";
			EndTry;
		EndIf;
	EndDo;
EndFunction

&AtClient
Procedure OpenAgentAuthenticateForm(ConnectionSettings, Line, ListOfExistObject)
	Var OpenFormParameters;
	OpenFormParameters = New Structure();                          
	OpenFormParameters.Insert("AgentConnectionName", ConnectionSettings.Name); 
	OpenFormParameters.Insert("AdministrationServerAgent", ConnectionSettings.AdministrationServerAgent);
	OpenFormParameters.Insert("AdministrationServerPort", ConnectionSettings.AdministrationServerPort);	
	OpenFormParameters.Insert("Login", "");	
	OpenFormParameters.Insert("Password", "");	
	OpenFormParameters.Insert("ListOfObjects", ListOfExistObject);
	
	OpenFormParameters.Insert("Line", Line);
	OpenFormParameters.Insert("ObjectChange", True);
	ProcessingClosingNotify = New NotifyDescription("ProcessingAuthenticationAgent", ThisObject);
	OpenForm(GetFormName("AuthenticateCentralServerForm"), 
		OpenFormParameters, ThisObject,,,,ProcessingClosingNotify, 
		FormWindowOpeningMode.LockWholeInterface);
EndProcedure

&AtClient
Procedure OpenAuthenticationInfobaseForm(ConnectionSettings, ClusterSettings, InfoBaseID, Line, 
	TableName = "ClusterTree", AfterCloseEvent = Undefined)
	
	Var OpenFormParameters;
	
	OpenFormParameters = New Structure();
	OpenFormParameters.Insert("ConnectionSettings", ConnectionSettings); 
	OpenFormParameters.Insert("ClusterSettings", ClusterSettings);
	OpenFormParameters.Insert("InfoBaseID", InfoBaseID);	
	OpenFormParameters.Insert("Line", Line);
	OpenFormParameters.Insert("ObjectChange", True); 
	
	ProcessingClosingNotify = New NotifyDescription("ProcessingInfobaseAuthentication", ThisObject, 
		New Structure("AfterCloseEvent,TableName", AfterCloseEvent, TableName));
		
	OpenForm(GetFormName("InfobaseAuthenticationForm"), 
		OpenFormParameters, ThisObject,,,,ProcessingClosingNotify, 
		FormWindowOpeningMode.LockWholeInterface);
EndProcedure

&AtClient
Procedure OpenAuthenticationClusterForm(ConnectionSettings, ClusterSettings, Line)
	Var OpenFormParameters, ProcessingClosingNotify;
	OpenFormParameters = New Structure();                          
	OpenFormParameters.Insert("ConnectionSettings", ConnectionSettings);
	OpenFormParameters.Insert("ClusterName", ClusterSettings.Name);
	OpenFormParameters.Insert("Line", Line);
	ProcessingClosingNotify = New NotifyDescription("ProcessingClusterAuthentication", ThisObject);
	OpenForm(GetFormName("AuthenticationForm"), 
		OpenFormParameters, ThisObject,,,,ProcessingClosingNotify, 
		FormWindowOpeningMode.LockWholeInterface);
EndProcedure

&AtClient
Procedure HadlerBeforeExpand() Export
	Var Line, CurrentTreeLine, GroupElements, ListOfExistObject, ReturnCode, ConnectionSettings, Value;
	Line = ExpandLine;
	CurrentTreeLine = ClusterTree.FindByID(Line);
	GroupElements = CurrentTreeLine.GetItems();
	ListOfExistObject = New Array();
	For each ExistObject in GroupElements Do
		ListOfExistObject.Add(ExistObject.Name);	
	EndDo;
	If CurrentTreeLine <> Undefined Then
		ClusterSettings = GetClusterParameters(CurrentTreeLine);	
		ConnectionSettings = GetServerAdministrationParameters(CurrentTreeLine);
		ReturnCode = CheckRuleToChangeAdministrationServer(ConnectionSettings, ClusterSettings);
		If ReturnCode <> Undefined Then
			If ReturnCode = "CentralAgentAdministratorNotAuthenticated" Then
				OpenAgentAuthenticateForm(ConnectionSettings, Line, ListOfExistObject);
				Cancel = True;
			ElsIf ReturnCode = "ClusterAdministratorNotAuthenticated" Then
				OpenAuthenticationClusterForm(ConnectionSettings, ClusterSettings, Line);
				Cancel = True;	
				Return;
			EndIf;
		EndIf;
	EndIf;
	DisplayListOfTreeObjects(Line);	
EndProcedure

&AtClient
Procedure HadlerBeforeClosing() Export
	SaveSettings = New Structure();
	ClosingAllowed = True;
	Close();
	SavingAdministrationConsoleSettings(ConnectionSettingsToAdministrationServers);	
EndProcedure

&AtClient
Procedure ClusterTreeBeforeExpand(Item, Line, Cancel)
	Var CurrentTreeLine, GroupElements;
	ExpandLine = Line;
	CurrentTreeLine = ClusterTree.FindByID(Line);
	GroupElements = CurrentTreeLine.GetItems();
	If GroupElements.Count() = 1 Then
		If GroupElements.Get(0).Name = "" Then
			GroupElements.Clear();
		EndIf;
	EndIf;
	AttachIdleHandler("HadlerBeforeExpand", 0.1, True);
EndProcedure

&AtClient
Procedure ItemConnectionsTableBeforeDeleteRow(Item, Cancel)
	Cancel = True;
EndProcedure

&AtClient
Procedure ItemLocksTableBeforeRowChange(Item, Cancel)
	Cancel = True;
EndProcedure

&AtClient
Procedure ItemLocksTableBeforeAddRow(Item, Cancel, Copying, Parent, Group, Parameter)
	Cancel = True;
EndProcedure

&AtClient
Procedure ItemLocksTableBeforeDeleteRow(Item, Cancel)
	Cancel = True;
EndProcedure

&AtClient
Procedure ItemConnectionsTableBeforeRowChange(Item, Cancel)
	Cancel = True;
EndProcedure

&AtClient
Procedure ItemConnectionsTableBeforeAddRow(Item, Cancel, Copying, Parent, Group, Parameter)
	Cancel = True;
EndProcedure

&AtClient
Procedure ItemWorkProcessTableBeforeRowChange(Item, Cancel)
	Cancel = True;
EndProcedure

&AtClient
Procedure ItemWorkProcessTableBeforeAddRow(Item, Cancel, Copying, Parent, Group, Parameter)
	Cancel = True;
EndProcedure

&AtClient
Procedure ItemWorkProcessTableBeforeDeleteRow(Item, Cancel)
	Cancel = True;
EndProcedure

&AtClient
Procedure ItemClusterManagerTableBeforeAddRow(Item, Cancel, Copying, Parent, Group, Parameter)
	Cancel = True;
EndProcedure

&AtClient
Procedure ItemClusterManagerTableBeforeRowChange(Item, Cancel)
	Cancel = True;
EndProcedure

&AtClient
Procedure ItemClusterManagerTableBeforeDeleteRow(Item, Cancel)
	Cancel = True;
EndProcedure

&AtClient
Procedure ItemStandartInfoTableBeforeDeleteRow(Item, Cancel)
	Cancel = True;
EndProcedure

&AtClient
Procedure ItemStandartInfoTableBeforeRowChange(Item, Cancel)
	Cancel = True;
EndProcedure

&AtClient
Procedure ItemStandartInfoTableBeforeAddRow(Item, Cancel, Copying, Parent, Group, Parameter)
	Cancel = True;
EndProcedure

&AtClient
Procedure ItemTableLimitsBeforeRowChange(Item, Cancel)
	Cancel = True;
EndProcedure

&AtClient
Procedure ItemTableLimitsBeforeAddRow(Item, Cancel, Copying, Parent, Group, Parameter)
	Cancel = True;
EndProcedure

&AtClient
Procedure ItemTableLimitsBeforeDeleteRow(Item, Cancel)
	Cancel = True;
EndProcedure

&AtClient
Procedure ItemSessionTableBeforeAddRow(Item, Cancel, Copying, Parent, Group, Parameter)
	Cancel = True;
EndProcedure

&AtClient
Procedure ItemSessionTableBeforeRowChange(Item, Cancel)
	Cancel = True;
EndProcedure

&AtClient
Procedure ItemSessionTableBeforeDeleteRow(Item, Cancel)
	Cancel = True;
EndProcedure

&AtClient
Procedure ItemAssignmentRuleTableBeforeRowChange(Item, Cancel)
	Var Services, CurrentTreeData, CurrentTreeLine, ClusterSettings, CurrentAssignmentRule, OpenFormParameters;
	CurrentTreeData = Items.ClusterTree.CurrentRow;
	CurrentTreeLine = ClusterTree.FindByID(CurrentTreeData);
	ConnectionSettings = GetServerAdministrationParameters(CurrentTreeLine.GetParent());
	ClusterSettings = GetClusterParameters(CurrentTreeLine.GetParent());
	Cancel = True;
	CurrentAssignmentRule = AssignmentRuleTable.FindByID(Items.ItemAssignmentRuleTable.CurrentRow);
	ProcessingClosingNotify = New NotifyDescription("ProcessingCreationAssignmentRule", ThisForm);
	OpenFormParameters = New Structure();
	OpenFormParameters.Insert("ObjectChange", True);
	Services = GetClusterServices(ConnectionSettings, ClusterSettings);
	OpenFormParameters.Insert("Services", Services);
	OpenFormParameters.Insert("Priority", CurrentAssignmentRule.Priority);
	OpenFormParameters.Insert("AdditionalParameter", CurrentAssignmentRule.AdditionalParameter);
	OpenFormParameters.Insert("InfoBaseName", CurrentAssignmentRule.InfoBaseName);
	OpenFormParameters.Insert("AssignmentRuleType", CurrentAssignmentRule.AssignmentRuleType);
	OpenFormParameters.Insert("ObjectType", CurrentAssignmentRule.ObjectName);
	OpenFormParameters.Insert("RuleID", CurrentAssignmentRule.AssignmentRuleID);
	OpenForm(GetFormName("AssignmentRuleForm"),OpenFormParameters,
				  ThisObject,,,,ProcessingClosingNotify,FormWindowOpeningMode.LockOwnerWindow);		
EndProcedure

&AtClient
Procedure ItemAssignmentRuleTableBeforeAddRow(Item, Cancel, Copying, Parent, Group, Parameter)
	Var CurrentTreeData, CurrentTreeLine, ConnectionSettings, ClusterSettings, ProcessingClosingNotify,
	   OpenFormParameters, Services;
	Cancel = True;
	CurrentTreeData = Items.ClusterTree.CurrentRow;
	CurrentTreeLine = ClusterTree.FindByID(CurrentTreeData);
	ConnectionSettings = GetServerAdministrationParameters(CurrentTreeLine.GetParent());
	ClusterSettings = GetClusterParameters(CurrentTreeLine.GetParent());

	ProcessingClosingNotify = New NotifyDescription("ProcessingCreationAssignmentRule", ThisObject);
	OpenFormParameters = New Structure();
	OpenFormParameters.Insert("ObjectChange", False);
	Services = GetClusterServices(ConnectionSettings, ClusterSettings);
	OpenFormParameters.Insert("Services", Services);
	OpenForm(GetFormName("AssignmentRuleForm"),OpenFormParameters,
				  ThisObject,,,,ProcessingClosingNotify,FormWindowOpeningMode.LockOwnerWindow);	
EndProcedure

&AtClient
Procedure ItemAssignmentRuleTableBeforeDeleteRow(Item, Cancel)
	Var CurrentTreeData, CurrentTreeLine, ConnectionSettings, ClusterSettings, CurrentAssignmentRule;
	CurrentTreeData = Items.ClusterTree.CurrentRow;
	CurrentTreeLine = ClusterTree.FindByID(CurrentTreeData);
	ConnectionSettings = GetServerAdministrationParameters(CurrentTreeLine.GetParent());
	ClusterSettings = GetClusterParameters(CurrentTreeLine.GetParent());
	Cancel = True;
	CurrentAssignmentRule = AssignmentRuleTable.FindByID(Items.AssignmentRuleTable.CurrentRow);
	RemoveAssignmentRuleFromCluster(ConnectionSettings, ClusterSettings, CurrentTreeLine.Name, CurrentAssignmentRule.RuleID);
	AssignmentRuleTable.Clear();
	FillAssignmentRuleTable(ConnectionSettings, ClusterSettings, CurrentTreeLine.Name);	
EndProcedure

&AtClient
Procedure PreviousCounterValuePage(Command)
	CounterValueTablePageNumber = CounterValueTablePageNumber - 1;
	ShowCurrentCounterValueTablePage();
	SetUpCounterButtonsAvailability();
EndProcedure

&AtClient
Procedure NextCounterValuePage(Command)
	CounterValueTablePageNumber = CounterValueTablePageNumber + 1;
	ShowCurrentCounterValueTablePage();
	SetUpCounterButtonsAvailability();
EndProcedure

&AtClient
Procedure PreviousSessionPage(Command)
	SessionTablePageNumber = SessionTablePageNumber - 1;
	ShowCurrentSessionTablePage();
	SetUpSessionButtonsAvailability();
EndProcedure

&AtClient
Procedure NextSessionPage(Command)
	SessionTablePageNumber = SessionTablePageNumber + 1;
	ShowCurrentSessionTablePage();
	SetUpSessionButtonsAvailability();
EndProcedure

&AtClient
Procedure FirstSessionPage(Command)
	SessionTablePageNumber = 0;
	ShowCurrentSessionTablePage();
	SetUpSessionButtonsAvailability();
EndProcedure

&AtClient
Procedure LastSessionPage(Command)
	SessionTablePageNumber = TableSessionPageCount - 1;
	ShowCurrentSessionTablePage();
	SetUpSessionButtonsAvailability();
EndProcedure

&AtClient
Procedure FirstCounterValuePage(Command)
	CounterValueTablePageNumber = 0;
	ShowCurrentCounterValueTablePage();
	SetUpCounterButtonsAvailability();
EndProcedure

&AtClient
Procedure LastCounterValuePage(Command)
	CounterValueTablePageNumber = TableCounterValuePageCount - 1;
	ShowCurrentCounterValueTablePage();
	SetUpCounterButtonsAvailability();
EndProcedure

#EndRegion

#Region FormFunctionsRegion

&AtClient
Function GetFormName(FormName) Export
	
	Var ForReturn;
	
	ForReturn = MetaPath + ".Form";
	If Not IsBlankString(FormName) Then
		ForReturn = ForReturn + "." + FormName;
	EndIf;
	Return ForReturn;
	
EndFunction

&AtServer
Procedure FillClusterTreeConnectionList()
	Var ClusterTreeValue, ClusterTreeRoot, ServerGroup, ServerGroupContent;
	ClusterTreeValue = FormAttributeToValue("ClusterTree");
	ClusterTreeValue.Rows.Clear();
   	ValueToFormAttribute(ClusterTreeValue, "ClusterTree");
	
	ClusterTreeRoot = ClusterTree.GetItems();
	ServerGroup = ClusterTreeRoot.Add();
	// start filling the ClusterTree
	// connections to different ras
	ServerGroup.Name = NStr("ru = 'Центральный сервер 1С:Предприятия'; SYS = 'MainForm.CentralServerName'", "ru");
	ServerGroup.PictureIndex = 0;
	ServerGroup.ItemGroup = True;
	ServerGroup.AdministrationItemType = "AdministrationCentralServer";
	ServerGroupContent = ServerGroup.GetItems();
	ConnectionSettingsToAdministrationServers = Undefined;
	If (Metadata.ScriptVariant = Metadata.ObjectProperties.ScriptVariant.English) Then 
		ConnectionSettingsToAdministrationServers = CommonSettingsStorage.Load("Common/AdministrationServersConnectionsParameters", "");
	ElsIf (Metadata.ScriptVariant = Metadata.ObjectProperties.ScriptVariant.Russian) Then
		ConnectionSettingsToAdministrationServers = CommonSettingsStorage.Load("Общее/ПараметрыПодключенияСерверовАдминистрирования", "");
	EndIf;

	ClusterUserAuthenticationSettings = New Structure();
	ClusterUserAuthenticationSettings.Insert("ClusterInfoBaseSettings", Undefined);
	If ConnectionSettingsToAdministrationServers <> Undefined Then
		For each ConnectionLine In ConnectionSettingsToAdministrationServers Do
			NewConnection = ConnectionTable.Add();
			NewConnection.Name = ConnectionLine.Key;
			If (Metadata.ScriptVariant = Metadata.ObjectProperties.ScriptVariant.English) Then
				NewConnection.ServerAdministrationAddress = ConnectionLine.Value.Address;
				NewConnection.ServerAdministrationPort = ConnectionLine.Value.Port;
			ElsIf (Metadata.ScriptVariant = Metadata.ObjectProperties.ScriptVariant.Russian) Then
			    NewConnection.ServerAdministrationAddress = ConnectionLine.Value.Адрес;
				NewConnection.ServerAdministrationPort = ConnectionLine.Value.Порт;
			EndIf;	
			NewConnection.Login = "";
			NewConnection.Password = "";
		EndDo;
	EndIf;	
EndProcedure

&AtClient
Procedure AddSecurityProfileToClusterTreeAtClient(GroupContent, AdministrationItemType, Name, PictureIndex)
	Var NewItemGroup, NewItems;
	NewItemGroup = GroupContent.Add();
	NewItemGroup.Name = Name;
	NewItemGroup.PictureIndex = PictureIndex;
	NewItemGroup.ItemGroup = False;
	NewItemGroup.AdministrationItemType = AdministrationItemType;
	NewItems = NewItemGroup.GetItems();
	NewItems.Add();
EndProcedure

&AtClient
Procedure AddItemToClusterTreeAtClient(GroupContent, Name, PictureIndex, Group, ItemType = "", ItemUUID = Undefined)
	Var NewItemGroup, NewItems;
	NewItemGroup = GroupContent.Add();
	NewItemGroup.Name = Name;
	NewItemGroup.PictureIndex = PictureIndex;
	NewItemGroup.ItemGroup = Group;
	NewItemGroup.ItemUUID = ItemUUID;
	If (Group = True) Then
		NewItemGroup.AdministrationItemType = ItemType;
		NewItems = NewItemGroup.GetItems();
		NewItems.Add();
	EndIf;
EndProcedure

&AtServer
Procedure AddItemToClusterTree(GroupContent, Name, PictureIndex, Group, ItemType)
	Var NewItemGroup, NewItems;
	NewItemGroup = GroupContent.Add();
	NewItemGroup.Name = Name;
	NewItemGroup.PictureIndex = PictureIndex;
	NewItemGroup.ItemGroup = Group;
	If (Group = True) Then
		NewItemGroup.AdministrationItemType = ItemType;
		NewItems = NewItemGroup.GetItems();
		NewItems.Add();
	EndIf;
EndProcedure

&AtServer
Procedure AddServerStructure(ConnectionParameters, TreeLineID)
	Var AdministrationAgent, AgentAdministrators, ServerGroupContent, ClusterGroup, ClusterGroupContent,
		Clusters, Cluster, AgentAdministratorsGroup;
	AdministrationAgent = New ServerAdministration(ConnectionParameters.AdministrationServerAgent, 
															ConnectionParameters.AdministrationServerPort);
	Try
		AdministrationAgent.Authenticate(ConnectionParameters.Login, ConnectionParameters.Password);
	Except
		Return;
	EndTry;	
	AgentAdministrators = AdministrationAgent.GetAdministrators();
	
	// current server
	ServerGroupContent = ClusterTree.FindByID(TreeLineID).GetItems();
	ClusterGroup = ServerGroupContent.Add();
	ClusterGroup.Name = NStr("ru = 'Кластеры'; SYS = 'MainForm.ClustersName'", "ru");
	ClusterGroup.PictureIndex = 2;
	ClusterGroup.ItemGroup = True; 
	ClusterGroup.AdministrationItemType = "Clusters";
	ClusterGroupContent = ClusterGroup.GetItems();
	
	Clusters = AdministrationAgent.GetClusters();
	For each Cluster In Clusters Do
		NewCluster = ClusterGroupContent.Add();
		NewCluster.Name = Cluster.Name;
		NewCluster.ItemUUID = Cluster.ClusterID;
		NewCluster.PictureIndex = 3;
		NewCluster.AdministrationItemType = "Cluster";
		NewCluster.AuthenticationCompleted = False;
		ClusterGroupItems = NewCluster.GetItems();
		AddItemToClusterTree(ClusterGroupItems, NStr("ru = 'Информационные базы'; SYS = 'MainForm.InfobasesNames'", "ru"), 4, True, "InfoBases");
		AddItemToClusterTree(ClusterGroupItems, NStr("ru = 'Рабочие серверы'; SYS = 'MainForm.WorkServerNames'", "ru"), 6, True, "WorkServers");
		AddItemToClusterTree(ClusterGroupItems, NStr("ru = 'Администраторы кластера'; SYS = 'MainForm.ClusterAdministratorNames'", "ru"), 9, True, "ClusterAdministrators");
		AddItemToClusterTree(ClusterGroupItems, NStr("ru = 'Менеджеры кластера'; SYS = 'MainForm.ClusterManagerNames'", "ru"), 11, True, "ClusterManagers");
		AddItemToClusterTree(ClusterGroupItems, NStr("ru = 'Рабочие процессы'; SYS = 'MainForm.WorkProcessNames'", "ru"), 13, True, "WorkProcesses");
		AddItemToClusterTree(ClusterGroupItems, NStr("ru = 'Сеансы'; SYS = 'MainForm.SessionNames'", "ru"), 15, True, "Sessions");
		AddItemToClusterTree(ClusterGroupItems, NStr("ru = 'Блокировки'; SYS = 'MainForm.LockNames'", "ru"), 17, True, "Locks");
		AddItemToClusterTree(ClusterGroupItems, NStr("ru = 'Соединения'; SYS = 'MainForm.ConnectionNames'", "ru"), 20, True, "Connections");
		AddItemToClusterTree(ClusterGroupItems, NStr("ru = 'Профили безопасности'; SYS = 'MainForm.ProfileNames'", "ru"), 22, True, "SecurityProfiles");
		AddItemToClusterTree(ClusterGroupItems, NStr("ru = 'Счетчики потребления ресурсов'; SYS = 'MainForm.CounterNames'", "ru"), 36, True, "ResourceConsumptionCounters");
		AddItemToClusterTree(ClusterGroupItems, NStr("ru = 'Ограничения потребления ресурсов'; SYS = 'MainForm.LimitNames'", "ru"), 38, True, "ResourceConsumptionLimits");
	EndDo;	
	//agent administrators
	AgentAdministratorsGroup = ServerGroupContent.Add();
	AgentAdministratorsGroup.Name = NStr("ru = 'Администраторы';SYS = 'MainForm.AgentAdministratorNames'", "ru");
	AgentAdministratorsGroup.PictureIndex = 9;
	AgentAdministratorsGroup.ItemGroup = True;
	AgentAdministratorsGroup.AdministrationItemType = "CentralServerAdministrators";
	AgentAdministratorsGroup.GetItems().Add();	
EndProcedure

&AtServer
Procedure SavingAdministrationConsoleSettings(ConnectionSettings)
	Var ConnectionSettingForStorage, Connection;
	ConnectionSettingForStorage = New Map();
	For each Connection In ConnectionSettings Do
		NewConnectionInfo = New Structure();
		If (Metadata.ScriptVariant = Metadata.ObjectProperties.ScriptVariant.English) Then
			NewConnectionInfo.Insert("Address", Connection.Value.AdministrationServerAgent);
			NewConnectionInfo.Insert("Port", Connection.Value.AdministrationServerPort);
		ElsIf (Metadata.ScriptVariant = Metadata.ObjectProperties.ScriptVariant.Russian) Then
		    NewConnectionInfo.Insert("Адрес", Connection.Value.AdministrationServerAgent);
			NewConnectionInfo.Insert("Порт", Connection.Value.AdministrationServerPort);
		EndIf;
		ConnectionSettingForStorage.Insert(Connection.Key, NewConnectionInfo);
	EndDo;
	If (Metadata.ScriptVariant = Metadata.ObjectProperties.ScriptVariant.English) Then 
		CommonSettingsStorage.Save("Common/AdministrationServersConnectionsParameters", "", ConnectionSettingForStorage);
	ElsIf (Metadata.ScriptVariant = Metadata.ObjectProperties.ScriptVariant.Russian) Then
		CommonSettingsStorage.Save("Общее/ПараметрыПодключенияСерверовАдминистрирования", "", ConnectionSettingForStorage);
	EndIf;
EndProcedure

&AtClient
Procedure DisplayListOfCommands(ParentItemType, AdministrationItemType, ItemGroup)
	Var CommandList, CurrentItemIsCluster, ItemWithoutContextMenu, ReadOnlyItem;
	CommandList = Items.ClusterTree.ContextMenu.ChildItems;
	CurrentItemIsCluster = AdministrationItemType = "Cluster";
	ItemWithoutContextMenu = 
			AdministrationItemType = "ClusterManagers" Or
			AdministrationItemType = "WorkProcesses" Or
			AdministrationItemType = "Sessions" Or
			AdministrationItemType = "Connections" Or
			AdministrationItemType = "Locks";
	ReadOnlyItem = 
			ParentItemType = "ClusterManagers" Or
			ParentItemType = "WorkProcesses";
	For each Command In CommandList Do
		If Command.Name = "ClusterTreeContextMenuAdd" Then
			Command.Enabled = ItemGroup And Not ItemWithoutContextMenu;
		ElsIf Command.Name = "ClusterTreeContextMenuDelete" Then
			Command.Enabled = AdministrationItemType = "ServerAdministration" Or Not ItemGroup 
			And Not ItemWithoutContextMenu And Not ReadOnlyItem;
		Else
			Command.Enabled = Not ItemGroup And Not ItemWithoutContextMenu;
		EndIf;
		If Command.Name = "ClusterTreeContextMenuAuthentication" Then
			Command.Visible = CurrentItemIsCluster;
		ElsIf Command.Name = "ClusterTreeContextMenuPartiallyApplyAssignmentRules" Then
			Command.Visible = CurrentItemIsCluster;
		ElsIf Command.Name = "ClusterTreeContextMenuFullyApplyAssignmentRules" Then
			Command.Visible = CurrentItemIsCluster;
		EndIf;
	EndDo;
	Items.ItemClusterTreeInsert.Enabled = ItemGroup And Not ItemWithoutContextMenu;
	Items.ItemClusterTreeEdit.Enabled = Not ItemGroup And Not ItemWithoutContextMenu;
	Items.ItemClusterTreeDelete.Enabled = AdministrationItemType = "ServerAdministration" Or Not ItemGroup 
			And Not ItemWithoutContextMenu And Not ReadOnlyItem;
	
EndProcedure

&AtClient
Procedure SetUpCounterButtonsAvailability()
	Items.ItemFirstCounterValuePage.Enabled = CounterValueTablePageNumber > 0;
	Items.ItemLastCounterValuePage.Enabled = CounterValueTablePageNumber < TableCounterValuePageCount - 1;	
	Items.ItemPreviousCounterValuePage.Enabled = CounterValueTablePageNumber > 0;
	Items.ItemNextCounterValuePage.Enabled = CounterValueTablePageNumber < TableCounterValuePageCount - 1;		
EndProcedure

&AtClient
Procedure SetUpSessionButtonsAvailability()
	Items.ItemFirstSessionPage.Enabled = SessionTablePageNumber > 0;
	Items.ItemLastSessionPage.Enabled = SessionTablePageNumber < TableSessionPageCount - 1;
	Items.ItemPreviousSessionPage.Enabled = SessionTablePageNumber > 0;
	Items.ItemNextSessionPage.Enabled = SessionTablePageNumber < TableSessionPageCount - 1;
EndProcedure

#EndRegion

#Region ManagementObjectsServerAdministrationRegion

#Region GetObjectsListsRegion

&AtServerNoContext
Function GetAdministrationAgent(ConnectionSettings)
	AdministrationAgent = New ServerAdministration(ConnectionSettings.AdministrationServerAgent, 
															ConnectionSettings.AdministrationServerPort);
	AdministrationAgent.Authenticate(ConnectionSettings.Login, ConnectionSettings.Password);
	Return AdministrationAgent;
EndFunction

&AtServerNoContext
Function GetAdministrationCluster(ConnectionSettings, ClusterSettings)
	Var AdministrationAgent, Clusters, Cluster;  
	AdministrationAgent = GetAdministrationAgent(ConnectionSettings);
	Clusters = AdministrationAgent.GetClusters();
	For each Cluster In Clusters Do
		If Cluster.Name = ClusterSettings.Name Then
			Try
				Cluster.Authenticate(ClusterSettings.User, ClusterSettings.Password);
			Except
				
			EndTry;
			Return Cluster;
		EndIf;
	EndDo;
EndFunction

&AtServerNoContext
Function GetSecurityProfile(ConnectionSettings, ClusterSettings, ProfileName)
	Var Cluster, Profile; 
	Cluster = GetAdministrationCluster(ConnectionSettings, ClusterSettings);
	For each Profile In Cluster.GetSecurityProfiles() Do
		If Profile.Name = ProfileName Then
			Return Profile;	
		EndIf;
	EndDo;
EndFunction

&AtServerNoContext
Function GetListOfExternalModuleNames(ConnectionSettings, ClusterSettings, ProfileName)
	Var ListOfExternalModuleNames, Profile, ExternalModules, ExternalModule;
	ListOfExternalModuleNames = New Array();
	Profile = GetSecurityProfile(ConnectionSettings, ClusterSettings, ProfileName);
	ExternalModules = Profile.GetAllowedExternalModules();
	For each ExternalModule In ExternalModules Do
		ListOfExternalModuleNames.Add(ExternalModule.Name);	
	EndDo;
	Return ListOfExternalModuleNames;	
EndFunction

&AtServerNoContext
Function GetListOfInternetResourceNames(ConnectionSettings, ClusterSettings, ProfileName)
	Var ListOfInternetResources, Profile, InternetResources, InternetResource;   	
	ListOfInternetResources = New Array();
	Profile = GetSecurityProfile(ConnectionSettings, ClusterSettings, ProfileName);
	InternetResources = Profile.GetAllowedInternetResources();
	For each InternetResource In InternetResources Do
		ListOfInternetResources.Add(InternetResource.Name);	
	EndDo;	
	Return ListOfInternetResources;
EndFunction

&AtServerNoContext
Function GetListOfAllowedApplicationNames(ConnectionSettings, ClusterSettings, ProfileName)
	Var ListOfAllowedApplications, Profile, AllowedApplications, AllowedApplication;
	ListOfAllowedApplications = New Array();
	Profile = GetSecurityProfile(ConnectionSettings, ClusterSettings, ProfileName);
	AllowedApplications = Profile.GetAllowedExternalApplications();
	For each AllowedApplication In AllowedApplications Do
		ListOfAllowedApplications.Add(AllowedApplication.Name);	
	EndDo;	
	Return ListOfAllowedApplications;
EndFunction

&AtServerNoContext
Function GetListOfAddInNames(ConnectionSettings, ClusterSettings, ProfileName)
	Var ListOfAddIns, Profile, AddIns, AddIn;
	ListOfAddIns = New Array();
	Profile = GetSecurityProfile(ConnectionSettings, ClusterSettings, ProfileName);
	AddIns = Profile.GetAllowedAddIns();
	For each AddIn In AddIns Do
		ListOfAddIns.Add(AddIn.Name);	
	EndDo;
	Return ListOfAddIns;
EndFunction

&AtServerNoContext
Function GetListOfCOMClassNames(ConnectionSettings, ClusterSettings, ProfileName)
	Var ListOfCOMClasses, Profile, COMClasses, COMClass;
	ListOfCOMClasses = New Array();
	Profile = GetSecurityProfile(ConnectionSettings, ClusterSettings, ProfileName);
	COMClasses = Profile.GetAllowedCOMClass();
	For each COMClass In COMClasses Do
		ListOfCOMClasses.Add(COMClass.Name);	
	EndDo;	
	Return ListOfCOMClasses;
EndFunction

&AtServerNoContext
Function GetListOfVirtualDirectoryNames(ConnectionSettings, ClusterSettings, ProfileName)
	Var ListOfVirtualDirectory, Profile, VirtualDirectories, VirtualDirectory;
	ListOfVirtualDirectory = New Array();
	Profile = GetSecurityProfile(ConnectionSettings, ClusterSettings, ProfileName);
	VirtualDirectories = Profile.GetAllowedVirtualDirectories();
	For each VirtualDirectory In VirtualDirectories Do
		ListOfVirtualDirectory.Add(VirtualDirectory.Alias);	
	EndDo;
	Return ListOfVirtualDirectory;
EndFunction

&AtServerNoContext
Function GetListOfClusterManagerNames(ConnectionSettings, ClusterSettings)
	Var ListOfClusterManager, Cluster, ClusterManager, ClusterManagerData;
	ListOfClusterManager = New Array();
	Cluster = GetAdministrationCluster(ConnectionSettings, ClusterSettings);
	Cluster.Authenticate(ClusterSettings.User, ClusterSettings.Password);
	For each ClusterManager In Cluster.GetClusterManagers() Do
		ClusterManagerData = New Structure();
		ClusterManagerData.Insert("ItemUUID", ClusterManager.ClusterManagerID);
		ClusterManagerData.Insert("Name", ClusterManager.Description);
		ListOfClusterManager.Add(ClusterManagerData);	
	EndDo;
	Return ListOfClusterManager;
EndFunction

&AtServerNoContext
Function GetListOfInfoBaseNames(ConnectionSettings, ClusterSettings)
	Var ListOfInfobase, Cluster, InfobaseData, Infobase;
	ListOfInfobase = New Array();
	Cluster = GetAdministrationCluster(ConnectionSettings, ClusterSettings);
	For each Infobase In Cluster.GetInfoBases() Do
		InfobaseData = New Structure();
		InfobaseData.Insert("ItemUUID", Infobase.InfoBaseID);
		InfobaseData.Insert("Name", Infobase.Name);
		ListOfInfobase.Add(InfobaseData);	
	EndDo;
	Return ListOfInfobase;
EndFunction

&AtServerNoContext
Function GetListOfClusterAdministratorNames(ConnectionSettings, ClusterSettings)
	Var ListOfAdministrator, Cluster, InfobaseData, Administrator;
	ListOfAdministrator = New Array();
	Cluster = GetAdministrationCluster(ConnectionSettings, ClusterSettings);
	For each Administrator In Cluster.GetClusterAdministrators() Do
		ListOfAdministrator.Add(Administrator.Name);	
	EndDo;	
	Return ListOfAdministrator;
EndFunction

&AtServerNoContext
Function GetListOfServerAdministratorNames(ConnectionSettings)
	Var ListOfAdministrator, Agent, InfobaseData, Administrator;
	ListOfAdministrator = New Array();
	Agent = GetAdministrationAgent(ConnectionSettings);
	For each Administrator In Agent.GetAdministrators() Do
		ListOfAdministrator.Add(Administrator.Name);	
	EndDo;	
	Return ListOfAdministrator
EndFunction

&AtServerNoContext
Function GetListOfWorkServerNames(ConnectionSettings, ClusterSettings)
	Var ListOfWorkServer, Cluster, WorkServer;
	ListOfWorkServer = New Array();
	Cluster = GetAdministrationCluster(ConnectionSettings, ClusterSettings);
	For each WorkServer In Cluster.GetWorkServers() Do
		ListOfWorkServer.Add(WorkServer.ComputerName);	
	EndDo;	
	Return ListOfWorkServer;
EndFunction

&AtServerNoContext
Function GetListOfWorkProcessNames(ConnectionSettings, ClusterSettings)
	Var ListOfWorkProcess, Cluster, WorkProcess;
	ListOfWorkProcess = New Array();
	Cluster = GetAdministrationCluster(ConnectionSettings, ClusterSettings);
	For each WorkProcess In Cluster.GetWorkProcesses() Do
		WorkProcessData = New Structure();
		WorkProcessData.Insert("ItemUUID", WorkProcess.WorkProcessID);
		WorkProcessData.Insert("Name", WorkProcess.ComputerName);
		WorkProcessData.Insert("ProcessID", WorkProcess.ProcessID);
		ListOfWorkProcess.Add(WorkProcessData);	
	EndDo;
	Return ListOfWorkProcess;
EndFunction

&AtServerNoContext
Function GetSecurityProfileNames(ConnectionSettings, ClusterSettings)
	Var ListOfProfile, Cluster, Profile;
	ListOfProfile = New Array();
	Cluster = GetAdministrationCluster(ConnectionSettings, ClusterSettings);
	For each Profile In Cluster.GetSecurityProfiles() Do
		ListOfProfile.Add(Profile.Name);
	EndDo;
	Return ListOfProfile;
EndFunction

&AtServerNoContext
Function GetListOfCounterNames(ConnectionSettings, ClusterSettings)
	Var ListOfCounter, Counter, Cluster;
	ListOfCounter = New Array();
	Cluster = GetAdministrationCluster(ConnectionSettings, ClusterSettings);
	For each Counter In Cluster.GetResourceConsumptionCounters() Do
		ListOfCounter.Add(Counter.Name);
	EndDo;
	Return ListOfCounter;
EndFunction

&AtServerNoContext
Function GetListOfLimitNames(ConnectionSettings, ClusterSettings)
	Var ListOfLimit, Limit, Cluster;
	ListOfLimit = New Array();
	Cluster = GetAdministrationCluster(ConnectionSettings, ClusterSettings);
	For each Limit In Cluster.GetResourceConsumptionLimits() Do
		ListOfLimit.Add(Limit.Name);	
	EndDo;
	Return ListOfLimit;
EndFunction

&AtServerNoContext
Function GetListOfClusterNames(ConnectionSettings)
	Var ListOfCluster, Clusters, Cluster, AdministrationAgent, ClusterData;
	ListOfCluster = New Array();
	AdministrationAgent = GetAdministrationAgent(ConnectionSettings);
	Clusters = AdministrationAgent.GetClusters();
	For each Cluster In Clusters Do
		ClusterData = New Structure();
		ClusterData.Insert("Name", Cluster.Name);
		ClusterData.Insert("ItemUUID", Cluster.ClusterID);
		ListOfCluster.Add(ClusterData);	
	EndDo;	
	Return ListOfCluster;
EndFunction

&AtServerNoContext
Function GetClusterServices(ConnectionSettings, ClusterSettings)
	Var Cluster, ListOfService;
	ListOfService = New Array();
	Cluster = GetAdministrationCluster(ConnectionSettings, ClusterSettings);
	For each Service In Cluster.GetServices() Do
		NewItem = New Structure();
		NewItem.Insert("Name", Service.Name);
		NewItem.Insert("Description", Service.Description);
		ListOfService.Add(NewItem);
	EndDo;
	Return ListOfService;
EndFunction

#EndRegion

#Region DeletingObjectsRegion

&AtServerNoContext
Procedure RemoveInfobaseFromCluster(ConnectionSettings, ClusterSettings, InfobaseName, DeleteMode)
	Var Cluster, Infobases, Infobase;
	Cluster = GetAdministrationCluster(ConnectionSettings, ClusterSettings);
	Infobases = Cluster.GetInfoBases();
	For each Infobase In Infobases Do
		If Infobase.Name = InfobaseName Then
			Infobase.Delete(DeleteMode);	
			Break;
		EndIf;
	EndDo;													
EndProcedure

&AtServerNoContext
Procedure RemoveWorkServerFromCluster(ConnectionSettings, ClusterSettings, WorkServerName)
	Var Cluster, WorkServers, WorkServer;
	Cluster = GetAdministrationCluster(ConnectionSettings, ClusterSettings);
	WorkServers = Cluster.GetWorkServers();
	For each WorkServer In WorkServers Do
		If WorkServer.ComputerName = WorkServerName Then
			WorkServer.Delete();	
			Break;
		EndIf;
	EndDo;													
EndProcedure

&AtServerNoContext
Procedure RemoveClusterAdministratorFromCluster(ConnectionSettings, ClusterSettings, AdministratorName)
	Var Cluster, Administrators, Administrator; 
	Cluster = GetAdministrationCluster(ConnectionSettings, ClusterSettings);
	Administrators = Cluster.GetClusterAdministrators();
	For each Administrator In Administrators Do
		If Administrator.Name = AdministratorName Then
			Administrator.Delete();	
			Break;
		EndIf;
	EndDo;												
EndProcedure

&AtServerNoContext
Procedure RemoveSecurityProfileFromCluster(ConnectionSettings, ClusterSettings, ProfileName)
	Var Cluster, Profiles, Profile;
	Cluster = GetAdministrationCluster(ConnectionSettings, ClusterSettings);
	Profiles = Cluster.GetSecurityProfiles();
	For each Profile In Profiles Do
		If Profile.Name = ProfileName Then
			Profile.Delete();	
			Break;
		EndIf;
	EndDo;												
EndProcedure

&AtServerNoContext
Procedure RemoveCounterFromCluster(ConnectionSettings, ClusterSettings, CounterName)
	Var Cluster, Counters, Counter;
	Cluster = GetAdministrationCluster(ConnectionSettings, ClusterSettings);
	Counters = Cluster.GetResourceConsumptionCounters();
	For each Cluster In Counters Do
		If Cluster.Name = CounterName Then
			Cluster.Delete();	
			Break;
		EndIf;
	EndDo;												
EndProcedure

&AtServerNoContext
Procedure RemoveLimitFromCluster(ConnectionSettings, ClusterSettings, LimitName)
	Var Cluster, Limits, Limit;
	Cluster = GetAdministrationCluster(ConnectionSettings, ClusterSettings);
	Limits = Cluster.GetResourceConsumptionLimits();
	For each Limit In Limits Do
		If Limit.Name = LimitName Then
			Limit.Delete();
			Break;
		EndIf;
	EndDo;													
EndProcedure

&AtServerNoContext
Procedure RemoveClusterFromCentralServer(ConnectionSettings, ClusterName)
	Var AdministrationAgent, Clusters, Cluster;
	AdministrationAgent = GetAdministrationAgent(ConnectionSettings);
	Clusters = AdministrationAgent.GetClusters();
	For each Cluster In Clusters Do
		If Cluster.Name = ClusterName Then
			Cluster.Authenticate();
			Cluster.Delete();
			Break;
		EndIf;
	EndDo;
EndProcedure

&AtServerNoContext
Procedure RemoveVirtualDirectoryFromCluster(ConnectionSettings, ClusterSettings, ProfileName, DirectoryAlias)
	Var Profile, VirtualDirectory;
	Profile = GetSecurityProfile(ConnectionSettings, ClusterSettings, ProfileName);	
	For each VirtualDirectory In Profile.GetAllowedVirtualDirectories() Do
		If VirtualDirectory.Alias = DirectoryAlias Then
			VirtualDirectory.Delete();
			Break;
		EndIf;
	EndDo;																
EndProcedure

&AtServerNoContext
Procedure RemoveCOMClassFromCluster(ConnectionSettings, ClusterSettings, ProfileName, COMCLassName)
	Var Profile, COMClass;
	Profile = GetSecurityProfile(ConnectionSettings, ClusterSettings, ProfileName);
	For each COMClass In Profile.GetAllowedCOMClass() Do
		If COMClass.Name = COMCLassName Then
			COMClass.Delete();
			Break;
		EndIf;
	EndDo;													
EndProcedure

&AtServerNoContext
Procedure RemoveAddInFromCluster(ConnectionSettings, ClusterSettings, ProfileName, AddInName)
	Var Profile, AddIn;
	Profile = GetSecurityProfile(ConnectionSettings, ClusterSettings, ProfileName);
	For each AddIn In Profile.GetAllowedAddIns() Do
		If AddIn.Name = AddInName Then
			AddIn.Delete();
			Break;
		EndIf;
	EndDo;	
EndProcedure

&AtServerNoContext
Procedure RemoveExternalModuleFromCluster(ConnectionSettings, ClusterSettings, ProfileName, ExternalModuleName)
	Var Profile, ExternalModule;
	Profile = GetSecurityProfile(ConnectionSettings, ClusterSettings, ProfileName);
	For each ExternalModule In Profile.GetAllowedExternalModules() Do
		If ExternalModule.Name = ExternalModuleName Then
			ExternalModule.Delete();
			Break;
		EndIf;
	EndDo;
EndProcedure

&AtServerNoContext
Procedure RemoveAllowedApplicationFromCluster(ConnectionSettings, ClusterSettings, ProfileName, ApplicationName)
	Var Profile, AllowedApplication;
	Profile = GetSecurityProfile(ConnectionSettings, ClusterSettings, ProfileName);
	For each AllowedApplication In Profile.GetAllowedExternalApplications() Do
		If AllowedApplication.Name = ApplicationName Then
			AllowedApplication.Delete();
			Break;
		EndIf;
	EndDo;
EndProcedure

&AtServerNoContext
Procedure RemoveInternetResourceFromCluster(ConnectionSettings, ClusterSettings, ProfileName, ResourceInternetName)
	Var Profile, ResourceInternet;
	Profile = GetSecurityProfile(ConnectionSettings, ClusterSettings, ProfileName);
	For each ResourceInternet In Profile.GetAllowedInternetResources() Do
		If ResourceInternet.Name = ResourceInternetName Then
			ResourceInternet.Delete();
			Break;
		EndIf;
	EndDo;	
EndProcedure

&AtServerNoContext
Procedure RemoveAgentAdministrator(ConnectionSettings, AdministratorName)
	Var AdministrationAgent, Administrators, Administrator;
	AdministrationAgent = GetAdministrationAgent(ConnectionSettings);
	Administrators = AdministrationAgent.GetAdministrators();
	For each Administrator In Administrators Do
		If Administrator.Name = AdministratorName Then
			Administrator.Delete();	
			Break;
		EndIf;
	EndDo;												
EndProcedure

&AtServerNoContext
Procedure RemoveAssignmentRuleFromCluster(ConnectionSettings, ClusterSettings, WorkServerName, RuleID)
	Var Cluster, WorkServers, WorkServer, Rules, Rule;
	Cluster = GetAdministrationCluster(ConnectionSettings, ClusterSettings);
	WorkServers = Cluster.GetWorkServers();
	For each WorkServer In WorkServers Do
		If WorkServer.ComputerName = WorkServerName Then
			Rules = WorkServer.GetAssignmentRules();
			For each Rule In Rules Do
				If Rule.RuleID = RuleID Then
					Rule.Delete();	
					Break;
				EndIf;
			EndDo;
			Break;
		EndIf;
	EndDo;		
EndProcedure

#EndRegion

#Region CreatingObjectsRegion

&AtServerNoContext
Procedure AddLimitOnCluster(ConnectionSettings, ClusterSettings, LimitSettings)
	Var Cluster, NewLimit;
	Cluster = GetAdministrationCluster(ConnectionSettings, ClusterSettings);
	NewLimit = Cluster.CreateResourceConsumptionLimit();
	NewLimit.Name = LimitSettings.Name;
	NewLimit.Action = LimitSettings.Action;
	NewLimit.CallDuration = LimitSettings.CallDuration;
	NewLimit.ServiceCallDuration = LimitSettings.ServiceCallDuration;
	NewLimit.DBMSCallDuration = LimitSettings.DBMSCallDuration;
	NewLimit.ActiveSessionCount = LimitSettings.ActiveSessionCount;
	NewLimit.CallCount = LimitSettings.CallCount;
	NewLimit.SessionCount = LimitSettings.SessionCount;
	NewLimit.DBMSSentAndReceivedDataSize = LimitSettings.DBMSSentAndReceivedDataSize;
	NewLimit.WriteDiskDataSize = LimitSettings.WriteDiskDataSize;
	NewLimit.ReadDiskDataSize = LimitSettings.ReadDiskDataSize;
	NewLimit.Description = LimitSettings.Description;
	NewLimit.MemoryUsage = LimitSettings.MemoryUsage;
	NewLimit.CPUTime = LimitSettings.CPUTime;
	NewLimit.Counter = LimitSettings.Counter;
	NewLimit.ErrorMessage = LimitSettings.ErrorMessage;
	NewLimit.Write();
EndProcedure

&AtServerNoContext
Procedure AddClusterAdminOnCluster(ConnectionSettings, ClusterSettings, AdministratorSettings)
	Var Cluster, ClusterAdministrator;
	Cluster = GetAdministrationCluster(ConnectionSettings, ClusterSettings);
	ClusterAdministrator = Cluster.CreateClusterAdministrator();
	ClusterAdministrator.Name = AdministratorSettings.Name;
	ClusterAdministrator.Password = AdministratorSettings.Password;
	ClusterAdministrator.OSAuthentication = AdministratorSettings.OSAuthentication;
	ClusterAdministrator.StandardAuthentication = AdministratorSettings.StandardAuthentication;
	ClusterAdministrator.Description = AdministratorSettings.Description;
	ClusterAdministrator.Write();
EndProcedure

&AtServerNoContext
Procedure RegisterAgentAdministrator(ConnectionSettings, AdministratorSettings)
	Var AdministrationAgent, Administrator;
	AdministrationAgent = GetAdministrationAgent(ConnectionSettings);
	Administrator = AdministrationAgent.CreateAdministrator();
	Administrator.Name = AdministratorSettings.Name;
	Administrator.Password = AdministratorSettings.Password;
	Administrator.OSAuthentication = AdministratorSettings.OSAuthentication;
	Administrator.StandardAuthentication = AdministratorSettings.StandardAuthentication;
	Administrator.Description = AdministratorSettings.Description;
	Administrator.Write();
EndProcedure

&AtServerNoContext
Procedure AddCounterOnCluster(ConnectionSettings, ClusterSettings, CounterSettings)
	Var Cluster, Counter;
	Cluster = GetAdministrationCluster(ConnectionSettings, ClusterSettings);
	If Cluster <> Undefined Then
		Counter = Cluster.CreateResourceConsumptionCounter();
		Counter.Name = CounterSettings.Name;
		Counter.Group = CounterSettings.Group;
		Counter.CollectionTime = CounterSettings.CollectionTime;
		Counter.Description = CounterSettings.Description;
		Counter.CollectCallsDuration = CounterSettings.CollectCallsDuration;
		Counter.CollectServiceCallsDuration = CounterSettings.CollectServiceCallsDuration;
		Counter.CollectDBMSCallsDuration = CounterSettings.CollectDBMSCallsDuration;
		Counter.CollectActiveSessionsCount = CounterSettings.CollectActiveSessionsCount;
		Counter.CollectCallsCount = CounterSettings.CollectCallsCount;
		Counter.CollectSessionCount = CounterSettings.CollectSessionCount;
		Counter.CollectDBMSSentAndReceivedDataSize = CounterSettings.CollectDBMSSentAndReceivedDataSize;
		Counter.CollectWriteDiskDataSize = CounterSettings.CollectWriteDiskDataSize;
		Counter.CollectReadDiskDataSize = CounterSettings.CollectReadDiskDataSize;
		Counter.CollectMemoryUsage = CounterSettings.CollectMemoryUsage;
		Counter.CollectCPUTime = CounterSettings.CollectCPUTime;
		Counter.FilterType = CounterSettings.FilterType;
		Counter.FilterValue = CounterSettings.FilterValue;
		Counter.Write();
	EndIf;
EndProcedure

&AtServerNoContext
Procedure AddSecurityProfileOnCluster(ConnectionSettings, ClusterSettings, SecurityProfileSettings)
	Var Cluster, Profile;
	Cluster = GetAdministrationCluster(ConnectionSettings, ClusterSettings);
	If Cluster <> Undefined Then
		Profile = Cluster.CreateSecurityProfile();
		Profile.Name = SecurityProfileSettings.Name;
		Profile.Description = SecurityProfileSettings.Description;
		Profile.AllowExternalCodeExecutionInUnsafeMode = 
			SecurityProfileSettings.AllowExternalCodeExecutionInUnsafeMode;
		Profile.CryptoAvailable = SecurityProfileSettings.CryptoAvailable;
		Profile.ModulesAvailableForExtension = SecurityProfileSettings.ModulesAvailableForExtension;
		Profile.ModulesNotAvailableForExtension = SecurityProfileSettings.ModulesNotAvailableForExtension;
		Profile.COMObjectFullAccess = SecurityProfileSettings.COMObjectFullAccess;
		Profile.AddInFullAccess = SecurityProfileSettings.AddInFullAccess;
		Profile.ExternalModuleFullAccess = SecurityProfileSettings.ExternalModuleFullAccess;
		Profile.InternetResourcesFullAccess = SecurityProfileSettings.InternetResourcesFullAccess;
		Profile.ExternalApplicationsFullAccess = SecurityProfileSettings.ExternalApplicationsFullAccess;
		Profile.FileSystemFullAccess = SecurityProfileSettings.FileSystemFullAccess;
		Profile.SafeModeProfile = SecurityProfileSettings.SafeModeProfile;
		Profile.PrivilegedModeAllowed = SecurityProfileSettings.PrivilegedModeAllowed;
		Profile.AccessRightsExtensionLimitingRoles = SecurityProfileSettings.AccessRightsExtensionLimitingRoles;
		Profile.AllowAccessRightsExtension = SecurityProfileSettings.AllowAccessRightsExtension;
		Profile.PrivilegedModeRoles = SecurityProfileSettings.PrivilegedModeRoles;		
		Profile.Write();
		Profiles = Cluster.GetClusterAdministrators();
	EndIf;
EndProcedure

&AtServerNoContext
Procedure AddVirtualDirectoryOnCluster(ConnectionSettings, ClusterSettings, DirectorySettings)
	Var Profile, NewVirtualDirectory;
	Profile = GetSecurityProfile(ConnectionSettings, ClusterSettings, DirectorySettings.ProfileName);
	If Profile <> Undefined Then
		NewVirtualDirectory = Profile.CreateAllowedVirtualDirectory();
		NewVirtualDirectory.Alias = DirectorySettings.Alias;
		NewVirtualDirectory.ReadingAllowed = DirectorySettings.ReadingAllowed;
		NewVirtualDirectory.WritingAllowed = DirectorySettings.WritingAllowed;
		NewVirtualDirectory.Description = DirectorySettings.Description;
		NewVirtualDirectory.Path = DirectorySettings.Path;
		NewVirtualDirectory.Write();
	EndIf;
EndProcedure

&AtServerNoContext
Procedure AddCOMClassOnCluster(ConnectionSettings, ClusterSettings, COMClassSettings)
	Var Profile, NewCOMClass;
	Profile = GetSecurityProfile(ConnectionSettings, ClusterSettings, COMClassSettings.ProfileName);
	If Profile <> Undefined Then
		NewCOMClass = Profile.CreateAllowedCOMClass();
		NewCOMClass.ComputerName = COMClassSettings.ComputerName;
		NewCOMClass.Description = COMClassSettings.Description;
		NewCOMClass.Name = COMClassSettings.Name;
		NewCOMClass.ObjectUUID = COMClassSettings.ObjectUUID;
		NewCOMClass.FileName = COMClassSettings.FileName;
		NewCOMClass.Write();
	EndIf;
EndProcedure

&AtServerNoContext
Procedure AddAddInOnCluster(ConnectionSettings, ClusterSettings, AllowedAddInSettings)
	Var Profile, NewAddIn; 
	Profile = GetSecurityProfile(ConnectionSettings, ClusterSettings, AllowedAddInSettings.ProfileName);
	If Profile <> Undefined Then
		NewAddIn = Profile.CreateAllowedAddIn();
		NewAddIn.Name = AllowedAddInSettings.Name;
		NewAddIn.Description = AllowedAddInSettings.Description;
		NewAddIn.HashSum = AllowedAddInSettings.HashSum;
		NewAddIn.Write();	
	EndIf;
EndProcedure

&AtServerNoContext
Procedure AddExternalModuleOnCluster(ConnectionSettings, ClusterSettings, ExternalModuleSettings)
	Var Profile, NewExternalModule;  
	Profile = GetSecurityProfile(ConnectionSettings, ClusterSettings, ExternalModuleSettings.ProfileName);
	If Profile <> Undefined Then
		NewExternalModule = Profile.CreateAllowedExternalModule();
		NewExternalModule.Name = ExternalModuleSettings.Name;
		NewExternalModule.Description = ExternalModuleSettings.Description;
		NewExternalModule.HashSum = ExternalModuleSettings.HashSum;
		NewExternalModule.Write();
	EndIf;	
EndProcedure

&AtServerNoContext
Procedure AddAllowedApplicationOnCluster(ConnectionSettings, ClusterSettings, ApplicationSettings)
	Var Profile, NewAllowedApp;
	Profile = GetSecurityProfile(ConnectionSettings, ClusterSettings, ApplicationSettings.ProfileName);
	If Profile <> Undefined Then 
		NewAllowedApp = Profile.CreateAllowedExternalApplication();
		NewAllowedApp.Name = ApplicationSettings.Name;
		NewAllowedApp.Description = ApplicationSettings.Description;
		NewAllowedApp.CommandString = ApplicationSettings.CommandString;
		NewAllowedApp.Write();
	EndIf;	
EndProcedure

&AtServerNoContext
Procedure AddInternetResourceOnCluster(ConnectionSettings, ClusterSettings, InternetResourceSettings)
	Var Profile, NewInternerResource; 
	Profile = GetSecurityProfile(ConnectionSettings, ClusterSettings, InternetResourceSettings.ProfileName);
	If Profile <> Undefined Then 
		NewInternerResource = Profile.CreateAllowedInternetResource();
		NewInternerResource.Name = InternetResourceSettings.Name;
		NewInternerResource.Address = InternetResourceSettings.Address;
		NewInternerResource.Description = InternetResourceSettings.Description;
		NewInternerResource.Port = InternetResourceSettings.Port;
		NewInternerResource.Protocol = InternetResourceSettings.Protocol;
		NewInternerResource.Write();
	EndIf;
EndProcedure

#EndRegion

#Region GetObjectsParamsRegion
&AtServerNoContext
Function GetParameterStructureLimit(ConnectionSettings, ClusterSettings, LimitName)
	Var LimitSettings, Cluster, Limits, Limit;
	LimitSettings = New Structure();
	Cluster = GetAdministrationCluster(ConnectionSettings, ClusterSettings);
	Limits = Cluster.GetResourceConsumptionLimits();
	For each Limit In Limits Do
		If Limit.Name = LimitName Then
			LimitSettings.Insert("Name", Limit.Name);
			LimitSettings.Insert("Counter", Limit.Counter);
			LimitSettings.Insert("Action", Limit.Action);
			LimitSettings.Insert("CallDuration", Limit.CallDuration);
			LimitSettings.Insert("ServiceCallDuration", Limit.ServiceCallDuration);
			LimitSettings.Insert("DBMSCallDuration", Limit.DBMSCallDuration);
			LimitSettings.Insert("ActiveSessionCount", Limit.ActiveSessionCount);
			LimitSettings.Insert("CallCount", Limit.CallCount);
			LimitSettings.Insert("SessionCount", Limit.SessionCount);
			LimitSettings.Insert("DBMSSentAndReceivedDataSize", Limit.DBMSSentAndReceivedDataSize);
			LimitSettings.Insert("WriteDiskDataSize", Limit.WriteDiskDataSize);
			LimitSettings.Insert("ReadDiskDataSize", Limit.ReadDiskDataSize);
			LimitSettings.Insert("MemoryUsage", Limit.MemoryUsage);
			LimitSettings.Insert("CPUTime", Limit.CPUTime);
			LimitSettings.Insert("ErrorMessage", Limit.ErrorMessage);
			LimitSettings.Insert("Description", Limit.Description);
			Break;
		EndIf;
	EndDo;
	Return LimitSettings;
EndFunction

&AtServerNoContext
Function GetParameterStructureCounter(ConnectionSettings, ClusterSettings, CounterName)
	Var CounterSettings, Cluster, Counters, ResourceCounter;
	CounterSettings = New Structure();
	Cluster = GetAdministrationCluster(ConnectionSettings, ClusterSettings);
	Counters = Cluster.GetResourceConsumptionCounters();
	For each ResourceCounter In Counters Do
		If ResourceCounter.Name = CounterName Then
			CounterSettings.Insert("Name", ResourceCounter.Name);
			CounterSettings.Insert("Group", ResourceCounter.Group);
			CounterSettings.Insert("CollectionTime", ResourceCounter.CollectionTime);
			CounterSettings.Insert("CollectCallsDuration", ResourceCounter.CollectCallsDuration);
			CounterSettings.Insert("CollectServiceCallsDuration", ResourceCounter.CollectServiceCallsDuration);
			CounterSettings.Insert("CollectDBMSCallsDuration", ResourceCounter.CollectDBMSCallsDuration);
			CounterSettings.Insert("CollectActiveSessionsCount", ResourceCounter.CollectActiveSessionsCount);
			CounterSettings.Insert("CollectCallsCount", ResourceCounter.CollectCallsCount);
			CounterSettings.Insert("CollectSessionCount", ResourceCounter.CollectSessionCount);
			CounterSettings.Insert("CollectDBMSSentAndReceivedDataSize", ResourceCounter.CollectDBMSSentAndReceivedDataSize);
			CounterSettings.Insert("CollectWriteDiskDataSize", ResourceCounter.CollectWriteDiskDataSize);
			CounterSettings.Insert("CollectReadDiskDataSize", ResourceCounter.CollectReadDiskDataSize);
			CounterSettings.Insert("CollectMemoryUsage", ResourceCounter.CollectMemoryUsage);
			CounterSettings.Insert("CollectCPUTime", ResourceCounter.CollectCPUTime);
			CounterSettings.Insert("FilterType", ResourceCounter.FilterType);
			CounterSettings.Insert("FilterValue", ResourceCounter.FilterValue);
			CounterSettings.Insert("Description", ResourceCounter.Description);
			Break;
		EndIf;
	EndDo;
	Return CounterSettings;
EndFunction

&AtServerNoContext
Function GetParameterStructureSecurityProfile(ConnectionSettings, ClusterSettings, ProfileName)
	Var ProfileSettings, Cluster, Profiles, Profile;  
	ProfileSettings = New Structure();
	Cluster = GetAdministrationCluster(ConnectionSettings, ClusterSettings);
	Profiles = Cluster.GetSecurityProfiles();
	For each Profile In Profiles Do
		If Profile.Name = ProfileName Then
			ProfileSettings.Insert("Name", Profile.Name);
			ProfileSettings.Insert("Description", Profile.Description);
			ProfileSettings.Insert("AllowExternalCodeExecutionInUnsafeMode", Profile.AllowExternalCodeExecutionInUnsafeMode);
			ProfileSettings.Insert("CryptoAvailable", Profile.CryptoAvailable);
			ProfileSettings.Insert("ModulesAvailableForExtension", Profile.ModulesAvailableForExtension);
			ProfileSettings.Insert("ModulesNotAvailableForExtension", Profile.ModulesNotAvailableForExtension);
			ProfileSettings.Insert("COMObjectFullAccess", Profile.COMObjectFullAccess);
			ProfileSettings.Insert("AddInFullAccess", Profile.AddInFullAccess);
			ProfileSettings.Insert("ExternalModuleFullAccess", Profile.ExternalModuleFullAccess);
			ProfileSettings.Insert("InternetResourcesFullAccess", Profile.InternetResourcesFullAccess);
			ProfileSettings.Insert("ExternalApplicationsFullAccess", Profile.ExternalApplicationsFullAccess);
			ProfileSettings.Insert("FileSystemFullAccess", Profile.FileSystemFullAccess);
			ProfileSettings.Insert("SafeModeProfile", Profile.SafeModeProfile);
			ProfileSettings.Insert("PrivilegedModeAllowed", Profile.PrivilegedModeAllowed);
			ProfileSettings.Insert("AccessRightsExtensionLimitingRoles", Profile.AccessRightsExtensionLimitingRoles);	
			ProfileSettings.Insert("AllowAccessRightsExtension", Profile.AllowAccessRightsExtension);
			ProfileSettings.Insert("PrivilegedModeRoles", Profile.PrivilegedModeRoles);			
			Break;
		EndIf;
	EndDo;
	Return ProfileSettings;
EndFunction

&AtServerNoContext
Function GetParameterStructureVirtualDirectory(ConnectionSettings, ClusterSettings, ProfileName, DirectoryAlias)
	Var DirectorySettings, Profile, VirtualDurectory;
	DirectorySettings = New Structure();
	Profile = GetSecurityProfile(ConnectionSettings, ClusterSettings, ProfileName);
	For each VirtualDurectory In Profile.GetAllowedVirtualDirectories() Do
		If VirtualDurectory.Alias = DirectoryAlias Then
			DirectorySettings.Insert("ProfileName", Profile.Name);
			DirectorySettings.Insert("Alias", VirtualDurectory.Alias);
			DirectorySettings.Insert("ReadingAllowed", VirtualDurectory.ReadingAllowed);
			DirectorySettings.Insert("WritingAllowed", VirtualDurectory.WritingAllowed);
			DirectorySettings.Insert("Path", VirtualDurectory.Path);
			DirectorySettings.Insert("Description", VirtualDurectory.Description);
			Break;
		EndIf;
	EndDo;
	Return DirectorySettings;
EndFunction

&AtServerNoContext
Function GetParameterStructureAddIn(ConnectionSettings, ClusterSettings, ProfileName, AddInName)
	Var Profile, AddInSettings;
	AddInSettings = New Structure();
	Profile = GetSecurityProfile(ConnectionSettings, ClusterSettings, ProfileName);
	For each AddIn In Profile.GetAllowedAddIns() Do
		If AddIn.Name = AddInName Then
			AddInSettings.Insert("ProfileName", Profile.Name);
			AddInSettings.Insert("Name", AddIn.Name);
			AddInSettings.Insert("HashSum", AddIn.HashSum);
			AddInSettings.Insert("Description", AddIn.Description);
			Break;
		EndIf;
	EndDo;
	Return AddInSettings;
EndFunction

&AtServerNoContext
Function GetParameterStructureCOMClass(ConnectionSettings, ClusterSettings, ProfileName, COMClassName)
	Var COMClassSettings, Profile, COMClass;
	COMClassSettings = New Structure();
	Profile = GetSecurityProfile(ConnectionSettings, ClusterSettings, ProfileName);
	For each COMClass In Profile.GetAllowedCOMClass() Do
		If COMClass.Name = COMClassName Then
			COMClassSettings.Insert("Name", COMClass.Name);
			COMClassSettings.Insert("ProfileName", Profile.Name);
			COMClassSettings.Insert("ObjectUUID", COMClass.ObjectUUID);
			COMClassSettings.Insert("Description", COMClass.Description);
			COMClassSettings.Insert("ComputerName", COMClass.ComputerName);
			COMClassSettings.Insert("FileName", COMClass.FileName);
			Break;
		EndIf;
	EndDo;
	Return COMClassSettings;
EndFunction

&AtServerNoContext
Function GetParameterStructureExternalModule(ConnectionSettings, ClusterSettings, ProfileName, ExternalModuleName)
	Var Profile, ExternalModuleSettings, ExternalModule;
	ExternalModuleSettings = New Structure();
	Profile = GetSecurityProfile(ConnectionSettings, ClusterSettings, ProfileName);
	For each ExternalModule In Profile.GetAllowedExternalModules() Do
		If ExternalModule.Name = ExternalModuleName Then
			ExternalModuleSettings.Insert("ProfileName", Profile.Name);
			ExternalModuleSettings.Insert("Name", ExternalModule.Name);
			ExternalModuleSettings.Insert("HashSum", ExternalModule.HashSum);
			ExternalModuleSettings.Insert("Description", ExternalModule.Description);
			Break;
		EndIf;
	EndDo;
	Return ExternalModuleSettings;
EndFunction

&AtServerNoContext
Function GetParameterStructureAllowedApplication(ConnectionSettings, ClusterSettings, ProfileName, ApplicationName)
	Var ApplicationSettings, Profile, ExternalApplication;
	ApplicationSettings = New Structure();
	Profile = GetSecurityProfile(ConnectionSettings, ClusterSettings, ProfileName);
	For each ExternalApplication In Profile.GetAllowedExternalApplications() Do
		If ExternalApplication.Name = ApplicationName Then
			ApplicationSettings.Insert("ProfileName", Profile.Name);
			ApplicationSettings.Insert("Name", ExternalApplication.Name);
			ApplicationSettings.Insert("CommandString", ExternalApplication.CommandString);
			ApplicationSettings.Insert("Description", ExternalApplication.Description);
			Break;
		EndIf;
	EndDo;
	Return ApplicationSettings;
EndFunction

&AtServerNoContext
Function GetParameterStructureInternetResource(ConnectionSettings, ClusterSettings, ProfileName, InternetResourceName)
	InternetResourceSettings = New Structure();
	Profile = GetSecurityProfile(ConnectionSettings, ClusterSettings, ProfileName);
	For each InternetResource In Profile.GetAllowedInternetResources() Do
		If InternetResource.Name = InternetResourceName Then
			InternetResourceSettings.Insert("ProfileName", Profile.Name);
			InternetResourceSettings.Insert("Name", InternetResource.Name);
			InternetResourceSettings.Insert("Address", InternetResource.Address);
			InternetResourceSettings.Insert("Port", InternetResource.Port);
			InternetResourceSettings.Insert("Protocol", InternetResource.Protocol);
			InternetResourceSettings.Insert("Description", InternetResource.Description);
			Break;
		EndIf;
	EndDo;	
	Return InternetResourceSettings;
EndFunction

&AtServerNoContext
Function GetParameterStructureWorkProcess(ConnectionSettings, ClusterSettings, WorkProcessID)
	Var Cluster, WorkProcesses, WorkProcess, License, WorkProcessSettings, Licenses;
	WorkProcessSettings = New Structure();
	Cluster = GetAdministrationCluster(ConnectionSettings, ClusterSettings);
	WorkProcesses = Cluster.GetWorkProcesses();
	For each WorkProcess In WorkProcesses Do
		If WorkProcess.WorkProcessID = WorkProcessID Then
			WorkProcessSettings.Insert("Running", WorkProcess.Running);
			WorkProcessSettings.Insert("Capacity", WorkProcess.Capacity);
			WorkProcessSettings.Insert("ComputerName", WorkProcess.ComputerName);
			WorkProcessSettings.Insert("Enable", WorkProcess.Enable);
			WorkProcessSettings.Insert("Port", WorkProcess.Port);
			WorkProcessSettings.Insert("MemoryUsageExcessTime", WorkProcess.MemoryUsageExcessTime);
			WorkProcessSettings.Insert("StartTime", WorkProcess.StartTime);
			WorkProcessSettings.Insert("WorkProcessStatus", WorkProcess.WorkProcessStatus);
			WorkProcessSettings.Insert("AvailablePerformance", WorkProcess.AvailablePerformance);
			WorkProcessSettings.Insert("AverageCallDuration", WorkProcess.AverageCallDuration);
			WorkProcessSettings.Insert("AverageDBMSCallsDuration", WorkProcess.AverageDBMSCallsDuration);
			WorkProcessSettings.Insert("AverageServiceCallDuration", WorkProcess.AverageServiceCallDuration);
			WorkProcessSettings.Insert("AverageWorkProcessCallProcessingDuration", WorkProcess.AverageWorkProcessCallProcessingDuration);
			WorkProcessSettings.Insert("AverageThreadCount", WorkProcess.AverageThreadCount);
			WorkProcessSettings.Insert("ProcessID", WorkProcess.ProcessID);
			WorkProcessSettings.Insert("MemoryUsage", WorkProcess.MemoryUsage);
			WorkProcessSettings.Insert("Reserve", WorkProcess.Reserve);
			Licenses = "";
			For each License In WorkProcess.Licenses Do
				Licenses = Licenses + License.DetailedPresentation + ";";	
			EndDo;
			WorkProcessSettings.Insert("Licenses", Licenses);
			Break;	
		EndIf;
	EndDo;	
	Return WorkProcessSettings;
EndFunction

&AtServerNoContext
Function GetParameterStructureClusterManager(ConnectionSettings, ClusterSettings, ClusterManagerName)
	Var ClusterManagerSettings, Cluster, ClusterManagers, ClusterManager;
	ClusterManagerSettings = New Structure();
	Cluster = GetAdministrationCluster(ConnectionSettings, ClusterSettings);
	ClusterManagers = Cluster.GetClusterManagers();
	For each ClusterManager In ClusterManagers Do
		If ClusterManager.Description = ClusterManagerName Then
			ClusterManagerSettings.Insert("MainManager", ClusterManager.MainManager);
			ClusterManagerSettings.Insert("ProcessID", ClusterManager.ProcessID);
			ClusterManagerSettings.Insert("ComputerName", ClusterManager.ComputerName);
			ClusterManagerSettings.Insert("Description", ClusterManager.Description);
			ClusterManagerSettings.Insert("Port", ClusterManager.Port);
			Break;	
		EndIf;
	EndDo;
	Return ClusterManagerSettings;
EndFunction

&AtServerNoContext
Function GetParameterStructureWorkServer(ConnectionSettings, ClusterSettings, WorkServerName)
	Var WorkServerSettings, Cluster, WorkServers, WorkServer, IPPortRanges, PortRange, NewPortRange;
	WorkServerSettings = New Structure();
	PortRange = New Array();
	Cluster = GetAdministrationCluster(ConnectionSettings, ClusterSettings);
	WorkServers = Cluster.GetWorkServers();
	For each WorkServer In WorkServers Do
		If WorkServer.ComputerName = WorkServerName Then
			WorkServerSettings.Insert("ComputerName", WorkServer.ComputerName);
			WorkServerSettings.Insert("SingleProcessConnectionsCount", WorkServer.SingleProcessConnectionsCount);
			WorkServerSettings.Insert("SingleProcessInfobasesCount", WorkServer.SingleProcessInfobasesCount);
			WorkServerSettings.Insert("MainManagerPort", WorkServer.MainManagerPort);
			WorkServerSettings.Insert("CreateManagerForEachService", WorkServer.CreateManagerForEachService);
			WorkServerSettings.Insert("Port", WorkServer.Port);
			IPPortRanges = New Array();
			For each IPPortRange In WorkServer.PortRanges Do
				NewPortRange = New Structure();
				NewPortRange.Insert("LowerBound", IPPortRange.LowerBound);
				NewPortRange.Insert("UpperBound", IPPortRange.UpperBound);
				PortRange.Add(NewPortRange);
			EndDo;
			WorkServerSettings.Insert("IPPortRanges", PortRange);
			WorkServerSettings.Insert("CentralServer", WorkServer.CentralServer);
			WorkServerSettings.Insert("Name", WorkServer.Name);
			WorkServerSettings.Insert("SingleCallSafeMemoryUsage", WorkServer.SingleCallSafeMemoryUsage);
			WorkServerSettings.Insert("WorkProcessSafeMemoryUsage", WorkServer.WorkProcessSafeMemoryUsage);
			WorkServerSettings.Insert("WorkProcessMemoryUsageLimit", WorkServer.WorkProcessMemoryUsageLimit);
			WorkServerSettings.Insert("CriticalProcessesTotalMemory", WorkServer.CriticalProcessesTotalMemory);
			WorkServerSettings.Insert("TemporaryAllowedProcessesTotalMemory", WorkServer.TemporaryAllowedProcessesTotalMemory);
			WorkServerSettings.Insert("TemporaryAllowedProcessesTotalMemoryExcessTimeLimit", 
				WorkServer.TemporaryAllowedProcessesTotalMemoryExcessTimeLimit);
			Break;	
		EndIf;
	EndDo;	
	Return WorkServerSettings;
EndFunction

&AtServerNoContext
Function GetParameterStructureAgentAdministrator(ConnectionSettings, AgentAdministrationName)
	Var AdministratorSettings, AdministrationAgent, AgentAdministrators, AgentAdministrator;
	AdministratorSettings = New Structure();
	AdministrationAgent = GetAdministrationAgent(ConnectionSettings);
	AgentAdministrators = AdministrationAgent.GetAdministrators();
	For each AgentAdministrator In AgentAdministrators Do
		If AgentAdministrator.Name = AgentAdministrationName Then
			AdministratorSettings.Insert("Name", AgentAdministrator.Name);
			AdministratorSettings.Insert("Description", AgentAdministrator.Description);
			AdministratorSettings.Insert("Password", AgentAdministrator.Password);
			Break;	
		EndIf;
	EndDo;
	Return AdministratorSettings;	
EndFunction

&AtServerNoContext
Function GetParameterStructureClusterAdministrator(ConnectionSettings, ClusterSettings, ClusterAdministratorName)
	Var AdministratorSettings, Cluster, ClusterAdministrators, ClusterAdministrator;
	AdministratorSettings = New Structure();
	Cluster = GetAdministrationCluster(ConnectionSettings, ClusterSettings);
	ClusterAdministrators = Cluster.GetClusterAdministrators();
	For each ClusterAdministrator In ClusterAdministrators Do
		If ClusterAdministrator.Name = ClusterAdministratorName Then
			AdministratorSettings.Insert("Name", ClusterAdministrator.Name);
			AdministratorSettings.Insert("Description", ClusterAdministrator.Description);
			AdministratorSettings.Insert("Password", ClusterAdministrator.Password);
			Break;	
		EndIf;
	EndDo;
	Return AdministratorSettings;	
EndFunction

#EndRegion

#Region ModifyingObjectsRegion

&AtServerNoContext
Procedure UpdateLimitOnCluster(ConnectionSettings, ClusterSettings, LimitSettings)
	Var Cluster, Limits, Limit; 
	Cluster = GetAdministrationCluster(ConnectionSettings, ClusterSettings);
	Limits = Cluster.GetResourceConsumptionLimits();
	For each Limit In Limits Do
		If Limit.Name = LimitSettings.Name Then
			Limit.Action = LimitSettings.Action;
			Limit.CallDuration = LimitSettings.CallDuration;
			Limit.ServiceCallDuration = LimitSettings.ServiceCallDuration;
			Limit.DBMSCallDuration = LimitSettings.DBMSCallDuration;
			Limit.ActiveSessionCount = LimitSettings.ActiveSessionCount;
			Limit.CallCount = LimitSettings.CallCount;
			Limit.SessionCount = LimitSettings.SessionCount;
			Limit.DBMSSentAndReceivedDataSize = LimitSettings.DBMSSentAndReceivedDataSize;
			Limit.WriteDiskDataSize = LimitSettings.WriteDiskDataSize;
			Limit.ReadDiskDataSize = LimitSettings.ReadDiskDataSize;
			Limit.Description = LimitSettings.Description;
			Limit.MemoryUsage = LimitSettings.MemoryUsage;
			Limit.CPUTime = LimitSettings.CPUTime;
			Limit.Counter = LimitSettings.Counter;
			Limit.ErrorMessage = LimitSettings.ErrorMessage;
			Limit.Write();
			Break;
		EndIf;
	EndDo;	
EndProcedure

&AtServerNoContext
Procedure UpdateCounterOnCluster(ConnectionSettings, ClusterSettings, CounterSettings)
	Cluster = GetAdministrationCluster(ConnectionSettings, ClusterSettings);
	Coutners = Cluster.GetResourceConsumptionCounters();
	For each ResourceCounter In Coutners Do
		If ResourceCounter.Name = CounterSettings.Name Then
			ResourceCounter.Group = CounterSettings.Group;
			ResourceCounter.CollectionTime = CounterSettings.CollectionTime;
			ResourceCounter.CollectCallsDuration = CounterSettings.CollectCallsDuration;
			ResourceCounter.CollectServiceCallsDuration = CounterSettings.CollectServiceCallsDuration;
			ResourceCounter.CollectDBMSCallsDuration = CounterSettings.CollectDBMSCallsDuration;
			ResourceCounter.CollectActiveSessionsCount = CounterSettings.CollectActiveSessionsCount;
			ResourceCounter.CollectCallsCount = CounterSettings.CollectCallsCount;
			ResourceCounter.CollectSessionCount = CounterSettings.CollectSessionCount;
			ResourceCounter.CollectDBMSSentAndReceivedDataSize = CounterSettings.CollectDBMSSentAndReceivedDataSize;
			ResourceCounter.CollectWriteDiskDataSize = CounterSettings.CollectWriteDiskDataSize;
			ResourceCounter.CollectReadDiskDataSize = CounterSettings.CollectReadDiskDataSize;
			ResourceCounter.CollectMemoryUsage = CounterSettings.CollectMemoryUsage;
			ResourceCounter.CollectCPUTime = CounterSettings.CollectCPUTime;
			ResourceCounter.FilterType = CounterSettings.FilterType;
			ResourceCounter.FilterValue = CounterSettings.FilterValue;
			ResourceCounter.Description = CounterSettings.Description;
			ResourceCounter.Write();
			Break;
		EndIf;
	EndDo;
EndProcedure

&AtServerNoContext
Procedure UpdateSecurityProfileOnCluster(ConnectionSettings, ClusterSettings, ProfileSettings)
	Var Cluster, Profiles, Profile;
	Cluster = GetAdministrationCluster(ConnectionSettings, ClusterSettings);
	Profiles = Cluster.GetSecurityProfiles();
	For each Profile In Profiles Do
		If Profile.Name = ProfileSettings.Name Then
			Profile.Description = ProfileSettings.Description;
			Profile.AllowExternalCodeExecutionInUnsafeMode = ProfileSettings.AllowExternalCodeExecutionInUnsafeMode;
			Profile.CryptoAvailable = ProfileSettings.CryptoAvailable;
			Profile.ModulesAvailableForExtension = ProfileSettings.ModulesAvailableForExtension;
			Profile.ModulesNotAvailableForExtension = ProfileSettings.ModulesNotAvailableForExtension;
			Profile.COMObjectFullAccess = ProfileSettings.COMObjectFullAccess;
			Profile.AddInFullAccess = ProfileSettings.AddInFullAccess;
			Profile.ExternalModuleFullAccess = ProfileSettings.ExternalModuleFullAccess;
			Profile.InternetResourcesFullAccess = ProfileSettings.InternetResourcesFullAccess;
			Profile.ExternalApplicationsFullAccess = ProfileSettings.ExternalApplicationsFullAccess;
			Profile.FileSystemFullAccess = ProfileSettings.FileSystemFullAccess;
			Profile.SafeModeProfile = ProfileSettings.SafeModeProfile;
			Profile.PrivilegedModeAllowed = ProfileSettings.PrivilegedModeAllowed;
			Profile.AccessRightsExtensionLimitingRoles = ProfileSettings.AccessRightsExtensionLimitingRoles;
			Profile.AllowAccessRightsExtension = ProfileSettings.AllowAccessRightsExtension;
			Profile.PrivilegedModeRoles = ProfileSettings.PrivilegedModeRoles;			
			Profile.Write();
			Break;
		EndIf;
	EndDo;
EndProcedure

&AtServerNoContext
Procedure UpdateVirtualDirectoryOnCluster(ConnectionSettings, ClusterSettings, DirectorySettings)
	Var Profile, VirtualDirectory;
	Profile = GetSecurityProfile(ConnectionSettings, ClusterSettings, DirectorySettings.ProfileName);
	For each VirtualDirectory In Profile.GetAllowedVirtualDirectories() Do
		If VirtualDirectory.Alias = DirectorySettings.Alias Then
			VirtualDirectory.ReadingAllowed = DirectorySettings.ReadingAllowed;
			VirtualDirectory.WritingAllowed = DirectorySettings.WritingAllowed;
			VirtualDirectory.Path = DirectorySettings.Path;
			VirtualDirectory.Description = DirectorySettings.Description;
			VirtualDirectory.Write();
			Break;
		EndIf;
	EndDo;
EndProcedure

&AtServerNoContext
Procedure UpdateCOMClassOnCluster(ConnectionSettings, ClusterSettings, COMClassSettings)
	Var Profile, COMClass;
	Profile = GetSecurityProfile(ConnectionSettings, ClusterSettings, COMClassSettings.ProfileName);
	For each COMClass In Profile.GetAllowedCOMClass() Do
		If COMClass.Name = COMClassSettings.Name Then
			COMClass.ObjectUUID = COMClassSettings.ObjectUUID;
			COMClass.Description = COMClassSettings.Description;
			COMClass.ComputerName = COMClassSettings.ComputerName;
			COMClass.FileName = COMClassSettings.FileName;
			COMClass.Write();
			Break;
		EndIf;
	EndDo;	
EndProcedure

&AtServerNoContext
Procedure UpdateAddInOnCluster(ConnectionSettings, ClusterSettings, AddInSettings)
	Var Profile, AddIn;
	Profile = GetSecurityProfile(ConnectionSettings, ClusterSettings, AddInSettings.ProfileName);
	For each AddIn In Profile.GetAllowedAddIns() Do
		If AddIn.Name = AddInSettings.Name Then
			AddIn.HashSum = AddInSettings.HashSum;
			AddIn.Description = AddInSettings.Description;
			AddIn.Write();
			Break;
		EndIf;
	EndDo;
EndProcedure

&AtServerNoContext
Procedure UpdateExternalModuleOnCluster(ConnectionSettings, ClusterSettings, ExternalModuleSettings)
	Var Profile, ExternalModule; 
	Profile = GetSecurityProfile(ConnectionSettings, ClusterSettings, 
		ExternalModuleSettings.ProfileName);
	For each ExternalModule In Profile.GetAllowedExternalModules() Do
		If ExternalModule.Name = ExternalModuleSettings.Name Then
			ExternalModule.HashSum = ExternalModuleSettings.HashSum;
			ExternalModule.Description = ExternalModuleSettings.Description;
			ExternalModule.Write();
			Break;
		EndIf;
	EndDo;
EndProcedure

&AtServerNoContext
Procedure UpdateAllowedApplicationOnCluster(ConnectionSettings, ClusterSettings, ApplicationSettings)
	Var Profile, ExternalApplication;
	Profile = GetSecurityProfile(ConnectionSettings, ClusterSettings, 
			ApplicationSettings.ProfileName);
	For each ExternalApplication In Profile.GetAllowedExternalApplications() Do
		If ExternalApplication.Name = ApplicationSettings.Name Then
			ExternalApplication.CommandString = ApplicationSettings.CommandString;
			ExternalApplication.Description = ApplicationSettings.Description;
			ExternalApplication.Write();
			Break;
		EndIf;
	EndDo;
EndProcedure

&AtServerNoContext
Procedure UpdateInternetResourceOnCluster(ConnectionSettings, ClusterSettings, InteretResourceSettings)
	Profile = GetSecurityProfile(ConnectionSettings, ClusterSettings, 
			InteretResourceSettings.ProfileName);
	For each InternetResource in Profile.GetAllowedInternetResources() Do
		If InternetResource.Name = InteretResourceSettings.Name Then
			InternetResource.Address = InteretResourceSettings.Address;
			InternetResource.Port = InteretResourceSettings.Port;
			InternetResource.Protocol = InteretResourceSettings.Protocol;
			InternetResource.Description = InteretResourceSettings.Description;
			InternetResource.Write();
			Break;
		EndIf;
	EndDo;	
EndProcedure

&AtServerNoContext
Procedure UpdateAssignmentRuleOnCluster(ConnectionSettings, ClusterSettings,
	AssignmentRuleSettings, WorkServerName)
	Var Cluster, WorkServer, WorkServers, AssignmentRules, AssignmentRule;
	Cluster = GetAdministrationCluster(ConnectionSettings, ClusterSettings);
	WorkServers = Cluster.GetWorkServers();
	For each WorkServer In WorkServers Do
		If WorkServer.ComputerName = WorkServerName Then
			AssignmentRules = WorkServer.GetAssignmentRules();
			For each AssignmentRule In AssignmentRules Do
				If AssignmentRule.RuleID = AssignmentRuleSettings.RuleID Then
					AssignmentRule.AdditionalParameter = AssignmentRuleSettings.AdditionalParameter;
					AssignmentRule.InfoBaseName = AssignmentRuleSettings.InfoBaseName;
					AssignmentRule.Priority = AssignmentRuleSettings.Priority;
					AssignmentRule.ObjectType = AssignmentRuleSettings.ObjectType;
					AssignmentRule.AssignmentRuleType = AssignmentRuleSettings.AssignmentRuleType;
					AssignmentRule.Write();
					Break;
				EndIf;
			EndDo;
			Break;
		EndIf;
	EndDo;	
EndProcedure

&AtServerNoContext
Procedure AddAssignmentRuleOnCluster(ConnectionSettings, ClusterSettings,
	AssignmentRuleSettings, WorkServerName)
	Var Cluster, WorkServer, WorkServers, NewAssignmentRule;
	Cluster = GetAdministrationCluster(ConnectionSettings, ClusterSettings);
	WorkServers = Cluster.GetWorkServers();
	For each WorkServer In WorkServers Do
		If WorkServer.ComputerName = WorkServerName Then
			NewAssignmentRule = WorkServer.CreateAssignmentRule();
			NewAssignmentRule.AdditionalParameter = AssignmentRuleSettings.AdditionalParameter;
			NewAssignmentRule.InfoBaseName = AssignmentRuleSettings.InfoBaseName;
			NewAssignmentRule.Priority = AssignmentRuleSettings.Priority;
			NewAssignmentRule.ObjectType = AssignmentRuleSettings.ObjectType;
			NewAssignmentRule.AssignmentRuleType = AssignmentRuleSettings.AssignmentRuleType;
			NewAssignmentRule.Write();
			Break;
		EndIf;
	EndDo;	
EndProcedure

#EndRegion

#Region FillingTablesRegion
&AtServer
Procedure FillConnectionsTable(ConnectionSettings, ClusterSettings)
	Var Cluster, Infobases, Infobase, Connections, Connection, NewLine;
	Cluster = GetAdministrationCluster(ConnectionSettings, ClusterSettings);
	Infobases = Cluster.GetInfoBases();
	Connections = Cluster.GetConnections();
	For each Connection In Connections Do
		NewLine = ConnectionsTable.Add();
		NewLine.StartDate = Connection.ConnectionTime;
		NewLine.InfobaseID = Connection.InfoBaseID;
		For each Infobase In Infobases Do
			If Infobase.InfobaseID = Connection.InfoBaseID Then
				NewLine.Infobase = Infobase.Name;
				Break;
			EndIf;
		EndDo;
		NewLine.Connection = Connection.ConnectionNumber;
		NewLine.Computer = Connection.ComputerName;
		NewLine.Session = Connection.SessionNumber;
		NewLine.Application = ApplicationPresentation(Connection.ApplicationName);
		NewLine.ConnectionID = Connection.ConnectionID;
		NewLine.PictureIndex = 21;
	EndDo;			
EndProcedure

&AtServer
Procedure FillLocksTable(ConnectionSettings, ClusterSettings)
	Var Cluster, Infobases, Locks, Lock, NewLine;
	Cluster = GetAdministrationCluster(ConnectionSettings, ClusterSettings);
	Infobases = Cluster.GetInfoBases();
	Locks = Cluster.GetLocks();
	For each Lock In Locks Do
		NewLine = LocksTable.Add();
		NewLine.LockStartTime = Lock.LockBeginTime;
		NewLine.ObjectID = Lock.ObjectID;
		NewLine.Description = Lock.Description;
		NewLine.PictureIndex = 18;
	EndDo;	
EndProcedure

&AtServer
Procedure FillSessionTable(ConnectionSettings, ClusterSettings)
	Var Cluster, Infobases, Sessions, Session, Infobase, NewTableLine, 
		SessionLicenses, SessionLicense, TempTable;
	Cluster = GetAdministrationCluster(ConnectionSettings, ClusterSettings);
	Infobases = Cluster.GetInfoBases();
	Sessions = Cluster.GetSessions();
	TempTable = FormAttributeToValue("SessionTable");
	For each Session In Sessions Do
		NewTableLine = TempTable.Add();
		For each Infobase In Infobases Do
			If Infobase.InfoBaseID = Session.InfoBaseID Then
				NewTableLine.infobase = Infobase.Name;
				Break;
			EndIf;
		EndDo;
		NewTableLine.PictureIndex = 16;
		NewTableLine.ApplicationName = Session.ApplicationName;
		NewTableLine.DBMSLockSessionNumber = Session.DBMSLockSessionNumber;
		NewTableLine.ManagedLockSessionNumber = Session.ManagedLockSessionNumber;
		NewTableLine.SessionNumber = Session.SessionNumber;
		NewTableLine.BeginTime = Session.BeginTime;
		NewTableLine.LastActivityTime = Session.LastActivityTime;
		NewTableLine.UserName = Session.UserName;
		NewTableLine.Locale = Session.LanguageCode;
		NewTableLine.Computer = Session.ComputerName;
		SessionLicenses = "";
		For each SessionLicense In Session.Licenses Do
			SessionLicenses = SessionLicense.DetailedPresentation + ";";	
		EndDo;
		NewTableLine.License = SessionLicenses;
		NewTableLine.DBMSConnection = Session.DBMSConnection;
		NewTableLine.HibernateSession = Session.HibernateSession;
		NewTableLine.HibernateSessionTerminateTime = Session.HibernateSessionTerminateTime;
		NewTableLine.PassiveSessionHibernateTime = Session.PassiveSessionHibernateTime;
		NewTableLine.DBMSLockSessionNumber = Session.DBMSLockSessionNumber;
		NewTableLine.ManagedLockSessionNumber = Session.ManagedLockSessionNumber;
		NewTableLine.SessionID = Session.SessionID;
		NewTableLine.CallDurationTotal = Session.CallDurationTotal;
		NewTableLine.CallDurationLast5Min = Session.CallDurationLast5Min;
		NewTableLine.CallDurationCurrent = Session.CallDurationCurrent;
		NewTableLine.MemoryUsageTotal = Session.MemoryUsageTotal;
		NewTableLine.MemoryUsageLast5Min = Session.MemoryUsageLast5Min;
		NewTableLine.MemoryUsageCurrent = Session.MemoryUsageCurrent;
		NewTableLine.ServiceCallDurationTotal = Session.ServiceCallDurationTotal;
		NewTableLine.ServiceCallDurationLast5Min = Session.ServiceCallDurationLast5Min;
		NewTableLine.ServiceCallDurationCurrent = Session.ServiceCallDurationCurrent;
		NewTableLine.DBMSCallDurationTotal = Session.DBMSCallDurationTotal;
		NewTableLine.DBMSCallDurationLast5Min = Session.DBMSCallDurationLast5Min;
		NewTableLine.DBMSCallDurationCurrent = Session.DBMSCallDurationCurrent;
		NewTableLine.CallCountTotal = Session.CallCountTotal;
		NewTableLine.CallCountLast5Min = Session.CallCountLast5Min;
		NewTableLine.WriteDiskDataSizeTotal = Session.WriteDiskDataSizeTotal;
		NewTableLine.WriteDiskDataSizeLast5Min = Session.WriteDiskDataSizeLast5Min;
		NewTableLine.WriteDiskDataSizeCurrent = Session.WriteDiskDataSizeCurrent;
		NewTableLine.ClientSentReceivedDataSize = Session.ClientSentReceivedDataSize;
		NewTableLine.ClientSentReceivedDataSizeLast5Min = Session.ClientSentReceivedDataSizeLast5Min;
		NewTableLine.DBMSSentReceivedDataSizeTotal = Session.DBMSSentAndReceivedDataSizeTotal;
		NewTableLine.DBMSSentReceivedDataSizeLast5Min = Session.DBMSSentAndReceivedDataSizeLast5Min;
		NewTableLine.ReadDiskDataSizeTotal = Session.ReadDiskDataSizeTotal;
		NewTableLine.ReadDiskDataSizeLast5Min = Session.ReadDiskDataSizeLast5Min;
		NewTableLine.ReadDiskDataSizeCurrent = Session.ReadDiskDataSizeCurrent;
		NewTableLine.CPUTimeTotal = Session.CPUTimeTotal;
		NewTableLine.CPUTimeLastLast5Min = Session.CPUTimeLast5Min;
		NewTableLine.CPUTimeCurrent = Session.CPUTimeCurrent;
		NewTableLine.CurrentServiceName = Session.CurrentServiceName;	
		NewTableLine.ClientIP = Session.ClientIPAddress;	 
	EndDo;
	ApllyFilterToSessionTable(TempTable);
	TableSessionPageCount = TempTable.Count() / 100 + 1;
	SessionStorageAddress = PutToTempStorage(TempTable, New UUID());
	SessionTablePageNumber = 0;
	ShowCurrentSessionTablePage();
EndProcedure

&AtServer
Procedure FillLimitsTable(ConnectionSettings, ClusterSettings)
	Var Cluster, Limit, NewTableLine;
	Cluster = GetAdministrationCluster(ConnectionSettings, ClusterSettings);
	For each Limit In Cluster.GetResourceConsumptionLimits() Do
		NewTableLine = TableLimits.Add();
		NewTableLine.PictureIndex = 39;
		NewTableLine.Name = Limit.Name;
		NewTableLine.Counter = Limit.Counter;
		NewTableLine.Description = Limit.Description;
	EndDo;
EndProcedure

&AtServer
Procedure FillSecurityProfileTable(ConnectionSettings, ClusterSettings)
	Var Cluster, Profile, NewTableLine;
	Cluster = GetAdministrationCluster(ConnectionSettings, ClusterSettings);
	For each Profile In Cluster.GetSecurityProfiles() Do
		NewTableLine = StandartInfoTable.Add();
		NewTableLine.Name = Profile.Name;
		NewTableLine.Description = Profile.Description;
		NewTableLine.PictureIndex = 23;
	EndDo;	
EndProcedure

&AtServer
Procedure FillCounterTable(ConnectionSettings, ClusterSettings)
	Var Cluster, Counter, NewTableLine;
	Cluster = GetAdministrationCluster(ConnectionSettings, ClusterSettings);
	For each Counter In Cluster.GetResourceConsumptionCounters() Do
		NewTableLine = StandartInfoTable.Add();
		NewTableLine.Name = Counter.Name;
		NewTableLine.Description = Counter.Description;
		NewTableLine.PictureIndex = 37;
	EndDo;	
EndProcedure

&AtServer
Procedure FillWorkProcessTable(ConnectionSettings, ClusterSettings)
	Var Cluster, WorkProcesses, WorkProcess, NewTableLine, Licenses, License;
	Cluster = GetAdministrationCluster(ConnectionSettings, ClusterSettings);	
	WorkProcesses = Cluster.GetWorkProcesses();
	For each WorkProcess In WorkProcesses Do
		NewTableLine = WorkProcessTable.Add();
		NewTableLine.ComputerName = WorkProcess.ComputerName;
		NewTableLine.Port = WorkProcess.Port;
		NewTableLine.WorkProcessStatus = WorkProcess.WorkProcessStatus;
		NewTableLine.PID = WorkProcess.ProcessID;
		NewTableLine.MemoryUsage = WorkProcess.MemoryUsage / 1024;
		NewTableLine.AvailablePerformance = WorkProcess.AvailablePerformance;
		Licenses = "";
		For each License In WorkProcess.Licenses Do
			Licenses = Licenses + License.DetailedPresentation + ";";	
		EndDo;
		NewTableLine.License = Licenses;
		NewTableLine.Reserve = WorkProcess.Reserve;
		NewTableLine.PictureIndex = 14;
	EndDo;	
EndProcedure

&AtServer
Procedure FillClusterManagerTable(ConnectionSettings, ClusterSettings)
	Var Cluster, ClusterManagers, ClusterManager, NewTableLine;
	Cluster = GetAdministrationCluster(ConnectionSettings, ClusterSettings);
	ClusterManagers = Cluster.GetClusterManagers();
	For each ClusterManager In ClusterManagers Do
		NewTableLine = ClusterManagerTable.Add();
		NewTableLine.Description = ClusterManager.Description;
		NewTableLine.Computer = ClusterManager.ComputerName;
		NewTableLine.PID = ClusterManager.ProcessID;
		NewTableLine.IPПорт = ClusterManager.Port;
		NewTableLine.PictureIndex = 12
	EndDo;
EndProcedure

&AtServer
Procedure FillWorkServerTable(ConnectionSettings, ClusterSettings)
	Var Cluster, NewTableLine, WorkServer;
	Cluster = GetAdministrationCluster(ConnectionSettings, ClusterSettings);
	For each WorkServer In Cluster.GetWorkServers() Do
		NewTableLine = StandartInfoTable.Add();
		NewTableLine.Name = WorkServer.ComputerName;
		NewTableLine.Description = WorkServer.Name;
		NewTableLine.PictureIndex = 7;	
	EndDo;
EndProcedure

&AtServer
Procedure FillInfoBaseTable(ConnectionSettings, ClusterSettings)
	Var Cluster, NewTableLine, InfoBase;
	Cluster = GetAdministrationCluster(ConnectionSettings, ClusterSettings);
	For each InfoBase In Cluster.GetInfoBases() Do
		NewTableLine = StandartInfoTable.Add();
		NewTableLine.Name = InfoBase.Name;
		NewTableLine.Description = InfoBase.Description;
		NewTableLine.PictureIndex = 5;		
	EndDo;	
EndProcedure

&AtServer
Procedure FillCounterValueTable(ConnectionSettings, ClusterSettings, CounterName)
	Var Cluster, Counter, CounterValues, CounterValue, Separators, NewTableLine,
		InfobaseTokenPosition, InfobaseName, SeparatorsTokenPosition, UserName, UserTokenPosition;
	Cluster = GetAdministrationCluster(ConnectionSettings, ClusterSettings);
	TempTable = FormAttributeToValue("CounterValueTable");
	For each Counter In Cluster.GetResourceConsumptionCounters() Do
		If Counter.Name = CounterName Then
			CounterValues = Counter.GetValues();
			For each CounterValue In CounterValues Do
				NewTableLine = TempTable.Add();
				InfobaseTokenPosition = Find(CounterValue.Object, ";");
				InfobaseName = Left(CounterValue.Object, InfobaseTokenPosition - 1);
				InfobaseName = Right(InfobaseName, StrLen(InfobaseName) - StrLen("infobase=")); 
				Separators = "";
				SeparatorsTokenPosition = Find(CounterValue.Object, "data-separation=");
				If SeparatorsTokenPosition <> 0 Then
					Separators = Right(CounterValue.Object, StrLen(CounterValue.Object) - 
							(SeparatorsTokenPosition + StrLen("data-separation")));			
				EndIf;
				UserName = "";
				UserTokenPosition = Find(CounterValue.Object, "user=");
				If UserTokenPosition <> 0 Then
					UserName = Right(CounterValue.Object, StrLen(CounterValue.Object) - (UserTokenPosition + StrLen("user")));	
				EndIf;
				NewTableLine.InfobaseName = InfobaseName;
				NewTableLine.Separators = Separators;
				NewTableLine.UserName = UserName;
				NewTableLine.CollectionTime = CounterValue.CollectionTime;
				NewTableLine.CallDuration = CounterValue.CallDuration;
				NewTableLine.CPUTime = CounterValue.CPUTime;
				NewTableLine.MemoryUsage = CounterValue.MemoryUsage;
				NewTableLine.ReadDiskDataSize = CounterValue.ReadDiskDataSize;
				NewTableLine.WriteDiskDataSize = CounterValue.WriteDiskDataSize;
				NewTableLine.ServiceCallDuration = CounterValue.ServiceCallDuration;
				NewTableLine.DBMSCallDuration = CounterValue.DBMSCallDuration;
				NewTableLine.DBMSSentReceivedDataSize = CounterValue.DBMSSentAndReceivedDataSize;
				NewTableLine.CallCount = CounterValue.CallCount;
				NewTableLine.SessionCount = CounterValue.SessionCount;
				NewTableLine.ActiveSessionCount = CounterValue.ActiveSessionCount;
				NewTableLine.PictureIndex = 37;	
			EndDo;
			Break;	
		EndIf;
	EndDo;
	ApllyFilterToCounterValueTable(TempTable);
	TableCounterValuePageCount = TempTable.Count() / 100 + 1;
	CounterValueStorageAddress = PutToTempStorage(TempTable, New UUID());
	CounterValueTablePageNumber = 0;
	ShowCurrentCounterValueTablePage();
EndProcedure

&AtServer
Procedure FillServiceTable(ConnectionSettings, ClusterSettings, CurrentManagerID)
	Var CLuster, ClusterManagers, Services, Service, ClusterManagerID, NewTableLine;
	Cluster = GetAdministrationCluster(ConnectionSettings, ClusterSettings);
	Services = Cluster.GetServices();
	For each Service In Services Do
		For each ClusterManagerID In Service.ManagerIDs Do
			If CurrentManagerID = ClusterManagerID Then
				NewTableLine = StandartInfoTable.Add();
				NewTableLine.Name = Service.Name;
				NewTableLine.Description = Service.Description;
				NewTableLine.PictureIndex = 19; 
			EndIf;
		EndDo;
	EndDo;
EndProcedure

&AtServer
Procedure FillAssignmentRuleTable(ConnectionSettings, ClusterSettings, WorkServerName)
	Var Cluster, WorkServers, Services, AssignmentRule, NewTableLine;
	Cluster = GetAdministrationCluster(ConnectionSettings, ClusterSettings);
	WorkServers = Cluster.GetWorkServers();
	Services = Cluster.GetServices();
	For each WorkServer In WorkServers Do
		If WorkServer.ComputerName = WorkServerName Then
			AssignmentRules = WorkServer.GetAssignmentRules();
			For each AssignmentRule In AssignmentRules Do
				NewTableLine = AssignmentRuleTable.Add();
				NewTableLine.Priority = AssignmentRule.Priority;
				NewTableLine.PictureIndex = 8;
				NewTableLine.AssignmentRuleType = AssignmentRule.AssignmentRuleType;
				If IsBlankString(AssignmentRule.ObjectType) Then
					NewTableLine.ObjectType = NStr("ru = 'Для всех';SYS='MainForm.IsBlankAssignmentObjectType'", "ru");
				ElsIf AssignmentRule.ObjectType = "Connection" Then
					NewTableLine.ObjectType = Nstr("ru = 'Клиентское соединение с информационной базой';SYS = 'MainForm.ClientConnection'", "ru");
				Else
					For each Service In Services Do
						If Service.Name = AssignmentRule.ObjectType Then
							NewTableLine.ObjectType = Service.Description;
							Break;
						EndIf;
					EndDo;
				EndIf;
				NewTableLine.AssignmentRuleID = AssignmentRule.RuleID;
				NewTableLine.ObjectName = AssignmentRule.ObjectType;
				NewTableLine.InfoBaseName = AssignmentRule.InfoBaseName;
				NewTableLine.AdditionalParameter = AssignmentRule.AdditionalParameter;
				If IsBlankString(NewTableLine.InfoBaseName) Then
					NewTableLine.InfoBaseName = NStr("ru = 'Для всех';SYS='MainForm.IsBlankAssignmentInfobase'", "ru");
				EndIf;
	
			EndDo;
		EndIf;
	EndDo;
EndProcedure

&AtServer
Procedure FillVirtualDirectoryTable(ConnectionSettings, ClusterSettings, ProfileName)
	Var Profile, VirtualDirectory, NewTableLine;
	Profile = GetSecurityProfile(ConnectionSettings, ClusterSettings, ProfileName);
	For each VirtualDirectory In Profile.GetAllowedVirtualDirectories() Do
		NewTableLine = StandartInfoTable.Add();
		NewTableLine.Name = VirtualDirectory.Alias;
		NewTableLine.Description = VirtualDirectory.Description;
		NewTableLine.PictureIndex = 25; 
	EndDo;
EndProcedure

&AtServer
Procedure FillAllowedComClassTable(ConnectionSettings, ClusterSettings, ProfileName)
	Var Profile, COMClass, NewTableLine;
	Profile = GetSecurityProfile(ConnectionSettings, ClusterSettings, ProfileName);
	For each COMClass In Profile.GetAllowedCOMClass() Do
		NewTableLine = StandartInfoTable.Add();
		NewTableLine.Name = COMClass.Name;
		NewTableLine.Description = COMClass.Description;
		NewTableLine.PictureIndex = 27; 
	EndDo;
EndProcedure

&AtServer
Procedure FillAllowedAddInTable(ConnectionSettings, ClusterSettings, ProfileName)
	Var Profile, AllowedAddIn, NewTableLine;
	Profile = GetSecurityProfile(ConnectionSettings, ClusterSettings, ProfileName);
	For each AllowedAddIn In Profile.GetAllowedAddIns() Do
		NewTableLine = StandartInfoTable.Add();
		NewTableLine.Name = AllowedAddIn.Name;
		NewTableLine.Description = AllowedAddIn.Description;
		NewTableLine.PictureIndex = 29; 
	EndDo;
EndProcedure

&AtServer
Procedure FillAllowedExternalModuleTable(ConnectionSettings, ClusterSettings, ProfileName)
	Var Profile, ExternalModule, NewTableLine; 
	Profile = GetSecurityProfile(ConnectionSettings, ClusterSettings, ProfileName);
	For each ExternalModule In Profile.GetAllowedExternalModules() Do
		NewTableLine = StandartInfoTable.Add();
		NewTableLine.Name = ExternalModule.Name;
		NewTableLine.Description = ExternalModule.Description;
		NewTableLine.PictureIndex = 31; 
	EndDo;
EndProcedure

&AtServer
Procedure FillAllowedApplicationTable(ConnectionSettings, ClusterSettings, ProfileName)
	Var Profile, ExternalApplication, NewTableLine; 
	Profile = GetSecurityProfile(ConnectionSettings, ClusterSettings, ProfileName);
	For each ExternalApplication In Profile.GetAllowedExternalApplications() Do
		NewTableLine = StandartInfoTable.Add();
		NewTableLine.Name = ExternalApplication.Name;
		NewTableLine.Description = ExternalApplication.Description;
		NewTableLine.PictureIndex = 33; 
	EndDo;
EndProcedure

&AtServer
Procedure FillInternetResourceTable(ConnectionSettings, ClusterSettings, ProfileName)
	Var Profile, InternetResource, NewTableLine;
	Profile = GetSecurityProfile(ConnectionSettings, ClusterSettings, ProfileName);
	For each InternetResource In Profile.GetAllowedInternetResources() Do
		NewTableLine = StandartInfoTable.Add();
		NewTableLine.Name = InternetResource.Name;
		NewTableLine.Description = InternetResource.Description;
		NewTableLine.PictureIndex = 35; 
	EndDo;
EndProcedure

#EndRegion

#EndRegion	

#Region FormClosingHandlersRegion
&AtClient
Procedure ProcessingAuthenticationCentralServer(ClosingResult, AdditionalParameters) Export
	Var CurrentTreeData, CurrentTreeLine, NewServer, AdministrationServers;  
	CurrentTreeData = Items.ClusterTree.CurrentRow;
	CurrentTreeLine = ClusterTree.FindByID(CurrentTreeData);
	If ClosingResult <> Undefined And ClosingResult <> DialogReturnCode.Cancel Then
		If CurrentTreeLine.AdministrationItemType = "AdministrationCentralServer" Then
			AdministrationServers = CurrentTreeLine.GetItems();
			NewServer = AdministrationServers.Add();
			NewServer.Name = ClosingResult.Name;
			NewServer.PictureIndex = 1;
			NewServer.ItemGroup = False;
			NewServer.AdministrationItemType = "ServerAdministration";
			ConnectionSettingsToAdministrationServers.Insert(ClosingResult.Name, ClosingResult);
			AddServerStructure(ClosingResult, NewServer.GetID());
		Else
			ConnectionSettingsToAdministrationServers.Insert(ClosingResult.Name, ClosingResult);
			AddServerStructure(ClosingResult, CurrentTreeLine.GetID());
		EndIf;
	EndIf;
EndProcedure

&AtClient
Procedure ProcessingAuthenticationAgent(ClosingResult, AdditionalParameters) Export
	If ClosingResult <> Undefined And ClosingResult <> DialogReturnCode.Cancel Then
		ConnectionSettingsToAdministrationServers.Insert(ClosingResult.Name, ClosingResult);
		SaveAgentPassword(ClusterTree.FindByID(ClosingResult.Line), ClosingResult);
		DisplayListOfTreeObjects(ClosingResult.Line);
	EndIf;	
EndProcedure

&AtClient
Procedure ProcessingCreationSecurityProfile(ClosingResult, AdditionalParameters) Export
	Var CurrentTreeData, CurrentTreeLine, Parent, ClusterSettings, ConnectionSettings;
	If ClosingResult <> Undefined And ClosingResult <> DialogReturnCode.Cancel Then
		CurrentTreeData = Items.ClusterTree.CurrentRow;
		CurrentTreeLine = ClusterTree.FindByID(CurrentTreeData);
		Parent = CurrentTreeLine.GetParent();
		ClusterSettings = GetClusterParameters(Parent);
		ConnectionSettings = GetServerAdministrationParameters(Parent);
		
		If ClosingResult.ObjectСhange = True Then
			UpdateSecurityProfileOnCluster(ConnectionSettings, ClusterSettings, ClosingResult);	
		Else
			AddSecurityProfileOnCluster(ConnectionSettings, ClusterSettings, ClosingResult);
		EndIf;
	EndIf;
	DisplayListOfTreeObjects(Items.ClusterTree.CurrentData.GetID());	
EndProcedure

&AtClient
Procedure ProcessingCreationNewResourceConsumptionLimit(ClosingResult, AdditionalParameters) Export
	Var CurrentTreeData, CurrentTreeLine, Parent, ClusterSettings, ConnectionSettings;
	If ClosingResult <> Undefined And ClosingResult <> DialogReturnCode.Cancel Then
		CurrentTreeData = Items.ClusterTree.CurrentRow;
		CurrentTreeLine = ClusterTree.FindByID(CurrentTreeData);
		Parent = CurrentTreeLine.GetParent();
		ClusterSettings = GetClusterParameters(Parent);
		ConnectionSettings = GetServerAdministrationParameters(Parent);
		
		If ClosingResult.ObjectСhange = True Then
			UpdateLimitOnCluster(ConnectionSettings, ClusterSettings, ClosingResult);
		Else
			AddLimitOnCluster(ConnectionSettings, ClusterSettings, ClosingResult);
		EndIf;
	EndIf;
	DisplayListOfTreeObjects(Items.ClusterTree.CurrentData.GetID());	
EndProcedure

&AtClient
Procedure ProcessingCreationResourceConsumptionCounter(ClosingResult, AdditionalParameters) Export
	Var CurrentTreeData, CurrentTreeLine, Parent, ClusterSettings, ConnectionSettings;
	If ClosingResult <> Undefined And ClosingResult <> DialogReturnCode.Cancel Then
		CurrentTreeData = Items.ClusterTree.CurrentRow;
		CurrentTreeLine = ClusterTree.FindByID(CurrentTreeData);
		Parent = CurrentTreeLine.GetParent();
		ClusterSettings = GetClusterParameters(Parent);
		ConnectionSettings = GetServerAdministrationParameters(Parent);
		
		If ClosingResult.ObjectСhange = True Then
			UpdateCounterOnCluster(ConnectionSettings, ClusterSettings, ClosingResult);	
		Else
			AddCounterOnCluster(ConnectionSettings, ClusterSettings, ClosingResult);
		EndIf;
		
	EndIf;
	DisplayListOfTreeObjects(Items.ClusterTree.CurrentData.GetID());	
EndProcedure

&AtClient
Procedure ProcessingCreationClusterAdministrator(ClosingResult, AdditionalParameters) Export
	Var CurrentTreeData, CurrentTreeLine, Parent, ClusterSettings, ConnectionSettings;
	If ClosingResult <> Undefined And ClosingResult <> DialogReturnCode.Cancel Then
		CurrentTreeData = Items.ClusterTree.CurrentRow;
		CurrentTreeLine = ClusterTree.FindByID(CurrentTreeData);
		Parent = CurrentTreeLine.GetParent();
		ClusterSettings = GetClusterParameters(Parent);
		ConnectionSettings = GetServerAdministrationParameters(Parent);
		AddClusterAdminOnCluster(ConnectionSettings, ClusterSettings, ClosingResult);
		SaveClusterPassword(Parent, ClosingResult); 	
	EndIf;
	DisplayListOfTreeObjects(Items.ClusterTree.CurrentData.GetID());	
EndProcedure

&AtClient
Procedure ProcessingCreationAgentAdministration(ClosingResult, AdditionalParameters) Export
	Var NewAgentConnection, CurrentTreeData, CurrentTreeLine, ConnectionSettings;
	If ClosingResult <> Undefined And ClosingResult <> DialogReturnCode.Cancel Then
		CurrentTreeData = Items.ClusterTree.CurrentRow;
		CurrentTreeLine = ClusterTree.FindByID(CurrentTreeData);
		ConnectionSettings = GetServerAdministrationParameters(CurrentTreeLine);
		RegisterAgentAdministrator(ConnectionSettings, ClosingResult);
		NewAgentConnection = ConnectionSettingsToAdministrationServers.Get(ConnectionSettings.Name);
		NewAgentConnection.Login = ClosingResult.Name;
		NewAgentConnection.Password = ClosingResult.Password;
		SaveAgentPassword(CurrentTreeLine, NewAgentConnection);
		If Items.ClusterTree.CurrentData <> Undefined Then
			DisplayListOfTreeObjects(Items.ClusterTree.CurrentData.GetID());
		EndIf;
	EndIf
EndProcedure

&AtClient
Procedure ProcessingCreationWorkServer(ClosingResult, AdditionalParameters) Export
	If Items.ClusterTree.CurrentData <> Undefined Then 
		DisplayListOfTreeObjects(Items.ClusterTree.CurrentData.GetID());
	EndIf;
EndProcedure

&AtClient
Procedure ProcessingCreationInfobase(ClosingResult, AdditionalParameters) Export
	If Items.ClusterTree.CurrentData <> Undefined Then
		DisplayListOfTreeObjects(Items.ClusterTree.CurrentData.GetID());
	EndIf;
EndProcedure

&AtClient
Procedure ProcessingCreationVirtualDirectory(ClosingResult, AdditionalParameters) Export
	Var Parent, CurrentTreeData, CurrentTreeLine, ClusterSettings, ConnectionSettings;
	If ClosingResult <> Undefined And ClosingResult <> DialogReturnCode.Cancel Then
		CurrentTreeData = Items.ClusterTree.CurrentRow;
		CurrentTreeLine = ClusterTree.FindByID(CurrentTreeData);
		Parent = CurrentTreeLine.GetParent();
		ClusterSettings = GetClusterParameters(Parent);
		ConnectionSettings = GetServerAdministrationParameters(Parent);
		If ClosingResult.ObjectСhange = True Then
			UpdateVirtualDirectoryOnCluster(ConnectionSettings, ClusterSettings, ClosingResult);	
		Else
			AddVirtualDirectoryOnCluster(ConnectionSettings, ClusterSettings, ClosingResult);
		EndIf;
	EndIf;
	DisplayListOfTreeObjects(Items.ClusterTree.CurrentData.GetID());	
EndProcedure

&AtClient
Procedure ProcessingCreationCOMClass(ClosingResult, AdditionalParameters) Export
	Var Parent, CurrentTreeData, CurrentTreeLine, ClusterSettings, ConnectionSettings;
	If ClosingResult <> Undefined And ClosingResult <> DialogReturnCode.Cancel Then
		CurrentTreeData = Items.ClusterTree.CurrentRow;
		CurrentTreeLine = ClusterTree.FindByID(CurrentTreeData);
		Parent = CurrentTreeLine.GetParent();
		ClusterSettings = GetClusterParameters(Parent);
		ConnectionSettings = GetServerAdministrationParameters(Parent);
		If ClosingResult.ObjectСhange = True Then
			UpdateCOMClassOnCluster(ConnectionSettings, ClusterSettings, ClosingResult);	
		Else
			AddCOMClassOnCluster(ConnectionSettings, ClusterSettings, ClosingResult);
		EndIf;
	EndIf;
	DisplayListOfTreeObjects(Items.ClusterTree.CurrentData.GetID());	
EndProcedure

&AtClient 
Procedure ProcessingCreationAddIn(ClosingResult, AdditionalParameters) Export
	Var Parent, CurrentTreeData, CurrentTreeLine, ClusterSettings, ConnectionSettings;
	If ClosingResult <> Undefined And ClosingResult <> DialogReturnCode.Cancel Then
		CurrentTreeData = Items.ClusterTree.CurrentRow;
		CurrentTreeLine = ClusterTree.FindByID(CurrentTreeData);
			Parent = CurrentTreeLine.GetParent();
			ClusterSettings = GetClusterParameters(Parent);
			ConnectionSettings = GetServerAdministrationParameters(Parent);
			If ClosingResult.ObjectСhange = True Then
				UpdateAddInOnCluster(ConnectionSettings, ClusterSettings, ClosingResult);	
			Else
				AddAddInOnCluster(ConnectionSettings, ClusterSettings, ClosingResult);
			EndIf;
	EndIf;
	DisplayListOfTreeObjects(Items.ClusterTree.CurrentData.GetID());	
EndProcedure

&AtClient 
Procedure ProcessingCreationExternalModule(ClosingResult, AdditionalParameters) Export
	Var Parent, CurrentTreeData, CurrentTreeLine, ClusterSettings, ConnectionSettings;
	If ClosingResult <> Undefined And ClosingResult <> DialogReturnCode.Cancel Then
		CurrentTreeData = Items.ClusterTree.CurrentRow;
		CurrentTreeLine = ClusterTree.FindByID(CurrentTreeData);
		Parent = CurrentTreeLine.GetParent();
		ClusterSettings = GetClusterParameters(Parent);
		ConnectionSettings = GetServerAdministrationParameters(Parent);
		If ClosingResult.ObjectСhange = True Then
			UpdateExternalModuleOnCluster(ConnectionSettings, ClusterSettings, ClosingResult);	
		Else
			AddExternalModuleOnCluster(ConnectionSettings, ClusterSettings, ClosingResult);
		EndIf;
	EndIf;
	DisplayListOfTreeObjects(Items.ClusterTree.CurrentData.GetID());	
EndProcedure

&AtClient 
Procedure ProcessingCreationAllowedApplication(ClosingResult, AdditionalParameters) Export
	Var Parent, CurrentTreeData, CurrentTreeLine, ClusterSettings, ConnectionSettings;
	If ClosingResult <> Undefined And ClosingResult <> DialogReturnCode.Cancel Then
		CurrentTreeData = Items.ClusterTree.CurrentRow;
		CurrentTreeLine = ClusterTree.FindByID(CurrentTreeData);
		Parent =  CurrentTreeLine.GetParent();
		ClusterSettings = GetClusterParameters(Parent);
		ConnectionSettings = GetServerAdministrationParameters(Parent);
		If ClosingResult.ObjectСhange = True Then
			UpdateAllowedApplicationOnCluster(ConnectionSettings, ClusterSettings, ClosingResult);	
		Else
			AddAllowedApplicationOnCluster(ConnectionSettings, ClusterSettings, ClosingResult);
		EndIf;

	EndIf;
	DisplayListOfTreeObjects(Items.ClusterTree.CurrentData.GetID());	
EndProcedure

&AtClient 
Procedure ProcessingCreationInternetResource(ClosingResult, AdditionalParameters) Export
	Var Parent, CurrentTreeData, CurrentTreeLine, ClusterSettings, ConnectionSettings;
	If ClosingResult <> Undefined And ClosingResult <> DialogReturnCode.Cancel Then
		CurrentTreeData = Items.ClusterTree.CurrentRow;
		CurrentTreeLine = ClusterTree.FindByID(CurrentTreeData);
		Parent =  CurrentTreeLine.GetParent();
		ClusterSettings = GetClusterParameters(Parent);
		ConnectionSettings = GetServerAdministrationParameters(Parent);
		If ClosingResult.ObjectСhange = True Then
			UpdateInternetResourceOnCluster(ConnectionSettings, ClusterSettings, ClosingResult);	
		Else
			AddInternetResourceOnCluster(ConnectionSettings, ClusterSettings, ClosingResult);
		EndIf;
	EndIf;
	DisplayListOfTreeObjects(Items.ClusterTree.CurrentData.GetID());	
EndProcedure

&AtClient
Procedure ProcessingCreationAssignmentRule(ClosingResult, AdditionalParameters) Export
	Var Parent, CurrentTreeData, CurrentTreeLine, ClusterSettings, ConnectionSettings;
	If ClosingResult <> Undefined Then
		CurrentTreeData = Items.ClusterTree.CurrentRow;
		CurrentTreeLine = ClusterTree.FindByID(CurrentTreeData);
		Parent =  CurrentTreeLine.GetParent();
		ClusterSettings = GetClusterParameters(Parent);
		ConnectionSettings = GetServerAdministrationParameters(Parent);
		If ClosingResult.ObjectСhange = True Then
			UpdateAssignmentRuleOnCluster(ConnectionSettings, 
				ClusterSettings, ClosingResult, CurrentTreeLine.Name);	
		Else
			AddAssignmentRuleOnCluster(ConnectionSettings,
				ClusterSettings, ClosingResult, CurrentTreeLine.Name);
		EndIf;
		AssignmentRuleTable.Clear();
		FillAssignmentRuleTable(ConnectionSettings, ClusterSettings, CurrentTreeLine.Name);
	EndIf;	
EndProcedure	

&AtClient
Procedure ProcessingClusterAuthentication(ClosingResult, AdditionalParameters) Export
	Var CurrentTreeLine;
	If ClosingResult <> Undefined And ClosingResult <> DialogReturnCode.Cancel Then
		CurrentTreeLine = ClusterTree.FindByID(ClosingResult.CurrentTreeLine);
		SaveClusterPassword(CurrentTreeLine, ClosingResult);
	EndIf;
	DisplayListOfTreeObjects(Items.ClusterTree.CurrentData.GetID());	
EndProcedure	 

&AtClient
Procedure ProcessingInfobaseAuthentication(ClosingResult, AdditionalParameters) Export
	Var CurrentTreeLine;
	If ClosingResult <> Undefined And ClosingResult <> DialogReturnCode.Cancel Then
		CurrentTreeLine = ThisObject[AdditionalParameters.TableName].FindByID(ClosingResult.Line);
		SaveInfobasePassword(CurrentTreeLine, ClosingResult);
		
		If AdditionalParameters.AfterCloseEvent <> Undefined Then
			ExecuteNotifyProcessing(AdditionalParameters.AfterCloseEvent); 
			
		EndIf;
		
		ClusterTreeBeforeRowChange(NULL, False);
	EndIf;
EndProcedure

&AtClient
Procedure ProcessingDeleteInfoBase(ClosingResult, AdditionalParameters) Export
	If ClosingResult = Undefined Or ClosingResult <> DialogReturnCode.Cancel Then
		Return;
	Else
		RemoveInfobaseFromCluster(AdditionalParameters.ConnectionSettings, 
			AdditionalParameters.ClusterSettings, AdditionalParameters.InfoBaseName, ClosingResult);	
	EndIf;
	CurrentRow = ClusterTree.FindByID(Items.ClusterTree.CurrentRow);
	Parent = CurrentRow.GetParent();
	If Parent <> Undefined Then
		DisplayListOfTreeObjects(Parent.GetID());
	EndIf;
EndProcedure

&AtClient
Procedure GetUserDeletionApproval(Result, AdditionalParameters) Export
	Var ParentItemType, ConnectionSettings, ClusterSettings, ObjectName, OpenFormParameters;  
	If Result = DialogReturnCode.Yes Then
		ParentItemType = AdditionalParameters.ParentItemType;
		ConnectionSettings = AdditionalParameters.ConnectionSettings;
		ClusterSettings = AdditionalParameters.ClusterSettings;
		ObjectName = AdditionalParameters.ObjectName;
		ProfileName = AdditionalParameters.ProfileName;
		If ParentItemType = "AdministrationCentralServer" Then
			ConnectionSettingsToAdministrationServers.Delete(ObjectName);
		// remove cluster
		ElsIf ParentItemType = "Clusters" Then
			RemoveClusterFromCentralServer(ConnectionSettings, ObjectName);
		// remove infobase
		ElsIf ParentItemType = "InfoBases" Then
			OpenFormParameters = New Structure();
			OpenFormParameters.Insert("ConnectionSettings", ConnectionSettings);
			OpenFormParameters.Insert("ClusterSettings", ClusterSettings);
			OpenFormParameters.Insert("InfoBaseName", ObjectName);
			ProcessingClosingNotify = New NotifyDescription("ProcessingDeleteInfoBase", ThisObject, OpenFormParameters);
			OpenForm(GetFormName("SelectDeleteInfobaseModeForm"),,
					  ThisObject,,,,ProcessingClosingNotify,FormWindowOpeningMode.LockWholeInterface);	
			return;		  
			// remove work server
		ElsIf ParentItemType = "WorkServers" Then
		    RemoveWorkServerFromCluster(ConnectionSettings, ClusterSettings, ObjectName);
		// remove cluster administration
		ElsIf ParentItemType = "ClusterAdministrators" Then
			RemoveClusterAdministratorFromCluster(ConnectionSettings, ClusterSettings, ObjectName);
		// remove security profile
		ElsIf ParentItemType = "SecurityProfiles" Then
			RemoveSecurityProfileFromCluster(ConnectionSettings, ClusterSettings, ObjectName);
		// remove counter
		ElsIf ParentItemType = "ResourceConsumptionCounters" Then
			RemoveCounterFromCluster(ConnectionSettings, ClusterSettings, ObjectName);
		// remove limit
		ElsIf ParentItemType = "ResourceConsumptionLimits" Then
			RemoveLimitFromCluster(ConnectionSettings, ClusterSettings, ObjectName);
		// remove virtual directory
		ElsIf ParentItemType = "VirtualDirectories" Then
			RemoveVirtualDirectoryFromCluster(ConnectionSettings, ClusterSettings, ProfileName, ObjectName);
		// remove COM class 
		ElsIf ParentItemType = "AllowedComClasses" Then
			RemoveCOMClassFromCluster(ConnectionSettings, ClusterSettings, ProfileName, ObjectName);
		// remove allowed addIn 
		ElsIf ParentItemType = "AllowedAddIns" Then
			RemoveAddInFromCluster(ConnectionSettings, ClusterSettings, ProfileName, ObjectName);
		// remove external module
		ElsIf ParentItemType = "ExternalModules" Then
			RemoveExternalModuleFromCluster(ConnectionSettings, ClusterSettings, ProfileName, ObjectName);
		// remove allowed application
		ElsIf ParentItemType = "AllowedApplications" Then
			RemoveAllowedApplicationFromCluster(ConnectionSettings, ClusterSettings, ProfileName, ObjectName);
		// remove internet resource
		ElsIf ParentItemType = "InternetResources" Then
			RemoveInternetResourceFromCluster(ConnectionSettings, ClusterSettings, ProfileName, ObjectName);
		// remove agent administration
		ElsIf ParentItemType = "CentralServerAdministrators" Then
			RemoveAgentAdministrator(ConnectionSettings, ObjectName);
		EndIf;
		CurrentRow = ClusterTree.FindByID(Items.ClusterTree.CurrentRow);
		Parent = CurrentRow.GetParent();
		If Parent <> Undefined Then
			DisplayListOfTreeObjects(Parent.GetID());
		EndIf;		
	EndIf;	
EndProcedure

&AtServer
Function CreateFileAtServer(UploadOptions)
	Var TemporaryFileName, XMLWriter, SettingsLine;
	TemporaryFileName = GetTempFileName();	
	XMLWriter = New XMLWriter;
	XMLWriter.OpenFile(TemporaryFileName, "UTF-8");
	XMLWriter.WriteXMLDeclaration();
	XMLWriter.WriteStartElement("ServerAdministrationSettings");
	XMLWriter.WriteStartElement("Connections"); 
	If UploadOptions.SaveCentralServerList Then
		For each SettingsLine In UploadOptions.ConnectionSettingsToAdministrationServers Do  
			XMLWriter.WriteStartElement("Connection"); 
			XMLWriter.WriteAttribute("Name", SettingsLine.Key);
			XMLWriter.WriteAttribute("AdministrationServerAddress", SettingsLine.Value.AdministrationServerAgent);
			XMLWriter.WriteAttribute("AdministrationServerPort", String(SettingsLine.Value.AdministrationServerPort));
			If UploadOptions.SaveServerAdministratorPasswords Then
				XMLWriter.WriteAttribute("Login", SettingsLine.Value.Login);
				XMLWriter.WriteAttribute("Password", SettingsLine.Value.Password);
			Else
				XMLWriter.WriteAttribute("Login", "");
				XMLWriter.WriteAttribute("Password", "");
			EndIf;
			XMLWriter.WriteEndElement(); 
		EndDo;
	EndIf;
	XMLWriter.WriteEndElement();
	XMLWriter.WriteStartElement("Objects");
	If UploadOptions.SaveClusterInfobaseAdministratorPasswords Then
		For each SettingsLine In UploadOptions.ClusterAndInfobaseUserAuthenticationSettings Do  
			XMLWriter.WriteStartElement("Object"); 
			XMLWriter.WriteAttribute("UUID", String(SettingsLine.Key));
			XMLWriter.WriteAttribute("Name", SettingsLine.Value.Name);
			XMLWriter.WriteAttribute("Password", SettingsLine.Value.Password);
			XMLWriter.WriteEndElement(); 
		EndDo;
	EndIf;
	XMLWriter.WriteEndElement();
	XMLWriter.WriteEndElement();
	XMLWriter.Close();
	Return PutToTempStorage(New BinaryData(TemporaryFileName), UUID);
EndFunction

&AtClient
Procedure ProcessingCloseSaveSettingsForm(Result, AdditionalParameters) Export
	Var DownloadLink, FileSettingsPath;
	If Result <> Undefined Then
		FileSettingsPath = Result.FileSettingsPath;
		If Not AttachFileSystemExtension() Then
        	Try
            	InstallFileSystemExtension();
        	Except
            	Message(ErrorDescription());
            	Return;
        	EndTry;
		EndIf;
		Result.Insert("ConnectionSettingsToAdministrationServers", ConnectionSettingsToAdministrationServers);
		Result.Insert("ClusterAndInfobaseUserAuthenticationSettings", ClusterAndInfobaseUserAuthenticationSettings);
	    If AttachFileSystemExtension() Then
	        DownloadLink = CreateFileAtServer(Result);
	        GetFile(DownloadLink, Result.FileSettingsPath, False);
			Message(NStr("ru = 'Файл настроек сохранен'; SYS = 'MainForm.SettingsFileSaved'", "ru"));
	    EndIf;
	EndIf;
EndProcedure

&AtServer
Function ReadFileAtServer(InternalServerAddress)
	Var TemporaryFileName, XMLReader, LoadSettingsFileResult, AdministratorSettings, ObjectUUID; 
	TemporaryFileName = GetTempFileName();
	GetFromTempStorage(InternalServerAddress).Write(TemporaryFileName);
	//start file reading
	ConnectionSettingsToAdministrationServers = New Map();
	ClusterAndInfobaseUserAuthenticationSettings = New Map();
	If ValueIsFilled(TemporaryFileName) Then
		XMLReader = New XMLReader;
		XMLReader.OpenFile(TemporaryFileName);
		While XMLReader.Read() Do
			If XMLReader.NodeType = XMLNodeType.StartElement Then
				If XMLReader.Name = "Connection" Then
					ConnectionSettings = New Structure();
					While XMLReader.ReadAttribute() Do
						If XMLReader.Name = "Name" Then
							ConnectionSettings.Insert("Name", XMLReader.Value);
						ElsIf XMLReader.Name = "AdministrationServerAddress" Then
							ConnectionSettings.Insert("AdministrationServerAgent", XMLReader.Value);
						ElsIf XMLReader.Name = "AdministrationServerPort" Then
							ConnectionSettings.Insert("AdministrationServerPort", XMLReader.Value);
						ElsIf XMLReader.Name = "Login" Then
							ConnectionSettings.Insert("Login", XMLReader.Value);
						ElsIf XMLReader.Name = "Password" Then
							ConnectionSettings.Insert("Password", XMLReader.Value);
						EndIf;
					EndDo;
					ConnectionSettingsToAdministrationServers.Insert(ConnectionSettings.Name, ConnectionSettings);
				ElsIf XMLReader.Name = "Object" Then
					AdministratorSettings = New Structure();
					While XMLReader.ReadAttribute() Do
						If XMLReader.Name = "UUID" Then
							ObjectUUID = New UUID(XMLReader.Value);
						ElsIf XMLReader.Name = "Name" Then
							AdministratorSettings.Insert("Name", XMLReader.Value);
						ElsIf XMLReader.Name = "Password" Then
							AdministratorSettings.Insert("Password", XMLReader.Value);
						EndIf;
					EndDo;
					ClusterAndInfobaseUserAuthenticationSettings.Insert(ObjectUUID, AdministratorSettings);	
				EndIf;
			EndIf;
		EndDo;
		LoadSettingsFileResult = New Structure();
		LoadSettingsFileResult.Insert("ConnectionSettingsToAdministrationServers", ConnectionSettingsToAdministrationServers);
		LoadSettingsFileResult.Insert("ClusterAndInfobaseUserAuthenticationSettings", ClusterAndInfobaseUserAuthenticationSettings);	
		Return LoadSettingsFileResult;
	EndIf;
EndFunction

&AtClient
Procedure UploadFileToServer(Result, InternalAddressServer, FileSettingsPath, AdditionalParameters) Export 
	Var LoadSettingsFileResult, NewServer, RootElements, CentralServer, VertexID;
	LoadSettingsFileResult = ReadFileAtServer(InternalAddressServer);
	If LoadSettingsFileResult <> Undefined Then
		ConnectionSettingsToAdministrationServers = LoadSettingsFileResult.ConnectionSettingsToAdministrationServers;
		ClusterAndInfobaseUserAuthenticationSettings = LoadSettingsFileResult.ClusterAndInfobaseUserAuthenticationSettings;
		Message(Nstr("ru = 'Из файла загружены настройки подключений к серверам администрирования'; SYS = 'MainForm.LoadSettings'", "ru"));
		FillClusterTreeConnectionList();
		RootElements = ClusterTree.GetItems();
		CentralServer = RootElements.Get(0).GetID();
		VertexID = ClusterTree.FindByID(CentralServer);
		For each ConnectionSettings In ConnectionSettingsToAdministrationServers Do
			NewServer = VertexID.GetItems().Add();
			ConnectionSettings = ConnectionSettings.Value;
			NewServer.Name = ConnectionSettings.Name;
			NewServer.PictureIndex = 1;
			NewServer.ItemGroup = False;
			NewServer.AdministrationItemType = "ServerAdministration";
			AddServerStructure(ConnectionSettings, NewServer.GetID());
		EndDo;
	EndIf;
EndProcedure

&AtClient
Procedure ProcessingCloseLoadSettingsForm(Result, AdditionalParameters) Export
	Var InternalAddressServer;
	If Result <> Undefined Then
		FileSettingsPath = Result.FileSettingsPath;
		If Not AttachFileSystemExtension() Then
        	Try
            	InstallFileSystemExtension();
        	Except
            	Message(ErrorDescription());
            	Return;
        	EndTry;
		EndIf;
		InternalAddressServer = "";
		LoadFileNotifyDescription = New NotifyDescription("UploadFileToServer", ThisObject);
		BeginPutFile(LoadFileNotifyDescription, InternalAddressServer, FileSettingsPath, False, New UUID);
	EndIf;
EndProcedure

&AtClient
Procedure ProcessingBeforeClose(ClosingResult, AdditionalParameters) Export	
	SavingAdministrationConsoleSettings(ConnectionSettingsToAdministrationServers);
	ClosingAllowed = True;
	Close();
EndProcedure	
#EndRegion

#Region ContextMenuCommandRegion                                     
&AtServer
Procedure TerminateSessionAtServer(ConnectionSettings, ClusterSettings, SessionID)
	Var Cluster, Sessions, Session;
	Cluster = GetAdministrationCluster(ConnectionSettings, ClusterSettings);
	Sessions = Cluster.GetSessions();
	For each Session In Sessions Do
		If Session.SessionID = New UUID(SessionID) Then
			Session.TerminateSession();		
		EndIf;
	EndDo;
EndProcedure

&AtServer
Procedure InterruptCurrentServerCallAtServer(ConnectionSettings, ClusterSettings, SessionID)
	Var Cluster, Sessions, Session;
	Cluster = GetAdministrationCluster(ConnectionSettings, ClusterSettings);
	Sessions = Cluster.GetSessions();
	For each Session In Sessions Do
		If Session.SessionID = SessionID Then
			Session.InterruptCurrentServerCall();		
		EndIf;
	EndDo;
EndProcedure

&AtServer
Procedure DeleteConnectionAtServer(
		ConnectionSettings, 
		ClusterSettings,
		InfoBaseParameters, 
		ConnectionID)
								
	Var Cluster, Infobases, Infobase, Connections, Connection, CurrentInfobase;
	
	Cluster = GetAdministrationCluster(ConnectionSettings, ClusterSettings);
	Infobases = Cluster.GetInfoBases();
	
	For Each Infobase In Infobases Do
		If Infobase.InfoBaseID = InfoBaseParameters.ItemUUID Then
			CurrentInfobase = Infobase;
			
			Break;
		EndIf;
	EndDo;

	If CurrentInfobase = Undefined Then
		Return;
		
	EndIf;

	CurrentInfobase.Authenticate(InfoBaseParameters.Name, 
		InfoBaseParameters.Password);
	
	Connections = CurrentInfobase.GetConnections();
	
	For each Connection In Connections Do
		If Connection.ConnectionID = ConnectionID Then
			Connection.Disconnect();
			
			break;
		EndIf;
	EndDo;
EndProcedure

&AtClient
Procedure TerminateSession(Command)
	Var CurrentTreeData, CurrentTreeLine, ConnectionSettings, ClusterSettings, SessionID;
	CurrentTreeData = Items.ClusterTree.CurrentRow;
	CurrentTreeLine = ClusterTree.FindByID(CurrentTreeData);
	ConnectionSettings = GetServerAdministrationParameters(CurrentTreeLine.GetParent());
	ClusterSettings = GetClusterParameters(CurrentTreeLine.GetParent());
	For each HighlightedLine In Items.ItemSessionTable.SelectedRows Do
		SessionID = SessionTable.FindByID(HighlightedLine).SessionID;	
		TerminateSessionAtServer(ConnectionSettings, ClusterSettings, SessionID);
	EndDo;
	SessionTable.Clear();
	FillSessionTable(ConnectionSettings, ClusterSettings);
EndProcedure

&AtClient
Procedure InterruptCurrentServerCall(Command)
	Var CurrentTreeData, CurrentTreeLine, ConnectionSettings, ClusterSettings, SessionID;  
	CurrentTreeData = Items.ClusterTree.CurrentRow;
	CurrentTreeLine = ClusterTree.FindByID(CurrentTreeData);
	ConnectionSettings = GetServerAdministrationParameters(CurrentTreeLine.GetParent());
	ClusterSettings = GetClusterParameters(CurrentTreeLine.GetParent());
	For each HighlightedLine In Items.ItemSessionTable.SelectedRows Do
		SessionID = SessionTable.FindByID(HighlightedLine).SessionID;	
		InterruptCurrentServerCallAtServer(ConnectionSettings, ClusterSettings, SessionID);
	EndDo;
EndProcedure

&AtClient
Procedure UpdateSessionTable(Command)
	SessionTable.Clear();
	CurrentTreeData = Items.ClusterTree.CurrentRow;
	CurrentTreeLine = ClusterTree.FindByID(CurrentTreeData);
	ConnectionSettings = GetServerAdministrationParameters(CurrentTreeLine.GetParent());
	ClusterSettings = GetClusterParameters(CurrentTreeLine.GetParent());
	FillSessionTable(ConnectionSettings, ClusterSettings);
EndProcedure

&AtClient
Procedure UpdateTableConnections(Command)
	ConnectionsTable.Clear();
	CurrentTreeData = Items.ClusterTree.CurrentRow;
	CurrentTreeLine = ClusterTree.FindByID(CurrentTreeData);
	ConnectionSettings = GetServerAdministrationParameters(CurrentTreeLine.GetParent());
	ClusterSettings = GetClusterParameters(CurrentTreeLine.GetParent());
	FillConnectionsTable(ConnectionSettings, ClusterSettings);
EndProcedure

&AtClient
Procedure UpdateTableLocks(Command)
	LocksTable.Clear();
	CurrentTreeData = Items.ClusterTree.CurrentRow;
	CurrentTreeLine = ClusterTree.FindByID(CurrentTreeData);
	ConnectionSettings = GetServerAdministrationParameters(CurrentTreeLine.GetParent());
	ClusterSettings = GetClusterParameters(CurrentTreeLine.GetParent());
	FillLocksTable(ConnectionSettings, ClusterSettings);
EndProcedure

&AtClient
Procedure DeleteConnection(Command)
	Var CurrentTreeData, CurrentTreeLine, ConnectionSettings, 
		ClusterSettings, HighlightedLine, Connection, ConnectionID, InfoBaseParameters; 
	CurrentTreeData = Items.ClusterTree.CurrentRow;
	CurrentTreeLine = ClusterTree.FindByID(CurrentTreeData);
	ConnectionSettings = GetServerAdministrationParameters(CurrentTreeLine.GetParent());
	ClusterSettings = GetClusterParameters(CurrentTreeLine.GetParent());
	For each HighlightedLine In Items.ItemConnectionsTable.SelectedRows Do
		Connection = ConnectionsTable.FindByID(HighlightedLine);
		ConnectionID = Connection.ConnectionID;
		InfoBaseParameters = ClusterAndInfobaseUserAuthenticationSettings.Get(Connection.InfoBaseID);
		If InfoBaseParameters = Undefined Or CheckRuleToChangeInfoBase(ConnectionSettings, ClusterSettings, InfoBaseParameters) <> Undefined Then
			AfterCloseEvent = New NotifyDescription(
				"AfterAuthentiticationInfobaseFormDeleteConnection", ThisObject,
				New Structure("ConnectionSettings,ClusterSettings,InfoBaseID,ConnectionID",
					ConnectionSettings, ClusterSettings, Connection.InfoBaseID, ConnectionID));
			
			OpenAuthenticationInfobaseForm(ConnectionSettings, 
				ClusterSettings, 
				Connection.InfoBaseID, 
				HighlightedLine, 
				"ConnectionsTable", 
				AfterCloseEvent);
			
		EndIf;
		
	EndDo;
	
EndProcedure

&AtClient
Procedure AfterAuthentiticationInfobaseFormDeleteConnection(Result, AdditionalParameters) Export
	
	InfoBaseParameters = ClusterAndInfobaseUserAuthenticationSettings.Get(
		AdditionalParameters.InfoBaseID);
		
	InfoBaseParameters.Insert("ItemUUID", AdditionalParameters.InfoBaseID);
		
	DeleteConnectionAtServer(
		AdditionalParameters.ConnectionSettings, 
		AdditionalParameters.ClusterSettings,
		InfoBaseParameters, 
		AdditionalParameters.ConnectionID);
		
	ConnectionsTable.Clear();
	FillConnectionsTable(
		AdditionalParameters.ConnectionSettings, 
		AdditionalParameters.ClusterSettings);	
		
EndProcedure

&AtClient
Procedure ClusterAuthentication(Command)
	CurrentTreeData = Items.ClusterTree.CurrentRow;
	CurrentTreeLine = ClusterTree.FindByID(CurrentTreeData);
	ConnectionSettings = GetServerAdministrationParameters(CurrentTreeLine.GetParent());
	ClusterSettings = GetClusterParameters(CurrentTreeLine);
	If ClusterSettings.Count() > 0 Then 
		OpenFormParameters = New Structure();
		OpenFormParameters.Insert("ConnectionSettings", ConnectionSettings);
		OpenFormParameters.Insert("ClusterName", ClusterSettings.Name);
		OpenFormParameters.Insert("Line", CurrentTreeData);
		ProcessingClosingNotify = New NotifyDescription("ProcessingClusterAuthentication", ThisObject);
		OpenForm(GetFormName("AuthenticationForm"), OpenFormParameters, ThisObject,,,,ProcessingClosingNotify, FormWindowOpeningMode.LockWholeInterface);
	EndIf;
EndProcedure

&AtServer
Procedure ApplyAssignmentRuleAtServer(ConnectionSettings, ClusterSettings, ReassignAllServices)
	Cluster = GetAdministrationCluster(ConnectionSettings, ClusterSettings);
	Cluster.ApplyAssignmentRules(ReassignAllServices);
EndProcedure

&AtClient
Procedure ApplyAssignmentRule(ReassignAllServices)
	CurrentTreeData = Items.ClusterTree.CurrentRow;
	CurrentTreeLine = ClusterTree.FindByID(CurrentTreeData);
	ClusterSettings = GetClusterParameters(CurrentTreeLine);
	ConnectionSettings = GetServerAdministrationParameters(CurrentTreeLine);
	ApplyAssignmentRuleAtServer(ConnectionSettings, ClusterSettings, ReassignAllServices);		
EndProcedure

&AtClient
Procedure FullyApplyAssignmentRules(Command)
	ApplyAssignmentRule(True);	
EndProcedure

&AtClient
Procedure PartiallyApplyAssignmentRules(Command)
	ApplyAssignmentRule(False);
EndProcedure

&AtClient
Procedure UpdateCounterValueTable(Command)
	CounterValueTable.Clear();
	CurrentTreeData = Items.ClusterTree.CurrentRow;
	CurrentTreeLine = ClusterTree.FindByID(CurrentTreeData);
	ConnectionSettings = GetServerAdministrationParameters(CurrentTreeLine.GetParent());
	ClusterSettings = GetClusterParameters(CurrentTreeLine.GetParent());
	FillCounterValueTable(ConnectionSettings, ClusterSettings, CurrentTreeLine.Name);
EndProcedure

#EndRegion

#Region DataCompositionFunctionsRegion

&AtServer
Procedure ApllyFilterToSessionTable(TempTable)
	Var SourceTable, ThisStandartProcessing, Template, TemplateComposer,
		CompositionProcessor, OutputTable, ExternalSets, OutputProcessor, ValueTable, 
		Column, SessionTableLine;
	SourceTable = TempTable;
	ThisStandartProcessing = FormAttributeToValue("Object");
	Template = ThisStandartProcessing.GetTemplate("SessionDataCompositionSchema");	
	TemplateComposer = New DataCompositionTemplateComposer;
	Template = TemplateComposer.Execute(Template, SessionSettingsLinker.GetSettings(), ,, Type("DataCompositionValueCollectionTemplateGenerator"));
	CompositionProcessor = New DataCompositionProcessor;
	ExternalSets = New Structure("SessionTable", SourceTable);
	CompositionProcessor.Initialize(Template, ExternalSets);
	OutputProcessor = New DataCompositionResultValueCollectionOutputProcessor;
	OutputTable = OutputProcessor.Output(CompositionProcessor);	
	SessionTable.Clear();
	ValueTable = FormAttributeToValue("SessionTable");
	For each Column In ValueTable.Columns Do
		Item = Items.Find("ItemSessionTable" + Column.Name);
		If Item <> Undefined Then
			Item.Visible = 
			OutputTable.Columns.Find(Column.Name) <> Undefined;
		EndIf;	
	EndDo;
	TempTable = OutputTable;
EndProcedure

&AtServer
Procedure ApllyFilterToCounterValueTable(TempTable)
	Var SourceTable, ThisStandartProcessing, Template, TemplateComposer,
		CompositionProcessor, OutputTable, ExternalSets, OutputProcessor, ValueTable,
		Column, CounterValueLine;
	SourceTable = TempTable;
	ThisStandartProcessing = FormAttributeToValue("object");
	Template = ThisStandartProcessing.GetTemplate("CounterValueDataCompositionSchema");	
	TemplateComposer = New DataCompositionTemplateComposer;
	Template = TemplateComposer.Execute(Template, CounterValueSettingsLinker.GetSettings(), ,, Type("DataCompositionValueCollectionTemplateGenerator"));
	CompositionProcessor = New DataCompositionProcessor;
	ExternalSets = New Structure("CounterValueTable", SourceTable);
	CompositionProcessor.Initialize(Template, ExternalSets);
	OutputProcessor = New DataCompositionResultValueCollectionOutputProcessor;
	OutputTable = OutputProcessor.Output(CompositionProcessor);
	CounterValueTable.Clear();
	ValueTable = FormAttributeToValue("CounterValueTable");
	For each Column In ValueTable.Columns Do
		Items.Find("ItemCounterValueTable" + Column.Name).Visible = 
			OutputTable.Columns.Find(Column.Name) <> Undefined;
		CounterValueTable.Add();	
	EndDo;
	TempTable = OutputTable;
EndProcedure

&AtClient
Procedure ItemCounterValueSettingsLinkerFilterOnChange(Item)
	UpdateCounterValueTable(Undefined);
SetUpCounterButtonsAvailability();
EndProcedure

&AtClient
Procedure ItemCounterValueSettingsLinkerOrderOnChange(Item)
	UpdateCounterValueTable(Undefined);
	SetUpCounterButtonsAvailability();
EndProcedure

&AtClient
Procedure ItemCounterValueSettingsLinkerChoiseOnChange(Item)
	UpdateCounterValueTable(Undefined);
	SetUpCounterButtonsAvailability();	
EndProcedure

&AtClient
Procedure ItemSessionSettingsLinkerFilterOnChange(Item)
	UpdateSessionTable(Undefined);
	SetUpSessionButtonsAvailability();
EndProcedure

&AtClient
Procedure ItemSessionSettingsLinkerOrderOnChange(Item)
	UpdateSessionTable(Undefined);
	SetUpSessionButtonsAvailability();
EndProcedure

&AtClient
Procedure ItemSessionSettingsLinkerChoiceOnChange(Item)
	UpdateSessionTable(Undefined);
	SetUpSessionButtonsAvailability();
EndProcedure

&AtServer 
Procedure ShowCurrentSessionTablePage()
	Var TempStorageTable, Count, Iterator;
	TempStorageTable = GetFromTempStorage(SessionStorageAddress);
	SessionTable.Clear();
	
	Count = TempStorageTable.Count();
	For Iterator = SessionTablePageNumber * 100 To (SessionTablePageNumber + 1) * 100 Do
		If Iterator < Count Then
			FillPropertyValues(SessionTable.Add(), TempStorageTable[Iterator]);
		Else
			Break;
		EndIf;
	EndDo;
	If (SessionTablePageNumber + 1) * 100 < Count Then
		SessionCount = "" + (SessionTablePageNumber * 100 + 1) + " - " + (SessionTablePageNumber + 1) * 100 + " из " + Count;
	Else
		SessionCount = "" + (SessionTablePageNumber * 100 + 1) + " - "  + ((SessionTablePageNumber) * 100 + SessionTable.Count()) + " из " +  Count;
	EndIf;
	CurrentSessionPageString = SessionTablePageNumber + 1;
	For each SessionLine In SessionTable Do
		SessionLine.PictureIndex = 16;
	EndDo;
EndProcedure

&AtServer 
Procedure ShowCurrentCounterValueTablePage()
	Var TempStorageTable, Count, Iterator;
	TempStorageTable = GetFromTempStorage(CounterValueStorageAddress);
	CounterValueTable.Clear();
	
	Count = TempStorageTable.Count();
	For Iterator = CounterValueTablePageNumber * 100 To (CounterValueTablePageNumber + 1) * 100 Do
		If Iterator < Count Then
			FillPropertyValues(CounterValueTable.Add(), TempStorageTable[Iterator]);
		Else
			Break;
		EndIf;
	EndDo;
	If (CounterValueTablePageNumber + 1) * 100 < Count Then
		CounterValueCount = "" + (CounterValueTablePageNumber * 100 + 1) + " - " + (CounterValueTablePageNumber + 1) * 100 + " из " + Count;
	Else
		CounterValueCount = "" + (CounterValueTablePageNumber * 100 + 1) + " - "  + ((CounterValueTablePageNumber) * 100 + CounterValueTable.Count()) + " из " +  Count;
	EndIf;
	CurrentCounterValuePageString = CounterValueTablePageNumber + 1;
	For each CounterValueLine In CounterValueTable Do
		CounterValueLine.PictureIndex = 37;
	EndDo;
EndProcedure

&AtClient
Procedure BeforeClose(Cancel, ShutDown, AlertText, StandardProcessing) 
	If ShutDown = True Or ClosingAllowed = True Then
		Cancel = False;
	Else
		AttachIdleHandler("HadlerBeforeClosing", 0.1, True);
		Cancel = True;
	EndIf;	
EndProcedure
#EndRegion
