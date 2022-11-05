#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	СтандартнаяОбработка = ложь;
	
	КонтрольнаяТочка = ПараметрыСеанса.оуп_ТекущаяКонтрольнаяТочка;
	если КонтрольнаяТочка.Пустая() Тогда
		Отказ = Истина;
	КонецЕсли;
	
	ОбновитьИСоздатьСтраницыФормы();
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаполнитьДанныеВыпускаПоСпецификации(Команда)
	сткРезультат = ПолучитьСпецицикациюКоманды(СтрЗаменить(Команда.Имя, "_КнопкаФормы_",""));
	если сткРезультат.код = 1 Тогда 
		сткПараметры = Новый Структура;
		сткПараметры.Вставить("Спецификация", 		сткРезультат.Значение);
		сткПараметры.Вставить("КонтрольнаяТочка", 	КонтрольнаяТочка);
		//@skip-check use-non-recommended-method
		сткПараметры.Вставить("ДатаСмены",			ТекущаяДата());
		ОткрытьФорму("Обработка.оуп_ЛинияРаспила.Форма.ЗаполнениеПоСпецификации", сткПараметры, ЭтотОбъект, ,,,, РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
&НаСервере
Процедура СформироватьТаблицуКоманд()

	тз = КонтрольнаяТочка.МатрицаВыпуска.Выгрузить();
	отбор = новый Структура("Активна", Истина);
	СТрокиПоОтборку =тз.Скопировать(отбор);
	Счетчик = 0;
	таблицаКоманд.Очистить();
	для Каждого строка из СТрокиПоОтборку Цикл 
		СтрокаКоманд = таблицаКоманд.Добавить();
		СтрокаКоманд.ИД = "Команда_Формы_" + строка(Счетчик);
		СтрокаКоманд.Спецификация = строка.Спецификация;
		СтрокаКоманд.Представление = строка.Спецификация.Наименование;
		СтрокаКоманд.КодСтраницы =  строка.Страница.Наименование;
		СтрокаКоманд.ПредставлениеСтраницы =  строка.Страница.ИмяНаФорме;
		Счетчик = Счетчик +1;
	КонецЦикла;
	

КонецПроцедуры

&НаСервере
Функция ЗаполнитьСтраницыФормы()
	сткВозврат = новый Структура("массивЭлементов, массивКоманд, МассивРеквизитов");
	массивЭлементов = новый Массив;
	массивКоманд = новый Массив;
	МассивРеквизитов = Новый Массив;
	
	группа = Элементы.СписокКоманд;
	массивЭлементов.Добавить(группа.Имя);
	
	СформироватьТаблицуКоманд();
	
	
	тзСтраниц = таблицаКоманд.Выгрузить();
	тзСтраниц.Свернуть("КодСтраницы, ПредставлениеСтраницы");
	
	
	для Каждого СтраницаКоманд из тзСтраниц Цикл 
		страница = оуп_ФормированиеФорм.ДобавитьСтраницу (
			ЭтотОбъект,
			группа,
			СтраницаКоманд.КодСтраницы,
			СтраницаКоманд.ПредставлениеСтраницы
			);
		массивЭлементов.Добавить(страница.Имя);

		отборСтраницы = новый Структура;
		отборСтраницы.Вставить("КодСтраницы", СтраницаКоманд.КодСтраницы);
		табКомандПоСтранице = таблицаКоманд.Выгрузить().Скопировать(отборСтраницы);
		сччетчик = 0;
		ГруппаЭлемента = оуп_ФормированиеФорм.ДобавитьгруппуОбычную(
			ЭтотОбъект, 
			"ГруппаСтраница_" + страница.Имя,
			 страница
			 );
		
		для Каждого строкаКоманда из табКомандПоСтранице Цикл
			если сччетчик%5= 0 Тогда 
				ГруппаЭлемента = оуп_ФормированиеФорм.ДобавитьгруппуОбычную(
					ЭтотОбъект, 
					"ГруппаСтраница_" + страница.Имя +"_"+ сччетчик, 
					страница
					);
			КонецЕсли;

			Представление = строкаКоманда.Представление; 

			НоваяКоманда = оуп_ФормированиеФорм.ДобавитьКоманду(
				ЭтотОбъект, 
				строкаКоманда.ИД,
				 "КопмлектацияНоменклатуры", 
				 Представление
			);
			массивКоманд.Добавить(НоваяКоманда.Имя);
			
			НовыйЭлемент = оуп_ФормированиеФорм.ДобавитьКнопкуКоманды(
				строкаКоманда.ИД, 
				ГруппаЭлемента, 
				ЭтотОбъект); 
			массивЭлементов.Добавить(НовыйЭлемент.Имя);
			
			сччетчик = сччетчик + 1;

		КонецЦикла;
		

		
	КонецЦикла;
	

	сткВозврат.массивЭлементов = массивЭлементов;
	сткВозврат.массивКоманд = массивКоманд;
	сткВозврат.МассивРеквизитов = МассивРеквизитов;
	
	Возврат сткВозврат;
КонецФункции

&НаСервере
Процедура поместитьАдресаЭлементовВХранилище(сткРеультат)

	АдресМассиваЭлементов = ПоместитьВоВременноеХранилище(
		сткРеультат.массивЭлементов, 
		УникальныйИдентификатор
	);
	АдресМассиваКоманд = ПоместитьВоВременноеХранилище(
		сткРеультат.массивКоманд,
	 	УникальныйИдентификатор
	 );
	АдресМассиваРеквизитов = ПоместитьВоВременноеХранилище(
		сткРеультат.МассивРеквизитов,
		УникальныйИдентификатор
	);

КонецПроцедуры // поместитьВХранилище()

&НаСервере
Процедура УдалитьСозданныеЭлементы(Адрес, Тип)

	массив = ПолучитьИзВременногоХранилища(Адрес);
	для Каждого элемент из массив Цикл 
		если ЭтотОбъект[Тип].Найти(элемент) = Неопределено Тогда 
			Продолжить;
		КонецЕсли;
		Попытка
			ЭтотОбъект[Тип].Удалить(ЭтотОбъект[Тип][элемент]);	
		Исключение
			сообщение = новый СообщениеПользователю();
			Сообщение.Текст = ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке());		
			Сообщение.Сообщить();
		КонецПопытки;
		
	КонецЦикла;

