#Область ПрограммныйИнтерфейс

Функция ПолучитьРеквизитВесов(Ссылка, ИмяРеквизита) Экспорт
	
	если Ложь Тогда
		ссылка = справочники.ВесыКонтрольныхТочек.НайтиПоКоду("");
	КонецЕсли;
	
	возврат Ссылка[ИмяРеквизита];
	
КонецФункции

#КонецОбласти

