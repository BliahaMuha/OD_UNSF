﻿
#Область ТиповыеПроцедурыИФункции

&НаСервере
Процедура ОД_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
	
	Элементы.НомерВходящегоДокумента.АвтоОтметкаНезаполненного = Истина;
	
	ЭлементСтатусДоработки = Элементы.Добавить("СтатусДоработки",Тип("ПолеФормы"),Элементы.ПраваяКолонка);
	ЭлементСтатусДоработки.Вид = ВидПоляФормы.ПолеВвода;
	ЭлементСтатусДоработки.ПутьКДанным = "Объект.ОД_СтатусДоработки"; 
	ЭлементСтатусДоработки.УстановитьДействие("ПриИзменении","СтатусДоработкиПриИзменении");
	
	ЭлементСостоянияОД = Элементы.Добавить("ОД_Состояние", Тип("ПолеФормы"), Элементы.ЛеваяКолонка);
	ЭлементСостоянияОД.Вид = ВидПоляФормы.ПолеВвода;
	ЭлементСостоянияОД.ПутьКДанным = "Объект.ОД_Состояние";
	
	Объект.ОД_ЗаявкаНаДС = ПроверитьЗаявкуНаРасходованиеДС(); 
	РКВ_Заявка = Элементы.Добавить("ОД_ЗаявкаНаДС",Тип("ПолеФормы"), Элементы.ЛеваяКолонка);
	РКВ_Заявка.Вид = ВидПоляФормы.ПолеФлажка;
	РКВ_Заявка.ПутьКДанным = "Объект.ОД_ЗаявкаНаДС";
	РКВ_Заявка.ТолькоПросмотр = Истина;
	//// ОД_ОтветственныйПрораб 
	
	ЭлементПрорабОД = Элементы.Добавить("ОД_ОтветственныйПрораб", Тип("ПолеФормы"), Элементы.ДополнительноПраваяКолонка);
	ЭлементПрорабОД.Вид = ВидПоляФормы.ПолеВвода;
	ЭлементПрорабОД.ПутьКДанным = "Объект.ОД_ОтветственныйПрораб"; 
	ЗаполнитьОтветственногоПрораба();
	
	//// ОД_ОтветственныйПрораб
	//Если НЕ (РольДоступна("ОД_СогласованиеСчетовНаОплатуПолученных") ИЛИ РольДоступна("АдминистраторСистемы")) Тогда
	Если НЕ Пользователи.РолиДоступны("ОД_СогласованиеСчетовНаОплатуПолученных", ПользователиИнформационнойБазы.ТекущийПользователь()) Тогда
		ЭлементСостоянияОД.ТолькоПросмотр = Истина;	
	КонецЕсли;
	
	ЭлементАкцепторОД = Элементы.Добавить("ОД_Акцептор", Тип("ПолеФормы"), Элементы.ЛеваяКолонка);
	ЭлементАкцепторОД.Вид = ВидПоляФормы.ПолеВвода;
	ЭлементАкцепторОД.ПутьКДанным = "Объект.ОД_Акцептор";
	//Если НЕ (РольДоступна("ОД_ИзменениеАкцептораСчетовНаОплатуПолученных") ИЛИ РольДоступна("АдминистраторСистемы")) Тогда
    Если НЕ Пользователи.РолиДоступны("ОД_ИзменениеАкцептораСчетовНаОплатуПолученных", ПользователиИнформационнойБазы.ТекущийПользователь()) Тогда
		ЭлементАкцепторОД.ТолькоПросмотр = Истина;	
	КонецЕсли;  
	
	ЗаполнитьАкцептора();
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Объект.ОД_Состояние = Перечисления.ОД_СостоянияСчетовНаОплатуОтПоставщиков.НаСогласовании;	
	КонецЕсли; 
	
	// Добавление команды "Добавить файл"
	Ком_ДобавитьФайл = ЭтаФорма.Команды.Добавить("Команда_ДобавитьФайл");
	Ком_ДобавитьФайл.Заголовок = "Добавить файлы";
	Ком_ДобавитьФайл.Действие = "ОД_ДобавитьФайл"; 
	Кно_ДобавитьФайл = ЭтаФорма.Элементы.Добавить("ОД_КнопкаДобавитьФайл", Тип("КнопкаФормы"), Элементы.ФормаНастройкаФормы.Родитель);
	Кно_ДобавитьФайл.Заголовок = "Добавить файлы";
	Кно_ДобавитьФайл.ИмяКоманды = "Команда_ДобавитьФайл";
	
	////// Вывод картинки прикрепленного счета
	////ДобавляемыеРеквизиты = Новый Массив; 
	////Реквизит_КартинкаПрикрепленногоФайла = Новый РеквизитФормы("ОД_МиниатюраСчет", Новый ОписаниеТипов("Строка",,,, Новый КвалификаторыСтроки));
	////ДобавляемыеРеквизиты.Добавить(Реквизит_КартинкаПрикрепленногоФайла);
	////ИзменитьРеквизиты(ДобавляемыеРеквизиты); 
	////
	////Эл_МиниатюраСчет = Элементы.Добавить("ОД_МиниатюраСчет", Тип("ПолеКартинки"), ЭтаФорма);
	////Эл_МиниатюраСчет.Вид = ВидПоля
	
	// Вывод договора с заказчиком
	ЭлДогСЗаказчиком = Элементы.Добавить("ОД_ДоговорСЗаказчиком", Тип("ПолеФормы"), Элементы.ЛеваяКолонка);
	ЭлДогСЗаказчиком.Вид = ВидПоляФормы.ПолеВвода;
	ЭлДогСЗаказчиком.ПутьКДанным = "Объект.ОД_ДоговорСЗаказчиком";
	ЭлДогСЗаказчиком.ТолькоПросмотр = Истина;
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ЗаполнитьДоговорСЗаказчиком();
	Иначе
		ЗаполнитьДоговорСЗаказчиком();
	КонецЕсли;
	
	// Журнал =====================================================================================
	СтраницаЖурнал = Элементы.Добавить("ОД_СтраницаЖурнал", Тип("ГруппаФормы"), Элементы.Страницы);
	СтраницаЖурнал.Вид = ВидГруппыФормы.Страница;
	СтраницаЖурнал.Заголовок = "Журнал"; 
	
	МассивТипаВыбора = Новый Массив;
	МассивТипаВыбора.Добавить(Тип("ТаблицаЗначений"));
	ОписаниеТипаВыбора = Новый ОписаниеТипов(МассивТипаВыбора);
	МассивРеквизитов = Новый Массив;
	МассивРеквизитов.Добавить(Новый РеквизитФормы("ТаблицаЖурнала", ОписаниеТипаВыбора, "", "ТЖ")); 
	
	ТЗ = Новый ТаблицаЗначений;
	ТЗ.Колонки.Добавить("Дата");
	ТЗ.Колонки.Добавить("Статус");
	ТЗ.Колонки.Добавить("Пользователь");
	
	Для Каждого Колонка Из ТЗ.Колонки Цикл

	    МассивРеквизитов.Добавить(Новый РеквизитФормы(Колонка.Имя, Колонка.ТипЗначения,"ТаблицаЖурнала"));
	    
	КонецЦикла;
	ИзменитьРеквизиты(МассивРеквизитов);      
	ТаблицаПолейВыбора = Элементы.Добавить("ТЖ", Тип("ТаблицаФормы"), СтраницаЖурнал);
	ТаблицаПолейВыбора.ПутьКДанным = "ТаблицаЖурнала";
	ТаблицаПолейВыбора.Отображение = ОтображениеТаблицы.Список;
	ТаблицаПолейВыбора.ПоложениеКоманднойПанели = ПоложениеКоманднойПанелиЭлементаФормы.Нет;
	ТаблицаПолейВыбора.ТолькоПросмотр = Истина; 
	ТаблицаПолейВыбора.Видимость = Истина;
	
	ЭТЗ = Элементы.Добавить("ТЖ_Дата", Тип("ПолеФормы"), ТаблицаПолейВыбора);
	ЭТЗ.Вид = ВидПоляФормы.ПолеВвода; ЭТЗ.ПутьКДанным = "ТаблицаЖурнала.Дата";
	
	ЭТЗ = Элементы.Добавить("ТЖ_Статус", Тип("ПолеФормы"), ТаблицаПолейВыбора);
	ЭТЗ.Вид = ВидПоляФормы.ПолеВвода; ЭТЗ.ПутьКДанным = "ТаблицаЖурнала.Статус";
	
	ЭТЗ = Элементы.Добавить("ТЖ_Пользователь", Тип("ПолеФормы"), ТаблицаПолейВыбора);
	ЭТЗ.Вид = ВидПоляФормы.ПолеВвода; ЭТЗ.ПутьКДанным = "ТаблицаЖурнала.Пользователь";
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ЗаполнитьЖурнал();	
	КонецЕсли; 
	
	ЭлСсылкаЖурнал = Элементы.Добавить("ОД_ГиперссылкаЖурнал" ,Тип("ДекорацияФормы"), Элементы.ГруппаКомментарий);
 	ЭлСсылкаЖурнал.Гиперссылка = Истина;
    ЭлСсылкаЖурнал.Заголовок  =  "Журнал";  
	ЭлСсылкаЖурнал.УстановитьДействие("Нажатие", "ОткрытьФормуОтчетаЖурнала");
	// ============================================================================================
	
	НЭ = Элементы.Добавить("ОД_ИзППМ", Тип("ПолеФормы"), Элементы.ЛеваяКолонка);
	НЭ.Вид = ВидПоляФормы.ПолеФлажка;
	НЭ.ПутьКДанным = "Объект.ОД_ИзППМ";
	НЭ.Заголовок = "Из ППМ";
	НЭ.Доступность = Ложь; 
	
	// =============== Добавление реквизитов в ТЧ ==========================
	
	НовЭл = Элементы.Добавить("ОД_ВсегоВППМ", Тип("ПолеФормы"), Элементы.Запасы);
	НовЭл.Вид = ВидПоляФормы.ПолеВвода;
	НовЭл.Доступность = Ложь;
	НовЭл.ПутьКДанным = "Объект.Запасы.ОД_ВсегоВППМ";
	
	НовЭл = Элементы.Добавить("ОД_УжеЗаказано", Тип("ПолеФормы"), Элементы.Запасы);
	НовЭл.Вид = ВидПоляФормы.ПолеВвода;
	НовЭл.Доступность = Ложь;
	НовЭл.ПутьКДанным = "Объект.Запасы.ОД_УжеЗаказано";
	
	НовЭл = Элементы.Добавить("ОД_Остаток", Тип("ПолеФормы"), Элементы.Запасы);
	НовЭл.Вид = ВидПоляФормы.ПолеВвода;
	НовЭл.Доступность = Ложь;
	НовЭл.ПутьКДанным = "Объект.Запасы.ОД_Остаток";
	
	Если НЕ Объект.ОД_ИзППМ Тогда
		Элементы.Найти("ОД_ВсегоВППМ").Видимость = Ложь;
		Элементы.Найти("ОД_УжеЗаказано").Видимость = Ложь;
		Элементы.Найти("ОД_Остаток").Видимость = Ложь;
	КонецЕсли;
	
	// =====================================================================
	Если НЕ Пользователи.РолиДоступны("ПолныеПрава", ПользователиИнформационнойБазы.ТекущийПользователь()) 
		ИЛИ НЕ Пользователи.РолиДоступны("АдминистраторСистемы", ПользователиИнформационнойБазы.ТекущийПользователь()) Тогда
		
		Элементы.Дата.ТолькоПросмотр 	= Истина; 
		Элементы.Номер.ТолькоПросмотр 	= Истина;
	КонецЕсли;
	
	// =====================================================================
	
