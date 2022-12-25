
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	If Parameters.ObjectFieldValues <> Undefined Then		
		ObjectFieldValues = Parameters.ObjectFieldValues;
		Active = ObjectFieldValues.Running;
		Reserve = ObjectFieldValues.Reserve;
		Computer = ObjectFieldValues.ComputerName;
		Performance = ObjectFieldValues.AvailablePerformance;
		Run = ObjectFieldValues.Enable;
		IPPort = ObjectFieldValues.Port;
		ExcessOverCriticalValue = ObjectFieldValues.MemoryUsageExcessTime;
		StartTime = ObjectFieldValues.StartTime;
		If (ObjectFieldValues.WorkProcessStatus = AdministrationWorkProcessStatus.Used) Then
			Use = NStr("ru = 'Используется';SYS='WorkProcessStatus.Used'", "ru");
		ElsIf (ObjectFieldValues.WorkProcessStatus = AdministrationWorkProcessStatus.NotUsed) Then
			Use = NStr("ru = 'Не используется';SYS='WorkProcessStatus.Used'", "ru");
		ElsIf  (ObjectFieldValues.WorkProcessStatus = AdministrationWorkProcessStatus.Reserve) Then
			Use = NStr("ru = 'Резервный';SYS='WorkProcessStatus.Used'", "ru");
		EndIf;
		Capacity = ObjectFieldValues.Capacity;
		ServerResponse = ObjectFieldValues.AverageCallDuration;
		SpentDBMS = ObjectFieldValues.AverageDBMSCallsDuration;
		SpentLockManager = ObjectFieldValues.AverageServiceCallDuration;
		SpentServer = ObjectFieldValues.AverageWorkProcessCallProcessingDuration;
		ClientThreadCount = ObjectFieldValues.AverageThreadCount;
		PIDProcessOS = ObjectFieldValues.ProcessID;
		MemoryUsage = ObjectFieldValues.MemoryUsage / 1024;
		License = ObjectFieldValues.Licenses;
	EndIf;
	ThisStandartProcessing = FormAttributeToValue("object");
	DocumentationLink = ThisStandartProcessing.GetLinkDocumentation("work process");
	If IsBlankString(DocumentationLink) Then
		Items.ItemDocumentationLink.Visible = False;
	EndIf;
EndProcedure

&AtClient
Procedure CloseWorkProcessForm(Command)
	Close();
EndProcedure

&AtClient
Procedure ItemDocumentationLinkClick(Item)
	GotoURL(DocumentationLink);
EndProcedure

&AtClient
Procedure DocumentationHelp(Command)
	GotoURL(DocumentationLink);
EndProcedure

