﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПутьКИсполняемомуФайлу = КаталогПрограммы();
	Программа = "ibcmd";
	
	УстановитьВерсииПрограммы();
	ПрочитатьПараметрыИзМакета();
	
КонецПроцедуры 

&НаСервере
Процедура УстановитьВерсииПрограммы();  
	
	ЭтаОбработка = РеквизитФормыВЗначение("Объект"); 
	Макеты = ЭтаОбработка.Метаданные().Макеты; 
	
	Элементы.ВерсияПрограммы.СписокВыбора.Очистить();
	ТекущаяВерсияПрограммы = "";
	Для Каждого МакетОбработки Из Макеты Цикл
		СоставСтрокиПрограммы = СтрРазделить(МакетОбработки.Синоним, " "); 
		Если СоставСтрокиПрограммы[0] = Программа Тогда
			ТекущаяВерсияПрограммы = СоставСтрокиПрограммы[СоставСтрокиПрограммы.ВГраница()];
			Элементы.ВерсияПрограммы.СписокВыбора.Добавить(ТекущаяВерсияПрограммы);
		КонецЕсли;
		
	КонецЦикла;	

	ВерсияПрограммы = ТекущаяВерсияПрограммы;
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьПараметрыИзМакета()
	
	НачальнаяСтрока	= 5; 
	КолонкаКоманды	= 1;
	//КолонкаПараметра	= 2;
	КолокнаОписания	= 4;
	
	ДеревоЗначенийКоманд			= РеквизитФормыВЗначение("ДеревоКоманд",			Тип("ДеревоЗначений")); 
	ТаблицаЗначенийПараметров	= РеквизитФормыВЗначение("ТаблицаПараметров",	Тип("ТаблицаЗначений")); 
	
	ДеревоЗначенийКоманд.Строки.Очистить();
	ТаблицаЗначенийПараметров.Очистить();
	
	ИмяМакета = "_" + Программа + "_" + СтрЗаменить(ВерсияПрограммы, ".", "_");
	
	Попытка
		МакетСтруктуры = Обработки.ПомощникСозданияСкриптов.ПолучитьМакет(ИмяМакета);	
	Исключение

		Сообщить(ОписаниеОшибки());
		ЗначениеВРеквизитФормы(ДеревоЗначенийКоманд,			"ДеревоКоманд");
		ЗначениеВРеквизитФормы(ТаблицаЗначенийПараметров,	"ТаблицаПараметров"); 
		
		Возврат;
	КонецПопытки;
	
	Если МакетСтруктуры.Области.Количество() = 0 Тогда
		ЗначениеВРеквизитФормы(ДеревоЗначенийКоманд,			"ДеревоКоманд");
		ЗначениеВРеквизитФормы(ТаблицаЗначенийПараметров,	"ТаблицаПараметров"); 
		
		Возврат;		
	КонецЕсли;
	
	ТаблицаОбластей = Новый ТаблицаЗначений();
	ТаблицаОбластей.Колонки.Добавить("ИмяОбласти",				ОбщегоНазначения.ОписаниеТипаСтрока(50));
	ТаблицаОбластей.Колонки.Добавить("Параметр",					ОбщегоНазначения.ОписаниеТипаСтрока(50));
	ТаблицаОбластей.Колонки.Добавить("НачалоДиапазонаСтрок",	ОбщегоНазначения.ОписаниеТипаЧисло(5));
	ТаблицаОбластей.Колонки.Добавить("КонецДиапазонаСтрок",	ОбщегоНазначения.ОписаниеТипаЧисло(5));
	ТаблицаОбластей.Колонки.Добавить("Описание",					ОбщегоНазначения.ОписаниеТипаСтрока(512));
	ТаблицаОбластей.Колонки.Добавить("КлючСвязи",				Новый ОписаниеТипов("УникальныйИдентификатор"));
	
	Для Каждого ОбластьМакета Из МакетСтруктуры.Области Цикл
		НачалоДиапазонаСтрок	= ОбластьМакета.Верх;
		КонецДиапазонаСтрок	= ОбластьМакета.Низ;
		
		СтрокаТаблицыОбластей = ТаблицаОбластей.Добавить();
		СтрокаТаблицыОбластей.НачалоДиапазонаСтрок	= НачалоДиапазонаСтрок;
		СтрокаТаблицыОбластей.КонецДиапазонаСтрок		= КонецДиапазонаСтрок;
		СтрокаТаблицыОбластей.ИмяОбласти				= ОбластьМакета.Имя;
		
		СтрокаТаблицыОбластей.Параметр	= СокрЛП(МакетСтруктуры.Область(НачалоДиапазонаСтрок, 
																				КолонкаКоманды, 
																				НачалоДиапазонаСтрок, 
																				КолонкаКоманды).Текст); 
																		
		СтрокаТаблицыОбластей.Описание = СокрЛП(МакетСтруктуры.Область(НачалоДиапазонаСтрок, 
																				КолокнаОписания, 
																				НачалоДиапазонаСтрок, 
																				КолокнаОписания).Текст); 
		КлючСвязи	= Новый УникальныйИдентификатор();
		СтрокаТаблицыОбластей.КлючСвязи = КлючСвязи;
		
	КонецЦикла;
	
	ТаблицаОбластей.Сортировать("НачалоДиапазонаСтрок");        
	
	Если ТаблицаОбластей.Количество() > 0 Тогда
		КонечнаяСтрока = ТаблицаОбластей[0].НачалоДиапазонаСтрок;
	Иначе	
		КонечнаяСтрока = МакетСтруктуры.ВысотаТаблицы;
	КонецЕсли;
	
	КорневаяСтрока = ДеревоЗначенийКоманд.Строки.Добавить();
	КорневаяСтрока.Команда		= Программа;
	КорневаяСтрока.ИмяОбласти	= Программа;
	КлючСвязи	= Новый УникальныйИдентификатор();
	КорневаяСтрока.КлючСвязи = КлючСвязи;
	
	Для Каждого СтрокаОбластей Из ТаблицаОбластей Цикл
		СоздатьПодчиненныеЭлементы(КорневаяСтрока, СтрокаОбластей, ТаблицаОбластей, ДеревоЗначенийКоманд);
	КонецЦикла;

	ЗаполнитьТаблицуПараметров(ТаблицаЗначенийПараметров, ДеревоЗначенийКоманд, МакетСтруктуры);

	ЗначениеВРеквизитФормы(ДеревоЗначенийКоманд,			"ДеревоКоманд");
	ЗначениеВРеквизитФормы(ТаблицаЗначенийПараметров,	"ТаблицаПараметров");
	
	ТекстСкрипта = "";
	
