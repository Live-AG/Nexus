
&AtClient
Procedure SaveSettingToFile(Command)
	Var ClosingOptions;
	If CheckFilling() Then
		ClosingOptions = New Structure();
		ClosingOptions.Insert("SaveCentralServerList", SaveCentralServerList);
		ClosingOptions.Insert("SaveClusterInfobaseAdministratorPasswords", SaveClusterInfobaseAdministratorPasswords);
		ClosingOptions.Insert("SaveServerAdministratorPasswords", SaveServerAdministratorPasswords);
		ClosingOptions.Insert("FileSettingsPath", FileSettingPath);
		Close(ClosingOptions);
	EndIf;
EndProcedure

&AtClient
Procedure CloseSaveSettingsForm(Command)
	Close();
EndProcedure

&AtClient
Procedure FileSelectionNotify(SelectedFiles, UploadOptions) Export
	If Not ValueIsFilled(SelectedFiles) Then
		Return;
	EndIf;
	FileSettingPath = SelectedFiles[0];
EndProcedure

&AtClient
Procedure ItemFileSettingPathStartChoice(Item, SelectionData, StandardProcessing)
	Var FileOpenType, NotifyDescription;
	StandardProcessing = False;
	FileOpenType = FileDialogMode.Save;
	FileOpenDialog = New FileDialog(FileOpenType);
	FileOpenDialog.Directory = FileSettingPath;
	If IsBlankString(FileSettingPath) Then
		FileOpenDialog.FullFileName = "srvadmsettings";
	Else
		FileOpenDialog.FullFileName = FileSettingPath;
	EndIf;
	Filter = NStr("ru = 'Текст';SYS='SaveSettings.FileSettingsFilter'", "ru") + "(*.xml)|*.xml";
	FileOpenDialog.Filter = Filter;
	FileOpenDialog.Multiselect = False;
	FileOpenDialog.Title = Nstr("'Выберете файл для сохранения настроек';SYS='SaveSettings.FileSettingsTitle'", "ru");
	NotifyDescription = New NotifyDescription("FileSelectionNotify", ThisForm);
	FileOpenDialog.Show(NotifyDescription);
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	
EndProcedure

&AtClient
Procedure DocumentationHelp(Command)
	// Вставить содержимое обработчика.
EndProcedure