КонецПроцедуры 

&НаКлиенте
Процедура СтатусДоработкиПриИзменении()
    Перем ВыбЗнач;

	Если Объект.ОД_СтатусДоработки = ПредопределенноеЗначение("Перечисление.ОД_СтатусыОтправкиНадоработку.НаДоработку") Тогда
		Массив = Новый Массив;
		//Массив.Добавить(Тип("Число"));
		ДопПараметры = Объект.Ссылка;	
		Массив.Добавить(Тип("Строка"));
		//Массив.Добавить(Тип("Дата"));
		//КЧ = Новый КвалификаторыЧисла(12,2);
		КС = Новый КвалификаторыСтроки(20);
		//КД = Новый КвалификаторыДаты(ЧастиДаты.Дата);
		ОписаниеТипов = Новый ОписаниеТипов(Массив, КС);
			
		Оповещение = Новый ОписаниеОповещения("ОтправитьСообщениеTG2", ЭтотОбъект, ДопПараметры);
		ПоказатьВводЗначения(Оповещение,ВыбЗнач, "Укажите причину доработки", ОписаниеТипов);
		
	КонецЕсли
	
КонецПроцедуры



&НаКлиенте
Процедура ОД_ПередЗаписьюПеред(Отказ, ПараметрыЗаписи)
	
	//Если (ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Проведение ИЛИ 
	//		ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Запись) И ПроверитьДубльВходящегоНомера()  Тогда
	//    Если НЕ ПараметрыЗаписи.Свойство("ОтказатьВПроведении") Тогда
	//        ДиалогСВопросом();
	//        Отказ = Истина; 
	//    Иначе 
	//        Отказ = ПараметрыЗаписи.ОтказатьВПроведении;
	//    КонецЕсли;
	//КонецЕсли; 
	Объект.ОД_ЗаявкаНаДС = ПроверитьЗаявкуНаРасходованиеДС();
	Если ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Проведение И ПроверитьДубльВходящегоНомера()  Тогда 
		
		Если НЕ ПараметрыЗаписи.Свойство("ОтказатьВПроведении") Тогда
	        ДиалогСВопросомПроведение();
	        Отказ = Истина; 
	    Иначе 
	        Отказ = ПараметрыЗаписи.ОтказатьВПроведении;
	    КонецЕсли;
	КонецЕсли; 
	
	Если ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Запись И ПроверитьДубльВходящегоНомера()  Тогда 
		
		Если НЕ ПараметрыЗаписи.Свойство("ОтказатьВПроведении") Тогда
	        ДиалогСВопросом();
	        Отказ = Истина; 
	    Иначе 
	        Отказ = ПараметрыЗаписи.ОтказатьВПроведении;
	    КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ДополнительныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьАкцептора()
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.ДокументОснование) Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(Объект.ДокументОснование) = Тип("ДокументСсылка.ЗаказПокупателя") Тогда
		Объект.ОД_Акцептор = Объект.ДокументОснование.Ответственный;	
	КонецЕсли; 
	
	Если ТипЗнч(Объект.ДокументОснование) = Тип("ДокументСсылка.ЗаказПоставщику") Тогда
		Если ЗначениеЗаполнено(Объект.ДокументОснование.ЗаказПокупателя) Тогда
			Объект.ОД_Акцептор = Объект.ДокументОснование.ЗаказПокупателя.Ответственный;	
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОД_ДобавитьФайл()
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		РаботаСФайламиКлиент.ДобавитьФайлы(Объект.Ссылка, УникальныйИдентификатор); 
	Иначе
		Сообщить("Добавление файлов возможно только для записанного документа!");	
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДоговорСЗаказчиком()

	Если НЕ ЗначениеЗаполнено(Объект.ДокументОснование) Тогда
		Возврат;		
	КонецЕсли;
	
	Если ТипЗнч(Объект.ДокументОснование) = Тип("ДокументСсылка.ЗаказПокупателя") Тогда
		Объект.ОД_ДоговорСЗаказчиком = Объект.ДокументОснование.Договор;	
	КонецЕсли;
	
	Если ТипЗнч(Объект.ДокументОснование) = Тип("ДокументСсылка.ЗаказПоставщику") Тогда
		Если ЗначениеЗаполнено(Объект.ДокументОснование.ЗаказПокупателя) Тогда
			Объект.ОД_ДоговорСЗаказчиком = Объект.ДокументОснование.ЗаказПокупателя.Договор;	
		Иначе
			Объект.ОД_ДоговорСЗаказчиком = Объект.ДокументОснование.Договор;	
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПроверитьДубльВходящегоНомера()
	
	ТекВхНомер = Объект.НомерВходящегоДокумента;
	ТекСсылка = Объект.Ссылка;
	ТекПост = Объект.Контрагент;
	
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
		//ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Уже существует документ с указанным входящим номером и поставщиком", ЭтотОбъект, "");		
		Возврат Истина;	
	Иначе
		Возврат Ложь;	
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ДиалогСВопросомПроведение()
	Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопросаПроведение",ЭтотОбъект); 
    ПоказатьВопрос(Оповещение,Строка("Уже существует документ с указанным входящим номером и поставщиком. Уверены что хотите записать документ?"),
                    РежимДиалогаВопрос.ДаНет,0,КодВозвратаДиалога.Да,"Записать документ?");	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияВопросаПроведение(Результат, Параметры) Экспорт
	ПараметрыЗаписи=Новый Структура;
    ПараметрыЗаписи.Вставить("ОтказатьВПроведении",НЕ (Результат = КодВозвратаДиалога.Да)); 
	ПараметрыЗаписи.Вставить("РежимЗаписи", РежимЗаписиДокумента.Проведение);
    Записать(ПараметрыЗаписи);	
