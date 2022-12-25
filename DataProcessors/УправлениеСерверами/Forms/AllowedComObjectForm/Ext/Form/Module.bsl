
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
		COMClassID = ObjectFieldValues.ObjectUUID;
		Description = ObjectFieldValues.Description;
		Computer = ObjectFieldValues.ComputerName;
		File = ObjectFieldValues.FileName;
		Name = ObjectFieldValues.Name;
	EndIf;
	ThisStandartProcessing = FormAttributeToValue("Object");
	DocumentationLink = ThisStandartProcessing.GetLinkDocumentation("COM class");
	If IsBlankString(DocumentationLink) Then
		Items.ItemDocumentationLink.Visible = False;
	EndIf;
EndProcedure

&AtClient
Function IsAllowedCOMClassNameUnique()
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
Procedure WriteCOMClassAndCloseForm(Command)
	Var UUIDClass, COMClassSettings;
	If CheckFilling() Then
		If IsAllowedCOMClassNameUnique() Then
			COMClassSettings = New Structure();
			COMClassSettings.Insert("ProfileName", SecurityProfileName);
			COMClassSettings.Insert("Name", Name);
			Try
				UUIDClass = New UUID(COMClassID);
			Except
				Message(Nstr("ru = 'Идентификатор объекта задан неверно.
						|Пример правильного идентификатора:A16C48CA-EF33-41B9-87B9-95A51190AE0D.';SYS='COMClass.UUIDErrorFormat'", "ru"));
				Return;
			EndTry;
			COMClassSettings.Insert("ObjectUUID", COMClassID);
			COMClassSettings.Insert("Description", Description);
			COMClassSettings.Insert("ComputerName", Computer);
			COMClassSettings.Insert("FileName", File);
			COMClassSettings.Insert("ObjectСhange", ObjectChange);
			ThisForm.Close(COMClassSettings);
		Else
			Message(Nstr("ru = 'COM-класс с таким именем уже существует. 
			|Введите уникальное имя или перейдите к изменению существующего COM-класса.';SYS='COMClass.AlreadyExists'", "ru"));
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