КонецПроцедуры // УдалитьСозданныеЭлементы()

&НаСервере
Процедура ОбновитьИСоздатьСтраницыФормы()
	если не ПустаяСтрока(АдресМассиваЭлементов) Тогда 
		УдалитьСозданныеЭлементы(АдресМассиваЭлементов, "Элементы");

	КонецЕсли;
		
	
	если не ПустаяСтрока(АдресМассиваКоманд) Тогда 
		УдалитьСозданныеЭлементы(АдресМассиваКоманд, "Команды");
	КонецЕсли;
	
		если ЗначениеЗаполнено(АдресМассиваРеквизитов) Тогда 
		массивРекв = ПолучитьИзВременногоХранилища(АдресМассиваРеквизитов);
		массивУдаления = новый Массив;
		для Каждого эл из массивРекв Цикл 
			Попытка			
				если не ЗначениеЗаполнено(эл.имя) Тогда 
					массивУдаления.Добавить(эл.путь);
					Продолжить;
				КонецЕсли;
			
				
				массивУдаления.Добавить(эл.путь + "."+ эл.имя);
			Исключение
				сообщение = новый СообщениеПользователю();
				Сообщение.Текст = ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке());		
				Сообщение.Сообщить();
			КонецПопытки;
			
			
		КонецЦикла;
		
		ИзменитьРеквизиты(, массивУдаления);
	КонецЕсли;
	СтраницыИРеквизитыСтруктура = ЗаполнитьСтраницыФормы();
	поместитьАдресаЭлементовВХранилище(СтраницыИРеквизитыСтруктура);
КонецПроцедуры

&НаСервере
Функция  ПолучитьСпецицикациюКоманды(ИД)
	сткВозврат = новый Структура("Код, Значение");
	
	тз = таблицаКоманд.Выгрузить();
	отбор = новый Структура;
	отбор.Вставить("ИД", ИД);
	строки = тз.НайтиСтроки(отбор);
	если строки.Количество() = 0 Тогда 
		сткВозврат.Код = 0;
		Возврат сткВозврат;
	КонецЕсли;
	
	для Каждого Строка из Строки Цикл 
		сткВозврат.Код = 1;
		сткВозврат.Значение = строка.Спецификация;
		Возврат сткВозврат;
	КонецЦикла;
	
КонецФункции // ПолучитьСпецицикациюКоманды()


#КонецОбласти