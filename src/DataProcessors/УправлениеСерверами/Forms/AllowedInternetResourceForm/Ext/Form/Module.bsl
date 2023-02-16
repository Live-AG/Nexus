
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
		SecurityProfileName = ObjectFieldValues.ProfileName;
		Name = ObjectFieldValues.Name;
		Address = ObjectFieldValues.Address;
		Port = ObjectFieldValues.Port;
		Protocol = ObjectFieldValues.Protocol;
		Description = ObjectFieldValues.Description;
	EndIf;
	ThisStandartProcessing = FormAttributeToValue("Object");
	DocumentationLink = ThisStandartProcessing.GetLinkDocumentation("resource internet");
	If IsBlankString(DocumentationLink) Then
		Items.ItemDocumentationLink.Visible = False;
	EndIf;
EndProcedure

&AtClient
Function IsInternetResourceNameUnique()
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
Procedure WriteInternetResourceAndCloseForm(Command)
	If CheckFilling() Then
		If IsInternetResourceNameUnique() Then
			InternetResourceSettings = New Structure();
			InternetResourceSettings.Insert("ProfileName", SecurityProfileName);
			InternetResourceSettings.Insert("Name", Name);
			InternetResourceSettings.Insert("Address", Address);
			InternetResourceSettings.Insert("Port", Port);
			InternetResourceSettings.Insert("Protocol", Protocol);
			InternetResourceSettings.Insert("Description", Description);
			InternetResourceSettings.Insert("ObjectСhange", ObjectChange);
			ThisForm.Close(InternetResourceSettings);
		Else
			Message(Nstr("ru = 'Ресурс интернет с таким именем уже существует.
					|Введите уникальное имя или перейдите к изменению существующего ресурса интернет.';SYS='InternetResource.AlreadyExists'", "ru"));
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

