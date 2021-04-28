function init_global(sampleName_in, inputPath_in, outputPath_in, dxHall_in, dyHall_in, ht_in, GV_in, amplecinta_in, m_in, n_in, gruix_in)
    % CALCUL DE CORRENT CRITIC EN CINTES DE MATERIAL SUPERCONDUCTOR
    % A PARTIR DE MESURES DE CAMP MAGNETIC AMB SONDA HALL
    % PER LINEALITZACIO I INVERSIO DEL PROBLEMA DE BIOT-SAVART
    % 
    % Jaume Amoros, UPC, Barcelona,
    % Miquel Carrera, UdL, Lleida,
    % Xavier Granados, ICMAB, Bellaterra
    %
    % Versio semi-automatica: ha d'estar en el directori amb les dades,
    % se li entren parametres ajustant dades a l'inici d'aquest llistat,
    % fa el calcul invers+directe,
    % guarda els resultats en un fitxer .mat de matlab/octave 
    % i genera un joc de figures standard

    % 2016/4/6
    % en desenvolupament

    global sampleName dxHall dyHall ht GV amplecinta inputPath outputPath m n gruix

    fprintf('Starting init_global\n')
    
    % Parametres de la mesura (TOTES LES MESURES SI)
    sampleName = sampleName_in;

    dxHall = dxHall_in;
    dyHall = dyHall_in;
    ht = ht_in;
    GV = GV_in;
    amplecinta = amplecinta_in;

    inputPath = inputPath_in;
    outputPath = outputPath_in;

    m = m_in;
    n = n_in;
    
    % gruix de la mostra
    gruix = gruix_in; % thickness of the sample


    % Nom de la mesura a estudiar (poden ser varis si s'han fet amb els mateixos parametres)
    mostra{1}=sampleName;

    %-------------------------------------------------------

    % GV Calibra�ao de 20 de junho de 2019:

    % GV = 235.1; % for hall sensor with 3 mA
    % GV = 140.85; % for hall sensor with 4 mA
    % GV = 97; % for hall sensor with 5 mA

    %-------------------------------------------------------

    % GV = 89.5; % for hall sensor feeded with 6 mA
    % GV = 135.9; % for hall sensor feeded with 4 mA
    % GV = 273.63; % for hall sensor feeded with 2 mA
    % GV = 432.98; % for hall sensor feeded with 1 mA

    % Parametres d'allisat i frequencia
    % allisatY,allisatX val mes que siguin senars (valor 1 = no allisament)
    % allisatY, allisatX � mais que impar (valor 1 = sem cheiro)
    % reemplac,ar cada mesura pel promig de les allisatY mesures centrades en ella en la fila
    % replace each measure with the average straight lines centered on it
    allisatY=1; 
    % despres de l'allisat anterior: reemplac,ar cada fila pel promig de les allisatX centrades en ella 
    allisatX=1; 
    % aprofitar una de cada freqX mesures en cada fila
    % Aproveite uma de cada medida de freqX em cada linha
    freqX=1;
    % aprofitar una de cada freqY files
    % Aproveite uma de cada medida de freqY em cada linha
    freqY=1; 
     % si se li dona valor no nul retalla la mesura, deixant l'amplada de la mostra mes la fraccio indicada d'amplada per cada costat
     % se voc� der um valor diferente de zero, corte a medida, deixando a largura da amostra mais a fra��o de largura indicada para cada lado
    margelat=0;
    % margelat=1/2; % retalla la mesura a la seccio central amb amplada la de
    % la cinta, mes el 50% d'amplada per cada costat

    % FI DE LA PART QUE TOCA L'USUARI


    % LECTURA DE LES DADES, CONVERSIO A TESLA I EMMAGATZEMAT PROVISIONAL EN
    % FORMAT MATLAB

    Hall2B(mostra, allisatX, allisatY,freqX,freqY,margelat);

    fprintf('End of edificio mesura\n')
    
    % tambe es generen figures de talls de la mesura de la sonda, 
    % i del camp B_z convolucionat, 
    % per cada mostra i en format png 
end