<<<<<<< HEAD
﻿
&AtClient
Procedure CloseClusterManagerForm(Command)
	Close();
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ObjectFieldValues = Parameters.ObjectFieldValues;
	Description = ObjectFieldValues.Description;
	Computer = ObjectFieldValues.ComputerName;
	MainPort = ObjectFieldValues.Port;
	OperationSystemProcess = ObjectFieldValues.ProcessID;
	
	ThisStandartProcessing = FormAttributeToValue("object");
	DocumentationLink = ThisStandartProcessing.GetLinkDocumentation("cluster manager");
	If IsBlankString(DocumentationLink) Then
		Items.ItemDocumentationLink.Visible = False;
	EndIf;
EndProcedure

&AtClient
Procedure ItemDocumentationLinkClick(Item)
	GotoURL(DocumentationLink);
EndProcedure

&AtClient
Procedure DocumentationHelp(Command)
	GotoURL(DocumentationLink);
EndProcedure

=======
﻿
&AtClient
Procedure CloseClusterManagerForm(Command)
	Close();
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ObjectFieldValues = Parameters.ObjectFieldValues;
	Description = ObjectFieldValues.Description;
	Computer = ObjectFieldValues.ComputerName;
	MainPort = ObjectFieldValues.Port;
	OperationSystemProcess = ObjectFieldValues.ProcessID;
	
	ThisStandartProcessing = FormAttributeToValue("object");
	DocumentationLink = ThisStandartProcessing.GetLinkDocumentation("cluster manager");
	If IsBlankString(DocumentationLink) Then
		Items.ItemDocumentationLink.Visible = False;
	EndIf;
EndProcedure

&AtClient
Procedure ItemDocumentationLinkClick(Item)
	GotoURL(DocumentationLink);
EndProcedure

&AtClient
Procedure DocumentationHelp(Command)
	GotoURL(DocumentationLink);
EndProcedure

>>>>>>> f3f19a63ed53bdfa614d9191f48ffaf36859af97
