﻿
&НаСервереБезКонтекста
Функция вСкопироватьСтруктуру(Источник)
	Струк = новый Структура;
	
	Для каждого Элем из Источник Цикл
		Струк.Вставить(Элем.Ключ, Элем.Значение);
	КонецЦикла;
	
	Возврат Струк;
КонецФункции

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	мОбъектСсылка = Параметры.мОбъектСсылка;
	ПутьКФормам = Параметры.ПутьКФормам;
	
	_ПолноеИмя = Параметры.ПолноеИмя;
	_ГдеНайдено = Параметры.ГдеНайдено;
	_ОграничениеНаСписокЗависимых = Параметры.ОграничениеНаСписокЗависимых;
	
	пСтрук = вСформироватьТекстЗапросаДляСпискаЗависимых(мОбъектСсылка, _ПолноеИмя, _ГдеНайдено, _ОграничениеНаСписокЗависимых);
	Если пСтрук = Неопределено Тогда
		Отказ = истина;
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("АдресаХранилищ") Тогда
		_АдресаХранилищ = вСкопироватьСтруктуру(Параметры.АдресаХранилищ);
	Иначе
		_АдресаХранилищ = новый Структура("ОбщиеРеквизиты");
		_АдресаХранилищ.ОбщиеРеквизиты = ПоместитьВоВременноеХранилище(-1, УникальныйИдентификатор);
	КонецЕсли;
	
	_КлючЗаписи = пСтрук.КлючЗаписи;
	_ТекстЗапроса = пСтрук.ТекстЗапроса;
	пТабРезультат = пСтрук.ТаблицаДанных;
	
	Заголовок = "Зависимые: " + Параметры.ПолноеИмя;
	
	Элементы._ДеревоОбъектов.Видимость = ложь;
	
	ТипUUID = Тип("УникальныйИдентификатор");
	
	МассивКСозданию = новый Массив;
	МассивКУдалению = новый Массив;
	
	Если ТипЗнч(пТабРезультат) = Тип("ТаблицаЗначений") Тогда
		Для каждого Колонка из пТабРезультат.Колонки Цикл
			Если Колонка.ТипЗначения.СодержитТип(ТипUUID) Тогда
				ТипЗначенияРеквизита = новый ОписаниеТипов;
			Иначе
				ТипЗначенияРеквизита = Колонка.ТипЗначения;
			КонецЕсли;
			МассивКСозданию.Добавить(новый РеквизитФормы(Колонка.Имя, ТипЗначенияРеквизита, "_СписокЗаписей", Колонка.Заголовок, ложь));
		КонецЦикла;
		
		ИзменитьРеквизиты(МассивКСозданию, МассивКУдалению);
		ЗначениеВРеквизитФормы(пТабРезультат, "_СписокЗаписей");
		_ЧислоЗаписей = пТабРезультат.Количество();
		
		Для каждого Колонка из пТабРезультат.Колонки Цикл
			Элем = ЭтаФорма.Элементы.Добавить("_СписокЗаписей_" + Колонка.Имя, Тип("ПолеФормы"), ЭтаФорма.Элементы._СписокЗаписей);
			Элем.ПутьКДанным="_СписокЗаписей."+Колонка.Имя;
			Элем.Вид=ВидПоляФормы.ПолеВвода;
			Элем.ДоступныеТипы=Колонка.ТипЗначения;
			Элем.КнопкаОткрытия = истина;
		КонецЦикла;
		
		Если _КлючЗаписи = Неопределено Тогда
			Элементы._СписокЗаписей_ОткрытьЗаписьРегистра.Видимость = ложь;
			Элементы._СписокЗаписейКонтекстноеМеню_ОткрытьЗаписьРегистра.Видимость = ложь;
		КонецЕсли;
	КонецЕсли;
	
	Если ТипЗнч(пТабРезультат) = Тип("ДеревоЗначений") Тогда
		Элементы._ДеревоОбъектов.Видимость = истина;
		ЗначениеВРеквизитФормы(пТабРезультат, "_ДеревоОбъектов");
		_ЧислоЗаписей = пТабРезультат.Строки.Количество();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура вОбновить()
	_ДеревоОбъектов.ПолучитьЭлементы().Очистить();
	_СписокЗаписей.Очистить();
	
	пСтрук = вСформироватьТекстЗапросаДляСпискаЗависимых(мОбъектСсылка, _ПолноеИмя, _ГдеНайдено, _ОграничениеНаСписокЗависимых, _ТекстЗапроса);
	Если пСтрук = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	_ТекстЗапроса = пСтрук.ТекстЗапроса;
	пТабРезультат = пСтрук.ТаблицаДанных;
	
	Если ТипЗнч(пТабРезультат) = Тип("ТаблицаЗначений") Тогда
		ЗначениеВРеквизитФормы(пТабРезультат, "_СписокЗаписей");
		_ЧислоЗаписей = пТабРезультат.Количество();
	ИначеЕсли ТипЗнч(пТабРезультат) = Тип("ДеревоЗначений") Тогда
		ЗначениеВРеквизитФормы(пТабРезультат, "_ДеревоОбъектов");
		_ЧислоЗаписей = пТабРезультат.Строки.Количество();
	КонецЕсли;
