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

close all
clc
clear 

global dxHall dyHall ht GV amplecinta
% PART QUE TOCA L'USUARI

% PARAMETRES DE LA MESURA I DEL CALCUL (CAL OMPLIR A MA)

% Nom de la mesura a estudiar (poden ser varis si s'han fet amb els mateixos parametres)


mostra{1}='Theva_plate_2_soldering_2021_3_4_14_32_';





% % descomentar si es volen processar varies mostres alhora
% mostra{2}='Amp3_135A_2011_5_24_11_53';
% mostra{3}='Amp3_135Aavall_2011_5_24_15_42';
% mostra{4}='Amp3_170A_2011_5_24_12_52';
% mostra{5}='Amp3_170Aavall_2011_5_24_14_42';
% mostra{6}='Amp3_50A_2011_5_24_10_53';
% mostra{7}='Amp3_50Aavall_2011_5_24_17_35';

% Parametres de la mesura (TOTES LES MESURES SI)
dxHall = 2e-4; % pas en X (entre files) de la sonda
dyHall = 5e-6; % pas en Y (dins de cada fila) de la sonda
ht = 0.3e-3; % alc,ada de mesura
GV = 97; % factor de conversio: Gauss per Volt % 14.23 For Roxana  % 70.93 for Pedro
amplecinta = 24e-3; % ample aproximat de la cinta, pot tenir marge d'error de l'ordre del 10-20%

%-------------------------------------------------------

% GV Calibraçao de 20 de junho de 2019:

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
% allisatY, allisatX é mais que impar (valor 1 = sem cheiro)
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
 % se você der um valor diferente de zero, corte a medida, deixando a largura da amostra mais a fração de largura indicada para cada lado
margelat=0;
% margelat=1/2; % retalla la mesura a la seccio central amb amplada la de
% la cinta, mes el 50% d'amplada per cada costat

% FI DE LA PART QUE TOCA L'USUARI


% LECTURA DE LES DADES, CONVERSIO A TESLA I EMMAGATZEMAT PROVISIONAL EN
% FORMAT MATLAB

Hall2B(mostra,allisatX,allisatY,freqX,freqY,margelat);

% tambe es generen figures de talls de la mesura de la sonda, 
% i del camp B_z convolucionat, 
% per cada mostra i en format png 
