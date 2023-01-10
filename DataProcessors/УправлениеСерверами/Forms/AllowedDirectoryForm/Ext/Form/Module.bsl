<<<<<<< HEAD
﻿
&AtClient
Procedure WriteDirectoryAndCloseForm(Command)
	If CheckFilling() Then
		If IsAllowedDirectoryNameUnique() Then
			DirectorySettings = New Structure();
			DirectorySettings.Insert("ProfileName", SecurityProfileName);
			DirectorySettings.Insert("Alias", LogicalURL);
			DirectorySettings.Insert("ReadingAllowed", AllowedReadData);
			DirectorySettings.Insert("WritingAllowed", AllowedWriteData);
			DirectorySettings.Insert("Path", PhysicalURL);
			DirectorySettings.Insert("Description", Description);
			DirectorySettings.Insert("ObjectСhange", ObjectChange);
			ThisForm.Close(DirectorySettings);
		Else
			Message(Nstr("ru = 'Виртуальный каталог с таким именем уже существует.
					|Введите уникальный логический URL или перейдите к изменению существующего логического каталога.';SYS='AllowedDirectory.AlreadyExists'", "ru"));
		EndIf;
	EndIf;
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ListOfExistingObjectNames = New Structure("ListOfObjects", Parameters.ListOfObjects);
	SecurityProfileName = Parameters.ProfileName;
	ObjectChange = Parameters.ObjectFieldValues <> Undefined;
	If Parameters.ObjectFieldValues <> Undefined Then
		Items.ItemSecurityProfileName.Enabled = False;
		Items.ItemLogicalURL.Enabled = False;
		ObjectFieldValues = Parameters.ObjectFieldValues;
		SecurityProfileName = SecurityProfileName;
		LogicalURL = ObjectFieldValues.Alias;
		AllowedReadData = ObjectFieldValues.ReadingAllowed;
		AllowedWriteData = ObjectFieldValues.WritingAllowed;
		PhysicalURL = ObjectFieldValues.Path;
		Description = ObjectFieldValues.Description;
	EndIf;
	ThisStandartProcessing = FormAttributeToValue("Object");
	DocumentationLink = ThisStandartProcessing.GetLinkDocumentation("virtual directory");
	If IsBlankString(DocumentationLink) Then
		Items.ItemDocumentationLink.Visible = False;
	EndIf;	
EndProcedure

&AtClient
Function IsAllowedDirectoryNameUnique()
	Var Result;
	Result = True;
	For each ExistingObjectName In ListOfExistingObjectNames.ListOfObjects Do
		If (Lower(LogicalURL) = Lower(ExistingObjectName)) Then
			Result = False;
			Break;
		EndIf;
	EndDo;
	Return Result;
EndFunction

&AtClient
Procedure ItemDocumentationLinkClick(Item)
	GotoURL(DocumentationLink);
EndProcedure

&AtClient
Procedure DocumentationHelp(Command)
	GotoURL(DocumentationLink);
EndProcedure

=======
﻿
&AtClient
Procedure WriteDirectoryAndCloseForm(Command)
	If CheckFilling() Then
		If IsAllowedDirectoryNameUnique() Then
			DirectorySettings = New Structure();
			DirectorySettings.Insert("ProfileName", SecurityProfileName);
			DirectorySettings.Insert("Alias", LogicalURL);
			DirectorySettings.Insert("ReadingAllowed", AllowedReadData);
			DirectorySettings.Insert("WritingAllowed", AllowedWriteData);
			DirectorySettings.Insert("Path", PhysicalURL);
			DirectorySettings.Insert("Description", Description);
			DirectorySettings.Insert("ObjectСhange", ObjectChange);
			ThisForm.Close(DirectorySettings);
		Else
			Message(Nstr("ru = 'Виртуальный каталог с таким именем уже существует.
					|Введите уникальный логический URL или перейдите к изменению существующего логического каталога.';SYS='AllowedDirectory.AlreadyExists'", "ru"));
		EndIf;
	EndIf;
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ListOfExistingObjectNames = New Structure("ListOfObjects", Parameters.ListOfObjects);
	SecurityProfileName = Parameters.ProfileName;
	ObjectChange = Parameters.ObjectFieldValues <> Undefined;
	If Parameters.ObjectFieldValues <> Undefined Then
		Items.ItemSecurityProfileName.Enabled = False;
		Items.ItemLogicalURL.Enabled = False;
		ObjectFieldValues = Parameters.ObjectFieldValues;
		SecurityProfileName = SecurityProfileName;
		LogicalURL = ObjectFieldValues.Alias;
		AllowedReadData = ObjectFieldValues.ReadingAllowed;
		AllowedWriteData = ObjectFieldValues.WritingAllowed;
		PhysicalURL = ObjectFieldValues.Path;
		Description = ObjectFieldValues.Description;
	EndIf;
	ThisStandartProcessing = FormAttributeToValue("Object");
	DocumentationLink = ThisStandartProcessing.GetLinkDocumentation("virtual directory");
	If IsBlankString(DocumentationLink) Then
		Items.ItemDocumentationLink.Visible = False;
	EndIf;	
EndProcedure

&AtClient
Function IsAllowedDirectoryNameUnique()
	Var Result;
	Result = True;
	For each ExistingObjectName In ListOfExistingObjectNames.ListOfObjects Do
		If (Lower(LogicalURL) = Lower(ExistingObjectName)) Then
			Result = False;
			Break;
		EndIf;
	EndDo;
	Return Result;
EndFunction

&AtClient
Procedure ItemDocumentationLinkClick(Item)
	GotoURL(DocumentationLink);
EndProcedure

&AtClient
Procedure DocumentationHelp(Command)
	GotoURL(DocumentationLink);
EndProcedure

>>>>>>> f3f19a63ed53bdfa614d9191f48ffaf36859af97
