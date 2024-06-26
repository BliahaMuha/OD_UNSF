﻿
&НаСервере
Процедура ОД_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
	
	ЭлементАкцепторОД = Элементы.Добавить("ОД_ОтветственныйИнженерПТО", Тип("ПолеФормы"), Элементы.ДополнительноПраво);
	ЭлементАкцепторОД.Вид = ВидПоляФормы.ПолеВвода;
	ЭлементАкцепторОД.ПутьКДанным = "Объект.ОД_ОтветственныйИнженерПТО";
	
	ЭлементПрорабОД = Элементы.Добавить("ОД_ОтветственныйПрораб", Тип("ПолеФормы"), Элементы.ДополнительноПраво);
	ЭлементПрорабОД.Вид = ВидПоляФормы.ПолеВвода;
	ЭлементПрорабОД.ПутьКДанным = "Объект.ОД_ОтветственныйПрораб";
		
КонецПроцедуры

&НаКлиенте
Процедура ОД_ДатаОтгрузкиПриИзмененииПеред(Элемент)
	
	Если ЗначениеЗаполнено(Объект.ДатаОтгрузки) Тогда
		Если Формат(Объект.ДатаОтгрузки, "ДЛФ=D") = Формат(ТекущаяДата(), "ДЛФ=D") Тогда
			Сообщить("Дата отгрузки не может быть сегодняшним днем!");
			Объект.ДатаОтгрузки = Дата('00010101');
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры
