
&AtServer
Procedure ПриСозданииНаСервере(Cancel, StandardProcessing)
	Items.ItemInfobaseDeleteModeDescription.Title = NStr("ru = 'При удалении информационной базы можно выбрать 
		|одно из 3-х действий над базой данных, в которой содержатся
		|данные информационной базы: 
		|- удалить базу данных целиком;
		|- очистить базу данных, убрав из нее все данные информационной базы;
		|- оставить базу данных и ее содержимое без именений.';SYS='InfobaseDeleteMode.Description'");
	ThisStandartProcessing = FormAttributeToValue("object");
	DocumentationLink = ThisStandartProcessing.GetLinkDocumentation("remove infobase");
	If IsBlankString(DocumentationLink) Then
		Items.ItemDocumentationLink.Visible = False;
	EndIf;
EndProcedure

&AtClient
Procedure CanсelSelectDatabaseDeleteMode(Command)
	Close();
EndProcedure

&AtClient
Procedure NoAсtionsWithDatabase(Command)
	Close(AdministrationInfoBaseDeletionMode.DontPerformActionsWithDatabase);
EndProcedure

&AtClient
Procedure ClearDatabase(Command)
	Close(AdministrationInfoBaseDeletionMode.ClearDatabase);
EndProcedure

&AtClient
Procedure DeleteDataBase(Command)
	Close(AdministrationInfoBaseDeletionMode.DeleteDatabase);
EndProcedure

&AtClient
Procedure ItemDocumentationLinkClick(Item)
	GotoURL(DocumentationLink);
EndProcedure

&AtClient
Procedure DocumentationHelp(Command)
	GotoURL(DocumentationLink);
EndProcedure

