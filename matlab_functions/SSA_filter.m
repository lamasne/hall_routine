% Filtratge SSA per files i per columnes en una mesura de sonda Hall, imposant que el
% camp magnetic en la vora sigui zero.
% Tambe es criba la mesura, agafant les mesures en cada fila saltant un pas
% fix.
%
% Arnau Duran, UPC, Barcelona
% 2017/3/19

function SSA_Filter()

    close all

    global sampleName outputPath

    %Mesura que estudiarem:
    nom = strcat(outputPath, '\', sampleName);

    load(nom)
    Vcru= Btot;
    %Fixem els par�metres del SSA:
    Lf = 10; % Window length L per SSA per files 
    Lc = 10; % Window length L per SSA per columnes 

    eigen_f = 4; % Numero eigentriples SSA per files 
    eigen_c = 4; % Numero eigentriples SSA per columnes 

    %Necessitem una mesura m�s grollera. Volem tenir una mostra de fxc
    %Dimensions de la mesura grollera:
    pas = 20; % agafarem una de cada pas mesures en cada fila

    files = length(Vcru(:,1));
    Vcru_g=Vcru(:,ceil(pas/2):pas:end);
    columnes = size(Vcru_g,2);


    %%%%%%%%%%%%%%%%%%%%%%
    % Un cop tenim Vcru_g, anem a fer filtrat per redu�r el soroll i tamb�
    % allisar els salts produ�ts per agafar menys dades.

    %Fem SSA per files. Treballarem amb la mesura Vcru_copia (per poder
    %comparar)

    Vcru_copia = SSA_files(Vcru_g,Lf,eigen_f);



    %Imposem nivell zero a cada fila --> Volem que els extrems de les files
    %sigui 0.
    %Ho fem establint una recta entre el primer i l'�ltim terme.
    %Anem definit la funci� per cada fila
    nivell0 = zeros(files,columnes);
    for f = 1:files
        nivell0(f,:)=linspace(Vcru_copia(f,1),Vcru_copia(f,end),columnes);
    end

    Vcru_copia = Vcru_copia - nivell0;



    %Al fer aix� veiem que a les columnes hem afegit molt m�s soroll: (ho fa
    %m�s dif�cil de treure amb l'SSA). (Ex. columna 1000)

    %Procedim a fer SSA per columnes.
    Vcru_copia = SSA_columnes(Vcru_copia,Lc,eigen_c);


    % guardem resultats
    nom_guardar = strcat(strrep(nom,'.mat',''),'_filtered.mat');
    % save ordinari
    save('-v7',nom_guardar, 'Vcru_copia');


end


        
        