КонецПроцедуры

&НаСервере
Процедура СоздатьПодчиненныеЭлементы(Знач СтрокаДерева, СтрокаОбластей, ТаблицаОбластей, ДеревоПараметров)
	
	НачалоДиапазонаСтрок	= СтрокаОбластей.НачалоДиапазонаСтрок;
	КонецДиапазонаСтрок	= СтрокаОбластей.КонецДиапазонаСтрок;
	
	НайденнаяСтрокаДерева = ДеревоПараметров.Строки.Найти(СтрокаОбластей.ИмяОбласти, "ИмяОбласти", Истина);
	
	Если ЗначениеЗаполнено(НайденнаяСтрокаДерева) Тогда
		Возврат;
	КонецЕсли;
	
	СтрокаДерева = СтрокаДерева.Строки.Добавить();
	СтрокаДерева.ИмяОбласти	= СтрокаОбластей.ИмяОбласти;
	СтрокаДерева.Команда		= СтрокаОбластей.Параметр;
	СтрокаДерева.Описание	= СтрокаОбластей.Описание;
	СтрокаДерева.КлючСвязи	= СтрокаОбластей.КлючСвязи;
	
	Для Каждого СтрокаПараметров Из ТаблицаОбластей Цикл
		
		Если СтрокаПараметров = СтрокаОбластей Тогда
			Продолжить;
		КонецЕсли;
		
		Если СтрокаПараметров.НачалоДиапазонаСтрок > НачалоДиапазонаСтрок
		   И СтрокаПараметров.КонецДиапазонаСтрок < КонецДиапазонаСтрок Тогда				   	
			
			СоздатьПодчиненныеЭлементы(СтрокаДерева, СтрокаПараметров, ТаблицаОбластей, ДеревоПараметров); 	
		КонецЕсли;  
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуПараметров(ТаблицаЗначенийПараметров, ДеревоЗначенийКоманд, МакетСтруктуры)
	
	КолонкаПараметра	= 2;
	КолокноОписания	= 4;
	
	СтрокиДереваКоманд = ДеревоЗначенийКоманд.Строки;
	
	Для Каждого СтрокаДерева Из СтрокиДереваКоманд Цикл
		
		ОбластьКоманд = МакетСтруктуры.ПолучитьОбласть(СтрокаДерева.ИмяОбласти);

		Для Каждого ПодчиненнаяКоманда Из СтрокаДерева.Строки Цикл
			ОбластьКоманд.УдалитьОбласть(ОбластьКоманд.Область(ПодчиненнаяКоманда.ИмяОбласти), ТипСмещенияТабличногоДокумента.ПоВертикали);	
		КонецЦикла;
		
		Для НомерСтроки = 1 По ОбластьКоманд.ВысотаТаблицы Цикл
			Параметр	= СокрЛП(ОбластьКоманд.Область(НомерСтроки, КолонкаПараметра, НомерСтроки, КолонкаПараметра).Текст);
			Описание	= СокрЛП(ОбластьКоманд.Область(НомерСтроки, КолокноОписания, НомерСтроки, КолокноОписания).Текст); 		
			
			Если Не ЗначениеЗаполнено(Параметр) Тогда
				Продолжить;				
			КонецЕсли;   
			
			СтрокаПараметров = ТаблицаЗначенийПараметров.Добавить();				
			
			СдвигСимвола = 1;
			НачалоАргумента = СтрНайти(Параметр, "<") + СдвигСимвола;
			КонецАргумента = СтрНайти(Параметр, ">");
			ИмяАргумента = Сред(Параметр, НачалоАргумента, КонецАргумента - НачалоАргумента);
			
			СтрокаПараметров.Параметр		= СокрЛП(Параметр);
			СтрокаПараметров.Описание		= СокрЛП(Описание);
			СтрокаПараметров.ИмяАргумента	= СокрЛП(ИмяАргумента);
			СтрокаПараметров.КлючСвязи		= СтрокаДерева.КлючСвязи;
		КонецЦикла;
		
		ЗаполнитьТаблицуПараметров(ТаблицаЗначенийПараметров, СтрокаДерева, МакетСтруктуры);			
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаКопироватьВБуфер(Команда)
	
	СкопироватьВБуферОбмена();
	
