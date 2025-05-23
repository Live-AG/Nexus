﻿

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьТаблицуКонтекстаВыполнения();	
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуКонтекстаВыполнения()

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
					|	КонтекстВыполненияСкрипта.Ссылка КАК КонтекстВыполнения
					|ИЗ
					|	ПланВидовХарактеристик.КонтекстВыполненияСкрипта КАК КонтекстВыполненияСкрипта";
	
	Результат = Запрос.Выполнить();  
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		НайденныеСтроки = Объект.КонтекстВыполнения.НайтиСтроки(Новый Структура("ЭлементКонтекста", Выборка.КонтекстВыполнения));
		Если НайденныеСтроки.Количество() = 0 Тогда
			НоваяСтрока = Объект.КонтекстВыполнения.Добавить();	
			НоваяСтрока.ЭлементКонтекста = Выборка.КонтекстВыполнения;
		КонецЕсли;
	КонецЦикла;	

КонецПроцедуры // ЗаполнитьТаблицуКонтекстаВыполнения()
  
&НаКлиенте
Процедура ПрочитатьПараметры(Команда)
	
	ТекстСкрипта = Объект.ТекстСкрипта;
	
	Объект.Переменные.Очистить();
	
	КоличествоВхождений = СтрЧислоВхождений(Объект.ТекстСкрипта, "%");
	НачалоПараметра = Истина;
	ПозицияПредыдущегоСимвола = 0; 
	
	Для СчетчикВхождений = 1 По КоличествоВхождений Цикл
		
		ПозицияТекущегоСимвола = СтрНайти(ТекстСкрипта, "%", , ПозицияПредыдущегоСимвола + 1);
		
		Если Не НачалоПараметра Тогда
			Параметр = Сред(ТекстСкрипта, ПозицияПредыдущегоСимвола + 1, ПозицияТекущегоСимвола - (ПозицияПредыдущегоСимвола + 1));
			НоваяСтрокаПараметров = Объект.Переменные.Добавить();
			НоваяСтрокаПараметров.Параметр = Параметр;	
		КонецЕсли;	
		
		ПозицияПредыдущегоСимвола = ПозицияТекущегоСимвола;
		
		НачалоПараметра = Не НачалоПараметра;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьСкрипт(Команда)
	
	Если Объект.МестоИсполнения = ПредопределенноеЗначение("Перечисление.МестаИсполненияСкрипта.НаКлиенте") Тогда
		Результат = ВыполнитьСкриптНаКлиенте();
	Иначе
		Результат = ВыполнитьСкриптНаСервере();
	КонецЕсли;
	
	Если Результат = Неопределено Тогда
		ПоказатьПредупреждение(, "Скрипт не выполнен!"); 
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура("РезультатПроверки", Результат.ПотокВывода + "
					| -------------------------------------------------------------------
					|" + Результат.ПотокОшибок);
	ОткрытьФорму("Справочник.Скрипты.Форма.ФормаРезультатаПроверки", ПараметрыФормы, , , , , , РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Функция ВыполнитьСкриптНаКлиенте()
	
	ПараметрыЗапускаПрограммы = ФайловаяСистемаКлиент.ПараметрыЗапускаПрограммы(); 
	ПараметрыЗапускаПрограммы.ПолучитьПотокВывода = Истина;
	ПараметрыЗапускаПрограммы.ДождатьсяЗавершения = Истина;
	
	Возврат ФайловаяСистемаКлиент.ЗапуститьПрограмму(Объект.ТекстСкрипта, ПараметрыЗапускаПрограммы);

КонецФункции    

&НаСервере
Функция ВыполнитьСкриптНаСервере()
	
	ПараметрыЗапускаПрограммы = ФайловаяСистема.ПараметрыЗапускаПрограммы(); 
	ПараметрыЗапускаПрограммы.ПолучитьПотокВывода = Истина;
	ПараметрыЗапускаПрограммы.ПолучитьПотокОшибок = Истина;
	ПараметрыЗапускаПрограммы.ДождатьсяЗавершения = Истина;
	
	Возврат ФайловаяСистема.ЗапуститьПрограмму(Объект.ТекстСкрипта, ПараметрыЗапускаПрограммы);  
	
КонецФункции // ВыполнитьСкриптНаСервере()