КонецПроцедуры



&НаСервереБезКонтекста
Функция вСформироватьТекстЗапросаДляСпискаЗависимых(Знач Ссылка, Знач пПолноеИмя, Знач пГдеНайдено, Знач пРазмерСписка, Знач пТекстЗапроса = "")
	Если СтрНайти(пПолноеИмя, "ПараметрСеанса") = 1 Тогда
		Возврат Неопределено;
	ИначеЕсли СтрНайти(пПолноеИмя, "ОпределяемыйТип") = 1 Тогда
		Возврат Неопределено;
	ИначеЕсли СтрНайти(пПолноеИмя, "Константа") = 1 Тогда
		Возврат Неопределено;
	ИначеЕсли СтрНайти(пПолноеИмя, "РегистрБухгалтерии") = 1 Тогда
		Возврат вСформироватьТекстЗапросаДляСпискаЗависимыхПоРегиструБухгалтерии(Ссылка, пПолноеИмя, пГдеНайдено, пРазмерСписка, пТекстЗапроса);
	ИначеЕсли СтрНайти(пПолноеИмя, "Регистр") = 1 Тогда
		пОбъектМД = Метаданные.НайтиПоПолномуИмени(пПолноеИмя);
		Если Метаданные.РегистрыСведений.Содержит(пОбъектМД) Тогда
			Если пОбъектМД.РежимЗаписи = Метаданные.СвойстваОбъектов.РежимЗаписиРегистра.Независимый Тогда
				Возврат вСформироватьТекстЗапросаДляСпискаЗависимыхПоНРС(Ссылка, пПолноеИмя, пГдеНайдено, пРазмерСписка, пТекстЗапроса);
			КонецЕсли;
		КонецЕсли;
		
		Возврат вСформироватьТекстЗапросаДляСпискаЗависимыхПоРегистру(Ссылка, пПолноеИмя, пГдеНайдено, пРазмерСписка, пТекстЗапроса);
	Иначе
		Возврат вСформироватьТекстЗапросаДляСпискаЗависимыхОбъектов(Ссылка, пПолноеИмя, пГдеНайдено, пРазмерСписка, пТекстЗапроса);
	КонецЕсли;
КонецФункции

