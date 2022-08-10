

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Кластеры1С.Наименование КАК Наименование,
	               |	Кластеры1С.ИдентификаторКластера КАК ИдентификаторКластера
	               |ИЗ
	               |	Справочник.Кластеры1С КАК Кластеры1С
	               |ГДЕ
	               |	Кластеры1С.ПометкаУдаления";
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		СписокСуществующихКластеров.Добавить(Выборка.ИдентификаторКластера, Выборка.Наименование);
	КонецЦикла;
	
	СтрукутараПараметров = Константы.ОбщиеПараметрыАутентификации.ПолучитьСтруктуруНастроекПоУмолчанию();
	ЗаполнитьЗначенияСвойств(ЭтаФорма, СтрукутараПараметров, "ПользовательСервераАдминистрирования, ПарольСервераАдминистрирования"); 
	
	Элементы.ПанельВыбораКластера.Видимость = Ложь;
	Элементы.РазделПараметровКластера.Видимость = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)    
	
	Если ПортСервераАдминистрирования = 0 Тогда 
		ПортСервераАдминистрирования = 1545;
	КонецЕсли;  
	
КонецПроцедуры


//// выполняем подключение к сервису администрирования
&НаКлиенте
Функция ПодключитьсяКАгенту()     
	
	Если ПроверитьЗаполнение() Тогда  
		
		Если IsCentralServerNameUnique() Тогда
			Если IsAvaliableAdministrationServer()  Тогда
				ConnectionSettings = Новый Структура();
				ConnectionSettings.Insert("Name", ConnectionName);
				ConnectionSettings.Insert("AdministrationServerAgent", АдресСервераАдминистрирования);
				ConnectionSettings.Insert("AdministrationServerPort", ПортСервераАдминистрирования);
				ConnectionSettings.Insert("Login", ПользовательСервераАдминистрирования);
				ConnectionSettings.Insert("Password", ПарольСервераАдминистрирования);
				ConnectionSettings.Insert("Line", TreeLine);
				Close(ConnectionSettings);
			КонецЕсли;
		Else
			Сообщить(Nstr("ru = 'Подключение к серверу администрирования с таким именем уже существует. 
				|Введите уникальное имя или перейдите к изменению существующего подключения.';SYS='CentralServerName.AlreadyExists'", "ru"));
		КонецЕсли;
		
	КонецЕсли; 
	
КонецФункции

//// Проверяем доступность сервиса администрирования по указанному адресу
//&AtServer
//Function IsAvaliableAdministrationServer()
//	// создаем тестовый объект для проверки возможности подключения
//	AdministrationAgent = New ServerAdministration(АдресСервераАдминистрирования, ПортСервераАдминистрирования);
//	Try
//		AdministrationAgent.Authenticate(ПользовательСервераАдминистрирования, ПарольСервераАдминистрирования);
//	Except
//		Message(NStr("ru = 'Неверное имя или пароль администратора центрального сервера';SYS='CreateCentralServer.WrongAdminPassword'", "ru"));
//		Return False;	
//	EndTry;
//	Return True;
//EndFunction

//&AtClient
//Function IsCentralServerNameUnique()
//	Var Result, ExistingObjectName;
//	Result = True;
//	If СписокСуществующихКластеров.ListOfObjects <> Undefined Then
//		For each ExistingObjectName In СписокСуществующихКластеров.ListOfObjects Do
//			If (Lower(ConnectionName) = Lower(ExistingObjectName)) Then
//				Result = False;
//				Break;
//			EndIf;
//		EndDo;
//	EndIf;
//	Return Result;
//EndFunction

//&AtServer
//Procedure уOnCreateAtServer(Cancel, StandardProcessing) 
//	
//	
//	
//	If Parameters.ObjectChange = True Then
//		ConnectionName = Parameters.AgentConnectionName;
//		АдресСервераАдминистрирования = Parameters.AdministrationServerAgent;
//		ПортСервераАдминистрирования = Parameters.AdministrationServerPort;
//		ПользовательСервераАдминистрирования = Parameters.Login;
//		ПарольСервераАдминистрирования = Parameters.Password;
//		TreeLine = Parameters.Line;
//		Items.ItemConnectionName.Enabled = False;
//	EndIf;
//	СписокСуществующихКластеров = New Structure("ListOfObjects", Parameters.ListOfObjects);  
//	
//	
//EndProcedure




&AtClient
Procedure DocumentationHelp(Command)
	// Вставить содержимое обработчика.
EndProcedure


&НаКлиенте
Процедура ПодключитьсяКАгенту(Команда)
	
	МассивКластеров = ПолучитьПараметрыКластера();
	
	Если ПараметрыКластеров > 1 Тогда
		Для Каждого Кластер Из МассивКластеров Цикл
			Элементы.СписокКластеров.СписокВыбора.Очистить();
			Элементы.СписокКластеров.СписокВыбора.Добавить(
		
		
		Элементы.РазделПодключенияАгента.ТолькоПросмотр = Истина; //????
		Элементы.ПанельВыбораКластера.Видимость = Истина;  
	Иначе
		Элементы.ПанельВыбораКластера.ТолькоПросмотр = Истина;
		Элементы.РазделПараметровКластера.Видимость = Истина;
	
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура ВыбратьКластер(Команда)
	
	Элементы.ПанельВыбораКластера.ТолькоПросмотр = Истина;
	Элементы.РазделПараметровКластера.Видимость = Истина;
	
	
КонецПроцедуры


&НаКлиенте
Процедура ПодключитьсяККластеру(Команда)
	// Вставить содержимое обработчика.
КонецПроцедуры