КонецПроцедуры

&НаКлиенте
Процедура ДиалогСВопросом()
    Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопроса",ЭтотОбъект); 
    ПоказатьВопрос(Оповещение,Строка("Уже существует документ с указанным входящим номером и поставщиком. Уверены что хотите записать документ?"),
                    РежимДиалогаВопрос.ДаНет,0,КодВозвратаДиалога.Да,"Записать документ?");    
КонецПроцедуры
                                                 
&НаКлиенте
Процедура ПослеЗакрытияВопроса(Результат, Параметры) Экспорт
    ПараметрыЗаписи=Новый Структура;
    ПараметрыЗаписи.Вставить("ОтказатьВПроведении",НЕ (Результат = КодВозвратаДиалога.Да));
    Записать(ПараметрыЗаписи);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуОтчетаЖурнала()
	ОткрытьФорму("Отчет.ОД_ЖурналСогласований.Форма");	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьЖурнал()
	ЭтаФорма.ТаблицаЖурнала.Очистить();
		
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ОД_ЖурналДействийСогласовний.Дата КАК Дата,
		|	ОД_ЖурналДействийСогласовний.Пользователь КАК Пользователь,
		|	ОД_ЖурналДействийСогласовний.СтатусСогласования КАК СтатусСогласования
		|ИЗ
		|	РегистрСведений.ОД_ЖурналДействийСогласовний КАК ОД_ЖурналДействийСогласовний
		|ГДЕ
		|	ОД_ЖурналДействийСогласовний.Документ = &ЭтотДок
		|
		|УПОРЯДОЧИТЬ ПО
		|	Дата";
	
	Запрос.УстановитьПараметр("ЭтотДок", Объект.Ссылка);	
	РезультатЗапроса = Запрос.Выполнить();	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		НС = ЭтаФорма.ТаблицаЖурнала.Добавить();
		НС.Дата = "" + ВыборкаДетальныеЗаписи.Дата;
		НС.Статус = "" + ВыборкаДетальныеЗаписи.СтатусСогласования;
		НС.Пользователь = "" + ВыборкаДетальныеЗаписи.Пользователь;
	КонецЦикла;
	
