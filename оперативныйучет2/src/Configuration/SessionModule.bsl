#Область ОбработчикиСобытий
&После("УстановкаПараметровСеанса")
Процедура оуп_УстановкаПараметровСеанса(ТребуемыеПараметры)
	//TODO: Вставить содержимое обработчика
	Запрос = новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	оуп_КонтрольныеТочкиИсполнителей.КонтрольнаяТочка,
	|	оуп_КонтрольныеТочкиИсполнителей.ЗапускатьРабочийСтол
	|ИЗ
	|	РегистрСведений.оуп_КонтрольныеТочкиИсполнителей КАК оуп_КонтрольныеТочкиИсполнителей
	|ГДЕ
	|	оуп_КонтрольныеТочкиИсполнителей.Пользователь = &Пользователь";
	запрос.УстановитьПараметр("Пользователь", ПараметрыСеанса.ТекущийПользователь );
	
	Выборка = запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ПараметрыСеанса.оуп_ТекущаяКонтрольнаяТочка = Выборка.КонтрольнаяТочка;	
		возврат;
	КонецЕсли;
	
	ПараметрыСеанса.оуп_ТекущаяКонтрольнаяТочка = справочники.КонтрольнаяТочка.ПустаяСсылка();
//
КонецПроцедуры
#КонецОбласти
