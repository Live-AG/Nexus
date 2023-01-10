<<<<<<< HEAD
﻿&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	// Заполнить список группировка
	Items.ItemCounterGroup.ChoiceList.Add(AdministrationResourceConsumptionCounterGroupType.Users, NStr("ru = 'Пользователи'; SYS='CounterForm.GroupTypeUsers'", "ru"));
	Items.ItemCounterGroup.ChoiceList.Add(AdministrationResourceConsumptionCounterGroupType.DataSeparation, NStr("ru = 'Разделение данных'; SYS='CounterForm.GroupTypeDataSeparation'", "ru"));
	// Заполнить список тип фильтра
	Items.ItemCounterFilterType.ChoiceList.Add(AdministrationResourceConsumptionCounterFilterType.All, NStr("ru = 'Все'; SYS='CounterForm.FilterTypeAll'", "ru"));
	Items.ItemCounterFilterType.ChoiceList.Add(AdministrationResourceConsumptionCounterFilterType.AllSelected, NStr("ru = 'Все выбранные'; SYS='CounterForm.FilterTypeAllSelected'", "ru"));
	Items.ItemCounterFilterType.ChoiceList.Add(AdministrationResourceConsumptionCounterFilterType.AllButSelected, NStr("ru = 'Все кроме выбранных'; SYS='CounterForm.FilterTypeAllButSelected'", "ru"));

	ListOfExistingObjectNames = New Structure("ListOfObjects", Parameters.ListOfObjects);
	ObjectChange = Parameters.ObjectFieldValues <> Undefined;
	If Parameters.ObjectFieldValues <> Undefined Then
		ObjectFieldValues = Parameters.ObjectFieldValues;
		Items.ItemName.Enabled = False;
		Name = ObjectFieldValues.Name;
		CounterGroup = ObjectFieldValues.Group;
		AccumulateTime = ObjectFieldValues.CollectionTime;
		CollectCallDuration = ObjectFieldValues.CollectCallsDuration;
		CollectServiceCallDuration = ObjectFieldValues.CollectServiceCallsDuration;
		CollectDBMSCallDuration = ObjectFieldValues.CollectDBMSCallsDuration;
		CollectActiveSessionCount = ObjectFieldValues.CollectActiveSessionsCount;
		CollectCallCount = ObjectFieldValues.CollectCallsCount;
		CollectSessionCount = ObjectFieldValues.CollectSessionCount;
		CollectDBMSSentReceivedDataSize = ObjectFieldValues.CollectDBMSSentAndReceivedDataSize;
		CollectWriteDataSize = ObjectFieldValues.CollectWriteDiskDataSize;
		CollectReadDataSize = ObjectFieldValues.CollectReadDiskDataSize;
		CollectMemoryUsage = ObjectFieldValues.CollectMemoryUsage;
		CollectCPUTime = ObjectFieldValues.CollectCPUTime;
		CounterFilterType = ObjectFieldValues.FilterType;
		CounterFilterValue = ObjectFieldValues.FilterValue;
		Description = ObjectFieldValues.Description;
	Else
		CounterGroup = AdministrationResourceConsumptionCounterGroupType.Users;
		CounterFilterType = AdministrationResourceConsumptionCounterFilterType.All;
	EndIf;
	ThisStandartProcessing = FormAttributeToValue("object");
	DocumentationLink = ThisStandartProcessing.GetLinkDocumentation("counter");
	If IsBlankString(DocumentationLink) Then
		Items.ItemDocumentationLink.Visible = False;
	EndIf;
EndProcedure

&AtClient
Function IsCounterNameUnique()
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

