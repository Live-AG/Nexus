<<<<<<< HEAD
﻿
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	Var ObjectFieldValues, NewTableLine;
	ListOfExistingObjectNames = New Structure("ListOfObjects", Parameters.ListOfObjects);  
	ObjectChange = Parameters.ObjectFieldValues <> Undefined;
	ClusterSettings = Parameters.ClusterSettings;
	ConnectionSettings = Parameters.ConnectionSettings;
	If Parameters.ObjectFieldValues <> Undefined Then
		ObjectFieldValues = Parameters.ObjectFieldValues;
		Computer = ObjectFieldValues.ComputerName;
		ConnectionCountByProcess = ObjectFieldValues.SingleProcessConnectionsCount;
		InfobaseCountByProcess = ObjectFieldValues.SingleProcessInfobasesCount;
		PortClusterMainManager = ObjectFieldValues.MainManagerPort;
		ManagerForEachService = ObjectFieldValues.CreateManagerForEachService;
		IPPort = ObjectFieldValues.Port;
		ServerIPPortRange = ObjectFieldValues.IPPortRanges;
		For each Range In ServerIPPortRange Do
			NewTableLine = IPPortRanges.Add();
			NewTableLine.LowerBound = Range.LowerBound;
			NewTableLine.UpperBound = Range.UpperBound;
		EndDo;
		MainServer = ObjectFieldValues.CentralServer;
		ServerDescription = ObjectFieldValues.Name;
		SafeMemoryUsageCall = ObjectFieldValues.SingleCallSafeMemoryUsage;
		CriticalProcessesTotalMemory = ObjectFieldValues.CriticalProcessesTotalMemory;
		TemporaryAllowedProcessesTotalMemory = ObjectFieldValues.TemporaryAllowedProcessesTotalMemory;
		TemporaryAllowedProcessesTotalMemoryExcessTimeLimit 
			= ObjectFieldValues.TemporaryAllowedProcessesTotalMemoryExcessTimeLimit;
		SafeWorkingProcessesMemoryLimit = ObjectFieldValues.WorkProcessSafeMemoryUsage;
		MaxMemoryUsageWorkProcess = ObjectFieldValues.WorkProcessMemoryUsageLimit;
		Items.ItemServerDescription.Enabled = False;
		Items.ItemIPпорт.Enabled = False;
		Items.ItemComputer.Enabled = False;
		Items.ItemPortClusterMainManager.Enabled = False;
	Else
		IPPort = 1540;
		PortClusterMainManager = 1541;
		InfobaseCountByProcess = 8;
		ConnectionCountByProcess = 128;
		NewTableLine = IPPortRanges.Add();
		NewTableLine.LowerBound = 1560;
		NewTableLine.UpperBound = 1591;
		If ListOfExistingObjectNames.Count() = 0 Then
			MainServer = True;	
		EndIf;
	EndIf;
	ThisStandartProcessing = FormAttributeToValue("object");
	DocumentationLink = ThisStandartProcessing.GetLinkDocumentation("work server");
	If IsBlankString(DocumentationLink) Then
		Items.ItemDocumentationLink.Visible = False;
	EndIf;
EndProcedure

&AtClient
Function IsServerNameUnique()
	Var Result;
	Result = True;
	For each ExistingObjectName In ListOfExistingObjectNames.ListOfObjects Do
		If (Lower(Computer) = Lower(ExistingObjectName)) Then
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
Procedure WriteWorkServerAtServer()
	Var WorkServers, Cluster, ChangedWorkServer, NewIPPortRange, PortRange; 
	Cluster = GetCluster(ConnectionSettings, ClusterSettings);
	If ObjectChange Then
		WorkServers = Cluster.GetWorkServers();
		For each WorkServer In WorkServers Do
			If WorkServer.ComputerName = Computer Then
				ChangedWorkServer = WorkServer;
				break;
			EndIf;
		EndDo;
	Else
		ChangedWorkServer = Cluster.CreateWorkServer();
		ChangedWorkServer.ComputerName = Computer;
		ChangedWorkServer.MainManagerPort = PortClusterMainManager;
		ChangedWorkServer.Name = ServerDescription;
		ChangedWorkServer.Port = IPPort;
	EndIf;
	If ChangedWorkServer <> Undefined Then
		ChangedWorkServer.SingleProcessInfobasesCount = InfobaseCountByProcess;
		ChangedWorkServer.CreateManagerForEachService = ManagerForEachService;
		ChangedWorkServer.CentralServer = MainServer;
		ChangedWorkServer.SingleCallSafeMemoryUsage = SafeMemoryUsageCall;
		ChangedWorkServer.CriticalProcessesTotalMemory = CriticalProcessesTotalMemory;
		ChangedWorkServer.TemporaryAllowedProcessesTotalMemory = TemporaryAllowedProcessesTotalMemory;
		ChangedWorkServer.TemporaryAllowedProcessesTotalMemoryExcessTimeLimit =
			TemporaryAllowedProcessesTotalMemoryExcessTimeLimit;
		ChangedWorkServer.WorkProcessSafeMemoryUsage = SafeWorkingProcessesMemoryLimit;
		ChangedWorkServer.WorkProcessMemoryUsageLimit = MaxMemoryUsageWorkProcess;
		ChangedWorkServer.SingleProcessConnectionsCount = ConnectionCountByProcess;
		ChangedWorkServer.ClearPortRanges();
		For each IPPortRange In IPPortRanges Do
			NewIPPortRange = New AdministrationPortRange(IPPortRange.LowerBound, IPPortRange.UpperBound);
			ChangedWorkServer.AddPortRange(NewIPPortRange);	
		EndDo;
		ChangedWorkServer.Write();
	EndIf;	
