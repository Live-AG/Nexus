
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	Var ObjectFieldValues, ThisStandartProcessing; 
	ListOfExistingObjectNames = New Structure("ListOfObjects", Parameters.ListOfObjects);
	SecurityProfileName = Parameters.ProfileName;
	ObjectChange = Parameters.ObjectFieldValues <> Undefined;
	If Parameters.ObjectFieldValues <> Undefined Then
		Items.ItemSecurityProfileName.Enabled = False;
		Items.ItemName.Enabled = False;
		ObjectFieldValues = Parameters.ObjectFieldValues;
		SecurityProfileName = SecurityProfileName;
		Name = ObjectFieldValues.Name;
		RunLineTemplate = ObjectFieldValues.CommandString;
		Description = ObjectFieldValues.Description;
	EndIf;
	ThisStandartProcessing = FormAttributeToValue("Object");
	DocumentationLink = ThisStandartProcessing.GetLinkDocumentation("external application");
	If IsBlankString(DocumentationLink) Then
		Items.ItemDocumentationLink.Visible = False;
	EndIf;
EndProcedure

&AtClient
Function IsAllowedApplicationNameUnique()
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
Procedure WriteApplicationAndCloseForm(Command)
	If CheckFilling() Then
		If IsAllowedApplicationNameUnique() Then
			ApplicationSettings = New Structure();
			ApplicationSettings.Insert("ProfileName", SecurityProfileName);
			ApplicationSettings.Insert("Name", Name);
			ApplicationSettings.Insert("CommandString", RunLineTemplate);
			ApplicationSettings.Insert("Description", Description);
			ApplicationSettings.Insert("ObjectСhange", ObjectChange);
			ThisForm.Close(ApplicationSettings);
		Else
			Message(Nstr("ru = 'Внешнее приложение с таким именем уже существует.
					|Введите уникальное имя или перейдите к изменению существующего внешнего приложения.';SYS='AllowedApplication.AlreadyExists'", "ru"));
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