КонецПроцедуры

Функция ПроверитьЗаявкуНаРасходованиеДС() 
  Запрос = Новый Запрос;
    Запрос.Текст =
        "ВЫБРАТЬ
        |	СчетНаОплатуПоставщика.Ссылка КАК Ссылка
        |ИЗ
        |	Документ.СчетНаОплатуПоставщика КАК СчетНаОплатуПоставщика
        |ГДЕ
        |	СчетНаОплатуПоставщика.Номер = &Номер";
    
    Запрос.УстановитьПараметр("Номер", Объект.Номер);
	//Запрос.УстановитьПараметр("ДатаНач", ДатаНач);
	//Запрос.УстановитьПараметр("ДатаКон", ДатаКон);

    РезультатЗапроса = Запрос.Выполнить();
    
    ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
    СписокЗаявок = Новый СписокЗначений;    
    Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
        СписокЗаявок.Добавить(ВыборкаДетальныеЗаписи.ссылка);
    КонецЦикла;
      
    Для Каждого Заявка из СписокЗаявок Цикл
        
        Запрос = Новый Запрос;
        Запрос.Текст =
        "ВЫБРАТЬ РАЗРЕШЕННЫЕ
        |    СвязанныеДокументы.Ссылка.Ссылка
        |ИЗ
        |    КритерийОтбора.СвязанныеДокументы(&Док) КАК СвязанныеДокументы";
        
        Запрос.УстановитьПараметр("Док", Объект.Ссылка);
        
        РезультатЗапроса = Запрос.Выполнить();
        ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
            Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
                //обработка полученных данных 
				Если ВыборкаДетальныеЗаписи.СсылкаСсылка.Пустая() Тогда
					Возврат Ложь
				Иначе 
					//Сообщить(ВыборкаДетальныеЗаписи.Следующий());
					Возврат Истина;
				КонецЕсли;	
            КонецЦикла;
		КонецЦикла;
		
