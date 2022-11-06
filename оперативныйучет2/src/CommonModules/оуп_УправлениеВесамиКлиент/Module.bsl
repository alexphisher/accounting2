#Область ПрограммныйИнтерфейс
Процедура подключитьДрайвер (Ссылка, Драйверподключен, ИД_устройства, ОбъектДрайвера)   Экспорт 

	Наименование = оуп_УправлениеВесамиВызовСервера.ПолучитьРеквизитВесов(Ссылка,"Наименование");
	
	если Наименование = Неопределено Тогда 
		Драйверподключен = ложь;
		Возврат;
	КонецЕсли;
	
	если Наименование = "MassaK" Тогда 
		Попытка
			ПодключитьВнешнююКомпоненту(
				оуп_УправлениеВесамиВызовСервера.ПолучитьРеквизитВесов(Ссылка, "путьДоКомпоненты"),
				"ID",
				ТипВнешнейКомпоненты.Native
			);
			
			ОбъектДрайвера = Новый("AddIn.ID.MassaKDriverR1C");
			ОбъектДрайвера.УстановитьПараметр("ip", 		оуп_УправлениеВесамиВызовСервера.ПолучитьРеквизитВесов(Ссылка,"ip"));
			//ОбъектДрайвера.УстановитьПараметр("port", 		Ссылка.port);
			//ОбъектДрайвера.УстановитьПараметр("connect", 	Ссылка.connect);
			//
			//Дрв.УстановитьПараметр("com", "COM1");
			//Дрв.УстановитьПараметр("connect", "serial");
			
			
			Драйверподключен = ОбъектДрайвера.Подключить(ИД_устройства);
		Исключение
			Драйверподключен = ложь;
			СообщитьОшибку(ОбработкаОшибок.ПодробноеПредставлениеОшибки(
				ИнформацияОбОшибке()
			));
		КонецПопытки;
		
	ИначеЕсли Наименование = "ШтрихМ" Тогда 
		Попытка 
			ОбъектДрайвера = Новый COMОбъект ("AddIn.DrvLP");
			ОбъектДрайвера.RemoteHost = оуп_УправлениеВесамиВызовСервера.ПолучитьРеквизитВесов(Ссылка,"ip");
			ОбъектДрайвера.Connect();
			Драйверподключен = Истина;
		Исключение
			Драйверподключен = ложь;
			СообщитьОшибку(ОбработкаОшибок.ПодробноеПредставлениеОшибки(
				ИнформацияОбОшибке()
			));
			
		КонецПопытки;
	ИначеЕсли Наименование = "ТензоМ" Тогда
		Попытка 
			ОбъектДрайвера = Новый COMОбъект("Controller.ScAuto"); 
			Драйверподключен = Истина;
		Исключение
			Драйверподключен = ложь;
			СообщитьОшибку(ОбработкаОшибок.ПодробноеПредставлениеОшибки(
				ИнформацияОбОшибке()
			));
		КонецПопытки;
		
	КонецЕсли;

	
КонецПроцедуры

Процедура ПолучитьВес (Количество, ИД_устройства, ОбъектДрайвера, ССылка) Экспорт 
	Наименование = Ссылка.Наименование;
		
	если Наименование = "MassaK" Тогда
		ОбъектДрайвера.ПолучитьВес(ИД_устройства, Количество);
	ИначеЕсли Наименование = "ШтрихМ" Тогда
		если не  УстановитьСоединениеСВесами_штрихМ(ОбъектДрайвера) Тогда
			Возврат;	
		КонецЕсли;
		
		Если ОбъектДрайвера.ResultCode = 0 Тогда 
			Количество =ОбъектДрайвера.Weight;		
		КонецЕсли;
		
	ИначеЕсли Наименование = "ТензоМ" Тогда
		Пока ОбъектДрайвера.GetStatus(1,1)="-5003" Цикл
			Количество = ОбъектДрайвера.GetWeight(1,1);
		КонецЦикла;	
		Количество = ОбъектДрайвера.GetWeight(1,1);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура  отключитьДрайвер (Ссылка, ОбъектДрайвера, ИД_устройства, Драйверподключен) Экспорт 
	если Ссылка.Наименование = "MassaK" Тогда
		если Драйверподключен Тогда 
			ОбъектДрайвера.Отключить(ИД_устройства);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры


#КонецОбласти


#Область СлужебныеПроцедурыИФункции

функция УстановитьСоединениеСВесами_штрихМ (ОбъектДрайвера)
	ОбъектДрайвера.connect();
		
	Если ОбъектДрайвера.ResultCode <> 0 Тогда	
		Возврат ложь;
	КонецЕсли;
		
	ОбъектДрайвера.GetLPStatus();

	Возврат Истина;
Конецфункции

Процедура СообщитьОшибку(текстСообшения)
	Сообщение = новый СообщениеПользователю();
	Сообщение.Текст = текстСообшения;
	Сообщение.Сообщить(); 	
КонецПроцедуры

#КонецОбласти

