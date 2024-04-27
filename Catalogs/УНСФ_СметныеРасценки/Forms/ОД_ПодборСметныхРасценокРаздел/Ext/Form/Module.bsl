﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ДокОснРек = Параметры.ДокОсн;
КонецПроцедуры

&НаСервере
Процедура ВыбратьИВернутьНаСервере(Об)
	
	Для Каждого Значение из Элементы.Список.ВыделенныеСтроки Цикл
		ДобавитьПозицииСметыПоРодителю(Значение, Об);	
	КонецЦикла; 
	
	См = ДокОснРек.ПолучитьОбъект();
	См.Стоимость = Справочники.УНСФ_Смета.ПолучитьСуммуСметы(См.Ссылка);
	См.Записать();
	
КонецПроцедуры
&НаКлиенте
Процедура ВыбратьИВернуть(Команда)
	Если ПроверитьНаГруппу(Элементы.Список.ТекущиеДанные.Ссылка) = Ложь Тогда
		Сообщить("Выбрать можно только раздел!");		
	Иначе
		ПоказатьВводЧисла(
		Новый ОписаниеОповещения("ВыполнитьВводОбъемаРабот", ЭтотОбъект),
			1,
			НСтр("ru='Введите количество для раздела'"),
			15,
			3);	
	КонецЕсли;
КонецПроцедуры
&НаКлиенте
Процедура ВыполнитьВводОбъемаРабот(Число, ДополнительныеПараметры) Экспорт
	
	Если Число = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ВыбратьИВернутьНаСервере(Число);
	ЭтаФорма.Закрыть();
КонецПроцедуры
&НаСервере
Функция ПроверитьНаГруппу(СсылНаСметнРасц)
	Возврат СсылНаСметнРасц.ЭтоГруппа;
КонецФункции

&НаСервере
Процедура ДобавитьПозицииСметыПоРодителю(РодительГруппа, Об)
	
	НР = Справочники.УНСФ_ПозицииСмет.СоздатьЭлемент();
	НР.РазделСметы = Истина; НР.Наименование = Строка(РодительГруппа);
	НР.Владелец = ДокОснРек; НР.Записать();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	УНСФ_СметныеРасценки.Ссылка КАК Ссылка,
		|	УНСФ_СметныеРасценки.Наименование КАК Наименование,
		|	УНСФ_СметныеРасценки.ЕдиницаИзмерения КАК ЕдиницаИзмерения
		|ИЗ
		|	Справочник.УНСФ_СметныеРасценки КАК УНСФ_СметныеРасценки
		|ГДЕ
		|	УНСФ_СметныеРасценки.Родитель = &ЭтотРод";

	Запрос.УстановитьПараметр("ЭтотРод", РодительГруппа);
	РезультатЗапроса = Запрос.Выполнить();	
	ВДЗ = РезультатЗапроса.Выбрать();	
	Пока ВДЗ.Следующий() Цикл
		
		СМ = 0; СР = 0;
		
		НПС = Справочники.УНСФ_ПозицииСмет.СоздатьЭлемент();
		НПС.Владелец = ДокОснРек; НПС.Наименование = ВДЗ.Наименование; НПС.Расценка = ВДЗ.Ссылка;
		НПС.Объем = Об; НПС.ЕдиницаИзмерения = ВДЗ.ЕдиницаИзмерения; 
		НПС.НаименованиеПолное = ВДЗ.Наименование; НПС.Родитель = НР.Ссылка;
			
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	УНСФ_СметныеРасценкиРесурсы.Ссылка КАК Ссылка,
			|	УНСФ_СметныеРасценкиРесурсы.Цена КАК Цена,
			|	УНСФ_СметныеРасценкиРесурсы.Количество КАК Количество,
			|	УНСФ_СметныеРасценкиРесурсы.Ресурс КАК Ресурс
			|ИЗ
			|	Справочник.УНСФ_СметныеРасценки.Ресурсы КАК УНСФ_СметныеРасценкиРесурсы
			|ГДЕ
			|	УНСФ_СметныеРасценкиРесурсы.Ссылка = &Ссылка";
		
		Запрос.УстановитьПараметр("Ссылка", ВДЗ.Ссылка);
		РезультатЗапроса = Запрос.Выполнить();	
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();	
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			НС = НПС.Ресурсы.Добавить();
		
			НС.Ресурс = ВыборкаДетальныеЗаписи.Ресурс; НС.Количество = ВыборкаДетальныеЗаписи.Количество;
			НС.КоличествоВсего = ВыборкаДетальныеЗаписи.Количество * Об; НС.Цена = ВыборкаДетальныеЗаписи.Цена;
			НС.Сумма = НС.КоличествоВсего * НС.Цена; СР = СР + НС.Сумма;
		КонецЦикла; 
				
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	УНСФ_СметныеРасценкиМатериалы.Ссылка КАК Ссылка,
			|	УНСФ_СметныеРасценкиМатериалы.Номенклатура КАК Номенклатура,
			|	УНСФ_СметныеРасценкиМатериалы.Характеристика КАК Характеристика,
			|	УНСФ_СметныеРасценкиМатериалы.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
			|	УНСФ_СметныеРасценкиМатериалы.Количество КАК Количество,
			|	УНСФ_СметныеРасценкиМатериалы.Цена КАК Цена
			|ИЗ
			|	Справочник.УНСФ_СметныеРасценки.Материалы КАК УНСФ_СметныеРасценкиМатериалы
			|ГДЕ
			|	УНСФ_СметныеРасценкиМатериалы.Ссылка = &Ссылка";
		
		Запрос.УстановитьПараметр("Ссылка", ВДЗ.Ссылка);
		РезультатЗапроса = Запрос.Выполнить();	
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();	
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			НС = НПС.Материалы.Добавить();
		
			НС.Номенклатура = ВыборкаДетальныеЗаписи.Номенклатура; НС.Характеристика = ВыборкаДетальныеЗаписи.Характеристика;
			НС.ЕдиницаИзмерения = ВыборкаДетальныеЗаписи.ЕдиницаИзмерения; НС.Количество = ВыборкаДетальныеЗаписи.Количество;
			НС.КоличествоВсего = НС.Количество * Об; НС.Цена = ВыборкаДетальныеЗаписи.Цена;
			НС.Сумма = НС.Цена * НС.КоличествоВсего; СМ = СМ + НС.Сумма;
		КонецЦикла;
		  		
		НПС.СуммаПозиции = СМ + СР;
		НПС.СуммаМатериалов = СМ;
		НПС.СуммаРесурсов = СР;
		
		НПС.Записать();		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	Возврат;
КонецПроцедуры
