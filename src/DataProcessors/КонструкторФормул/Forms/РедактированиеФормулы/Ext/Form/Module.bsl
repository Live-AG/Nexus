﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	ДляЗапроса = Параметры.ДляЗапроса;
	
	ПараметрыДобавленияСпискаПолей = КонструкторФормулСлужебный.ПараметрыДобавленияСпискаПолей();
	ПараметрыДобавленияСпискаПолей.ИмяСписка = ИмяСпискаОперандов();
	ПараметрыДобавленияСпискаПолей.КоллекцииПолей.Добавить(ПрочитатьСписокОперандов());
	ПараметрыДобавленияСпискаПолей.МестоРазмещенияСписка = Элементы.ГруппаДоступныеПоля;
	ПараметрыДобавленияСпискаПолей.ПодсказкаВводаСтрокиПоиска = НСтр("ru = 'Найти операнд...'");
	ПараметрыДобавленияСпискаПолей.ИспользоватьИдентификаторыДляФормул = Не ДляЗапроса;
	ПараметрыДобавленияСпискаПолей.ОбработчикиСписка.Вставить("Выбор", "Подключаемый_СписокПолейВыбор");
	КонструкторФормулСлужебный.ДобавитьСписокПолейНаФорму(ЭтотОбъект, ПараметрыДобавленияСпискаПолей);
	
	ПараметрыДобавленияСпискаПолей = КонструкторФормулСлужебный.ПараметрыДобавленияСпискаПолей();
	ПараметрыДобавленияСпискаПолей.ИмяСписка = ИмяСпискаОператоров();
	ПараметрыДобавленияСпискаПолей.КоллекцииПолей.Добавить(СписокОператоров());
	ПараметрыДобавленияСпискаПолей.МестоРазмещенияСписка = Элементы.ГруппаОператорыИФункции;
	ПараметрыДобавленияСпискаПолей.ПодсказкаВводаСтрокиПоиска = НСтр("ru = 'Найти оператор или функцию...'");
	ПараметрыДобавленияСпискаПолей.СкобкиПредставлений = Ложь;
	ПараметрыДобавленияСпискаПолей.ОбработчикиСписка.Вставить("Выбор", "Подключаемый_СписокПолейВыбор");
	ПараметрыДобавленияСпискаПолей.ОбработчикиСписка.Вставить("НачалоПеретаскивания", "Подключаемый_ОператорыНачалоПеретаскивания");
	ПараметрыДобавленияСпискаПолей.ОбработчикиСписка.Вставить("ОкончаниеПеретаскивания", "Подключаемый_ОператорыОкончаниеПеретаскивания");
	КонструкторФормулСлужебный.ДобавитьСписокПолейНаФорму(ЭтотОбъект, ПараметрыДобавленияСпискаПолей);
	
	ПредставлениеФормулы = КонструкторФормулСлужебный.ПредставлениеФормулы(ЭтотОбъект, Параметры.Формула);
	
	Элементы.Наименование.Видимость = Параметры.Наименование <> Неопределено;
	Наименование = Параметры.Наименование;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПодтвердитьИЗакрыть", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(ОписаниеОповещения, Отказ, ЗавершениеРаботы);
	
	Если Модифицированность Или ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗавершитьРедактирование(Команда)
	
	ПодключитьОбработчикОжидания("ЗакрытьФорму", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьФормулу(Команда)
	
	ВыполнитьПроверку();
	ПоказатьПредупреждение(, НСтр("ru = 'Проверка выполнена успешно.'"));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПодтвердитьИЗакрыть(Результат = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	ЗакрытьФорму();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФорму()

	ВыполнитьПроверку();
	Модифицированность = Ложь;
	Закрыть(ОписаниеФормулы());
	
КонецПроцедуры

&НаСервере
Функция ПрочитатьСписокОперандов()
	
	СписокОперандов = Параметры.Операнды;
	Если ЭтоАдресВременногоХранилища(СписокОперандов) Тогда
		СписокОперандов = ПолучитьИзВременногоХранилища(СписокОперандов);
	КонецЕсли;
	
	Если СписокОперандов = Неопределено Тогда
		СписокОперандов = КонструкторФормулСлужебный.ТаблицаПолей();
	КонецЕсли;
	
	КомпоновщикНастроек = КонструкторФормулСлужебный.КомпоновщикНастроекИсточникаПолей(СписокОперандов);
	
	Возврат КонструкторФормулСлужебный.КоллекцияПолей(СписокОперандов, , Параметры.ИмяКоллекцииСКДОперандов);
	
КонецФункции

&НаКлиенте
Функция ОписаниеФормулы()
	
	ОписаниеФормулы = Новый Структура;
	ОписаниеФормулы.Вставить("Формула", ФормулаИзПредставления());
	ОписаниеФормулы.Вставить("ПредставлениеФормулы", ПредставлениеФормулы);
	Если Элементы.Наименование.Видимость Тогда
		ОписаниеФормулы.Вставить("Наименование", Наименование);
	КонецЕсли;
	
	Возврат ОписаниеФормулы;
	
КонецФункции

&НаСервере
Функция ФормулаИзПредставления()
	
	Возврат КонструкторФормулСлужебный.ФормулаИзПредставления(ЭтотОбъект, ПредставлениеФормулы);
	
КонецФункции

#Область ПодключаемыйСписокПолей

&НаКлиенте
Процедура Подключаемый_СписокПолейПередРазворачиванием(Элемент, Строка, Отказ)
	
	КонструкторФормулКлиент.СписокПолейПередРазворачиванием(ЭтотОбъект, Элемент, Строка, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РазвернутьТекущийЭлементСпискаПолей()
	
	КонструкторФормулКлиент.РазвернутьТекущийЭлементСпискаПолей(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ЗаполнитьСписокДоступныхПолей(ПараметрыЗаполнения) Экспорт // АПК:78 - вызывается из КонструкторФормулКлиент
	
	ЗаполнитьСписокДоступныхПолей(ПараметрыЗаполнения);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокДоступныхПолей(ПараметрыЗаполнения)
	
	КонструкторФормулСлужебный.ЗаполнитьСписокДоступныхПолей(ЭтотОбъект, ПараметрыЗаполнения);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_СписокПолейНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, Выполнение)
	
	КонструкторФормулКлиент.СписокПолейНачалоПеретаскивания(ЭтотОбъект, Элемент, ПараметрыПеретаскивания, Выполнение);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_СтрокаПоискаИзменениеТекстаРедактирования(Элемент, Текст, СтандартнаяОбработка)
	
	КонструкторФормулКлиент.СтрокаПоискаИзменениеТекстаРедактирования(ЭтотОбъект, Элемент, Текст, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПоискВСпискеПолей()
	
	ВыполнитьПоискВСпискеПолей();
	
КонецПроцедуры

&НаСервере
Процедура ВыполнитьПоискВСпискеПолей()
	
	КонструкторФормулСлужебный.ВыполнитьПоискВСпискеПолей(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_СтрокаПоискаОчистка(Элемент, СтандартнаяОбработка)
	
	КонструкторФормулКлиент.СтрокаПоискаОчистка(ЭтотОбъект, Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ДополнительныеОбработчикиПодключаемыхСписков

// Параметры:
//  Элемент - ТаблицаФормы
//
&НаКлиенте
Процедура Подключаемый_СписокПолейВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВыбранноеПоле = КонструкторФормулКлиент.ВыбранноеПолеВСпискеПолей(ЭтотОбъект);
	Если Элемент.Имя = ИмяСпискаОперандов() Тогда
		ПредставлениеФормулы = СокрП(ПредставлениеФормулы) + " [" + ВыбранноеПоле.ПредставлениеПутиКДанным + "]";
	Иначе
		ПредставлениеФормулы = СокрП(ПредставлениеФормулы) + " " + ВыражениеДляВставки(ВыбранноеПоле);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОператорыНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, Выполнение)
	
	Оператор = КонструкторФормулКлиент.ВыбранноеПолеВСпискеПолей(ЭтотОбъект, ИмяСпискаОператоров());
	ПараметрыПеретаскивания.Значение = ВыражениеДляВставки(Оператор);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОператорыОкончаниеПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	
	Если КонструкторФормулКлиент.ВыбранноеПолеВСпискеПолей(ЭтотОбъект, ИмяСпискаОператоров()).ПутьКДанным = "Формат" Тогда
		ФорматСтроки = Новый КонструкторФорматнойСтроки;
		ФорматСтроки.Показать(Новый ОписаниеОповещения("ОператорыОкончаниеПеретаскиванияЗавершение", ЭтотОбъект, Новый Структура("ФорматСтроки", ФорматСтроки)));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОператорыОкончаниеПеретаскиванияЗавершение(Текст, ДополнительныеПараметры) Экспорт
	
	ФорматСтроки = ДополнительныеПараметры.ФорматСтроки;
	
	Если ЗначениеЗаполнено(ФорматСтроки.Текст) Тогда
		ТекстДляВставки = "Формат( , """ + ФорматСтроки.Текст + """)";
		Элементы.ПредставлениеФормулы.ВыделенныйТекст = ТекстДляВставки;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

&НаКлиентеНаСервереБезКонтекста
Функция ИмяСпискаОперандов()
	
	Возврат "СписокОперандов";
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ИмяСпискаОператоров()
	
	Возврат "СписокОператоров";
	
КонецФункции

&НаСервере
Функция СписокОператоров()
	
	СписокОператоров = Параметры.Операторы;
	Если Не ЗначениеЗаполнено(СписокОператоров) Тогда
		СписокОператоров = КонструкторФормулСлужебный.СписокОператоров(?(ДляЗапроса, "ВсеОператорыСКД", Неопределено));
	КонецЕсли;
	
	Возврат КонструкторФормулСлужебный.КоллекцияПолей(СписокОператоров, , Параметры.ИмяКоллекцииСКДОператоров);
	
КонецФункции

&НаКлиенте
Функция ВыражениеДляВставки(Оператор)
	
	Результат = Оператор.Заголовок + "(";
	
	Если Не ЗначениеЗаполнено(Оператор.Родитель) Тогда
		Возврат "";
	КонецЕсли;
	
	Если Оператор.Родитель.Имя = "Разделители" Тогда
		Результат = "+ """ + Оператор.Заголовок + """ +";
		Если Оператор.Имя = "[ ]" Тогда
			Результат = "+ "" "" +";
		КонецЕсли;
	КонецЕсли;
	
	Если Оператор.Родитель.Имя = "ЛогическиеОператорыИКонстанты"
		Или Оператор.Родитель.Имя = "Операторы"
		Или Оператор.Родитель.Имя = "ОперацииНадСтроками"
		Или Оператор.Родитель.Имя = "ЛогическиеОперации"
		Или Оператор.Родитель.Имя = "ОперацииСравнения" И Оператор.Имя <> "В" Тогда
		Результат = Оператор.Заголовок;
	КонецЕсли;
	
	Если Оператор.Родитель.Имя = "ПрочиеФункции" Тогда
		Если Оператор.Имя = "[?]" Или Оператор.Имя = "Формат" Тогда
			Результат = Оператор.Заголовок + "(,,)";
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ВыражениеДляПроверки()
	
	Возврат КонструкторФормулСлужебный.ВыражениеДляПроверки(ЭтотОбъект, ПредставлениеФормулы, ИмяСпискаОперандов());
	
КонецФункции

&НаСервере
Процедура ПроверитьВыражениеДляЗапроса()
	
	Выражение = КонструкторФормулСлужебный.ФормулаИзПредставления(ЭтотОбъект, ПредставлениеФормулы);
	Поле = КомпоновщикНастроек.Настройки.ПользовательскиеПоля.Элементы.Добавить(Тип("ПользовательскоеПолеВыражениеКомпоновкиДанных"));
	
	Попытка
		Поле.УстановитьВыражениеДетальныхЗаписей(Выражение);
	Исключение
		ВызватьИсключение КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПроверку()
	
	Если ДляЗапроса Тогда
		Попытка
			ПроверитьВыражениеДляЗапроса();
		Исключение
			ТекстОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
			ВызватьИсключение ТекстСообщенияОбОшибкеПриПроверкеФормулы(ТекстОшибки);
		КонецПопытки;
	Иначе
		Выражение = ВыражениеДляПроверки();
		Попытка
			Результат = Вычислить(Выражение);
		Исключение
			ТекстОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
			ВызватьИсключение ТекстСообщенияОбОшибкеПриПроверкеФормулы(ТекстОшибки);
		КонецПопытки;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ТекстСообщенияОбОшибкеПриПроверкеФормулы(ТекстОшибки)
	
	ШаблонСообщения = НСтр("ru = 'Введенная формула некорректная:
	|%1'");
	
	ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		ШаблонСообщения, ТекстОшибки);
		
	Возврат ТекстСообщения;
	
КонецФункции
	
	
#КонецОбласти