&НаСервереБезКонтекста
Функция вСформироватьТекстЗапросаДляСпискаЗависимыхОбъектов(Знач Ссылка, Знач пПолноеИмя, Знач пГдеНайдено, Знач пРазмерСписка, Знач пТекстЗапроса = "")
	Если не ПустаяСтрока(пТекстЗапроса) Тогда
		Запрос = новый Запрос;
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		Запрос.Текст = пТекстЗапроса;
		Перейти ~ВыпонитьЗапрос;
	КонецЕсли;
	
	пЭтоПланОбмена = (СтрНайти(пПолноеИмя, "ПланОбмена.") = 1);
	
	пОграничениеНаРазмер = ?(пРазмерСписка = 0, "", " ПЕРВЫЕ " + Формат(пРазмерСписка, "ЧГ=0"));
	
	пМассивЗапросов = новый Массив;
	пМассивРеквизитов = СтрРазделить(пГдеНайдено, ",");
	
	пРазделитель = Символы.ПС + "ОБЪЕДИНИТЬ ВСЕ" + Символы.ПС;
	
	Для каждого пРеквизит из пМассивРеквизитов Цикл
		пМассив = СтрРазделить(пРеквизит, ".");
		пЭтоТабЧасть = (пМассив.Количество() = 4);
		
		Если пЭтоПланОбмена Тогда
			Если пМассив[1] = "Состав" Тогда
				Продолжить;
			КонецЕсли;
		Иначе
			Если пЭтоТабЧасть Тогда
				пПоле = пМассив[3];
				пИмяПоля = пМассив[1] + "." + пПоле;
				пИмяТаблицы = пПолноеИмя + "." + пМассив[1];
			Иначе
				пПоле = пМассив[2];
				пИмяПоля = пПоле;
				пИмяТаблицы = пПолноеИмя;
			КонецЕсли;
		КонецЕсли;
		
		пМассивЗапросов.Добавить(
			"ВЫБРАТЬ" + пОграничениеНаРазмер + "
			|	т.Ссылка,
			|	""" + пИмяПоля + """ КАК Поле
			|ИЗ
			|	" + пИмяТаблицы + " КАК т
			|ГДЕ
			|	т." + пПоле + " = &Ссылка"
		);
	КонецЦикла;
	
	Если пМассивЗапросов.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	пТекстЗапроса = СтрСоединить(пМассивЗапросов, пРазделитель);
	
	Если пМассивЗапросов.Количество() > 1 Тогда
		пТекстЗапроса =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	т.Ссылка КАК Ссылка,
		|	т.Поле КАК Поле
		|ИЗ (
		|" + пТекстЗапроса + "
		|) КАК т";
	КонецЕсли;
	
	Запрос = новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.Текст = пТекстЗапроса + "
	|ИТОГИ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Поле)
	|ПО
	|	Ссылка";
	;
	
	~ВыпонитьЗапрос:
	пТабРезультат = Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Возврат новый Структура("КлючЗаписи, ТаблицаДанных, ТекстЗапроса", Неопределено, пТабРезультат, Запрос.Текст);
КонецФункции

&НаСервереБезКонтекста
Функция вСформироватьТекстЗапросаДляСпискаЗависимыхПоНРС(Знач Ссылка, Знач пПолноеИмя, Знач пГдеНайдено, Знач пРазмерСписка, Знач пТекстЗапроса = "")
	Если не ПустаяСтрока(пТекстЗапроса) Тогда
		Запрос = новый Запрос;
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		Запрос.Текст = пТекстЗапроса;
		Перейти ~ВыпонитьЗапрос;
	КонецЕсли;
	
	пСтрукКлючЗаписи = новый Структура;
	пМассивИзмерений = новый Массив;
	
	пОбъектМД = Метаданные.НайтиПоПолномуИмени(пПолноеИмя);
	
	пЕстьПериод = (пОбъектМД.ПериодичностьРегистраСведений <> Метаданные.СвойстваОбъектов.ПериодичностьРегистраСведений.Непериодический);
	Если пЕстьПериод Тогда
		пМассивИзмерений.Добавить("т.Период");
		пСтрукКлючЗаписи.Вставить("Период");
	КонецЕсли;
	
	Для каждого Элем из пОбъектМД.Измерения Цикл
		пМассивИзмерений.Добавить("т." + Элем.Имя);
		пСтрукКлючЗаписи.Вставить(Элем.Имя);
	КонецЦикла;
	
	Если пМассивИзмерений.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	пОграничениеНаРазмер = ?(пРазмерСписка = 0, "", " ПЕРВЫЕ " + Формат(пРазмерСписка, "ЧГ=0"));
	
	пМассивЗапросов = новый Массив;
	пМассивРеквизитов = СтрРазделить(пГдеНайдено, ",");
	
	пРазделитель = Символы.ПС + "ОБЪЕДИНИТЬ ВСЕ" + Символы.ПС;
	
	Для каждого пРеквизит из пМассивРеквизитов Цикл
		пМассив = СтрРазделить(пРеквизит, ".");
		пПоле = пМассив[2];
		пМассивЗапросов.Добавить(
			"ВЫБРАТЬ РАЗЛИЧНЫЕ" + пОграничениеНаРазмер + "
			|	" + СтрСоединить(пМассивИзмерений, "," + Символы.ПС + Символы.Таб) + "
			|ИЗ
			|	" + пПолноеИмя + " КАК т
			|ГДЕ
			|	т." + пПоле + " = &Ссылка"
		);
	КонецЦикла;
	
	Если пМассивЗапросов.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	пТекстЗапроса = СтрСоединить(пМассивЗапросов, пРазделитель);
	
	Запрос = новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.Текст = пТекстЗапроса;
	
	~ВыпонитьЗапрос:
	пТабРезультат = Запрос.Выполнить().Выгрузить();
	
	Возврат новый Структура("КлючЗаписи, ТаблицаДанных, ТекстЗапроса", пСтрукКлючЗаписи, пТабРезультат, Запрос.Текст);
