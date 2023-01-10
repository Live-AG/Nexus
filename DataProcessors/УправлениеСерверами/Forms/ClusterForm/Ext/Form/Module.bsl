<<<<<<< HEAD
﻿
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	Var ThisStandartProcessing;
	ObjectChange = Parameters.ObjectFieldValues <> Undefined;
	ConnectionSettings = Parameters.ConnectionSettings;
	// заполняем список выбора безопасности соединения
	Items.ItemConnectionsSecurityLevel.ChoiceList.Add(
		AdministrationConnectionSecurityLevel.Secure, NStr("ru = 'Постоянно'; SYS='ClusterForm.SecurityLevelSecure'", "ru"));
	Items.ItemConnectionsSecurityLevel.ChoiceList.Add(
		AdministrationConnectionSecurityLevel.Unsecure, NStr("ru = 'Выключено'; SYS='ClusterForm.SecurityLevelUnsecure'", "ru"));
	Items.ItemConnectionsSecurityLevel.ChoiceList.Add(
		AdministrationConnectionSecurityLevel.SecureOnConnect, NStr("ru = 'Только соединение'; SYS='ClusterForm.SecurityLevelSecureOnConnect'", "ru"));
	// заполняем список выбора балансировки нагрузки
	Items.ItemLoadBalancingMode.ChoiceList.Add(AdministrationProcessChoicePriority.ByPerformance, 
		NStr("ru = 'По производительности';SYS='ClusterForm.PriorityByPerformance'", "ru"));
	Items.ItemLoadBalancingMode.ChoiceList.Add(AdministrationProcessChoicePriority.ByMemory, 
		NStr("ru = 'По памяти';SYS='ClusterForm.PriorityByMemory'", "ru"));
	If Parameters.ObjectFieldValues = Undefined Then
		ConnectionsSecurityLevel = AdministrationConnectionSecurityLevel.Unsecure;
		LoadBalancingMode = AdministrationProcessChoicePriority.ByPerformance;
	Else
		Items.ItemIPPort.Enabled = False;
		Items.ItemComputer.Enabled = False;
		Items.ItemClusterName.Enabled = False;
		FillClusterPropertyValues(Parameters.ObjectFieldValues);
	EndIf;
	ThisStandartProcessing = FormAttributeToValue("object");
	DocumentationLink = ThisStandartProcessing.GetLinkDocumentation("cluster");
	If IsBlankString(DocumentationLink) Then
		Items.ItemDocumentationLink.Visible = False;
	EndIf;
EndProcedure

&AtClient
Function IsClusterNameUnique()
	Var Result;
	Result = True;
	For each ExistingObjectName In ListOfExistingObjectNames.ListOfObjects Do
		If (Lower(ClusterName) = Lower(ExistingObjectName)) Then
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

&AtServer
Procedure FillClusterPropertyValues(EditableClusterName)
	AdministrationAgent = GetAdministrationAgent(ConnectionSettings);
	For each Cluster In AdministrationAgent.GetClusters() Do
		If Cluster.Name = EditableClusterName Then
			ClusterName = Cluster.Name;
			Computer = Cluster.ComputerName;
			IPPort = Cluster.Port;
			ConnectionsSecurityLevel = Cluster.ConnectionSecurityLevel;
			ForceTerminationTime = Cluster.ForceTerminationTime;
			FaultToleranceLevel = Cluster.FaultToleranceLevel;
			LoadBalancingMode = Cluster.LoadBalancingMode;
			ProcessRestartPeriod = Cluster.ProcessRestartPeriod;
			ProcessMemoryLimit = Cluster.ProcessMemoryLimit;
			MaxMemoryTimeLimit = Cluster.MaxMemoryTimeLimit;
			ProcessErrorCountLimit = Cluster.ProcessErrorCountLimit;
			TerminateProblemProcess = Cluster.TerminateProblemProcess;
			WriteDumpWhileTerminatingByMemory = Cluster.WriteDumpWhenTerminatingByMemoryLimit;
			Break;
		EndIf;
	EndDo;
EndProcedure

&AtServer
Procedure AddClusterAtServer()
	AdministrationAgent = GetAdministrationAgent(ConnectionSettings);
	Cluster = AdministrationAgent.CreateCluster();
	Cluster.Name = ClusterName;
	Cluster.ComputerName = Computer;
	Cluster.Port = IPPort;
	Cluster.ConnectionSecurityLevel = ConnectionsSecurityLevel;
	Cluster.ForceTerminationTime = ForceTerminationTime;
	Cluster.FaultToleranceLevel = FaultToleranceLevel;
	Cluster.LoadBalancingMode = LoadBalancingMode;
	Cluster.ProcessRestartPeriod = ProcessRestartPeriod;
	Cluster.ProcessMemoryLimit = ProcessMemoryLimit;
	Cluster.MaxMemoryTimeLimit = MaxMemoryTimeLimit;
	Cluster.ProcessErrorCountLimit = ProcessErrorCountLimit;
	Cluster.TerminateProblemProcess = TerminateProblemProcess;
	Cluster.WriteDumpWhenTerminatingByMemoryLimit = WriteDumpWhileTerminatingByMemory;
	Cluster.Write();
