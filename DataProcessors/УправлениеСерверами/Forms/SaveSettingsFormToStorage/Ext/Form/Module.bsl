
&AtClient
Procedure SaveSettingToFile(Command)
	Var ClosingOptions;
	ClosingOptions = New Structure();
	ClosingOptions.Insert("SaveCentralServerList", SaveCentralServerList);
	ClosingOptions.Insert("SaveClusterInfobaseAdministratorPasswords", SaveClusterInfobaseAdministratorPasswords);
	ClosingOptions.Insert("SaveServerAdministratorPasswords", SaveServerAdministratorPasswords);;
	Close(ClosingOptions);
EndProcedure

&AtClient
Procedure CloseSaveSettingsForm(Command)
	Close();
EndProcedure

&AtServer
Procedure OnLoadDataFromSettingsAtServer(Settings)
	SaveCentralServerList = Settings.Get("SaveCentralServerList");
	SaveServerAdministratorPasswords = Settings.Get("SaveServerAdministratorPasswords");
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandartProcessing)
	SaveCentralServerList = True;
	SaveServerAdministratorPasswords = true;
EndProcedure

&AtClient
Procedure DocumentationHelp(Command)
	// Вставить содержимое обработчика.
EndProcedure