КонецФункции

&НаСервереБезКонтекста
Функция вСформироватьТекстЗапросаДляСпискаЗависимыхПоРегистру(Знач Ссылка, Знач пПолноеИмя, Знач пГдеНайдено, Знач пРазмерСписка, Знач пТекстЗапроса = "")
	Если не ПустаяСтрока(пТекстЗапроса) Тогда
		Запрос = новый Запрос;
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		Запрос.Текст = пТекстЗапроса;
		Перейти ~ВыпонитьЗапрос;
	КонецЕсли;
	
	пМассивИзмерений = новый Массив;
	
	пОбъектМД = Метаданные.НайтиПоПолномуИмени(пПолноеИмя);
	
	пЕстьПериод = не Метаданные.РегистрыРасчета.Содержит(пОбъектМД);
	Если Метаданные.РегистрыСведений.Содержит(пОбъектМД) и пОбъектМД.ПериодичностьРегистраСведений = Метаданные.СвойстваОбъектов.ПериодичностьРегистраСведений.Непериодический Тогда
		пЕстьПериод = ложь;
	КонецЕсли;
	
	Если пЕстьПериод Тогда
		пМассивИзмерений.Добавить("т.Период");
	КонецЕсли;
	
	Если  Метаданные.РегистрыРасчета.Содержит(пОбъектМД) Тогда
		пМассивИзмерений.Добавить("т.ПериодРегистрации");
		пМассивИзмерений.Добавить("т.Сторно");
	КонецЕсли;
	
	пМассивИзмерений.Добавить("т.Регистратор");
	пМассивИзмерений.Добавить("т.НомерСтроки");
	
	Для каждого Элем из пОбъектМД.Измерения Цикл
		пМассивИзмерений.Добавить("т." + Элем.Имя);
	КонецЦикла;
	
	пОграничениеНаРазмер = ?(пРазмерСписка = 0, "", " ПЕРВЫЕ " + Формат(пРазмерСписка, "ЧГ=0"));
	
	пМассивЗапросов = новый Массив;
	пМассивРеквизитов = СтрРазделить(пГдеНайдено, ",");
	
	пРазделитель = Символы.ПС + "ОБЪЕДИНИТЬ ВСЕ" + Символы.ПС;
	
	Для каждого пРеквизит из пМассивРеквизитов Цикл
		пМассив = СтрРазделить(пРеквизит, ".");
		пПоле = пМассив[2];
		пМассивЗапросов.Добавить(
			"ВЫБРАТЬ РАЗЛИЧНЫЕ" + пОграничениеНаРазмер + "
			|	" + СтрСоединить(пМассивИзмерений, "," + Символы.ПС + Символы.Таб) + "
			|ИЗ
			|	" + пПолноеИмя + " КАК т
			|ГДЕ
			|	т." + пПоле + " = &Ссылка"
		);
	КонецЦикла;
	
	Если пМассивЗапросов.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	пТекстЗапроса = СтрСоединить(пМассивЗапросов, пРазделитель);
	
	Запрос = новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.Текст = пТекстЗапроса;
	
	~ВыпонитьЗапрос:
	пТабРезультат = Запрос.Выполнить().Выгрузить();
	
	Возврат новый Структура("КлючЗаписи, ТаблицаДанных, ТекстЗапроса", Неопределено, пТабРезультат, Запрос.Текст);
КонецФункции

