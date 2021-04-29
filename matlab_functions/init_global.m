function init_global(sampleName, inputPath, outputPath, dxHall, dyHall, ht, GV, amplecinta, m, n, gruix)

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
  
    fprintf('Starting init_global\n')

    %-------------------------------------------------------
    % GV Calibra�ao de 20 de junho de 2019:
    %-------------------------------------------------------
    % GV = 235.1; % for hall sensor with 3 mA
    % GV = 140.85; % for hall sensor with 4 mA
    % GV = 97; % for hall sensor with 5 mA
    % GV = 89.5; % for hall sensor feeded with 6 mA
    % GV = 135.9; % for hall sensor feeded with 4 mA
    % GV = 273.63; % for hall sensor feeded with 2 mA
    % GV = 432.98; % for hall sensor feeded with 1 mA
    %-------------------------------------------------------
    save('-v7', 'global_params.mat', 'sampleName', 'dxHall', 'dyHall', 'ht', 'GV', 'amplecinta', 'inputPath', 'outputPath', 'm', 'n', 'gruix');
    
    fprintf('End of init_global\n')
    
    % tambe es generen figures de talls de la mesura de la sonda, 
    % i del camp B_z convolucionat, 
    % per cada mostra i en format png 
end