КонецФункции

&НаСервере
Процедура ЗаполнитьОтветственногоПрораба() 
	Если ТипЗнч(Объект.ДокументОснование.Ссылка) = Тип("ДокументСсылка.ЗаказПоставщику") И НЕ Объект.ДокументОснование.Ссылка.Пустая() Тогда   
		Объект.ОД_ОтветственныйПрораб = Объект.ДокументОснование.ОД_ОтветственныйПрораб;
	Иначе
		Объект.ОД_ОтветственныйПрораб = Справочники.Сотрудники.ПустаяСсылка();	
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОД_ОповеститьПрорабаПосле(Команда)
	// Вставить содержимое обработчика.
	Перем ВыбЗнач;
	Массив = Новый Массив;
	ДопПараметры = Объект.Ссылка;	
	Массив.Добавить(Тип("Дата"));
	КД = Новый КвалификаторыДаты(ЧастиДаты.ДатаВремя);
	ОписаниеТипов = Новый ОписаниеТипов(Массив, КД);
	//Оповещение = Новый ОписаниеОповещения("ОтправитьСообщениеTG", ЭтотОбъект, ДопПараметры);
	//ПоказатьВводЗначения(Оповещение,ВыбЗнач, "Укажите причину доработки", ОписаниеТипов);
	Оповещение = Новый ОписаниеОповещения("ОтправитьСообщениеTG", ЭтотОбъект, ДопПараметры);
	ПоказатьВводЗначения(Оповещение,ВыбЗнач, "Укажите дату доставки", ОписаниеТипов);