&НаСервереБезКонтекста
Функция вСформироватьТекстЗапросаДляСпискаЗависимыхПоРегиструБухгалтерии(Знач Ссылка, Знач пПолноеИмя, Знач пГдеНайдено, Знач пРазмерСписка, Знач пТекстЗапроса = "")
	Если не ПустаяСтрока(пТекстЗапроса) Тогда
		Запрос = новый Запрос;
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		Запрос.Текст = пТекстЗапроса;
		Перейти ~ВыпонитьЗапрос;
	КонецЕсли;
	
	пМассивИзмерений = новый Массив;
	
	пОбъектМД = Метаданные.НайтиПоПолномуИмени(пПолноеИмя);
	
	пЕстьКорреспонденция = пОбъектМД.Корреспонденция;
	
	пНеБалансовыеПоля = новый Соответствие;
	
	пМассивИзмерений.Добавить("т.Период");
	пМассивИзмерений.Добавить("т.Регистратор");
	пМассивИзмерений.Добавить("т.НомерСтроки");
	
	Для каждого Элем из пОбъектМД.Измерения Цикл
		Если пЕстьКорреспонденция и не Элем.Балансовый Тогда
			пНеБалансовыеПоля[Элем.Имя] = 1;
			пМассивИзмерений.Добавить("т." + Элем.Имя + "Дт");
			пМассивИзмерений.Добавить("т." + Элем.Имя + "Кт");
		Иначе
			пМассивИзмерений.Добавить("т." + Элем.Имя);
		КонецЕсли;
	КонецЦикла;
	
	Если пЕстьКорреспонденция Тогда
		пМассивИзмерений.Добавить("т.СчетДт");
		пМассивИзмерений.Добавить("т.СчетКт");
		
		пНеБалансовыеПоля["Счет"] = 1;
		Для каждого Элем из пОбъектМД.Ресурсы Цикл
			Если не Элем.Балансовый Тогда
				пНеБалансовыеПоля[Элем.Имя] = 1;
			КонецЕсли;
		КонецЦикла;
	Иначе
		пМассивИзмерений.Добавить("т.Счет");
	КонецЕсли;
	
	пОграничениеНаРазмер = ?(пРазмерСписка = 0, "", " ПЕРВЫЕ " + Формат(пРазмерСписка, "ЧГ=0"));
	
	пМассивЗапросов = новый Массив;
	пМассивРеквизитов = СтрРазделить(пГдеНайдено, ",");
	
	пРазделитель = Символы.ПС + "ОБЪЕДИНИТЬ ВСЕ" + Символы.ПС;
	
	Для каждого пРеквизит из пМассивРеквизитов Цикл
		пМассив = СтрРазделить(пРеквизит, ".");
		пПоле = пМассив[2];
		Если пНеБалансовыеПоля[пПоле] = 1 Тогда
			пМассивЗапросов.Добавить(
				"ВЫБРАТЬ РАЗЛИЧНЫЕ" + пОграничениеНаРазмер + "
				|	" + СтрСоединить(пМассивИзмерений, "," + Символы.ПС + Символы.Таб) + "
				|ИЗ
				|	" + пПолноеИмя + " КАК т
				|ГДЕ
				|	(т." + пПоле + "Дт = &Ссылка или т." + пПоле + "Кт = &Ссылка)"
			);
		Иначе
			пМассивЗапросов.Добавить(
				"ВЫБРАТЬ РАЗЛИЧНЫЕ" + пОграничениеНаРазмер + "
				|	" + СтрСоединить(пМассивИзмерений, "," + Символы.ПС + Символы.Таб) + "
				|ИЗ
				|	" + пПолноеИмя + " КАК т
				|ГДЕ
				|	т." + пПоле + " = &Ссылка"
			);
		КонецЕсли;
	КонецЦикла;
	
	Если пМассивЗапросов.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	пТекстЗапроса = СтрСоединить(пМассивЗапросов, пРазделитель);
	
	Запрос = новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.Текст = пТекстЗапроса;
	
	~ВыпонитьЗапрос:
	пТабРезультат = Запрос.Выполнить().Выгрузить();
	
	Возврат новый Структура("КлючЗаписи, ТаблицаДанных, ТекстЗапроса", Неопределено, пТабРезультат, Запрос.Текст);
КонецФункции

