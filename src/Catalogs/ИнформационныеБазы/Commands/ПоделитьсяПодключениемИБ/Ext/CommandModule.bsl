﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
	Диалог.Расширение = "v8i";
	Диалог.Фильтр = "(*.v8i)|*.v8i";
	
	ОписаниеОповещения = Новый ОписаниеОповещения("СохранитьЯрлык", ЭтотОбъект, ПараметрКоманды);
	ФайловаяСистемаКлиент.ПоказатьДиалогВыбора(ОписаниеОповещения, Диалог);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьЯрлык(ВыбранныеФайлы, ИнформационнаяБаза) Экспорт
	
	Если ВыбранныеФайлы = Неопределено Или ВыбранныеФайлы.Количество() = 0 Тогда
		Возврат;		
	КонецЕсли;
	
	ПутьКФайлу = ВыбранныеФайлы[0];
	
	ТекстФайла = ПолучитьТекстФайлаЯрлыка(ИнформационнаяБаза);	
	
	//ВерсияПлатформы = "8.3.17.1851";     
	//
	//ТекстФайла = СтрШаблон("[%1]
	//			|Connect=Srvr=""%2"";Ref=""%3"";
	//			|ID=%4
	//			|OrderInList=%5
	//			|Folder=/
	//			|OrderInTree=%6
	//			|External=0
	//			|ClientConnectionSpeed=Normal
	//			|App=Auto
	//			|WA=1
	//			|Version=8.3
	//			|DefaultVersion=%7
	//			|AppArch=x86",
	//
	//			СтруктураПараметров.Наименование,
	//			СтруктураПараметров.Кластер,
	//			СтруктураПараметров.ИмяБазы,
	//			СтруктураПараметров.ИдентификаторБазы,
	//			СтруктураПараметров.КодВЛисте,
	//			СтруктураПараметров.КодВДереве,
	//			ВерсияПлатформы);
	//			
	//СимволРазделителя = ПолучитьРазделительПути();
	//
	//Если Прав(ПутьККаталогу, 1) <> СимволРазделителя Тогда
	//	ПутьККаталогу = ПутьККаталогу + СимволРазделителя;
	//КонецЕсли;			
	//
	//РазделитьФайл(
	#Если МобильноеПриложениеКлиент Тогда
	
	ФайлЯрлыка = Новый ЗаписьТекста(ПутьКФайлу);
	
	#Иначе
		
	ФайлЯрлыка = Новый ЗаписьТекста(ПутьКФайлу, КодировкаТекста.UTF8);
		
	#КонецЕсли 
	ФайлЯрлыка.Записать(ТекстФайла);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьТекстФайлаЯрлыка(ИнформационнаяБаза)
	
	ВерсияПлатформы		= "8.3.17.1851";		
	//СтруктураПараметров	= Новый Структура;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
		               |	ИнформационныеБазы.Наименование КАК Наименование,
		               |	ИнформационныеБазы.Сервер1С.Наименование КАК Сервер1СНаименование,
		               |	ИнформационныеБазы.Сервер1С.ПортКластера КАК Сервер1СПортКластера,
		               |	ИнформационныеБазы.ИмяНаСервере1С КАК ИмяНаСервере1С,
		               |	ИнформационныеБазы.Ссылка КАК Ссылка,
		               |	ИнформационныеБазы.Код КАК КодВСписке,
		               |	ИнформационныеБазы.Код КАК КодВДереве
		               |ИЗ
		               |	Справочник.ИнформационныеБазы КАК ИнформационныеБазы
		               |ГДЕ
		               |	ИнформационныеБазы.Ссылка = &ИнформационнаяБаза";
	
	Запрос.УстановитьПараметр("ИнформационнаяБаза", ИнформационнаяБаза);
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Если Выборка.Следующий() Тогда
		//СтруктураПараметров.Вставить("Наименование",			Выборка.Наименование);
		//СтруктураПараметров.Вставить("Кластер",				Выборка.Сервер1СНаименование + ":" + Формат(Выборка.Сервер1СПортКластера, "ЧГ="));
		//СтруктураПараметров.Вставить("ИмяБазы",				Выборка.Наименование);
		//СтруктураПараметров.Вставить("ИдентификаторБазы",	Строка(ИнформационнаяБаза.УникальныйИдентификатор()));
		//СтруктураПараметров.Вставить("КодВЛисте",           	Выборка.КодВСписке);
		//СтруктураПараметров.Вставить("КодВДереве",          	Выборка.КодВДереве);
		
		Наименование			= Выборка.Наименование;
		Кластер				= Выборка.Сервер1СНаименование + ":" + Формат(Выборка.Сервер1СПортКластера, "ЧГ=");
		ИмяБазы				= Выборка.Наименование;
		ИдентификаторБазы		= Строка(ИнформационнаяБаза.УникальныйИдентификатор());
		КодВЛисте			= Выборка.КодВСписке;
		КодВДереве			= Выборка.КодВДереве;
	КонецЕсли;
	
	ТекстФайла = СтрШаблон("[%1]
				|Connect=Srvr=""%2"";Ref=""%3"";
				|ID=%4
				|OrderInList=%5
				|Folder=/
				|OrderInTree=%6
				|External=0
				|ClientConnectionSpeed=Normal
				|App=Auto
				|WA=1
				|Version=8.3
				|DefaultVersion=%7
				|AppArch=x86",
				Наименование, Кластер, ИмяБазы, ИдентификаторБазы, КодВЛисте, КодВДереве, ВерсияПлатформы);
	
	Возврат ТекстФайла;

КонецФункции // ПолучитьСтруктураПараметров()
