#Область ПрограммныйИнтерфейс
Функция ЗаполнитьСтруктуруПараметровДокументПереработки(Документ)  Экспорт 
	если Ложь тогда 
		Документ = документы.оуп_ПакетДокументовПередачиПереработчику.СоздатьДокумент();		
	КонецЕсли;
	
	//@skip-check structure-consructor-too-many-keys
	сткНастройки = новый Структура("Организация, Партнер, Договор, Склад, ХозяйственнаяОперация", 
	Документ.ОрганизацияОтправитель, 
	Документ.Переработчик, 
	Документ.ДоговорПереработки, 
	Документ.СкладОтправитель,
	Перечисления.ХозяйственныеОперации.ПередачаПереработчику2_5
	);
		
	Возврат сткНастройки
	
КонецФункции // ЗаполнитьСтруктуруПараметровДокументПереработки()

Функция ЗаполнитьСтруктуруПараметровДокументПоступления(Документ) Экспорт
	если Ложь Тогда
		Документ = документы.оуп_ПакетДокументовПередачиПереработчику.СоздатьДокумент();
	КонецЕсли;
	 
	
	//@skip-check structure-consructor-too-many-keys
	сткНастройки = новый Структура("Организация, Партнер, Договор, Склад", 
	Документ.ОрганизацияПолучатель, 
	Документ.ПартнерДавалец, 
	Документ.ДоговорПоступления, 
	Документ.СкладПолучатель
	);
	
	
	Возврат сткНастройки
	
КонецФункции // ЗаполнитьСтруктуруПараметровДокументПереработки()

Функция СформироватьДокументПередачи(Параметры, ПакетДокументов) Экспорт
	возврат оуп_ПередачаВПереработку.СформироватьДокументПередачи(Параметры, ПакетДокументов)	;
КонецФункции

Функция СформироватьДокументПоступления(Параметры, тчТовары) Экспорт
	возврат оуп_ПередачаВПереработку.СформироватьДокументПоступления(Параметры, тчТовары);
КонецФункции

Функция ПолучитьОстаткиДляПередачиВПереработку(Параметры) Экспорт
	возврат оуп_ПередачаВПереработку.ПолучитьОстаткиДляПередачиВПереработку(Параметры);
КонецФункции

#КонецОбласти