EndProcedure

&AtServer
Procedure UpdateClusterAtServer()
	AdministrationAgent = GetAdministrationAgent(ConnectionSettings);
	For each Cluster In AdministrationAgent.GetClusters() Do
		If Cluster.Name = ClusterName Then
			Cluster.ConnectionSecurityLevel = ConnectionsSecurityLevel;
			Cluster.ForceTerminationTime = ForceTerminationTime;
			Cluster.FaultToleranceLevel = FaultToleranceLevel;
			Cluster.LoadBalancingMode = LoadBalancingMode;
			Cluster.ProcessRestartPeriod = ProcessRestartPeriod;
			Cluster.ProcessMemoryLimit = ProcessMemoryLimit;
			Cluster.MaxMemoryTimeLimit = MaxMemoryTimeLimit;
			Cluster.ProcessErrorCountLimit = ProcessErrorCountLimit;
			Cluster.TerminateProblemProcess = TerminateProblemProcess;
			Cluster.WriteDumpWhenTerminatingByMemoryLimit = WriteDumpWhileTerminatingByMemory;
			Break;
		EndIf;
	EndDo;
	Cluster.Write();
EndProcedure

&AtClient
Procedure WriteClusterAndCloseForm(Command)
	If CheckFilling() Then
		If IPPort < 65536 Or IPPort > 0 Then
			If ObjectChange Then
				UpdateClusterAtServer();
			Else
				AddClusterAtServer();
			EndIf;
			Close();
		Else
			Message(NStr("ru = 'Поле ""IP Порт"" должно быть в диапазоне от 1 до 65535';SYS='ClusterForm.PortRangeError'", "ru"));
		EndIf;
	EndIf;

EndProcedure

&AtClient
Procedure ItemDocumentationLinkClick(Item)
	GotoURL(DocumentationLink);
EndProcedure

&AtClient
Procedure ItemProcessMemoryLimitTuning(Item, Trend, StandardProcessing)
	StandardProcessing = False;
	ProcessMemoryLimit = Trend * 1000 + Item.EditText;
EndProcedure

&AtClient
Procedure DocumentationHelp(Command)
	GotoURL(DocumentationLink);
EndProcedure

=======
﻿
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	Var ThisStandartProcessing;
	ObjectChange = Parameters.ObjectFieldValues <> Undefined;
	ConnectionSettings = Parameters.ConnectionSettings;
	// заполняем список выбора безопасности соединения
	Items.ItemConnectionsSecurityLevel.ChoiceList.Add(
		AdministrationConnectionSecurityLevel.Secure, NStr("ru = 'Постоянно'; SYS='ClusterForm.SecurityLevelSecure'", "ru"));
	Items.ItemConnectionsSecurityLevel.ChoiceList.Add(
		AdministrationConnectionSecurityLevel.Unsecure, NStr("ru = 'Выключено'; SYS='ClusterForm.SecurityLevelUnsecure'", "ru"));
	Items.ItemConnectionsSecurityLevel.ChoiceList.Add(
		AdministrationConnectionSecurityLevel.SecureOnConnect, NStr("ru = 'Только соединение'; SYS='ClusterForm.SecurityLevelSecureOnConnect'", "ru"));
	// заполняем список выбора балансировки нагрузки
	Items.ItemLoadBalancingMode.ChoiceList.Add(AdministrationProcessChoicePriority.ByPerformance, 
		NStr("ru = 'По производительности';SYS='ClusterForm.PriorityByPerformance'", "ru"));
	Items.ItemLoadBalancingMode.ChoiceList.Add(AdministrationProcessChoicePriority.ByMemory, 
		NStr("ru = 'По памяти';SYS='ClusterForm.PriorityByMemory'", "ru"));
	If Parameters.ObjectFieldValues = Undefined Then
		ConnectionsSecurityLevel = AdministrationConnectionSecurityLevel.Unsecure;
		LoadBalancingMode = AdministrationProcessChoicePriority.ByPerformance;
	Else
		Items.ItemIPPort.Enabled = False;
		Items.ItemComputer.Enabled = False;
		Items.ItemClusterName.Enabled = False;
		FillClusterPropertyValues(Parameters.ObjectFieldValues);
	EndIf;
	ThisStandartProcessing = FormAttributeToValue("object");
	DocumentationLink = ThisStandartProcessing.GetLinkDocumentation("cluster");
	If IsBlankString(DocumentationLink) Then
		Items.ItemDocumentationLink.Visible = False;
	EndIf;
EndProcedure

