
#Область ОбработчикиСобытийФормы
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	параметры.Свойство("Склад", Склад);
	параметры.Свойство("Организация", Организация);
	если склад.Пустая() или Организация.Пустая() Тогда
		отказ = Истина;
	КонецЕсли;
	ОбновитьОстаткиОрганизации();
	
КонецПроцедуры
#КонецОбласти

#Область СлужебныеПроцедурыИФункции
&НаСервере
Процедура ОбновитьОстаткиОрганизации() 
	ПараметрыЗапроса = Новый Структура("Склад, Организация", Склад, Организация);
	
	АдресТаблицы = оуп_ПередачаВПереработкуВызовСервера.ПолучитьОстаткиДляПередачиВПереработку(ПараметрыЗапроса);
	Таблица = ПолучитьИзВременногоХранилища(АдресТаблицы);
	ЗначениеВРеквизитФормы(Таблица, "Остатки");
КонецПроцедуры
#КонецОбласти