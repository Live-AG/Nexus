<<<<<<< HEAD
﻿
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	Var ThisStandartProcessing, ObjectFieldValues; 
	// заполняем список выбора для действия при превышении
	Items.FormActionOnExceedingLimits.ChoiceList.Add(
		AdministrationActionOnResourceConsumptionLimitExcess.None, Nstr("ru = 'Нет'; SYS='LimitActionType.None'", "ru"));
	Items.FormActionOnExceedingLimits.ChoiceList.Add(
		AdministrationActionOnResourceConsumptionLimitExcess.SetThreadLowPriority, Nstr("ru = 'Установить низкий приоритет потока'; SYS='LimitActionType.SetThreadLowPriority'", "ru"));
	Items.FormActionOnExceedingLimits.ChoiceList.Add(
		AdministrationActionOnResourceConsumptionLimitExcess.InterruptCurrentServerCall, Nstr("ru = 'Прервать текущий серверный вызов'; SYS='LimitActionType.InterruptCurrentServerCall'", "ru"));
 	Items.FormActionOnExceedingLimits.ChoiceList.Add(
		AdministrationActionOnResourceConsumptionLimitExcess.TerminateSession, Nstr("ru = 'Завершить сеанс'; SYS='LimitActionType.TerminateSession'", "ru"));

	ListOfExistingObjectName = New Structure("ListOfObjects", Parameters.ListOfObjects);
	ObjectСhange = Parameters.ObjectFieldValues <> Undefined;
	If Parameters.ObjectFieldValues <> Undefined Then		
		ObjectFieldValues = Parameters.ObjectFieldValues;
		LimitName = ObjectFieldValues.Name;
		Items.FormLimitName.Enabled = False;
		ResourceConsumptionCounter = ObjectFieldValues.Counter;
		ActionOnExceedingLimits = ObjectFieldValues.Action;
		LimitServerCallDuration = ObjectFieldValues.CallDuration;
		LimitServiceCallDuration = ObjectFieldValues.ServiceCallDuration;
		LimitDBMSCallDuration = ObjectFieldValues.DBMSCallDuration;
		LimitActiveSessionCount = ObjectFieldValues.ActiveSessionCount;
		LimitServerCallCount = ObjectFieldValues.CallCount;
		LimitSessionCount = ObjectFieldValues.SessionCount;
		LimitDBMSSendReceiveSize = ObjectFieldValues.DBMSSentAndReceivedDataSize;
		LimitWriteDataSize = ObjectFieldValues.WriteDiskDataSize;
		LimitReadDataSize = ObjectFieldValues.ReadDiskDataSize;
		LimitMemoryUsage = ObjectFieldValues.MemoryUsage;
		LimitCPUTime = ObjectFieldValues.CPUTime;
		LimitUserErrorMessage = ObjectFieldValues.ErrorMessage;
		LimitDescription = ObjectFieldValues.Description;
	EndIf;
	ThisStandartProcessing = FormAttributeToValue("object");
	DocumentationLink = ThisStandartProcessing.GetLinkDocumentation("limit");
	If IsBlankString(DocumentationLink) Then
		Items.ItemDocumentationLink.Visible = False;
	EndIf;
EndProcedure

&AtClient
Function IsLimitNameUnique()
	Var Result;
	Result = True;
	For each ExistingObjectName In ListOfExistingObjectName.ListOfObjects Do
		If (Lower(LimitName) = Lower(ExistingObjectName)) Then
			Result = False;
			Break;
		EndIf;
	EndDo;
	Return Result;
EndFunction

