&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	Var ObjectFieldValues;
	ListOfExistingObjectNames = New Structure("ListOfObjects", Parameters.ListOfObjects);
	If Parameters.ObjectFieldValues <> Undefined Then
		ObjectFieldValues = Parameters.ObjectFieldValues;
		Name = ObjectFieldValues.Name;
		Items.ItemName.Enabled = False;
		Description = ObjectFieldValues.Description;
		PasswordAuthentication = True;
		Password = ObjectFieldValues.Password;
		PasswordConfirmation = ObjectFieldValues.Password;
	EndIf;
	ThisStandartProcessing = FormAttributeToValue("object");
	DocumentationLink = ThisStandartProcessing.GetLinkDocumentation("cluster administrator");
	If IsBlankString(DocumentationLink) Then
		Items.ItemDocumentationLink.Visible = False;
	EndIf;
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	PasswordAuthentication = True;
EndProcedure

&AtClient
Function IsAdministratorNameUnique()
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
Procedure WriteAdministratorAndCloseForm(Command)
	If CheckFilling() Then
		If Password = PasswordConfirmation Then
			If IsAdministratorNameUnique() Then
				AdministratorSettings = New Structure();
				AdministratorSettings.Insert("Name", Name);
				AdministratorSettings.Insert("Description", Description);
				AdministratorSettings.Insert("Password", Password);
				AdministratorSettings.Insert("OSUser", User);
				AdministratorSettings.Insert("OSAuthentication", OperationSystemAuthentication);
				AdministratorSettings.Insert("StandardAuthentication", PasswordAuthentication);
				Close(AdministratorSettings);
			Else
				Message(NStr("ru = 'Администратор с таким именем уже существует.
						|Введите уникальное имя или перейдите к изменению существующего администратора.';SYS='CreateAdministrator.AdministratorExists'", "ru"));
			EndIf;
		Else
			Message(NStr("ru = 'Подтверждение пароля не совпадает с паролем';SYS='CreateAdministrator.PasswordConfirm'", "ru"));
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


