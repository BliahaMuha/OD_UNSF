﻿
#Область ТиповыеПроцедурыИФункции

&Перед("ОбработкаПроверкиЗаполнения")
Процедура ОД_ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ПроверяемыеРеквизиты.Добавить("НомерВходящегоДокумента");
	
КонецПроцедуры

&После("ПередЗаписью")
Процедура ОД_ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	//ПроверитьДубльВходящегоНомера();
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоНовый() Тогда	
		
		ДобавитьЗаписьВРегистрЖурналаДокументовСогласование(Истина); 
		
	Иначе	
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	СчетНаОплатуПоставщика.ОД_Состояние КАК ОД_Состояние
			|ИЗ
			|	Документ.СчетНаОплатуПоставщика КАК СчетНаОплатуПоставщика
			|ГДЕ
			|	СчетНаОплатуПоставщика.Ссылка = &Ссылка";
		
		Запрос.УстановитьПараметр("Ссылка", ЭтотОбъект.Ссылка);	
		РезультатЗапроса = Запрос.Выполнить();		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();		
		Если ВыборкаДетальныеЗаписи.Следующий() Тогда
			
			Если ВыборкаДетальныеЗаписи.ОД_Состояние <> ЭтотОбъект.ОД_Состояние Тогда
				ДобавитьЗаписьВРегистрЖурналаДокументовСогласование(Ложь);	
			КонецЕсли;
			
		КонецЕсли;
				
	КонецЕсли; 
	
	Если РежимЗаписи <> РежимЗаписиДокумента.ОтменаПроведения Тогда
		Попытка
			Если ТипЗнч(ЭтотОбъект.ДокументОснование) = Тип("ДокументСсылка.ЗаказПоставщику") Тогда
				Об = ЭтотОбъект.ДокументОснование.ПолучитьОбъект();
				Об.Контрагент = ЭтотОбъект.Контрагент;
				Об.Договор = ЭтотОбъект.Договор;
				Попытка
					Об.Записать();
				Исключение
					Сообщить(ОписаниеОшибки());
					Об.ОбменДанными.Загрузка = Истина;
					Об.Записать();
				КонецПопытки;
			КонецЕсли;	
		Исключение
			
		КонецПопытки;
	КонецЕсли;
	
КонецПроцедуры

&После("ОбработкаЗаполнения")
Процедура ОД_ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ЗаказПоставщику") Тогда
		ЭтотОбъект.ОД_ИзППМ = ДанныеЗаполнения.ОД_ИзППМ;
		Для Каждого Значение из ДанныеЗаполнения.Запасы Цикл
			ЭтотОбъект.Запасы[Значение.НомерСтроки - 1].ОД_ВсегоВППМ = 
				ДанныеЗаполнения.Запасы[Значение.НомерСтроки - 1].ОД_ВсегоВППМ;
			ЭтотОбъект.Запасы[Значение.НомерСтроки - 1].ОД_УжеЗаказано = 
				ДанныеЗаполнения.Запасы[Значение.НомерСтроки - 1].ОД_УжеЗаказано;
			ЭтотОбъект.Запасы[Значение.НомерСтроки - 1].ОД_Остаток = 
				ДанныеЗаполнения.Запасы[Значение.НомерСтроки - 1].ОД_Остаток;
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ДополнительныеПроцедурыИФункции

Процедура ПроверитьДубльВходящегоНомера()
	
	ТекВхНомер = ЭтотОбъект.НомерВходящегоДокумента;
	ТекСсылка = ЭтотОбъект.Ссылка;
	ТекПост = ЭтотОбъект.Контрагент;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СчетНаОплатуПоставщика.Ссылка КАК Ссылка
		|ИЗ
		|	Документ.СчетНаОплатуПоставщика КАК СчетНаОплатуПоставщика
		|ГДЕ
		|	СчетНаОплатуПоставщика.Ссылка <> &Ссылка
		|	И СчетНаОплатуПоставщика.Контрагент = &Конт
		|	И СчетНаОплатуПоставщика.НомерВходящегоДокумента = &НомерВходящегоДокумента";
	
	Запрос.УстановитьПараметр("НомерВходящегоДокумента", ТекВхНомер);
	Запрос.УстановитьПараметр("Конт", ТекПост);
	Запрос.УстановитьПараметр("Ссылка", ТекСсылка);	
	РезультатЗапроса = Запрос.Выполнить();	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Уже существует документ с указанным входящим номером и поставщиком", ЭтотОбъект, "");		
	Иначе
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ДобавитьЗаписьВРегистрЖурналаДокументовСогласование(НовыйДокумент)

	НаборЗаписей = РегистрыСведений.ОД_ЖурналДействийСогласовний.СоздатьМенеджерЗаписи(); 

	НаборЗаписей.Период = ТекущаяДата();
	НаборЗаписей. Дата = ТекущаяДата(); 
	НаборЗаписей.Пользователь = ПользователиКлиентСервер.ТекущийПользователь();
	Если НовыйДокумент Тогда  
		ЭтотОбъект.УстановитьСсылкуНового(Документы.СчетНаОплатуПоставщика.ПолучитьСсылку());	
		НаборЗаписей.Документ = ПолучитьСсылкуНового();	
	Иначе
		НаборЗаписей.Документ = ЭтотОбъект.Ссылка;	
	КонецЕсли;	 
	
	Если ЭтотОбъект.ОД_Состояние = Перечисления.ОД_СостоянияСчетовНаОплатуОтПоставщиков.Согласован Тогда
		НаборЗаписей.СтатусСогласования = "Согласован";		
	Иначе
		НаборЗаписей.СтатусСогласования = Строка(ЭтотОбъект.ОД_Состояние);	
	КонецЕсли;
		

	НаборЗаписей.Записать();
	
КонецПроцедуры 

#КонецОбласти