КонецПроцедуры

 &НаКлиенте
 Процедура ОтправитьСообщениеTG(ВыбЗнач, ДопПараметры) Экспорт
	 СтрТовары = " ";
	 Для Каждого Товар Из Объект.Запасы Цикл 
		 СтрТовары = СтрТовары  + "
		 |" + Товар.Номенклатура + " " +"Количество: " +  Товар.Количество + " " + Товар.ЕдиницаИзмерения + " ";
		 //СтрТовары.Добавить(Товар.Номенклатура +" " + Товар.Количество);
	КонецЦикла;
	ПолучательID = ПолучитьПолучательID(Объект.ОД_ОтветственныйПрораб);
	Токен = ПолучитьТокен(); 

	Заказ =  "Доставка по заказу" + " " +  Объект.Номер + " " + Объект.ОД_ДоговорСЗаказчиком + " Товары в заказе: " + СтрТовары + " 
	|" + "ДАТА ДОСТАВКИ: ";
	ОД_МодульВзаимодействиеTG.ОтправитьСообщениеТелеграмм(ВыбЗнач,ПолучательID,Токен,Заказ);

КонецПроцедуры 

&НаКлиенте
Процедура ОтправитьСообщениеTG2(ВыбЗнач, ДопПараметры) Экспорт 
	
	ПолучательID = ПолучитьПолучательID(Объект.Автор);
	Токен = ПолучитьТокен(); 
	Заказ = Объект.Номер;
	ОД_МодульВзаимодействиеTG.ОтправитьСообщениеТелеграмм(ВыбЗнач,ПолучательID,Токен, Заказ);