EndProcedure

&AtClient
Procedure WriteWorkServerAndCloseForm(Command)
	Var ErrorRange;
	ErrorRange = False;
	If TemporaryAllowedProcessesTotalMemory < -1 Then
		Message(NStr("ru = 'Поле ""Временно допустимый объем памяти процессов"" 
			|должно быть в диапазоне от -1 до 9223372036854775807.';SYS='WorkServer.TemporaryAllowedProcessesTotalMemoryExcessTimeLimit'", "ru"));	
		ErrorRange = True;	
	ElsIf TemporaryAllowedProcessesTotalMemoryExcessTimeLimit > 65535 Then
		Message(NStr("ru = 'Поле ""Интервал превышения допустимого объема памяти процессов"" 
		|должно быть в диапазоне от 0 до 65535';SYS='WorkServer.TemporaryAllowedProcessesTotalMemory'", "ru"));
		ErrorRange = True;	
	ElsIf SafeMemoryUsageCall < -1 Then
		Message(NStr("ru = 'Поле ""Безопасный расход памяти за один вызов"" 
			|должно быть в диапазоне от -1 до 9223372036854775807.';SYS='WorkServer.SafeMemoryUsageCall'", "ru"));
		ErrorRange = True;
	ElsIf CriticalProcessesTotalMemory < -1 Then
		Message(NStr("ru = 'Поле ""Критический объем памяти процессов"" 
			|должно быть в диапазоне от -1 до 9223372036854775807.';SYS='WorkServer.CriticalProcessesTotalMemoryRangeError'", "ru"));	
			ErrorRange = True;	
	EndIf;
	If CheckFilling() And Not ErrorRange Then
		If IsServerNameUnique() Then
			WriteWorkServerAtServer();
			Close();
		Else
			Message(NStr("ru = 'Рабочий сервер уже зарегистрирован в кластере.
					|Введите уникальное имя или перейдите к изменению существующего рабочего сервера.';SYS='WorkServer.AlreadyExists'", "ru"));
		EndIf;
	EndIf;
EndProcedure

&AtClient
Procedure ItemDocumentationLinkClick(Item)
	GotoURL(DocumentationLink);
EndProcedure

&AtClient
Procedure ItemMaxMemoryUsageWorkProcessTuning(Item, Trend, StandardProcessing)
	StandardProcessing = False;
	MaxMemoryUsageWorkProcess = Trend * 1000000 + Item.EditText;
EndProcedure

&AtClient
Procedure ItemSafeMemoryUsageCallTuning(Item, Trend, StandardProcessing)
	StandardProcessing = False;
	SafeMemoryUsageCall = Trend * 1000000 + Item.EditText;
EndProcedure

&AtClient
Procedure ItemSafeWorkingProcessesMemoryLimitTuning(Item, Trend, StandardProcessing)
	StandardProcessing = False;
	SafeWorkingProcessesMemoryLimit = Trend * 1000000 + Item.EditText;
EndProcedure


&AtClient
Procedure CriticalProcessesTotalMemoryTuning(Item, Trend, StandardProcessing)
	StandardProcessing = False;
	CriticalProcessesTotalMemory = Trend * 1000000 + Item.EditText;
EndProcedure


&AtClient
Procedure TemporaryAllowedProcessesTotalMemoryTuning(Item, Trend, StandardProcessing)
	StandardProcessing = False;
	TemporaryAllowedProcessesTotalMemory = Trend * 1000000 + Item.EditText;
EndProcedure


&AtClient
Procedure TemporaryAllowedProcessesTotalMemoryExcessTimeLimitTuning(Item, Trend, StandardProcessing)
	StandardProcessing = False;
	TemporaryAllowedProcessesTotalMemoryExcessTimeLimit = Trend * 1000000 + Item.EditText;
EndProcedure

&AtClient
Procedure DocumentationHelp(Command)
	GotoURL(DocumentationLink);
EndProcedure

=======
﻿
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	Var ObjectFieldValues, NewTableLine;
	ListOfExistingObjectNames = New Structure("ListOfObjects", Parameters.ListOfObjects);  
	ObjectChange = Parameters.ObjectFieldValues <> Undefined;
	ClusterSettings = Parameters.ClusterSettings;
	ConnectionSettings = Parameters.ConnectionSettings;
	If Parameters.ObjectFieldValues <> Undefined Then
		ObjectFieldValues = Parameters.ObjectFieldValues;
		Computer = ObjectFieldValues.ComputerName;
		ConnectionCountByProcess = ObjectFieldValues.SingleProcessConnectionsCount;
		InfobaseCountByProcess = ObjectFieldValues.SingleProcessInfobasesCount;
		PortClusterMainManager = ObjectFieldValues.MainManagerPort;
		ManagerForEachService = ObjectFieldValues.CreateManagerForEachService;
		IPPort = ObjectFieldValues.Port;
		ServerIPPortRange = ObjectFieldValues.IPPortRanges;
		For each Range In ServerIPPortRange Do
			NewTableLine = IPPortRanges.Add();
			NewTableLine.LowerBound = Range.LowerBound;
			NewTableLine.UpperBound = Range.UpperBound;
		EndDo;
		MainServer = ObjectFieldValues.CentralServer;
		ServerDescription = ObjectFieldValues.Name;
		SafeMemoryUsageCall = ObjectFieldValues.SingleCallSafeMemoryUsage;
		CriticalProcessesTotalMemory = ObjectFieldValues.CriticalProcessesTotalMemory;
		TemporaryAllowedProcessesTotalMemory = ObjectFieldValues.TemporaryAllowedProcessesTotalMemory;
		TemporaryAllowedProcessesTotalMemoryExcessTimeLimit 
			= ObjectFieldValues.TemporaryAllowedProcessesTotalMemoryExcessTimeLimit;
		SafeWorkingProcessesMemoryLimit = ObjectFieldValues.WorkProcessSafeMemoryUsage;
		MaxMemoryUsageWorkProcess = ObjectFieldValues.WorkProcessMemoryUsageLimit;
		Items.ItemServerDescription.Enabled = False;
		Items.ItemIPпорт.Enabled = False;
		Items.ItemComputer.Enabled = False;
		Items.ItemPortClusterMainManager.Enabled = False;
	Else
		IPPort = 1540;
		PortClusterMainManager = 1541;
		InfobaseCountByProcess = 8;
		ConnectionCountByProcess = 128;
		NewTableLine = IPPortRanges.Add();
		NewTableLine.LowerBound = 1560;
		NewTableLine.UpperBound = 1591;
		If ListOfExistingObjectNames.Count() = 0 Then
			MainServer = True;	
		EndIf;
	EndIf;
	ThisStandartProcessing = FormAttributeToValue("object");
	DocumentationLink = ThisStandartProcessing.GetLinkDocumentation("work server");
	If IsBlankString(DocumentationLink) Then
		Items.ItemDocumentationLink.Visible = False;
	EndIf;
EndProcedure

&AtClient
Function IsServerNameUnique()
	Var Result;
	Result = True;
	For each ExistingObjectName In ListOfExistingObjectNames.ListOfObjects Do
		If (Lower(Computer) = Lower(ExistingObjectName)) Then
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
Procedure WriteWorkServerAtServer()
	Var WorkServers, Cluster, ChangedWorkServer, NewIPPortRange, PortRange; 
	Cluster = GetCluster(ConnectionSettings, ClusterSettings);
	If ObjectChange Then
		WorkServers = Cluster.GetWorkServers();
		For each WorkServer In WorkServers Do
			If WorkServer.ComputerName = Computer Then
				ChangedWorkServer = WorkServer;
				break;
			EndIf;
		EndDo;
	Else
		ChangedWorkServer = Cluster.CreateWorkServer();
		ChangedWorkServer.ComputerName = Computer;
		ChangedWorkServer.MainManagerPort = PortClusterMainManager;
		ChangedWorkServer.Name = ServerDescription;
		ChangedWorkServer.Port = IPPort;
	EndIf;
	If ChangedWorkServer <> Undefined Then
		ChangedWorkServer.SingleProcessInfobasesCount = InfobaseCountByProcess;
		ChangedWorkServer.CreateManagerForEachService = ManagerForEachService;
		ChangedWorkServer.CentralServer = MainServer;
		ChangedWorkServer.SingleCallSafeMemoryUsage = SafeMemoryUsageCall;
		ChangedWorkServer.CriticalProcessesTotalMemory = CriticalProcessesTotalMemory;
		ChangedWorkServer.TemporaryAllowedProcessesTotalMemory = TemporaryAllowedProcessesTotalMemory;
		ChangedWorkServer.TemporaryAllowedProcessesTotalMemoryExcessTimeLimit =
			TemporaryAllowedProcessesTotalMemoryExcessTimeLimit;
		ChangedWorkServer.WorkProcessSafeMemoryUsage = SafeWorkingProcessesMemoryLimit;
		ChangedWorkServer.WorkProcessMemoryUsageLimit = MaxMemoryUsageWorkProcess;
		ChangedWorkServer.SingleProcessConnectionsCount = ConnectionCountByProcess;
		ChangedWorkServer.ClearPortRanges();
		For each IPPortRange In IPPortRanges Do
			NewIPPortRange = New AdministrationPortRange(IPPortRange.LowerBound, IPPortRange.UpperBound);
			ChangedWorkServer.AddPortRange(NewIPPortRange);	
		EndDo;
		ChangedWorkServer.Write();
	EndIf;	
EndProcedure

&AtClient
Procedure WriteWorkServerAndCloseForm(Command)
	Var ErrorRange;
	ErrorRange = False;
	If TemporaryAllowedProcessesTotalMemory < -1 Then
		Message(NStr("ru = 'Поле ""Временно допустимый объем памяти процессов"" 
			|должно быть в диапазоне от -1 до 9223372036854775807.';SYS='WorkServer.TemporaryAllowedProcessesTotalMemoryExcessTimeLimit'", "ru"));	
		ErrorRange = True;	
	ElsIf TemporaryAllowedProcessesTotalMemoryExcessTimeLimit > 65535 Then
		Message(NStr("ru = 'Поле ""Интервал превышения допустимого объема памяти процессов"" 
		|должно быть в диапазоне от 0 до 65535';SYS='WorkServer.TemporaryAllowedProcessesTotalMemory'", "ru"));
		ErrorRange = True;	
	ElsIf SafeMemoryUsageCall < -1 Then
		Message(NStr("ru = 'Поле ""Безопасный расход памяти за один вызов"" 
			|должно быть в диапазоне от -1 до 9223372036854775807.';SYS='WorkServer.SafeMemoryUsageCall'", "ru"));
		ErrorRange = True;
	ElsIf CriticalProcessesTotalMemory < -1 Then
		Message(NStr("ru = 'Поле ""Критический объем памяти процессов"" 
			|должно быть в диапазоне от -1 до 9223372036854775807.';SYS='WorkServer.CriticalProcessesTotalMemoryRangeError'", "ru"));	
			ErrorRange = True;	
	EndIf;
	If CheckFilling() And Not ErrorRange Then
		If IsServerNameUnique() Then
			WriteWorkServerAtServer();
			Close();
		Else
			Message(NStr("ru = 'Рабочий сервер уже зарегистрирован в кластере.
					|Введите уникальное имя или перейдите к изменению существующего рабочего сервера.';SYS='WorkServer.AlreadyExists'", "ru"));
		EndIf;
	EndIf;
EndProcedure

&AtClient
Procedure ItemDocumentationLinkClick(Item)
	GotoURL(DocumentationLink);
EndProcedure

&AtClient
Procedure ItemMaxMemoryUsageWorkProcessTuning(Item, Trend, StandardProcessing)
	StandardProcessing = False;
	MaxMemoryUsageWorkProcess = Trend * 1000000 + Item.EditText;
EndProcedure

&AtClient
Procedure ItemSafeMemoryUsageCallTuning(Item, Trend, StandardProcessing)
	StandardProcessing = False;
	SafeMemoryUsageCall = Trend * 1000000 + Item.EditText;
EndProcedure

&AtClient
Procedure ItemSafeWorkingProcessesMemoryLimitTuning(Item, Trend, StandardProcessing)
	StandardProcessing = False;
	SafeWorkingProcessesMemoryLimit = Trend * 1000000 + Item.EditText;
EndProcedure


&AtClient
Procedure CriticalProcessesTotalMemoryTuning(Item, Trend, StandardProcessing)
	StandardProcessing = False;
	CriticalProcessesTotalMemory = Trend * 1000000 + Item.EditText;
EndProcedure


&AtClient
Procedure TemporaryAllowedProcessesTotalMemoryTuning(Item, Trend, StandardProcessing)
	StandardProcessing = False;
	TemporaryAllowedProcessesTotalMemory = Trend * 1000000 + Item.EditText;
EndProcedure


&AtClient
Procedure TemporaryAllowedProcessesTotalMemoryExcessTimeLimitTuning(Item, Trend, StandardProcessing)
	StandardProcessing = False;
	TemporaryAllowedProcessesTotalMemoryExcessTimeLimit = Trend * 1000000 + Item.EditText;
EndProcedure

&AtClient
Procedure DocumentationHelp(Command)
	GotoURL(DocumentationLink);
EndProcedure

>>>>>>> f3f19a63ed53bdfa614d9191f48ffaf36859af97
