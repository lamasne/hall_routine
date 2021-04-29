function Hall2B()
    % Conversio de uV a Tesla: 
    % es llegeixen els fitxers .csv de la llista mostra,
    % es fa la recta de regressio de les 100 primeres
    % i 100 darreres mesures de cada fila; aquesta recta es el nivell zero i es
    % resta; 
    % un cop centrada la mesura entorn al nivell zero s'aplica el factor
    % de conversio de uV a Tesla,
    % es fan allisats opcionals (primer al llarg de cada fila, despres entre
    % files)
    % i s'escriu dades de cada mostra en un fitxer .mat (Matlab binari v6,
    % legible des de Matlab i Octave)
    %
    % Nova versio: guarda llista de coordenades x,y de cada mesura
    % de Bz; el fitxer on guarda camp Bz es diu {mostra}.mat
    %
    % Conversão de uV para Tesla:
    % são lidos .csv arquivos da lista mostra,
    % é feita a linha de regressao das primeiras 100 e últimas 100 medidas de cada 
    % linha; Esta linha reta é o nível zero e é de descanso; Uma vez que a
    % medição está centrada em torno do nível zero, o fator é aplicado
    % de conversão de uV para Tesla, são maquiagem opcional (primeiro ao longo 
    % de cada linha, depois digite de arquivos)
    % eu escrevo dados para cada amostra em um arquivo .mat (Matlab bin v6,
    % legível de Matlab e Octave)
    %
    % Nova versão: salve a lista de coordenadas x e de cada medida
    % de Bz; O arquivo onde o campo Bz é armazenado diz {sample} .mat

    % Jaume Amoros, UPC, Barcelona
    % 2016/4/6
    %
    % provat i funciona

    fprintf('Starting Hall2B\n')

    load('global_params.mat', 'sampleName', 'dxHall', 'dyHall', 'GV', 'amplecinta', 'inputPath', 'outputPath', 'ht');
    
    % Parametres d'allisat i frequencia
    % allisatY,allisatX val mes que siguin senars (valor 1 = no allisament)
    % allisatY, allisatX mais que impar (valor 1 = sem cheiro)
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
    
    
    % % fraccio de l'ample de la cinta per cada costat en el que es pren tambe la
    % % mesura de B per fer el calcul
    % margelatB=1/4; 

    % Nom de la mesura a estudiar (poden ser varis si s'han fet amb els mateixos parametres)
    mostra{1}=sampleName;
    nm=length(mostra);

    for k=1:nm,
        fitxer=[inputPath '\' mostra{k} '.csv'];
        A=col2matlab(fitxer);
        fprintf('Size of input: %d x %d\n', size(A))
        desti=[outputPath '\' mostra{k} '.mat'];
        files=size(A,1);
        cols=size(A,2);
        colsB=cols-allisatY+1;

        % draw the transversal cross section (x=mid-tape) of the probe voltage
        figure(1)
        plot(A(round(files/2),:),'r');
        xlabel('mesura');
        ylabel('V');
        title('Tall transvers de mesura sonda a mitja cinta');
        print('-dpng',[outputPath '\tall_transvers_central_uV_' mostra{k} '.png']);
        
        % draw the longitudinal cross section (y=mid-tape) of the probe voltage
        figure(2)
        plot(A(:,round(cols/2)),'r');
        xlabel('fila');
        ylabel('V');
        title('Tall longitudinal de mesura sonda a mitja cinta');
        print('-dpng',[outputPath '\tall_longitudinal_central_uV_' mostra{k} '.png']);


        % el nivell zero es determina fila a fila per compensar deriva de la
        % sonda
        for l=1:files,
            r=polyfit([linspace(1,100,100),linspace(cols-99,cols,100)],[A(l,1:100),A(l,cols-99:cols)],1);
            nzero=polyval(r,linspace(1,cols,cols));
            fila=A(l,:)-nzero;
            % allisat dins de cada fila:
            filaconv=conv(fila,ones(1,allisatY))/allisatY; 
            BllisY(l,:)=filaconv(allisatY:end-allisatY+1);
        end;
        % allisat entre files
        for l=1:colsB,
            columna=BllisY(:,l)';
            colconv=conv(columna,ones(1,allisatX))/allisatX;
            BllisYX(:,l)=colconv(allisatX:end-allisatX+1)';
        end;
        BllisYX=BllisYX*GV*1e-4; % passem de uV a T via GV i 1G=1e-4 T
        % finestra usada pel calcul: per defecte centrada i amb ample
        % (1+2*margelatB)*ample de la cinta a menys que margelat valgui 0,
        % cas en que no retalla res
        if margelat==0
            Btot=BllisYX(1:freqX:end,1:freqY:end);
        else
            Btot=BllisYX(1:freqX:end,round(colsB/2-(0.5+margelatB)*amplecinta/dyHall):freqY:round(colsB/2+(0.5+margelatB)*amplecinta/dyHall));
        end;

        dx=freqX*dxHall;
        dy=freqY*dyHall;
        xb1=linspace(0,dx*(size(Btot,1)-1),size(Btot,1));
        yb1=linspace(0,dy*(size(Btot,2)-1),size(Btot,2));
        [xb2,yb2]=ndgrid(xb1,yb1);
        save(desti,'Btot','xb2','yb2','ht','-v6');
        
        figure(3)
        plot(linspace(0,(size(Btot,2)-1)*dy,size(Btot,2)),Btot(round(size(Btot,1)/2),:));
        xlabel('y width (m)');
        ylabel('B_z(T)');
        title('Tall transvers de B_z a mitja cinta');
        print('-dpng',[outputPath '\tall_transvers_central_Bz_' mostra{k} '.png']);
        
        figure(4)
        plot(linspace(0,(size(Btot,1)-1)*dx,size(Btot,1)),Btot(:,round(size(Btot,2)/2)));
        xlabel('x length (m)');
        ylabel('B_z(T)');
        title('Tall longitudinal de B_z a mitja cinta');
        print('-dpng',[outputPath '\tall_longitudinal_central_Bz_' mostra{k} '.png']);
        clear A BllisY BllisYX Btot
        
        fprintf('End of Hall2B\n')

end;

