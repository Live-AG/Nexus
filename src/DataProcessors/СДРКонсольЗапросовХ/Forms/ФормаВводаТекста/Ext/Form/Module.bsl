﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Заголовок  = Параметры.Заголовок;
КонецПроцедуры

&НаКлиенте
Процедура _Выполнить(Команда)
	Закрыть(_Текст.ПолучитьТекст());
КонецПроцедуры
