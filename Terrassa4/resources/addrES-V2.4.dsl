#Start Grammar for country 
START GRAMMAR ES.COUNTRY
    CountryLine        <- OptBlanks CountryName OptBlanks EOF
    CountryName        <- 'Espanol'_i / 'Espana'_i / 'Spanien'_i / 'Spain'_i / 'Espagne'_i
FIELDS
    CountryName        Component.Country
VALIDATION
    Rc.MaxLineLength          [W]:  CountryLine      <+   (.{60,})
END GRAMMAR ES.COUNTRY


START GRAMMAR ES.PROVINCE
    SpainProvinceLine   <- OptBlanks Province OptBlanks EOF
    Province            <- ('Albacete'_i/'Alicante'_i/'Almeria'_i/'Asturias'_i/'Avila'_i/'Badajoz'_i/(('Balearic Islands'_i)/('Islas Baleares'_i)/('ILLES BALEARS'_i))/'Barcelona'_i/'Biscay'_i/'Burgos'_i/'Cantabria'_i/(('Castellon'_i)/('Castell'_i ('\xF3'_i/'o'_i) 'n'_i))/'Ceuta'_i/'Ciudad Real'_i/'Cuenca'_i/'C'_i ('\xE1'_i/'a'_i) 'ceres'_i/'C'_i ('\xE1'_i/'a'_i) 'diz'_i/'C'_i ('\xF3'_i/'o'_i) 'rdoba'_i/'Girona'_i/'Granada'_i/'Guadalajara'_i/'Guip'_i ('\xFA'_i/'u'_i) 'zcoa'_i/'Huelva'_i/'Huesca'_i/'Ja'_i ('\xE9'_i/'e'_i) 'n'_i/(('a Coru'_i ('\xF1'_i/'n'_i) 'a'_i) /('La Coru'_i ('\xF1'_i/'n'_i) 'a'_i) /('Corunna'_i))/'La Rioja'_i/'Las Palmas'_i/'Le'_i ('\xF3'_i/'o'_i) 'n'_i/'Lleida'_i/'Lugo'_i/'Madrid'_i/'Melilla'_i/'Murcia'_i/'M'_i ('\xE1'_i/'a'_i) 'laga'_i/'Navarra'_i/'Ourense'_i/'Palencia'_i/'Pontevedra'_i/'Salamanca'_i/(('Santa Cruzde Tenerife'_i)/('SANTA CRUZ DE T'_i)/('Santa Cruz de Tenerife'_i))/'Segovia'_i/'Sevilla'_i/'Soria'_i/'Tarragona'_i/'Teruel'_i/'Toledo'_i/'Valencia'_i/'Valladolid'_i/'Zamora'_i/'Zaragoza'_i/('\xC1'_i/'A'_i) 'lava'_i/ ('\xC1'_i/'A'_i) 'vila'_i)
FIELDS
    Province            Component.Location.Province
    Province            Component.Location.State
END GRAMMAR ES.PROVINCE


