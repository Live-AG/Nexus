﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОписаниеПеременных

// СтандартныеПодсистемы

// Хранилище глобальных переменных.
//
// ПараметрыПриложения - Соответствие - хранилище переменных, где:
//   * Ключ - Строка - имя переменной в формате "ИмяБиблиотеки.ИмяПеременной";
//   * Значение - Произвольный - значение переменной.
//
// Инициализация (на примере СообщенияДляЖурналаРегистрации):
//   ИмяПараметра = "СтандартныеПодсистемы.СообщенияДляЖурналаРегистрации";
//   Если ПараметрыПриложения[ИмяПараметра] = Неопределено Тогда
//     ПараметрыПриложения.Вставить(ИмяПараметра, Новый СписокЗначений);
//   КонецЕсли;
//  
// Использование (на примере СообщенияДляЖурналаРегистрации):
//   ПараметрыПриложения["СтандартныеПодсистемы.СообщенияДляЖурналаРегистрации"].Добавить(...);
//   ПараметрыПриложения["СтандартныеПодсистемы.СообщенияДляЖурналаРегистрации"] = ...;
Перем ПараметрыПриложения Экспорт;

// Конец СтандартныеПодсистемы

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПередНачаломРаботыСистемы()
	
	// СтандартныеПодсистемы
	СтандартныеПодсистемыКлиент.ПередНачаломРаботыСистемы();
	// Конец СтандартныеПодсистемы
	
КонецПроцедуры

Процедура ПриНачалеРаботыСистемы()
	
	// СтандартныеПодсистемы
	СтандартныеПодсистемыКлиент.ПриНачалеРаботыСистемы();
	// Конец СтандартныеПодсистемы
	
КонецПроцедуры

Процедура ПередЗавершениемРаботыСистемы(Отказ, ТекстПредупреждения)
	
	// СтандартныеПодсистемы
	СтандартныеПодсистемыКлиент.ПередЗавершениемРаботыСистемы(Отказ, ТекстПредупреждения);
	// Конец СтандартныеПодсистемы
	
КонецПроцедуры

Процедура ОбработкаПолученияФормыВыбораПользователейСистемыВзаимодействия(НазначениеВыбора, Форма, ИдентификаторОбсуждения, Параметры, ВыбраннаяФорма, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.Обсуждения
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Обсуждения") Тогда
	
		МодульОбсужденияСлужебныйКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОбсужденияСлужебныйКлиент");
		МодульОбсужденияСлужебныйКлиент.ПриПолученииФормыВыбораПользователейСистемыВзаимодействия(НазначениеВыбора, Форма, ИдентификаторОбсуждения, Параметры, ВыбраннаяФорма, СтандартнаяОбработка);
	
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Обсуждения
		
КонецПроцедуры

#КонецОбласти