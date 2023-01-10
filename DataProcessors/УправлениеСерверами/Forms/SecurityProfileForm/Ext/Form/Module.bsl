<<<<<<< HEAD
﻿
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	Var ObjectFieldValues, ThisStandartProcessing; 
	ListOfExistingObjectNames = New Structure("ListOfObjects", Parameters.ListOfObjects);
	ObjectChange = Parameters.ObjectFieldValues <> Undefined;
	If Parameters.ObjectFieldValues <> Undefined Then
		ObjectFieldValues = Parameters.ObjectFieldValues;
		ProfileName = ObjectFieldValues.Name;
		ProfileDescription = ObjectFieldValues.Description;
		FullAccessToExternalModules = ObjectFieldValues.AllowExternalCodeExecutionInUnsafeMode;
		FullAccessToCryptographicFunctions = ObjectFieldValues.CryptoAvailable;
		AvailableForExpansionModules = ObjectFieldValues.ModulesAvailableForExtension;
		UnavailableForExtensionModules = ObjectFieldValues.ModulesNotAvailableForExtension;
		FullAccessToCOMObjects = ObjectFieldValues.COMObjectFullAccess;
		FullAccessToExternalComponents = ObjectFieldValues.AddInFullAccess;
		FullAccessToExtendingAccess = ObjectFieldValues.AllowAccessRightsExtension;
		FullAccessToOnlineResources = ObjectFieldValues.InternetResourcesFullAccess;
		FullAccessToApplicationsOfOperatingSystem = ObjectFieldValues.ExternalApplicationsFullAccess;
		FullAccessToServerFileSystem = ObjectFieldValues.FileSystemFullAccess;
		SafeModeProfile = ObjectFieldValues.SafeModeProfile;
		FullAccessToPrivilegedMode = ObjectFieldValues.PrivilegedModeAllowed;
		RolesLimitingExpansionRights = ObjectFieldValues.AccessRightsExtensionLimitingRoles;
		FullAccessToExpandAllModules = ObjectFieldValues.ExternalModuleFullAccess;
		PrivilegedModeRoles = ObjectFieldValues.PrivilegedModeRoles;
		Items.ItemProfileName.Enabled = False;
	EndIf;
	ThisStandartProcessing = FormAttributeToValue("object");
	DocumentationLink = ThisStandartProcessing.GetLinkDocumentation("security profile");
	If IsBlankString(DocumentationLink) Then
		Items.ItemDocumentationLink.Visible = False;
	EndIf;
EndProcedure

