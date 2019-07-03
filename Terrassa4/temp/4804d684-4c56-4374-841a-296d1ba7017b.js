importPackage(java.util);
importPackage(java.lang);
importPackage(Packages.java.io);
importPackage(Packages.javax.xml.parsers);
importClass(javax.xml.parsers.DocumentBuilder);
importClass(javax.xml.parsers.DocumentBuilderFactory);
importPackage(Packages.javax.xml);
importPackage(Packages.javax.xml.xpath);
importClass(javax.xml.xpath.XPathFactory);
importClass(javax.xml.xpath.XPathConstants);
importClass(org.w3c.dom.NodeList);
importPackage(net.compart.cplib.docponent);
fileVariables.EsUltimaPagina 		= pageVariables.PageIsLast;
processVariables.PaginaDocumento 	= pageVariables.PageNumber;
var numeroPaginas = parseInt(processVariables.PaginaDocumento)+1;
var parImpar = numeroPaginas % 2;
if (parImpar == 1) {
	processVariables.FicheroImpar = true;
} else {processVariables.FicheroImpar = false;}

/*if(page.isLandscape())
      page.setRotation(90);
var leftSpace 	= new Length(frame, "0mm");
var rightSpace 	= new Length(frame, "0mm");
var topSpace 	= new Length(frame, "0mm");
var bottomSpace = new Length(frame, "0mm");
page.setFitToPrintableAreaFormat(Page.Paperformat.A4, Page.Orientation.Portrait, leftSpace, rightSpace, topSpace, bottomSpace);*/

if (processVariables.PaginaDocumento == 1) {
	try{
		processVariables.NumeroDocumento 	= parseInt(processVariables.NumeroDocumento)+1;
		fileVariables.nombreFicheroSalida 	= "Terrassa.pdf";
		var builderFactory 					= DocumentBuilderFactory.newInstance();
		var builder 						= builderFactory.newDocumentBuilder();
		var xPath 							= XPathFactory.newInstance().newXPath();
		var confUID 						= new FileInputStream(new File(fileVariables.InputFileDirectory+ "/ConfTrabajo.xml"));
		var xmlDocumentUID 					= builder.parse(confUID);
		var xPathUID 						= XPathFactory.newInstance().newXPath();
		nodeList 							= xPathUID.compile("//trabajo/cod_orden_trabajo").evaluate(xmlDocumentUID, XPathConstants.NODESET);
		processVariables.UID 				= nodeList.item(0).getFirstChild().getNodeValue();
		nodeList 							= xPathUID.compile("//trabajo/cod_subtrabajo_f1").evaluate(xmlDocumentUID, XPathConstants.NODESET);
		processVariables.UID 				= processVariables.UID+ nodeList.item(0).getFirstChild().getNodeValue();
		fileVariables.dir 					= fileVariables.InputFileDirectory.replace("/proceso","/normal")+"/"+"Terrassa_FC.xml";
	} catch (e) {logger.error("Error al configurar las rutas de salida.");}
}