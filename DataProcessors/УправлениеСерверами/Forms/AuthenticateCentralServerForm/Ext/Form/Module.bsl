// При открытии
&AtClient
Procedure OnOpen(Cancel)
	If ServerAdministrationAddress = "" Then
		ServerAdministrationAddress = "localhost";
	EndIf;
	If ServerAdministrationPort = 0 Then 
		ServerAdministrationPort = 1545;
	EndIf;
#If Not WebClient Then
	if (IsBlankString(ConnectionName)) Then	
		ConnectionName = ComputerName();
	EndIf;
#EndIf
EndProcedure

// выполняем подключение к сервису администрирования
&AtClient
Procedure AddNewConnectionAndClose(Command)
	If CheckFilling() Then
		If IsCentralServerNameUnique() Then
			If IsAvaliableAdministrationServer()  Then
				ConnectionSettings = New Structure();
				ConnectionSettings.Insert("Name", ConnectionName);
				ConnectionSettings.Insert("AdministrationServerAgent", ServerAdministrationAddress);
				ConnectionSettings.Insert("AdministrationServerPort", ServerAdministrationPort);
				ConnectionSettings.Insert("Login", CentralServerUser);
				ConnectionSettings.Insert("Password", CentralServerUserPassword);
				ConnectionSettings.Insert("Line", TreeLine);
				Close(ConnectionSettings);
			EndIf;
		Else
			Message(Nstr("ru = 'Подключение к серверу администрирования с таким именем уже существует. 
				|Введите уникальное имя или перейдите к изменению существующего подключения.';SYS='CentralServerName.AlreadyExists'", "ru"));
		EndIf;
	EndIf;
EndProcedure

// Проверяем доступность сервиса администрирования по указанному адресу
&AtServer
Function IsAvaliableAdministrationServer()
	// создаем тестовый объект для проверки возможности подключения
	AdministrationAgent = New ServerAdministration(ServerAdministrationAddress, ServerAdministrationPort);
	Try
		AdministrationAgent.Authenticate(CentralServerUser, CentralServerUserPassword);
	Except
		Message(NStr("ru = 'Неверное имя или пароль администратора центрального сервера';SYS='CreateCentralServer.WrongAdminPassword'", "ru"));
		Return False;	
	EndTry;
	Return True;
EndFunction

&AtClient
Function IsCentralServerNameUnique()
	Var Result, ExistingObjectName;
	Result = True;
	If ListOfExistingObjectName.ListOfObjects <> Undefined Then
		For each ExistingObjectName In ListOfExistingObjectName.ListOfObjects Do
			If (Lower(ConnectionName) = Lower(ExistingObjectName)) Then
				Result = False;
				Break;
			EndIf;
		EndDo;
	EndIf;
	Return Result;
EndFunction

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	If Parameters.ObjectChange = True Then
		ConnectionName = Parameters.AgentConnectionName;
		ServerAdministrationAddress = Parameters.AdministrationServerAgent;
		ServerAdministrationPort = Parameters.AdministrationServerPort;
		CentralServerUser = Parameters.Login;
		CentralServerUserPassword = Parameters.Password;
		TreeLine = Parameters.Line;
		Items.ItemConnectionName.Enabled = False;
	EndIf;
	ListOfExistingObjectName = New Structure("ListOfObjects", Parameters.ListOfObjects);
EndProcedure

&AtClient
Procedure DocumentationHelp(Command)
	// Вставить содержимое обработчика.
EndProcedure
