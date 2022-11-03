#Область СлужебныйПрограммныйИнтерфейс
Функция ПолучитьПараметрыПередачиВПроизводство(Параметры) Экспорт
	//@skip-check structure-consructor-too-many-keys
	сткВозврат = новый Структура("Код, Организация, ПереработчикПартнер, ДоговорПереработки, 
	|ОрганизацияПереаботчик, ПартнерДавалецСырья, ДоговорПоступленияСырья");
	сткВозврат.Код = 0;
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
		|	НастройкиПередачиВПереработку.Организация,
		|	НастройкиПередачиВПереработку.ПереработчикПартнер,
		|	НастройкиПередачиВПереработку.ДоговорПереработки,
		|	НастройкиПередачиВПереработку.ОрганизацияПереаботчик,
		|	НастройкиПередачиВПереработку.ПартнерДавалецСырья,
		|	НастройкиПередачиВПереработку.ДоговорПоступленияСырья
		|ИЗ
		|	РегистрСведений.НастройкиПередачиВПереработку КАК НастройкиПередачиВПереработку
		|ГДЕ
		|	НастройкиПередачиВПереработку.ФормироватьДокументыПередачи
		|	И НастройкиПередачиВПереработку.Организация = &Организация";
	
	Запрос.УстановитьПараметр("Организация", Параметры.Организация);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(сткВозврат, ВыборкаДетальныеЗаписи);
		сткВозврат.Код = 1;
	КонецЦикла;
	
	Возврат сткВозврат;

КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПередачаПереработчику
// Создает документ передачи переработчику. 2.5
//@skip-check doc-comment-export-function-return-section
//@skip-check doc-comment-parameter-section
Функция СформироватьДокументПередачи(сткНастройки, ПакетДокументов) Экспорт 
	Если Ложь Тогда
		ПакетДокументов = документы.оуп_ПакетДокументовПередачиПереработчику.СоздатьДокумент();
	КонецЕсли;
	
	
	//документ = документы.ПередачаСырьяПереработчику.СоздатьДокумент();
	документ = документы.ПередачаТоваровХранителю.СоздатьДокумент();
	документ.Заполнить(Неопределено);
	Документ.Дата = ТекущаяДатаСеанса() ;
	Документ.Валюта = Константы.ВалютаРегламентированногоУчета.Получить();
	ЗаполнитьЗначенияСвойств(Документ,сткНастройки);
	для Каждого СтрокаТовар из ПакетДокументов.Товары Цикл 
		СтрокаДокумента = документ.Товары.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаДокумента, СтрокаТовар);
		СтрокаДокумента.КоличествоУпаковок = СтрокаДокумента.Количество;
		СтрокаДокумента.Склад = Документ.Склад;
		если ЗначениеЗаполнено(СтрокаТовар.Серия) Тогда 
			СтрокаДокумента.СтатусУказанияСерий = 14;	
		КонецЕсли;
		
	КонецЦикла;
	
	ЗаполнитьСтатусУказанияСерийПередачаВПереработчику_25(Документ);

	Возврат документ;
КонецФункции // СформироватьДокументПередачи()

//Статусы укащания серий передача переработчику 2.5
Процедура ЗаполнитьСтатусУказанияСерийПередачаВПереработчику_25(Документ)
	
	МенеджерОбъекта = Документы.ПередачаТоваровХранителю;
	
	ПараметрыУказанияСерий = Новый ФиксированнаяСтруктура(
	НоменклатураСервер.ПараметрыУказанияСерий(Документ, МенеджерОбъекта)
	);
		
	ПроверитьСериюРассчитатьСтатус = Новый Структура;
	ПроверитьСериюРассчитатьСтатус.Вставить("Склад",                  документ.Склад);
	ПроверитьСериюРассчитатьСтатус.Вставить("ПараметрыУказанияСерий", ПараметрыУказанияСерий);
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПроверитьСериюРассчитатьСтатус",        ПроверитьСериюРассчитатьСтатус);
	
	ОбработкаТабличнойЧастиСервер.ОбработатьТЧ(документ.Товары, СтруктураДействий, Неопределено);
	