&AtClient
Procedure CommandWriteLimitAndCloseForm(Command)
	Var LimitSettings;
	If CheckFilling() Then
		If IsLimitNameUnique() Then
			LimitSettings = New Structure();
			LimitSettings.Insert("Name", LimitName);
			LimitSettings.Insert("Counter", ResourceConsumptionCounter);
			LimitSettings.Insert("Action", ActionOnExceedingLimits);
			LimitSettings.Insert("CallDuration", LimitServerCallDuration);
			LimitSettings.Insert("ServiceCallDuration", LimitServiceCallDuration);
			LimitSettings.Insert("DBMSCallDuration", LimitDBMSCallDuration);
			LimitSettings.Insert("ActiveSessionCount", LimitActiveSessionCount);
			LimitSettings.Insert("CallCount", LimitServerCallCount);
			LimitSettings.Insert("SessionCount", LimitSessionCount);
			LimitSettings.Insert("DBMSSentAndReceivedDataSize", LimitDBMSSendReceiveSize);
			LimitSettings.Insert("WriteDiskDataSize", LimitWriteDataSize);
			LimitSettings.Insert("ReadDiskDataSize", LimitReadDataSize);
			LimitSettings.Insert("MemoryUsage", LimitMemoryUsage);
			LimitSettings.Insert("CPUTime", LimitCPUTime);
			LimitSettings.Insert("ErrorMessage", LimitUserErrorMessage);
			LimitSettings.Insert("Description", LimitDescription);
			LimitSettings.Insert("ObjectСhange", ObjectСhange);
			ThisForm.Close(LimitSettings);
		Else
			Message(Nstr("ru = 'Ограничение потребления ресурсов с таким именем уже существует. 
				|Введите уникальное имя или перейдите к изменению существующего ограничения.';SYS='LimitName.AlreadyExists'", "ru"));
		EndIf;
	EndIf;
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	If ObjectСhange = False Then
		ActionOnExceedingLimits = AdministrationActionOnResourceConsumptionLimitExcess.None;
	EndIf;
EndProcedure

&AtClient
Procedure ItemDocumentationLinkClick(Item)
	GotoURL(DocumentationLink);
EndProcedure

&AtClient
Procedure LimitServerCallDurationTuning(Item, Trend, StandardProcessing)
	StandardProcessing = False;
	LimitServerCallDuration = Trend * 1000 + Item.EditText;
EndProcedure

&AtClient
Procedure FormLimitCPUTimeTuning(Item, Trend, StandardProcessing)
	StandardProcessing = False;
	LimitCPUTime = Trend * 1000 + Item.EditText;
EndProcedure

&AtClient
Procedure FormLimitDBMSCallDurationTuning(Item, Trend, StandardProcessing)
	StandardProcessing = False;
	LimitDBMSCallDuration = Trend * 1000 + Item.EditText;
EndProcedure

&AtClient
Procedure FormLimitServiceCallDurationTuning(Item, Trend, StandardProcessing)
	StandardProcessing = False;
	LimitServiceCallDuration = Trend * 1000 + Item.EditText;
EndProcedure

&AtClient
Procedure FormLimitMemoryUsageTuning(Item, Trend, StandardProcessing)
	StandardProcessing = False;
    LimitMemoryUsage = Trend * 1000000 + Item.EditText;
EndProcedure

&AtClient
Procedure FormLimitReadDataSizeTuning(Item, Trend, StandardProcessing)
	StandardProcessing = False;
    LimitReadDataSize = Trend * 1000000 + Item.EditText;
EndProcedure

&AtClient
Procedure FormLimitWriteDataSizeTuning(Item, Trend, StandardProcessing)
	StandardProcessing = False;
    LimitWriteDataSize = Trend * 1000000 + Item.EditText;
EndProcedure

&AtClient
Procedure FormLimitDBMSSendReceiveSizeTuning(Item, Trend, StandardProcessing)
	StandardProcessing = False;
    LimitDBMSSendReceiveSize = Trend * 1000000 + Item.EditText;
EndProcedure

&AtClient
Procedure FormLimitServerCallCountTuning(Item, Trend, StandardProcessing)
	StandardProcessing = False;
    LimitServerCallCount = Trend * 100 + Item.EditText;
EndProcedure

&AtClient
Procedure FormLimitSessionCountTuning(Item, Trend, StandardProcessing)
	StandardProcessing = False;
    LimitSessionCount = Trend * 10 + Item.EditText;
EndProcedure

&AtClient
Procedure FormLimitActiveSessionCountTuning(Item, Trend, StandardProcessing)
	StandardProcessing = False;
    LimitActiveSessionCount = Trend * 10 + Item.EditText;
EndProcedure

&AtClient
Procedure DocumentationHelp(Command)
	GotoURL(DocumentationLink);
EndProcedure

=======
﻿
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	Var ThisStandartProcessing, ObjectFieldValues; 
	// заполняем список выбора для действия при превышении
	Items.FormActionOnExceedingLimits.ChoiceList.Add(
		AdministrationActionOnResourceConsumptionLimitExcess.None, Nstr("ru = 'Нет'; SYS='LimitActionType.None'", "ru"));
	Items.FormActionOnExceedingLimits.ChoiceList.Add(
		AdministrationActionOnResourceConsumptionLimitExcess.SetThreadLowPriority, Nstr("ru = 'Установить низкий приоритет потока'; SYS='LimitActionType.SetThreadLowPriority'", "ru"));
	Items.FormActionOnExceedingLimits.ChoiceList.Add(
		AdministrationActionOnResourceConsumptionLimitExcess.InterruptCurrentServerCall, Nstr("ru = 'Прервать текущий серверный вызов'; SYS='LimitActionType.InterruptCurrentServerCall'", "ru"));
 	Items.FormActionOnExceedingLimits.ChoiceList.Add(
		AdministrationActionOnResourceConsumptionLimitExcess.TerminateSession, Nstr("ru = 'Завершить сеанс'; SYS='LimitActionType.TerminateSession'", "ru"));

	ListOfExistingObjectName = New Structure("ListOfObjects", Parameters.ListOfObjects);
	ObjectСhange = Parameters.ObjectFieldValues <> Undefined;
	If Parameters.ObjectFieldValues <> Undefined Then		
		ObjectFieldValues = Parameters.ObjectFieldValues;
		LimitName = ObjectFieldValues.Name;
		Items.FormLimitName.Enabled = False;
		ResourceConsumptionCounter = ObjectFieldValues.Counter;
		ActionOnExceedingLimits = ObjectFieldValues.Action;
		LimitServerCallDuration = ObjectFieldValues.CallDuration;
		LimitServiceCallDuration = ObjectFieldValues.ServiceCallDuration;
		LimitDBMSCallDuration = ObjectFieldValues.DBMSCallDuration;
		LimitActiveSessionCount = ObjectFieldValues.ActiveSessionCount;
		LimitServerCallCount = ObjectFieldValues.CallCount;
		LimitSessionCount = ObjectFieldValues.SessionCount;
		LimitDBMSSendReceiveSize = ObjectFieldValues.DBMSSentAndReceivedDataSize;
		LimitWriteDataSize = ObjectFieldValues.WriteDiskDataSize;
		LimitReadDataSize = ObjectFieldValues.ReadDiskDataSize;
		LimitMemoryUsage = ObjectFieldValues.MemoryUsage;
		LimitCPUTime = ObjectFieldValues.CPUTime;
		LimitUserErrorMessage = ObjectFieldValues.ErrorMessage;
		LimitDescription = ObjectFieldValues.Description;
	EndIf;
	ThisStandartProcessing = FormAttributeToValue("object");
	DocumentationLink = ThisStandartProcessing.GetLinkDocumentation("limit");
	If IsBlankString(DocumentationLink) Then
		Items.ItemDocumentationLink.Visible = False;
	EndIf;
EndProcedure

&AtClient
Function IsLimitNameUnique()
	Var Result;
	Result = True;
	For each ExistingObjectName In ListOfExistingObjectName.ListOfObjects Do
		If (Lower(LimitName) = Lower(ExistingObjectName)) Then
			Result = False;
			Break;
		EndIf;
	EndDo;
	Return Result;
EndFunction

&AtClient
Procedure CommandWriteLimitAndCloseForm(Command)
	Var LimitSettings;
	If CheckFilling() Then
		If IsLimitNameUnique() Then
			LimitSettings = New Structure();
			LimitSettings.Insert("Name", LimitName);
			LimitSettings.Insert("Counter", ResourceConsumptionCounter);
			LimitSettings.Insert("Action", ActionOnExceedingLimits);
			LimitSettings.Insert("CallDuration", LimitServerCallDuration);
			LimitSettings.Insert("ServiceCallDuration", LimitServiceCallDuration);
			LimitSettings.Insert("DBMSCallDuration", LimitDBMSCallDuration);
			LimitSettings.Insert("ActiveSessionCount", LimitActiveSessionCount);
			LimitSettings.Insert("CallCount", LimitServerCallCount);
			LimitSettings.Insert("SessionCount", LimitSessionCount);
			LimitSettings.Insert("DBMSSentAndReceivedDataSize", LimitDBMSSendReceiveSize);
			LimitSettings.Insert("WriteDiskDataSize", LimitWriteDataSize);
			LimitSettings.Insert("ReadDiskDataSize", LimitReadDataSize);
			LimitSettings.Insert("MemoryUsage", LimitMemoryUsage);
			LimitSettings.Insert("CPUTime", LimitCPUTime);
			LimitSettings.Insert("ErrorMessage", LimitUserErrorMessage);
			LimitSettings.Insert("Description", LimitDescription);
			LimitSettings.Insert("ObjectСhange", ObjectСhange);
			ThisForm.Close(LimitSettings);
		Else
			Message(Nstr("ru = 'Ограничение потребления ресурсов с таким именем уже существует. 
				|Введите уникальное имя или перейдите к изменению существующего ограничения.';SYS='LimitName.AlreadyExists'", "ru"));
		EndIf;
	EndIf;
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	If ObjectСhange = False Then
		ActionOnExceedingLimits = AdministrationActionOnResourceConsumptionLimitExcess.None;
	EndIf;
EndProcedure

&AtClient
Procedure ItemDocumentationLinkClick(Item)
	GotoURL(DocumentationLink);
EndProcedure

&AtClient
Procedure LimitServerCallDurationTuning(Item, Trend, StandardProcessing)
	StandardProcessing = False;
	LimitServerCallDuration = Trend * 1000 + Item.EditText;
EndProcedure

&AtClient
Procedure FormLimitCPUTimeTuning(Item, Trend, StandardProcessing)
	StandardProcessing = False;
	LimitCPUTime = Trend * 1000 + Item.EditText;
EndProcedure

&AtClient
Procedure FormLimitDBMSCallDurationTuning(Item, Trend, StandardProcessing)
	StandardProcessing = False;
	LimitDBMSCallDuration = Trend * 1000 + Item.EditText;
EndProcedure

&AtClient
Procedure FormLimitServiceCallDurationTuning(Item, Trend, StandardProcessing)
	StandardProcessing = False;
	LimitServiceCallDuration = Trend * 1000 + Item.EditText;
EndProcedure

&AtClient
Procedure FormLimitMemoryUsageTuning(Item, Trend, StandardProcessing)
	StandardProcessing = False;
    LimitMemoryUsage = Trend * 1000000 + Item.EditText;
EndProcedure

&AtClient
Procedure FormLimitReadDataSizeTuning(Item, Trend, StandardProcessing)
	StandardProcessing = False;
    LimitReadDataSize = Trend * 1000000 + Item.EditText;
EndProcedure

&AtClient
Procedure FormLimitWriteDataSizeTuning(Item, Trend, StandardProcessing)
	StandardProcessing = False;
    LimitWriteDataSize = Trend * 1000000 + Item.EditText;
EndProcedure

&AtClient
Procedure FormLimitDBMSSendReceiveSizeTuning(Item, Trend, StandardProcessing)
	StandardProcessing = False;
    LimitDBMSSendReceiveSize = Trend * 1000000 + Item.EditText;
EndProcedure

&AtClient
Procedure FormLimitServerCallCountTuning(Item, Trend, StandardProcessing)
	StandardProcessing = False;
    LimitServerCallCount = Trend * 100 + Item.EditText;
EndProcedure

&AtClient
Procedure FormLimitSessionCountTuning(Item, Trend, StandardProcessing)
	StandardProcessing = False;
    LimitSessionCount = Trend * 10 + Item.EditText;
EndProcedure

&AtClient
Procedure FormLimitActiveSessionCountTuning(Item, Trend, StandardProcessing)
	StandardProcessing = False;
    LimitActiveSessionCount = Trend * 10 + Item.EditText;
EndProcedure

&AtClient
Procedure DocumentationHelp(Command)
	GotoURL(DocumentationLink);
EndProcedure

>>>>>>> f3f19a63ed53bdfa614d9191f48ffaf36859af97