&AtClient
Function IsClusterNameUnique()
	Var Result;
	Result = True;
	For each ExistingObjectName In ListOfExistingObjectNames.ListOfObjects Do
		If (Lower(ClusterName) = Lower(ExistingObjectName)) Then
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

&AtServer
Procedure FillClusterPropertyValues(EditableClusterName)
	AdministrationAgent = GetAdministrationAgent(ConnectionSettings);
	For each Cluster In AdministrationAgent.GetClusters() Do
		If Cluster.Name = EditableClusterName Then
			ClusterName = Cluster.Name;
			Computer = Cluster.ComputerName;
			IPPort = Cluster.Port;
			ConnectionsSecurityLevel = Cluster.ConnectionSecurityLevel;
			ForceTerminationTime = Cluster.ForceTerminationTime;
			FaultToleranceLevel = Cluster.FaultToleranceLevel;
			LoadBalancingMode = Cluster.LoadBalancingMode;
			ProcessRestartPeriod = Cluster.ProcessRestartPeriod;
			ProcessMemoryLimit = Cluster.ProcessMemoryLimit;
			MaxMemoryTimeLimit = Cluster.MaxMemoryTimeLimit;
			ProcessErrorCountLimit = Cluster.ProcessErrorCountLimit;
			TerminateProblemProcess = Cluster.TerminateProblemProcess;
			WriteDumpWhileTerminatingByMemory = Cluster.WriteDumpWhenTerminatingByMemoryLimit;
			Break;
		EndIf;
	EndDo;
EndProcedure

&AtServer
Procedure AddClusterAtServer()
	AdministrationAgent = GetAdministrationAgent(ConnectionSettings);
	Cluster = AdministrationAgent.CreateCluster();
	Cluster.Name = ClusterName;
	Cluster.ComputerName = Computer;
	Cluster.Port = IPPort;
	Cluster.ConnectionSecurityLevel = ConnectionsSecurityLevel;
	Cluster.ForceTerminationTime = ForceTerminationTime;
	Cluster.FaultToleranceLevel = FaultToleranceLevel;
	Cluster.LoadBalancingMode = LoadBalancingMode;
	Cluster.ProcessRestartPeriod = ProcessRestartPeriod;
	Cluster.ProcessMemoryLimit = ProcessMemoryLimit;
	Cluster.MaxMemoryTimeLimit = MaxMemoryTimeLimit;
	Cluster.ProcessErrorCountLimit = ProcessErrorCountLimit;
	Cluster.TerminateProblemProcess = TerminateProblemProcess;
	Cluster.WriteDumpWhenTerminatingByMemoryLimit = WriteDumpWhileTerminatingByMemory;
	Cluster.Write();
EndProcedure

&AtServer
Procedure UpdateClusterAtServer()
	AdministrationAgent = GetAdministrationAgent(ConnectionSettings);
	For each Cluster In AdministrationAgent.GetClusters() Do
		If Cluster.Name = ClusterName Then
			Cluster.ConnectionSecurityLevel = ConnectionsSecurityLevel;
			Cluster.ForceTerminationTime = ForceTerminationTime;
			Cluster.FaultToleranceLevel = FaultToleranceLevel;
			Cluster.LoadBalancingMode = LoadBalancingMode;
			Cluster.ProcessRestartPeriod = ProcessRestartPeriod;
			Cluster.ProcessMemoryLimit = ProcessMemoryLimit;
			Cluster.MaxMemoryTimeLimit = MaxMemoryTimeLimit;
			Cluster.ProcessErrorCountLimit = ProcessErrorCountLimit;
			Cluster.TerminateProblemProcess = TerminateProblemProcess;
			Cluster.WriteDumpWhenTerminatingByMemoryLimit = WriteDumpWhileTerminatingByMemory;
			Break;
		EndIf;
	EndDo;
	Cluster.Write();
EndProcedure

&AtClient
Procedure WriteClusterAndCloseForm(Command)
	If CheckFilling() Then
		If IPPort < 65536 Or IPPort > 0 Then
			If ObjectChange Then
				UpdateClusterAtServer();
			Else
				AddClusterAtServer();
			EndIf;
			Close();
		Else
			Message(NStr("ru = 'Поле ""IP Порт"" должно быть в диапазоне от 1 до 65535';SYS='ClusterForm.PortRangeError'", "ru"));
		EndIf;
	EndIf;

EndProcedure

&AtClient
Procedure ItemDocumentationLinkClick(Item)
	GotoURL(DocumentationLink);
EndProcedure

&AtClient
Procedure ItemProcessMemoryLimitTuning(Item, Trend, StandardProcessing)
	StandardProcessing = False;
	ProcessMemoryLimit = Trend * 1000 + Item.EditText;
EndProcedure

&AtClient
Procedure DocumentationHelp(Command)
	GotoURL(DocumentationLink);
EndProcedure

>>>>>>> f3f19a63ed53bdfa614d9191f48ffaf36859af97