КонецПроцедуры
#КонецОбласти

#Область ПуступлениеУПереработчика
// Создает документ поступления товаров у Переработчика от Давальца 
// Приобретение товаров
//@skip-check doc-comment-export-function-return-section
//@skip-check doc-comment-parameter-section
Функция  СформироватьДокументПоступления(сткНастройки, тчТовары) Экспорт 
	
	документ = документы.ПриобретениеТоваровУслуг.СоздатьДокумент();
	документ.Заполнить(Неопределено);
	
	документ.Дата = ТекущаяДатаСеанса();
	
	ЗаполнитьЗначенияСвойств(документ, сткНастройки); 
	документ.Комментарий = "#ПоступлениеСырьяОтДавальца.";
	документ.НаименованиеВходящегоДокумента= "Передача сырья переработчику";
	документ.Контрагент = ПартнерыИКонтрагенты.ПолучитьКонтрагентаПартнераПоУмолчанию(Документ.Партнер);
	
	
	ПараметрыЗаполнения = Документы.ПриобретениеТоваровУслуг.ПараметрыЗаполненияНалогообложенияНДСЗакупки(документ);
	УчетНДСУП.ЗаполнитьНалогообложениеНДСЗакупки(документ.НалогообложениеНДС, ПараметрыЗаполнения, Неопределено);
	
	ПараметрыЗаполнения = Документы.ПриобретениеТоваровУслуг.ПараметрыЗаполненияВидаДеятельностиНДС(документ);
	
	УчетНДСУП.ЗаполнитьВидДеятельностиНДС(документ.ЗакупкаПодДеятельность, ПараметрыЗаполнения, неопределено);
	
	документ.ВариантПриемкиТоваров = ЗакупкиСервер.ПолучитьВариантПриемкиТоваров();
	
	если не ЗначениеЗаполнено (документ.ВалютаВзаиморасчетов) тогда
		документ.ВалютаВзаиморасчетов = Константы.ВалютаРегламентированногоУчета.Получить();
	конецесли;
	
	если не ЗначениеЗаполнено (документ.Валюта) тогда
		документ.Валюта = Константы.ВалютаРегламентированногоУчета.Получить();
	конецесли;
	
	для Каждого СтрокаТовар из тчТовары Цикл 
		СтрокаДокумента = Документ.Товары.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаДокумента, СтрокаТовар);
		СтрокаДокумента.КоличествоУпаковок = СтрокаДокумента.Количество;
		СтрокаДокумента.СтавкаНДС = СтрокаДокумента.Номенклатура.СтавкаНДС;
		//@skip-check wrong-type-expression
		СтрокаДокумента.Цена = 0.01;
		//@skip-check wrong-type-expression
		СтрокаДокумента.Сумма = СтрокаДокумента.Количество * СтрокаДокумента.Цена;
		СтрокаДокумента.СуммаСНДС = СтрокаДокумента.Сумма;
		СтрокаДокумента.Склад = документ.Склад;
		
	КонецЦикла;
	СтатусУказанияСерийПоступление(Документ);
	
	документ.СуммаДокумента = документ.Товары.Итог("СуммаСНДС");
	
	
	
	Возврат документ;
КонецФункции // СформироватьДокументПоступления()

//Статусы указания серий для поступления товаров
Процедура СтатусУказанияСерийПоступление(документ)
	СтруктураДействий = новый Структура;
	ПараметрыУказанияСерий = документы.ПриобретениеТоваровУслуг.ПараметрыУказанияСерий(Документ);
	СтруктураДействий.Вставить("ПроверитьСериюРассчитатьСтатус", Новый Структура("Склад, ПараметрыУказанияСерий", Документ.Склад, ПараметрыУказанияСерий));
	ОбработкаТабличнойЧастиСервер.ОбработатьТЧ(Документ.Товары, СтруктураДействий, Неопределено);
	
КонецПроцедуры
#КонецОбласти


#КонецОбласти