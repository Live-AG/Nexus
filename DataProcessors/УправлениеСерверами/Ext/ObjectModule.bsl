&AtServer
Function GetLinkDocumentation(ItemName) Export
	Var InterfaceLanguage, LinkTemplate, ObjectArea, LocaleArea;
	InterfaceLanguage = Left(CurrentLocaleCode(), 2);
	LinkTemplate = GetTemplate("DocumentationLinkTemplate");
	ObjectArea = LinkTemplate.Area("Object");
	LocaleArea = LinkTemplate.Areas.Find(InterfaceLanguage);
	DocumentationLink = Undefined;
	If LocaleArea <> Undefined Then
		For LineNumber = 1 To LinkTemplate.TableHeight Do
			If (LinkTemplate.Area(LineNumber, ObjectArea.Left).Text = ItemName) Then
				DocumentationLink = LinkTemplate.Area(LineNumber, LocaleArea.Left).Text; 		
				Break;	
			EndIf;
		EndDo;
	EndIf;
	if StrLen(DocumentationLink) > 0 Then
		CurrentSystemInfo = New SystemInfo();
		AppVersion = CurrentSystemInfo.AppVersion;
		TemporaryString = "";
		While Find(AppVersion, ".") > 0 Do
			CurrentOffset = Find(AppVersion, ".");
			TemporaryString = TemporaryString + Left(AppVersion, CurrentOffset);
			AppVersion = Right(AppVersion, StrLen(AppVersion) - CurrentOffset); 
		EndDo;
		TemporaryString = StrReplace(TemporaryString, ".", "");
		DocumentationLink = StrReplace(DocumentationLink, "%*%", TemporaryString);	 
	EndIf;
	Return DocumentationLink;
EndFunction