КонецПроцедуры

&НаСервере
Функция ПолучитьТокен()
	Возврат Константы.ОД_ТокенTG.Получить();
КонецФункции

&НаСервере
Функция ПолучитьПолучательID(Получатель) 
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Пользователи.TG_ID КАК TG_ID
		|ИЗ
		|	Справочник.Пользователи КАК Пользователи
		|ГДЕ
		|	Пользователи.Ссылка = &Получатель";
	
	Запрос.УстановитьПараметр("Получатель", Получатель);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		// Вставить обработку выборки ВыборкаДетальныеЗаписи
		 ПолучательID = ВыборкаДетальныеЗаписи.TG_ID;
		 Возврат ПолучательID;
	КонецЦикла;
		
		
КонецФункции

&НаКлиенте
Процедура ОД_ЗапланироватьОплатуПриИзмененииПосле(Элемент)
	Если ПроверитьСтатусСчетаНаСервере() Тогда
		Объект.ЗапланироватьОплату = Истина;
	Иначе 
		ПоказатьПредупреждение(Новый ОписаниеОповещения("ОД_ЗапланироватьОплатуПриИзмененииПослеЗавершение", ЭтотОбъект),"Счет должен быть согласован!",,"Счет не согласован!");
		Объект.ЗапланироватьОплату = Ложь;
		Объект.ПлатежныйКалендарь.Очистить();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОД_ЗапланироватьОплатуПриИзмененииПослеЗавершение(ДополнительныеПараметры) Экспорт
	
	Элементы.ПлатежныйКалендарьПроцентОплаты.Доступность = Ложь;
	Элементы.ПлатежныйКалендарьСуммаОплаты.Доступность = Ложь;
	Элементы.ПлатежныйКалендарьСуммаНДСОплаты.Доступность = Ложь; 
	Элементы.ПлатежныйКалендарьДатаОплаты.Доступность = Ложь;
	Элементы.ПлатежныйКалендарьОбщаяГруппа.Доступность = Ложь;

КонецПроцедуры

&НаСервере
Функция ПроверитьСтатусСчетаНаСервере()
	Если Объект.ОД_Состояние = Перечисления.ОД_СостоянияСчетовНаОплатуОтПоставщиков.Согласован Тогда
		Возврат Истина
	Иначе
		Возврат Ложь
	КонецЕсли;

КонецФункции
#КонецОбласти







