
#Область ОбработчикиСобытийФормы
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	если не ЗначениеЗаполнено(Объект.ВерсияДанных) Тогда
		Объект.Автор = ПараметрыСеанса.ТекущийПользователь;	
	КонецЕсли;
	если Объект.Проведен Тогда
		//@skip-check module-unused-local-variable
		ТолькоПросмотр = Истина;
	КонецЕсли;
	КонтрольнаяТочка = ПараметрыСеанса.оуп_ТекущаяКонтрольнаяТочка;
	если КонтрольнаяТочка.Пустая() Тогда
		ТолькоПросмотр = Истина;	
	КонецЕсли;
	ЗаполнитьРеквизитыПриСоздании();
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	//TODO: Вставить содержимое обработчика
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы
&НаКлиенте
Процедура ПодборОстатков(Команда)
		ПараметрыВыбораОстатка = Новый Структура("Склад, Организация", объект.СкладОтправитель, объект.ОрганизацияОтправитель );
	ОткрытьФорму("документ.оуп_ПакетДокументовПередачиПереработчику.форма.ФормаПодборОстатки", 
		ПараметрыВыбораОстатка,,,,,, РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
КонецПроцедуры


#КонецОбласти

//@skip-check module-structure-top-region
#Область ОбработчикиСобытийЭлементовТаблицыФормытовары1
&НаКлиенте
Процедура товары1Выбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
//	//TODO: Вставить содержимое обработчика
//	ТекСтрока = объект.товары.Получить(ВыбраннаяСтрока);
//	НавССылка = ПолучитьНавигационнуюСсылку(ТекСтрока.Документ);
//	ПерейтиПоНавигационнойСсылке(НавССылка);
КонецПроцедуры

&НаКлиенте
Процедура товары1ПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, ЭтоГруппа, Параметр)
	//TODO: Вставить содержимое обработчика
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура товары1ПередУдалением(Элемент, Отказ)
	//TODO: Вставить содержимое обработчика
	Отказ = Истина;
КонецПроцедуры
#КонецОбласти

//@skip-check module-structure-top-region
#Область СлужебныеПроцедурыИФункции
&НаСервере
Процедура ЗаполнитьРеквизитыПриСоздании()
	Объект.СкладОтправитель = контрольнаяточка.Склад;
	Объект.ОрганизацияОтправитель = КонтрольнаяТочка.Организация;
	ПараметрыЗапроса = Новый Структура("организация", Объект.ОрганизацияОтправитель );
	
	ПараметрыПередачи = оуп_ПередачаВПереработку.ПолучитьПараметрыПередачиВПроизводство(ПараметрыЗапроса);
	если ПараметрыПередачи.код = 0 Тогда
		Возврат;
	КонецЕсли;
	Объект.ПартнерДавалец = ПараметрыПередачи.ПартнерДавалецСырья;
	Объект.ДоговорПоступления = ПараметрыПередачи.ДоговорПоступленияСырья;
	Объект.ОрганизацияПолучатель = ПараметрыПередачи.ОрганизацияПереаботчик;
	Объект.Переработчик = ПараметрыПередачи.ПереработчикПартнер;
	Объект.ДоговорПереработки = ПараметрыПередачи.ДоговорПереработки;
КонецПроцедуры

#КонецОбласти
