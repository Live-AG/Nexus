
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
		Name = ObjectFieldValues.Name;
		CheckSum = ObjectFieldValues.HashSum;
		Description = ObjectFieldValues.Description;
	EndIf;
	ThisStandartProcessing = FormAttributeToValue("Object");
	DocumentationLink = ThisStandartProcessing.GetLinkDocumentation("addIn");
	If IsBlankString(DocumentationLink) Then
		Items.ItemDocumentationLink.Visible = False;
	EndIf;
EndProcedure

&AtClient
Function IsAllowedComponentNameUnique()
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
Procedure WriteComponentAndCloseForm(Command)
	If CheckFilling() Then
		If IsAllowedComponentNameUnique() Then
			ComponentSettings = New Structure();
			ComponentSettings.Insert("ProfileName", SecurityProfileName);
			ComponentSettings.Insert("Name", Name);
			ComponentSettings.Insert("HashSum", CheckSum);
			ComponentSettings.Insert("Description", Description);
			ComponentSettings.Insert("ObjectСhange", ObjectChange);
			ThisForm.Close(ComponentSettings);
		Else
			Message(Nstr("ru = 'Внешняя компонента с таким именем уже существует.
					|Введите уникальное имя или перейдите к изменению существующей внешней компоненты.';SYS='AllowedComponent.AlreadyExists'", "ru"));
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