КонецПроцедуры

&НаСервере
Процедура СкопироватьВБуферОбмена()
	
	ПолеHTMLБуфера = СтрШаблон("<!DOCTYPE html>
									|<html>
									|	<body onload='copy()'>
									|		<input id='input' type='text'/>
									|		<script>
									|			function copy() {
									|				var text = '%1';
									|				var ua = navigator.userAgent;
									|				if (ua.search(/MSIE/) > 0 || ua.search(/Trident/) > 0) {
									|					window.clipboardData.setData('Text', text);
									|				} else {
									|					var copyText = document.getElementById('input');
									|					copyText.value = text;
									|					copyText.select();
									|					document.execCommand('copy');
									|				}
									|			}
									|		</script>
									|	</body>
									|</html>",
									СокрЛП(ТекстСкрипта));   
			
	//ПоказатьОповещениеПользователя("Скопировано в буфер");

КонецПроцедуры

&НаКлиенте
Процедура ТаблицаПараметровИспользованиеПриИзменении(Элемент)
	
	ТекущаяСтрокаПараметров = Элементы.ТаблицаПараметров.ТекущиеДанные;
	Если ТекущаяСтрокаПараметров.Использование Тогда
		ТекущаяСтрокаКоманд = Элементы.ДеревоКоманд.ТекущиеДанные;
		УстановитьОтметкуКоменды(ТекущаяСтрокаКоманд, Истина);
	КонецЕсли;	
		
	УстановитьСтрокуСкрипта();

КонецПроцедуры

&НаКлиенте
Процедура ДеревоКомандИспользованиеПриИзменении(Элемент)
	
	ТекущаяСтрокаКоманды = Элементы.ДеревоКоманд.ТекущиеДанные;
	Если ТекущаяСтрокаКоманды.Использование Тогда
		УстановитьПометкуРодительскойКоманды(ТекущаяСтрокаКоманды);
		УстановитьПометкуОбязательныхПараметров(ТекущаяСтрокаКоманды.КлючСвязи);
	Иначе
		СнятьПометкуПараметровКоманды(ТекущаяСтрокаКоманды.КлючСвязи);
		СнятьПометкуПодчиненнойКоманды(ТекущаяСтрокаКоманды);
	КонецЕсли;	

	УстановитьСтрокуСкрипта();			
	
КонецПроцедуры

&НаКлиенте
Процедура ПрограммаПриИзменении(Элемент)
	
	УстановитьВерсииПрограммы();
	ПрочитатьПараметрыИзМакета();   
	
	Если Элементы.ДеревоКоманд.ТекущаяСтрока <> Неопределено Тогда
		Элементы.ДеревоКоманд.Развернуть(Элементы.ДеревоКоманд.ТекущаяСтрока, Истина); 
	КонецЕсли;   
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаПараметровАргументПриИзменении(Элемент)
	
	УстановитьСтрокуСкрипта();

КонецПроцедуры