#Start Grammar for cityline
START GRAMMAR ES.CITY uses ES.PROVINCE
    SpainCityLine       <- OptBlanks Location OptBlanks EOF
    Location            <- (IsoCountryCode OptBlanks [-] OptBlanks)? Postcode OptBlanks SpainCity (OptBlanks Symbols* Province Symbols*)?
    IsoCountryCode      <- ('ES'_i / 'E'_i)
    Postcode            <- [0-9][0-9][0-9][0-9][0-9]
    SpainCity           <- Chars (OptBlanks !(Symbols* Province Symbols*) ([']/[-])? OptBlanks Chars)*
    Symbols             <- OptBlanks ([(] / [)] / [,]) OptBlanks
FIELDS
    Location            Component.Location
    IsoCountryCode      Component.Location.Country
    Postcode            Component.Location.Zip
    Province            Component.Location.City.District
    Province            Component.Location.State
    SpainCity           Component.Location.City
    SpainCity           Component.Location.City.City
VALIDATION
    Rc.MaxLineLength          [W]:  SpainCityLine       <+   (.{60,})
    Rc.ZipInvalid             [E]:  Postcode            <+   (!([0-9]{5}))
    Rc.ZipValid               [I]:  Postcode            <+   ([0-9]{5})
    Rc.ZipNotFound            [E]:  Postcode            <+   (!.)
    Rc.CityNotFound           [E]:  SpainCity           <+   (!.)
    Rc.CityFound              [I]:  SpainCity           <+   (!(!.))
END GRAMMAR ES.CITY


#Start Grammar for Street including type and number
START GRAMMAR ES.STREET_WITH_TYPE_AND_NUMBER
    SpainStreetLine    <- OptBlanks SpainStreet OptBlanks EOF
    SpainStreet        <- ((OptBlanks StreetName OptBlanks Symbols? OptBlanks StreetNumber) / (OptBlanks StreetType OptBlanks StreetName OptBlanks Symbols? OptBlanks StreetNumber))
    StreetType         <- 'Aldea'_i /'Apartado'_i / 'APTDO'_i / 'Ap.'_i /'Avda.'_i / 'Avenida'_i / 'Avinguda'_i / 'Barrio'_i / 'C/'_i / 'Calle'_i / 'Camino'_i /'Carrer'_i ('a'_i)?/ 'Carretera'_i /'Cami'_i /'Cami'_i /'Camino'_i /'Casa'_i /'Casas'_i /'Casal'_i /'Cuesta'_i /'CTRA'_i /'Finca'_i /'Lista'_i / 'Lugar'_i /'Masia'_i /'Paseo'_i / 'Pasaje'_i /'Passatge'_i /'Pda.'_i / 'Plaza'_i / 'PLA'_i '\xC3'_i 'A'_i / 'Poligono'_i / 'Prolongac'_i /'Rambla'_i /'Ronda'_i / 'Son'_i /'URBANIZAC'_i / 'URB.'_i /'Villa'_i /'Zona'_i 
    StreetName         <- OptBlanks !StreetType OptBlanks FrChars (OptBlanks (!FloorSymbol) Symbols OptBlanks FrChars)? ((OptBlanks (!FloorSymbol) FrChars)+)? (OptBlanks [,] [0-9]+ FloorSymbol OptBlanks ('izqu'_i / 'dcho'_i))?
    StreetNumber       <- (FloorSymbol)? OptBlanks SingleNumber (OptBlanks ('-' / [.]) OptBlanks SingleNumber)? FullSuffix*
    FloorSymbol        <- ( ('N'_i) / ([0-9]+) ) OptBlanks ( [º] / [°] / '\xB0'_i / '\x2DA'_i / '\x2116'_i)
    FullSuffix         <- (OptBlanks [/]* OptBlanks) Suffix
    SingleNumber       <- [0-9]+ (OptBlanks [0-9]* [/.] OptBlanks [0-9]+)? DeChar?
    Suffix             <- (OptBlanks NonBlanks)+
    Symbols            <- ([-] / [/] / [,] / [']/ [.])
FIELDS
    SpainStreet        Component.Street
    StreetName         Component.Street.Name
    StreetType         Component.Street.Type
    StreetNumber       Component.Street.Number
VALIDATION
    Rc.MaxLineLength          [W]:  SpainStreetLine      <+   (.{60,})
END GRAMMAR ES.STREET_WITH_TYPE_AND_NUMBER


START GRAMMAR ES.STREET_GENERIC
    StreetLine              <- OptBlanks Street OptBlanks EOF
    StreetType         <- 'Aldea'_i /'Apartado'_i / 'APTDO'_i / 'Ap.'_i /'Avda.'_i / 'Avenida'_i / 'Avinguda'_i / 'Barrio'_i / 'C/'_i / 'Calle'_i / 'Camino'_i /'Carrer'_i ('a'_i)?/ 'Carretera'_i /'Cami'_i /'Cami'_i /'Camino'_i /'Casa'_i /'Casas'_i /'Casal'_i /'Cuesta'_i /'CTRA'_i /'Finca'_i / 'JUNTA'_i / 'Lista'_i / 'Lugar'_i /'Masia'_i /'Paseo'_i / 'Pasaje'_i /'Passatge'_i /'Pda.'_i / 'Plaza'_i / 'Poligono'_i / 'Prolongac'_i /'Rambla'_i / 'RESIDENCIA'_i / 'Ronda'_i / 'Son'_i /'URBANIZAC'_i /'Villa'_i /'Zona'_i 
    Street                  <- StreetType .*
FIELDS
    Street                  Component.Street
VALIDATION
    Rc.MaxLineLength        [W]: StreetLine          <+   (.{60,})
END GRAMMAR ES.STREET_GENERIC


START GRAMMAR ES.POBOX
    PoBoxLine               <- OptBlanks PoBox OptBlanks EOF
    PoBox                   <- PoBoxName OptBlanks PoBoxNumber
    PoBoxName               <- ('P'_i OptDot OptBlanks 'O'_i OptDot OptBlanks 'Box'_i / 'POB'_i / 'Apartado')
    PoBoxNumber             <- (OptBlanks [0-9]+)+
    OptDot                  <- [.]?
FIELDS                      
    PoBoxNumber             Component.Pobox
VALIDATION
    Rc.MaxLineLength        [W]: PoBoxNumber         <+   (.{9,})
END GRAMMAR ES.POBOX


START GRAMMAR ES.PACKSTATION
    SpainPackstationLine  <- OptBlanks SpainPackstation OptBlanks EOF
    SpainPackstation      <- 'Lista de Correos'_i 
 FIELDS
    SpainPackstation      Component.Packstation
END GRAMMAR ES.PACKSTATION


START GRAMMAR ES.TITLE
    TitleLine          <- OptBlanks Title OptBlanks EOF
    Title              <- 	'Doctora'_i / 'Doctor'_i / 'Dr.'_i/ 'Dna'_i / 'Dn'_i / 'Dona'_i / 'Don'_i / 'Profesora'_i / 'Profesor'_i / 'Prof.'_i / 'Senorita'_i / 'Senora'_i / 'Senor'_i 
FIELDS
    Title              Component.Name.Title
END GRAMMAR ES.TITLE


START GRAMMAR ES.ENTITY
    SpainEntityLine             <- OptBlanks SpainEntity OptBlanks EOF
    SpainEntity                 <- EntityWithID / EntityHeuristic
    EntityWithID                <- Name? OptBlanks Type
    EntityHeuristic             <- (OptBlanks [-&. ]* NonHeuristicWord)* (OptBlanks [-&.]* OptBlanks (IdHeuristic / InHeuristicWord)) .*
    NonHeuristicWord            <- !IdHeuristic !InHeuristicWord DeChar+
    InHeuristicWord             <- (!IdInWordHeuristic (FrChar / [-&.]))* IdInWordHeuristic ([-&.]/FrChars)*
    Name                        <- (OptBlanks ([-&. ]* (!(Id FrChar*)) (FrChars / [0-9])+)+)+
    Type                        <- IdSuffix / (IdInfix (OptBlanks NonBlanks)*)
    Id                          <- IdInfix / IdSuffix
    IdInWordHeuristic           <-  'Central'_i / 'Centro Comercial'_i / 'Centro'_i / 'En linea'_i / 'Instituto'_i / 'Investigaci'_i ('\xF3'_i/'o'_i) 'n'_i / 'Universidad'_i / 'Restaurante'_i
    IdHeuristic                 <-  'Agencia'_i / 'Banca'_i / 'Biblioteca'_i / 'Caf'_i ('\xE9'_i/'e'_i) / 'Concejo Municipal'_i / 'Consulta'_i / 'Cooperativa'_i / 'Estati'_i ('\xF3n'_i/'on'_i) / 'Hotel'_i / 'Hostal'_i
    IdInfix                     <- ('Alcante'_i / 'Departamento'_i / 'Organizaci' ('\xF3n'_i/'on'_i))[.]?
    IdSuffix                    <- ('Autonomo'_i / 'Company'_i / 'COOP'_i /'RETA'_i / 'S.L.N.E.'_i / 'S.A.U.' / 'S.A.'_i / 'S.L.U.'_i / 'S.L.' / 'Sociedad Civil'_i / 'Sociedad de Responsibilidad Limitada'_i / 'Sociedad Anonima'_i)[.]?
FIELDS
    EntityWithID                Component.Entity
    EntityHeuristic             Component.Entity
    Name                        Component.Entity.Name
    Type                        Component.Entity.Type
VALIDATION
    Rc.MaxLineLength          [W]:  SpainEntityLine      <+   (.{60,})
END GRAMMAR ES.ENTITY


START GRAMMAR ES.EXTRA.ENTITY uses ES.ENTITY
FIELDS
    EntityWithID                Component.Extra.Entity
    EntityHeuristic             Component.Extra.Entity
    Name                        Component.Extra.Entity.Name
    Type                        Component.Extra.Entity.Type
END GRAMMAR ES.EXTRA.ENTITY


START GRAMMAR ES.NAME uses ES.TITLE, ES.ENTITY, ES.EXTRA.ENTITY
    SpainNameLine               <- OptBlanks SpainNameFull OptBlanks EOF
    SpainNameFull               <- SpainTitle? SpainName
    SpainName                   <- (!SpainTitle) OptBlanks [0-9]*(OptBlanks Chars '.'? OptBlanks Symbols?)+
    SpainTitle                  <- (Title Blanks)
    Symbols                     <- (['] / [-] / [/] / [&]/ [,])
FIELDS
    SpainNameFull               Component.Nameline
    SpainName                   Component.Name
    Title                       Component.Name.Title
    EntityWithID                Component.Entity
    EntityHeuristic             Component.Entity
    Name                        Component.Entity.Name
    Type                        Component.Entity.Type
    EntityWithID                Component.Extra.Entity
    EntityHeuristic             Component.Extra.Entity
    Name                        Component.Extra.Entity.Name
    Type                        Component.Extra.Entity.Type
VALIDATION
    Rc.MaxLineLength          [W]:  SpainNameLine      <+   (.{60,})
END GRAMMAR ES.NAME 


START GRAMMAR ES.EXTRA1
    SpanishExtraLine    <- .* EOF
FIELDS
    SpanishExtraLine    Component.Extra1
END GRAMMAR ES.EXTRA1


START GRAMMAR ES.EXTRA2 uses ES.EXTRA1
FIELDS
    SpanishExtraLine    Component.Extra2
END GRAMMAR ES.EXTRA2


START GRAMMAR ES.EXTRA3 uses ES.EXTRA1
FIELDS
    SpanishExtraLine    Component.Extra3
END GRAMMAR ES.EXTRA3


START GRAMMAR ES.EXTRA4 uses ES.EXTRA1
FIELDS
    SpanishExtraLine    Component.Extra4
END GRAMMAR ES.EXTRA4


START GRAMMAR ES.EXTRA5 uses ES.EXTRA1
FIELDS
    SpanishExtraLine    Component.Extra5
END GRAMMAR ES.EXTRA5


START BLOCK NextExtraLine
    if not ES.EXTRA1 matched
        consume with ES.EXTRA1
    else
        if not ES.EXTRA2 matched
            consume with ES.EXTRA2
        else
            if not ES.EXTRA3 matched
                consume with ES.EXTRA3
            else
                if not ES.EXTRA4 matched
                    consume with ES.EXTRA4
                else
                    if not ES.EXTRA5 matched
                        consume with ES.EXTRA5
                    else
                    endif
                endif
            endif
        endif
    endif
END BLOCK NextExtraLine



START PARSER

# This will cause a failure if a consume or check statement would be applied with no lines left
    #parsing fails if no more lines

    # Apply Country grammar
    consume with ES.COUNTRY
    
    consume with ES.PROVINCE

    # must consume - we abort if CH.CITY doesn't match!
    must consume with ES.CITY
    
    consume with ES.POBOX

    if not ES.POBOX matched
        consume with ES.STREET_WITH_TYPE_AND_NUMBER
        if not ES.STREET_WITH_TYPE_AND_NUMBER matched
            consume with ES.PACKSTATION
            if not ES.PACKSTATION matched
                must consume with ES.STREET_GENERIC
            endif
        endif
    else
        consume with ES.STREET_WITH_TYPE_AND_NUMBER
    endif

    consume with ES.ENTITY

    parsing succeeds if no more lines
    
    # must consume - we abort if CH.CITY doesn't match!
    consume with ES.NAME
    
    parsing succeeds if no more lines
    
    consume with ES.TITLE
    
    if not ES.ENTITY matched
        consume with ES.ENTITY
    endif

    if not ES.EXTRA.ENTITY matched
        consume with ES.EXTRA.ENTITY
    endif
    
    # invoke extra lines 
    invoke NextExtraLine
    invoke NextExtraLine
    invoke NextExtraLine
    invoke NextExtraLine
    invoke NextExtraLine

END PARSER
