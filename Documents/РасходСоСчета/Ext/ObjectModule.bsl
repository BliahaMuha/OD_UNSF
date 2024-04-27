﻿
&Перед("ОбработкаЗаполнения")
Процедура ОД_ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ЗаказПоставщику") Тогда
		Если ДанныеЗаполнения.ОД_Состояние <> Справочники.СостоянияЗаказовПоставщикам.НайтиПоНаименованию("Согласован") Тогда
			ВызватьИсключение("Документ должен иметь состояние ""Согласован""");
			Возврат;	
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры
