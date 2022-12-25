
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	Var ThisStandartProcessing, ObjectFieldValues;
	ListOfExistingObjectNames = New Structure("ListOfObjects", Parameters.ListOfObjects);
	SecurityProfileName = Parameters.ProfileName;
	ObjectChange = Parameters.ObjectFieldValues <> Undefined;
	If Parameters.ObjectFieldValues <> Undefined Then
		Items.ItemSecurityProfileName.Enabled = False;
		Items.ItemName.Enabled = False;
		ObjectFieldValues = Parameters.ObjectFieldValues;
		SecurityProfileName = SecurityProfileName;
		Name = ObjectFieldValues.Name;
		CheckSum = ObjectFieldValues.HashSum;
		Description = ObjectFieldValues.Description;
	EndIf;
	ThisStandartProcessing = FormAttributeToValue("Object");
	DocumentationLink = ThisStandartProcessing.GetLinkDocumentation("external module");
	If IsBlankString(DocumentationLink) Then
		Items.ItemDocumentationLink.Visible = False;
	EndIf;
EndProcedure

&AtClient
Function IsAllowedModuleNameUnique()
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
Procedure WriteModuleAndCloseForm(Command)
	If CheckFilling() Then
		If IsAllowedModuleNameUnique() Then
			AllowedModuleSettings = New Structure();
			AllowedModuleSettings.Insert("ProfileName", SecurityProfileName);
			AllowedModuleSettings.Insert("Name", Name);
			AllowedModuleSettings.Insert("HashSum", CheckSum);
			AllowedModuleSettings.Insert("Description", Description);
			AllowedModuleSettings.Insert("ObjectСhange", ObjectChange);
			ThisForm.Close(AllowedModuleSettings);
		Else
			Message(Nstr("ru = 'Внешний модуль с таким именем уже существует.
					|Введите уникальное имя или перейдите к изменению существующего внешнего модуля.';SYS='AllowedModule.AlreadyExists'", "ru"));
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

