importPackage(java.util);
importPackage(java.lang);
importPackage(Packages.java.io);
importPackage (Packages.java.nio.charset);
fileVariables.NombreFichero = fileVariables.InputFileBaseName.substring(21, 33);
map = new HashMap();
try {
	dir 		= new File(fileVariables.InputFileDirectory);
	var files 	= dir.listFiles();
	ficherosTXT = new ArrayList();
	for (var i = 0; i < files.length; i++) {
		if (!files[i].getName().contains(".pdf")) {
			if (!files[i].getName().contains(".xml")) {
				ficherosTXT.add(files[i].getName());
				fileVariables.HayFicheros = true;
			}
		}
//		if (files[i].getName().includes(".1400")) {
//			ficherosTXT.add(files[i].getName());
//			fileVariables.HayFicheros = true;
//			}
	}
	if (fileVariables.HayFicheros = false){logger.error("No se ha encontrado FICHERO GUIA.");}
	for (var i = 0; i < ficherosTXT.size(); i++) {
		var br = new BufferedReader(new InputStreamReader(new FileInputStream(fileVariables.InputFileDirectory + "/" + ficherosTXT.get(i)),"Cp1252"));
		var separador = "";	
		while ((separador = br.readLine()) != null) {
			logger.info("<*>" + separador);

			separador = separador.replaceAll("#.#", " . ");
			separador = separador.substring(1, 24).toString().trim() + "#.#" + 
						separador.substring(24, 124).toString().trim() + "#.#" + 
						separador.substring(124,174).toString().trim() + "#.#" + 
						separador.substring(174, 214).toString().trim() + "#.#" + 
						separador.substring(214,265).toString().trim() + "#.#" + 
						separador.substring(265).toString().trim();
			var res = separador.split("#.#");
			map.put(res[res.length - 1].toString(), separador);
		}
		br.close();
	}
	logger.info("****aaaaaaaaaaaaaaaaaaaa******");

	var lineaMapa 				= map.get(fileVariables.NombreFichero);
	var BarCode 				= lineaMapa.split("#.#");
	fileVariables.VarSICER 		= BarCode[0];
	fileVariables.UserNombre 	= BarCode[1];
	fileVariables.UserDireccion = BarCode[2];
	fileVariables.UserCiudad 	= BarCode[3];
	fileVariables.UserCP 		= BarCode[4];
} catch (e) {logger.error("Error durante la lectura del FICHERO GUIA.");}