&AtClient
Procedure WriteProfileAndCloseForm(Command)
	If CheckFilling() Then
		If IsProfileNameUnique() Then
			ProfileSettings = New Structure();
			ProfileSettings.Insert("Name", ProfileName);
			ProfileSettings.Insert("Description", ProfileDescription);
			ProfileSettings.Insert("AllowExternalCodeExecutionInUnsafeMode", FullAccessToExternalModules);
			ProfileSettings.Insert("CryptoAvailable", FullAccessToCryptographicFunctions);
			ProfileSettings.Insert("ModulesAvailableForExtension", AvailableForExpansionModules);
			ProfileSettings.Insert("ModulesNotAvailableForExtension", UnavailableForExtensionModules);
			ProfileSettings.Insert("COMObjectFullAccess", FullAccessToCOMObjects);
			ProfileSettings.Insert("AddInFullAccess", FullAccessToExternalComponents);
			ProfileSettings.Insert("AllowAccessRightsExtension", FullAccessToExtendingAccess);
			ProfileSettings.Insert("InternetResourcesFullAccess", FullAccessToOnlineResources);
			ProfileSettings.Insert("ExternalApplicationsFullAccess", FullAccessToApplicationsOfOperatingSystem);
			ProfileSettings.Insert("FileSystemFullAccess", FullAccessToServerFileSystem);
			ProfileSettings.Insert("SafeModeProfile", SafeModeProfile);
			ProfileSettings.Insert("PrivilegedModeAllowed", FullAccessToPrivilegedMode);
			ProfileSettings.Insert("AccessRightsExtensionLimitingRoles", RolesLimitingExpansionRights);
			ProfileSettings.Insert("ExternalModuleFullAccess", FullAccessToExpandAllModules);
			ProfileSettings.Insert("ObjectСhange", ObjectChange);
			ProfileSettings.Insert("PrivilegedModeRoles", PrivilegedModeRoles);			
			ThisForm.Close(ProfileSettings);
		Else
			Message(Nstr("ru = 'Профиль безопасности с таким именем уже существует.
					|Введите уникальное имя профиля или перейдите к изменению существующего профиля.';SYS='ProfileName.AlreadyExists'", "ru"));
		EndIf;
	EndIf;	
EndProcedure

&AtClient
Function IsProfileNameUnique()
	Var Result;
	Result = True;
	For each ExistingObjectName In ListOfExistingObjectNames.ListOfObjects Do
		If (Lower(ProfileName) = Lower(ExistingObjectName)) Then
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
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	Var ObjectFieldValues, ThisStandartProcessing; 
	ListOfExistingObjectNames = New Structure("ListOfObjects", Parameters.ListOfObjects);
	ObjectChange = Parameters.ObjectFieldValues <> Undefined;
	If Parameters.ObjectFieldValues <> Undefined Then
		ObjectFieldValues = Parameters.ObjectFieldValues;
		ProfileName = ObjectFieldValues.Name;
		ProfileDescription = ObjectFieldValues.Description;
		FullAccessToExternalModules = ObjectFieldValues.AllowExternalCodeExecutionInUnsafeMode;
		FullAccessToCryptographicFunctions = ObjectFieldValues.CryptoAvailable;
		AvailableForExpansionModules = ObjectFieldValues.ModulesAvailableForExtension;
		UnavailableForExtensionModules = ObjectFieldValues.ModulesNotAvailableForExtension;
		FullAccessToCOMObjects = ObjectFieldValues.COMObjectFullAccess;
		FullAccessToExternalComponents = ObjectFieldValues.AddInFullAccess;
		FullAccessToExtendingAccess = ObjectFieldValues.AllowAccessRightsExtension;
		FullAccessToOnlineResources = ObjectFieldValues.InternetResourcesFullAccess;
		FullAccessToApplicationsOfOperatingSystem = ObjectFieldValues.ExternalApplicationsFullAccess;
		FullAccessToServerFileSystem = ObjectFieldValues.FileSystemFullAccess;
		SafeModeProfile = ObjectFieldValues.SafeModeProfile;
		FullAccessToPrivilegedMode = ObjectFieldValues.PrivilegedModeAllowed;
		RolesLimitingExpansionRights = ObjectFieldValues.AccessRightsExtensionLimitingRoles;
		FullAccessToExpandAllModules = ObjectFieldValues.ExternalModuleFullAccess;
		PrivilegedModeRoles = ObjectFieldValues.PrivilegedModeRoles;
		Items.ItemProfileName.Enabled = False;
	EndIf;
	ThisStandartProcessing = FormAttributeToValue("object");
	DocumentationLink = ThisStandartProcessing.GetLinkDocumentation("security profile");
	If IsBlankString(DocumentationLink) Then
		Items.ItemDocumentationLink.Visible = False;
	EndIf;
EndProcedure

&AtClient
Procedure WriteProfileAndCloseForm(Command)
	If CheckFilling() Then
		If IsProfileNameUnique() Then
			ProfileSettings = New Structure();
			ProfileSettings.Insert("Name", ProfileName);
			ProfileSettings.Insert("Description", ProfileDescription);
			ProfileSettings.Insert("AllowExternalCodeExecutionInUnsafeMode", FullAccessToExternalModules);
			ProfileSettings.Insert("CryptoAvailable", FullAccessToCryptographicFunctions);
			ProfileSettings.Insert("ModulesAvailableForExtension", AvailableForExpansionModules);
			ProfileSettings.Insert("ModulesNotAvailableForExtension", UnavailableForExtensionModules);
			ProfileSettings.Insert("COMObjectFullAccess", FullAccessToCOMObjects);
			ProfileSettings.Insert("AddInFullAccess", FullAccessToExternalComponents);
			ProfileSettings.Insert("AllowAccessRightsExtension", FullAccessToExtendingAccess);
			ProfileSettings.Insert("InternetResourcesFullAccess", FullAccessToOnlineResources);
			ProfileSettings.Insert("ExternalApplicationsFullAccess", FullAccessToApplicationsOfOperatingSystem);
			ProfileSettings.Insert("FileSystemFullAccess", FullAccessToServerFileSystem);
			ProfileSettings.Insert("SafeModeProfile", SafeModeProfile);
			ProfileSettings.Insert("PrivilegedModeAllowed", FullAccessToPrivilegedMode);
			ProfileSettings.Insert("AccessRightsExtensionLimitingRoles", RolesLimitingExpansionRights);
			ProfileSettings.Insert("ExternalModuleFullAccess", FullAccessToExpandAllModules);
			ProfileSettings.Insert("ObjectСhange", ObjectChange);
			ProfileSettings.Insert("PrivilegedModeRoles", PrivilegedModeRoles);			
			ThisForm.Close(ProfileSettings);
		Else
			Message(Nstr("ru = 'Профиль безопасности с таким именем уже существует.
					|Введите уникальное имя профиля или перейдите к изменению существующего профиля.';SYS='ProfileName.AlreadyExists'", "ru"));
		EndIf;
	EndIf;	
EndProcedure

&AtClient
Function IsProfileNameUnique()
	Var Result;
	Result = True;
	For each ExistingObjectName In ListOfExistingObjectNames.ListOfObjects Do
		If (Lower(ProfileName) = Lower(ExistingObjectName)) Then
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