&НаКлиенте
Процедура СнятьПометкуПодчиненнойКоманды(Знач ТекущаяСтрокаКоманды)

	СтрокиПодчиненныхКоманд = ТекущаяСтрокаКоманды.ПолучитьЭлементы();
	Для Каждого ТекущаяСтрокаКоманды Из СтрокиПодчиненныхКоманд Цикл
		ТекущаяСтрокаКоманды.Использование = Ложь;
		СнятьПометкуПараметровКоманды(ТекущаяСтрокаКоманды.КлючСвязи);
		СнятьПометкуПодчиненнойКоманды(ТекущаяСтрокаКоманды);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПометкуРодительскойКоманды(ТекущаяСтрокаКоманды)
	
	РодительскаяСтрокаКоманды = ТекущаяСтрокаКоманды.ПолучитьРодителя();
	Если РодительскаяСтрокаКоманды <> Неопределено Тогда
		РодительскаяСтрокаКоманды.Использование = Истина;
		УстановитьПометкуРодительскойКоманды(РодительскаяСтрокаКоманды)
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура СнятьПометкуПараметровКоманды(КлючСвязи)
	
	СтрокиПараметров = ТаблицаПараметров.НайтиСтроки(Новый Структура("КлючСвязи", КлючСвязи));
	Для Каждого СтрокаПараметра Из СтрокиПараметров Цикл
		СтрокаПараметра.Использование = Ложь;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПометкуОбязательныхПараметров(КлючСвязи)
	
	СтрокиПараметров = ТаблицаПараметров.НайтиСтроки(Новый Структура("КлючСвязи", КлючСвязи));
	Для Каждого СтрокаПараметра Из СтрокиПараметров Цикл
		Если СтрНачинаетсяС(СтрокаПараметра.Параметр, "<") 
			И СтрЗаканчиваетсяНа(СтрокаПараметра.Параметр, ">") Тогда 
			СтрокаПараметра.Использование = Истина;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтметкуКоменды(Знач СтрокаКоманд, Отметка)
	
	СтрокаКоманд.Использование = Отметка;
	СтрокаКоманд = СтрокаКоманд.ПолучитьРодителя();
	Если СтрокаКоманд <> Неопределено Тогда
		УстановитьОтметкуКоменды(СтрокаКоманд, Отметка)		
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоКоммандПриАктивизацииСтроки(Элемент)
	
	ТекущаяСтрокаКоманд = Элементы.ДеревоКоманд.ТекущиеДанные;
	Если ТекущаяСтрокаКоманд = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОтборСтрок = Новый Структура("КлючСвязи", ТекущаяСтрокаКоманд.КлючСвязи);
	Элементы.ТаблицаПараметров.ОтборСтрок = Новый ФиксированнаяСтруктура(ОтборСтрок);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтрокуСкрипта()

	СтрокаСкрипта = "";
	СтрокиДереваКоманд = ДеревоКоманд.ПолучитьЭлементы();
	ЗаполнитьПараметрыКоманды(СтрокаСкрипта, СтрокиДереваКоманд);
	
	ТекстСкрипта = ПутьКИсполняемомуФайлу + СтрокаСкрипта;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПараметрыКоманды(СтрокаСкрипта, СтрокиДереваКоманд)
	
	Для Каждого СтрокаКоманды Из СтрокиДереваКоманд Цикл
		
		Если Не СтрокаКоманды.Использование Тогда
			Продолжить;
		КонецЕсли;
		
		СтрокаСкрипта = СтрокаСкрипта + СтрокаКоманды.Команда + " ";
		
		СтрокиПараметров = ТаблицаПараметров.НайтиСтроки(Новый Структура("КлючСвязи", СтрокаКоманды.КлючСвязи));
		
		Для Каждого СтрокаПараметра Из СтрокиПараметров Цикл
			Если Не СтрокаПараметра.Использование Тогда
				Продолжить;
			КонецЕсли;
			
			СтрокаСкрипта = СтрокаСкрипта + " " + ПолучитьСтрокуПараметра(СтрокаПараметра);	
		КонецЦикла;	
		
		ПодчиненныеСтроки = СтрокаКоманды.ПолучитьЭлементы();
		ЗаполнитьПараметрыКоманды(СтрокаСкрипта, ПодчиненныеСтроки);
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьСтрокуПараметра(СтруктураСтроки)
	
	МассивПараметорв = СтрРазделить(СокрЛП(СтруктураСтроки.Параметр), "|");
	Если ЗначениеЗаполнено(СтруктураСтроки.Аргумент) Тогда
		СтрокаПараметра = СтрЗаменить(СокрЛП(МассивПараметорв[0]), 
											"<" + СтруктураСтроки.ИмяАргумента + ">", 
											"""" + СтруктураСтроки.Аргумент + """");
	Иначе
		СтрокаПараметра = СокрЛП(МассивПараметорв[0]);
	КонецЕсли;
		
	Возврат СтрокаПараметра;
	
КонецФункции

&НаКлиенте
Процедура ВерсияПлатформыПриИзменении(Элемент)
	
	ПрочитатьПараметрыИзМакета();	
	
КонецПроцедуры