&НаКлиенте
Процедура _ОткрытьЗаписьРегистра(Команда)
	ТекДанные = Элементы._СписокЗаписей.ТекущиеДанные;
	Если ТекДанные <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(_КлючЗаписи, ТекДанные);
		пКлючЗаписи = вСоздатьКлючЗаписи(_ПолноеИмя, _КлючЗаписи);
		ПоказатьЗначение(, пКлючЗаписи);
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Функция вСоздатьКлючЗаписи(Знач пПолноеИмя, Знач пКлючЗаписи)
	пОбъектМД = Метаданные.НайтиПоПолномуИмени(пПолноеИмя);
	
	Если Метаданные.РегистрыСведений.Содержит(пОбъектМД) Тогда
		пМененджер = РегистрыСведений[пОбъектМД.Имя]
	ИначеЕсли Метаданные.РегистрыНакопления.Содержит(пОбъектМД) Тогда
		пМененджер = РегистрыНакопления[пОбъектМД.Имя]
	ИначеЕсли Метаданные.РегистрыБухгалтерии.Содержит(пОбъектМД) Тогда
		пМененджер = РегистрыБухгалтерии[пОбъектМД.Имя]
	ИначеЕсли Метаданные.РегистрыРасчета.Содержит(пОбъектМД) Тогда
		пМененджер = РегистрыРасчета[пОбъектМД.Имя]
	КонецЕсли;
	
	Возврат пМененджер.СоздатьКлючЗаписи(пКлючЗаписи);
КонецФункции


&НаКлиенте
Процедура _Обновить(Команда)
	_ДеревоОбъектов.ПолучитьЭлементы().Очистить();
	_СписокЗаписей.Очистить();
	
	вОбновить();
КонецПроцедуры

&НаКлиенте
Процедура _ПоказатьТекстЗапроса(Команда)
	Если не ПустаяСтрока(_ТекстЗапроса) Тогда
		пТекст = новый ТекстовыйДокумент;
		пТекст.УстановитьТекст(_ТекстЗапроса);
		пТекст.Показать("Текст запроса для зависимых");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура _ОграничениеНаСписокЗависимыхПриИзменении(Элемент)
	_ТекстЗапроса = "";
КонецПроцедуры

&НаКлиенте
Процедура _ОткрытьОбъект(Команда)
	вОткрытьОбъектВФорме(истина);
КонецПроцедуры

&НаКлиенте
Процедура _ОткрытьОбъектСтандартно(Команда)
	вОткрытьОбъектВФорме(ложь);
КонецПроцедуры

&НаКлиенте
Процедура вОткрытьОбъектВФорме(Знач пСпецФорма = истина)
	ЭФ = ЭтаФорма.ТекущийЭлемент;
	
	Если ЭФ.Имя = "_ДеревоОбъектов" Тогда
		ТекДанные = Элементы._ДеревоОбъектов.ТекущиеДанные;
		Если ТекДанные <> Неопределено Тогда
			вОткрытьОбъект(ТекДанные.Ссылка, пСпецФорма);
		КонецЕсли;
	ИначеЕсли ЭФ.Имя = "_СписокЗаписей" Тогда
		ТекДанные = Элементы._СписокЗаписей.ТекущиеДанные;
		Если ТекДанные <> Неопределено Тогда
			ПолеЭФ = ЭФ.ТекущийЭлемент;
			пПоле = Сред(ПолеЭФ.Имя, СтрДлина("_СписокЗаписей_")+1);
			пЗначение = ТекДанные[пПоле];
			
			Если ЗначениеЗаполнено(пЗначение) и вЭтоОбъектМетаданных(ТипЗнч(пЗначение)) Тогда
				вОткрытьОбъект(пЗначение, пСпецФорма);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура вОткрытьОбъект(Знач Ссылка, Знач пСпецФорма = истина)
	Если пСпецФорма Тогда
		пСтрук = новый Структура("ПутьКФормам, мОбъектСсылка, АдресаХранилищ", ПутьКФормам, Ссылка, _АдресаХранилищ);
		ОткрытьФорму(ПутьКФормам + "ФормаОбъекта", пСтрук, ,Ссылка);
	Иначе
		ПоказатьЗначение(, Ссылка);
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Функция вЭтоОбъектМетаданных(Знач Тип)
	ОбъектМД = Метаданные.НайтиПоТипу(Тип);
	Возврат ( ОбъектМД <> Неопределено и не Метаданные.Перечисления.Содержит(ОбъектМД) );
КонецФункции
