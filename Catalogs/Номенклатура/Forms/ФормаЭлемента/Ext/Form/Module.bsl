﻿
&НаСервере
Процедура ОД_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
	
	ЭлементНеокругляемыйОД = Элементы.Добавить("ОД_Неокругляемый", Тип("ПолеФормы"),Элементы.ГруппаОбъемИВес);
	ЭлементНеокругляемыйОД.Вид = ВидПоляФормы.ПолеФлажка;
	ЭлементНеокругляемыйОД.ПутьКДанным = "Объект.ОД_Неокругляемый";
	
	ЭлементКратностьОД = Элементы.Добавить("ОД_КратностьОкругления", Тип("ПолеФормы"),Элементы.ГруппаОбъемИВес);
	ЭлементКратностьОД.Вид = ВидПоляФормы.ПолеВвода;
	ЭлементКратностьОД.ПутьКДанным = "Объект.ОД_КратностьОкругления";
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Объект.ОД_КратностьОкругления = 1;	
	КонецЕсли;
	
КонецПроцедуры
