var paginasIni 							= parseInt(processVariables.pagacumuladas);

var pagDiferencia = 1;
if (processVariables.FicheroImpar == "true")
	pagDiferencia = pagDiferencia + 1;

var paginasFin 							= parseInt(processVariables.PaginaDocumento) + paginasIni + pagDiferencia;
processVariables.paginasContainsFichero = paginasFin - paginasIni;
processVariables.pagacumuladas 			= parseInt(processVariables.pagacumuladas) + parseInt(processVariables.paginasContainsFichero);
var anexos 			= "000000";
var duplex			= "DUPLEX";
var tipoPapel		= "A4";
var idioma			= "CASTELLANO";
var canal			= "POSTAL";
var esMuestra		= "NO";
var sobre			= "C6";
//if (processVariables.paginasContainsFichero > 4)
//	sobre			= "MAN";

var paginasContainsFichero = processVariables.paginasContainsFichero.toString().split(".");
var ini 			= paginasIni + 1;
ini 				= ini.toString().split(".");
var fin 			= paginasFin.toString().split(".");
var auxDoc 			= processVariables.NumeroDocumento.toString().split(".");
fileVariables.xml_UID 					= processVariables.UID+ "M" + formatea(auxDoc[0],8);
fileVariables.xml_Paginas 				= paginasContainsFichero[0];
fileVariables.xml_Fichero 				= fileVariables.nombreFicheroSalida;
fileVariables.xml_PosSpoolIni 			= ini[0];
fileVariables.xml_PosSpoolFin 			= fin[0];
fileVariables.xml_DocIdCliente 			= "";
fileVariables.xml_Idioma 				= idioma;
fileVariables.xml_FicheroEntrada 		= fileVariables.InputFileName;
fileVariables.xml_Canal 				= canal;
fileVariables.xml_EsMuestra 			= esMuestra;
fileVariables.xml_TipoCorrespondencia 	= "";
fileVariables.xml_Distribuidor 			= "";
fileVariables.xml_TipoPapel 			= tipoPapel;
fileVariables.xml_Duplex 				= duplex;
fileVariables.xml_Bundle 				= "";
fileVariables.xml_Sobre 				= sobre;
fileVariables.xml_Insertos 				= anexos;
fileVariables.xml_NomInserto1 			= "";
fileVariables.xml_NomInserto2 			= "";
fileVariables.xml_NomInserto3 			= "";
fileVariables.xml_NomInserto4 			= "";
fileVariables.xml_NomInserto5 			= "";
fileVariables.xml_NomInserto6 			= "";
fileVariables.xml_DestCodCliente 		= "";
fileVariables.xml_DestContratoCliente 	= "";
fileVariables.xml_DestNombre 			= escapaCaracteres(fileVariables.UserNombre);
fileVariables.xml_DestDireccion 		= escapaCaracteres(fileVariables.UserDireccion);
fileVariables.xml_DestLocalidad 		= escapaCaracteres(fileVariables.UserCiudad);
fileVariables.xml_DestProvincia 		= escapaCaracteres(fileVariables.UserProvincia);
fileVariables.xml_DestCP 				= fileVariables.UserCP;
fileVariables.xml_DestZip 				= "";
fileVariables.xml_DestPais 				= "";
fileVariables.xml_DestZonaPostal 		= fileVariables.VarZonaPostal;
function formatea(cadena, posiciones) {
	var posicionesAct 	= cadena.length;
	var relleno 		= posiciones - posicionesAct;
	for (var i = 0; i < relleno; i++) {cadena = "0" + cadena;}
	return cadena;
}
function escapaCaracteres(cadenaXML){
logger.info("cadenaXML:" + cadenaXML);
cadenaXML = cadenaXML.replace(/&/g, '&amp;')
   .replace(/</g, '&lt;')
   .replace(/>/g, '&gt;')
   .replace(/"/g, '&quot;')
   .replace(/'/g, '&apos;');
return cadenaXML;
}