&AtClient
Procedure WriteCounterAndCloseForm(Command)
	If CheckFilling() Then
		If IsCounterNameUnique() Then
			CounterSettings = New Structure();
			CounterSettings.Insert("Name", Name);
			CounterSettings.Insert("Group", CounterGroup);
			CounterSettings.Insert("CollectionTime", AccumulateTime);
			CounterSettings.Insert("CollectCallsDuration", CollectCallDuration);
			CounterSettings.Insert("CollectServiceCallsDuration", CollectServiceCallDuration);
			CounterSettings.Insert("CollectDBMSCallsDuration", CollectDBMSCallDuration);
			CounterSettings.Insert("CollectActiveSessionsCount", CollectActiveSessionCount);
			CounterSettings.Insert("CollectCallsCount", CollectCallCount);
			CounterSettings.Insert("CollectSessionCount", CollectSessionCount);
			CounterSettings.Insert("CollectDBMSSentAndReceivedDataSize", CollectDBMSSentReceivedDataSize);
			CounterSettings.Insert("CollectWriteDiskDataSize", CollectWriteDataSize);
			CounterSettings.Insert("CollectReadDiskDataSize", CollectReadDataSize);
			CounterSettings.Insert("CollectMemoryUsage", CollectMemoryUsage);
			CounterSettings.Insert("CollectCPUTime", CollectCPUTime);
			CounterSettings.Insert("FilterType", CounterFilterType);
			CounterSettings.Insert("FilterValue", CounterFilterValue);
			CounterSettings.Insert("Description", Description);
			CounterSettings.Insert("ObjectСhange", ObjectChange);
			Close(CounterSettings);			
		Else
			Message(NStr("ru = 'Счетчик потребления ресурсов с таким именем уже существует. 
				|Введите уникальное имя или перейдите к изменению существующего счетчика.'; SYS='CounterForm.CounterAlreadyExists'", "ru"));
		EndIf;
	EndIf;
EndProcedure

// при изменении длительности сбора
&AtClient
Procedure ItemAccumulateTimeOnChange(Item)
	If AccumulateTime < 0 Then
		Message(Nstr("ru = 'Период счетчика не может быть отрицательным'; SYS='CounterForm.NegativeCounterPeriodValue'", "ru"));
		AccumulateTime = 0;
	EndIf;
EndProcedure

// при нажатии на кнопку Close
&AtClient
Procedure ЗакрытьФормуСчетчика(Command)
	Close();
EndProcedure

&AtClient
Procedure ItemDocumentationLinkClick(Item)
	GotoURL(DocumentationLink);
EndProcedure

&AtClient
Procedure ItemAccumulateTimeTuning(Item, Trend, StandardProcessing)
	StandardProcessing = False;
	AccumulateTime = Trend * 1000 + Item.EditText;
EndProcedure

&AtClient
Procedure DocumentationHelp(Command)
	GotoURL(DocumentationLink);
EndProcedure

=======
﻿&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	// Заполнить список группировка
	Items.ItemCounterGroup.ChoiceList.Add(AdministrationResourceConsumptionCounterGroupType.Users, NStr("ru = 'Пользователи'; SYS='CounterForm.GroupTypeUsers'", "ru"));
	Items.ItemCounterGroup.ChoiceList.Add(AdministrationResourceConsumptionCounterGroupType.DataSeparation, NStr("ru = 'Разделение данных'; SYS='CounterForm.GroupTypeDataSeparation'", "ru"));
	// Заполнить список тип фильтра
	Items.ItemCounterFilterType.ChoiceList.Add(AdministrationResourceConsumptionCounterFilterType.All, NStr("ru = 'Все'; SYS='CounterForm.FilterTypeAll'", "ru"));
	Items.ItemCounterFilterType.ChoiceList.Add(AdministrationResourceConsumptionCounterFilterType.AllSelected, NStr("ru = 'Все выбранные'; SYS='CounterForm.FilterTypeAllSelected'", "ru"));
	Items.ItemCounterFilterType.ChoiceList.Add(AdministrationResourceConsumptionCounterFilterType.AllButSelected, NStr("ru = 'Все кроме выбранных'; SYS='CounterForm.FilterTypeAllButSelected'", "ru"));

	ListOfExistingObjectNames = New Structure("ListOfObjects", Parameters.ListOfObjects);
	ObjectChange = Parameters.ObjectFieldValues <> Undefined;
	If Parameters.ObjectFieldValues <> Undefined Then
		ObjectFieldValues = Parameters.ObjectFieldValues;
		Items.ItemName.Enabled = False;
		Name = ObjectFieldValues.Name;
		CounterGroup = ObjectFieldValues.Group;
		AccumulateTime = ObjectFieldValues.CollectionTime;
		CollectCallDuration = ObjectFieldValues.CollectCallsDuration;
		CollectServiceCallDuration = ObjectFieldValues.CollectServiceCallsDuration;
		CollectDBMSCallDuration = ObjectFieldValues.CollectDBMSCallsDuration;
		CollectActiveSessionCount = ObjectFieldValues.CollectActiveSessionsCount;
		CollectCallCount = ObjectFieldValues.CollectCallsCount;
		CollectSessionCount = ObjectFieldValues.CollectSessionCount;
		CollectDBMSSentReceivedDataSize = ObjectFieldValues.CollectDBMSSentAndReceivedDataSize;
		CollectWriteDataSize = ObjectFieldValues.CollectWriteDiskDataSize;
		CollectReadDataSize = ObjectFieldValues.CollectReadDiskDataSize;
		CollectMemoryUsage = ObjectFieldValues.CollectMemoryUsage;
		CollectCPUTime = ObjectFieldValues.CollectCPUTime;
		CounterFilterType = ObjectFieldValues.FilterType;
		CounterFilterValue = ObjectFieldValues.FilterValue;
		Description = ObjectFieldValues.Description;
	Else
		CounterGroup = AdministrationResourceConsumptionCounterGroupType.Users;
		CounterFilterType = AdministrationResourceConsumptionCounterFilterType.All;
	EndIf;
	ThisStandartProcessing = FormAttributeToValue("object");
	DocumentationLink = ThisStandartProcessing.GetLinkDocumentation("counter");
	If IsBlankString(DocumentationLink) Then
		Items.ItemDocumentationLink.Visible = False;
	EndIf;
EndProcedure

&AtClient
Function IsCounterNameUnique()
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

&AtClient
Procedure WriteCounterAndCloseForm(Command)
	If CheckFilling() Then
		If IsCounterNameUnique() Then
			CounterSettings = New Structure();
			CounterSettings.Insert("Name", Name);
			CounterSettings.Insert("Group", CounterGroup);
			CounterSettings.Insert("CollectionTime", AccumulateTime);
			CounterSettings.Insert("CollectCallsDuration", CollectCallDuration);
			CounterSettings.Insert("CollectServiceCallsDuration", CollectServiceCallDuration);
			CounterSettings.Insert("CollectDBMSCallsDuration", CollectDBMSCallDuration);
			CounterSettings.Insert("CollectActiveSessionsCount", CollectActiveSessionCount);
			CounterSettings.Insert("CollectCallsCount", CollectCallCount);
			CounterSettings.Insert("CollectSessionCount", CollectSessionCount);
			CounterSettings.Insert("CollectDBMSSentAndReceivedDataSize", CollectDBMSSentReceivedDataSize);
			CounterSettings.Insert("CollectWriteDiskDataSize", CollectWriteDataSize);
			CounterSettings.Insert("CollectReadDiskDataSize", CollectReadDataSize);
			CounterSettings.Insert("CollectMemoryUsage", CollectMemoryUsage);
			CounterSettings.Insert("CollectCPUTime", CollectCPUTime);
			CounterSettings.Insert("FilterType", CounterFilterType);
			CounterSettings.Insert("FilterValue", CounterFilterValue);
			CounterSettings.Insert("Description", Description);
			CounterSettings.Insert("ObjectСhange", ObjectChange);
			Close(CounterSettings);			
		Else
			Message(NStr("ru = 'Счетчик потребления ресурсов с таким именем уже существует. 
				|Введите уникальное имя или перейдите к изменению существующего счетчика.'; SYS='CounterForm.CounterAlreadyExists'", "ru"));
		EndIf;
	EndIf;
EndProcedure

// при изменении длительности сбора
&AtClient
Procedure ItemAccumulateTimeOnChange(Item)
	If AccumulateTime < 0 Then
		Message(Nstr("ru = 'Период счетчика не может быть отрицательным'; SYS='CounterForm.NegativeCounterPeriodValue'", "ru"));
		AccumulateTime = 0;
	EndIf;
EndProcedure

// при нажатии на кнопку Close
&AtClient
Procedure ЗакрытьФормуСчетчика(Command)
	Close();
EndProcedure

&AtClient
Procedure ItemDocumentationLinkClick(Item)
	GotoURL(DocumentationLink);
EndProcedure

&AtClient
Procedure ItemAccumulateTimeTuning(Item, Trend, StandardProcessing)
	StandardProcessing = False;
	AccumulateTime = Trend * 1000 + Item.EditText;
EndProcedure

&AtClient
Procedure DocumentationHelp(Command)
	GotoURL(DocumentationLink);
EndProcedure

>>>>>>> f3f19a63ed53bdfa614d9191f48ffaf36859af97
