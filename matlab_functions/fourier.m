% calcul de Biot-Savart invers en mesura stacknouL30_2polsnou_gap600_2016_5_4_10_25_
% pel metode de Fourier, amb filtratge SSA de la mesura de B
%
% Jaume Amoros, Arnau Duran UPC, Barcelona
% Miquel Carrera, UdL, Lleida
% ...
%
% 20170614

function fourier()

    fprintf('Starting fourier\n')

    % Inverting x and y (and m and n)   
    tmp = matfile('global_params.mat','Writable',true);

    dxHall = tmp.pas * tmp.dyHall;
    dyHall = tmp.dxHall;
    m = fix(tmp.n / tmp.pas);
    n = tmp.m;
    
    tmp.dyHall = dyHall;
    tmp.dxHall = dxHall;
    tmp.m = m;
    tmp.n = n;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    load('global_params.mat', 'sampleName', 'outputPath', 'm', 'n', 'dxHall', 'dyHall', 'ht', 'gruix');

    
    temps0=clock;

    % your file with filtered data on variable Vcru_copia
    input = strcat(outputPath, '\', sampleName, '_filtered');


    load(input);

    % USER FILLS THIS DATA
    % malla de mesura de Bz te m files x n columnes

    % eix OX dona direccio de cada fila (o -col?), eix OY direccio de cada columna (o fila?). Passos en cada eix
    % alc,ada sobre la mostra a la que la sonda mesura Bz
    % factor de calibracio V/T en la mesura
    calibracio=1;  % 75.2; conversion factor from Volts to Tesla
    % END OF SPECIFIC DATA FOR EACH MEASUREMENT

    % THE SEQUEL IS THE INVERSION, INDEPENDENT OF THE SAMPLE 
    % la malla de discretitzacio aqui es exactament la mateixa que la de mesura
    % de Bz

    % segueixen els calculs d'ofici
    % la B mesurada
    B2=(Vcru_copia.')/calibracio;


    % Llista de punts de mesura de Bz, i simetrics, amb (0,0,ht)=mesura inicial
    x=linspace(1-m,m-1,2*m-1)*dxHall;
    y=linspace(1-n,n-1,2*n-1)*dyHall;
    [x2,y2]=ndgrid(x,y);
    xb=x2(:);
    yb=y2(:);
    zb=ht*ones(size(xb));

    % element central, per a calcular la G de Fourier
    x0=-dxHall/2;
    xf=dxHall/2;
    y0=-dyHall/2;
    yf=dyHall/2;
    z0=-gruix;
    zf=0;

    % calcul de la G requerida pel metode de Fourier
    G1=calculG2(x0,xf,y0,yf,z0,zf,xb,yb,zb);
    G=zeros(2*m,2*n);
    G(2:end,2:end)=reshape(G1,2*m-1,2*n-1);
    tG=fft2(G);

    % calcul invers via transformades de Fourier discretes
    Bext=zeros(2*m,2*n);
    fprintf('size(Bext(m+1:2*m,n+1:2*n) = %d x %d\n', size(Bext(m+1:2*m,n+1:2*n)))
    fprintf('size(B2) = %d x %d\n', size(B2))
    Bext(m+1:2*m,n+1:2*n)=B2;

    tB=fft2(Bext); 
    tM=tB./tG;

    Mext=real(ifft2(tM));
    M2=Mext(1:m,1:n);
    temps1=clock;

    % Estudi estadistic de la propagacio de l'error relatiu
    % creacio de mostra de perturbacions aleatories normalitzades per B2
    % (s'ha de canviar! per a que els punts estiguin equidistribuits en
    % l'esfera)
    npert=1000;
    DeltaB=rand(size(B2,1),size(B2,2),npert);
    DeltaB2=DeltaB.*DeltaB;
    normesDeltaB=sqrt(squeeze(sum(sum(DeltaB2,2))));
    for k=1:npert,
        DeltaB(:,:,k)=DeltaB(:,:,k)/normesDeltaB(k);
    end;
    % inversio per cada perturbacio
    for k=1:npert,
        DBext=zeros(2*m,2*n);
        DBext(m+1:2*m,n+1:2*n)=DeltaB(:,:,k);

        tDB=fft2(DBext);
        tDM=tDB./tG;

        DMext=real(ifft2(tDM));
        DM2=DMext(1:m,1:n);
        DeltaM(:,:,k)=DM2;
    end;
    DeltaM2=DeltaM.*DeltaM;
    normesDeltaM=sqrt(squeeze(sum(sum(DeltaM2,2))));
    llista_c=normesDeltaM*sqrt(sum(sum(B2.*B2)))/sqrt(sum(sum(M2.*M2)));
    'test de Kolmogorov-Smirnov: 1=normalitat'
    kstest(llista_c) 
    % mitja i desviacio standard dels valors de c
    cbarra=mean(llista_c);
    sigmac=std(llista_c);

    temps2=clock;
    
    'Temps calcul inicial'
    temps1-temps0

    'Temps analisi estadistic'
    temps2-temps1
    
    mesh(M2);
    xlabel('n');
    ylabel('m');

    output = strcat(outputPath, '\', sampleName, '_fourier.mat');
    save(output, 'M2', 'x', 'y', 'x2', 'y2', 'B2', 'cbarra', 'sigmac', 'temps2', '-v6');
    
    % END OF STATIC CODE THAT IS NOT EDITED

    %{
    % DO THIS BY HAND AFTER SEEING M2 IN THE SCREEN
    % Simply eliminate the first and last rows and columns of M2 (the edges) 
    % to get rid of the edge area where spurious M has been found
    % retall de M2: 
    % ES FA A MA !!
    % Es mira el grafic original de M2 i es decideix a ull quines files i
    % columnes de la vora s'exclouen. 
    % Ens quedarem amb la finestra (m0:mf,n0:nf) de M2
    m0=20; % rows
    mf=65;
    n0=20; % columns 
    nf=230;
    % WHAT FOLLOWS IS AUTOMATIC
    M2=M2(m0:mf,n0:nf);
    m=mf-m0+1;
    n=nf-n0+1;

    %Fem SSA sobre M2. L = 20. Eigen files = 5 i per columnes = 5. (es pot
    %acabar d'ajustar amb m�s precisi�, per� el canvi �s poc significatiu).

    M2 = SSA_files(M2,20,4);
    M2 = SSA_columnes(M2,20,4);

    % els elements per la M calculada son rectangles dxHall x dyHall centrats en cada
    % mesura de Bz
    x=x(m:end);
    y=y(n:end);
    xm2=x2(m:end,n:end); % abans de retallar les vores
    ym2=y2(m:end,n:end);
    % apliquem retall de les vores
    xm2=xm2(m0:mf,n0:nf);
    ym2=ym2(m0:mf,n0:nf);
    xm=xm2(:);
    ym=ym2(:);

    % mirarem B nomes en la zona retallada
    xb2=xm2; 
    yb2=ym2;
    B2=B2(m0:mf,n0:nf);
    xb=xb2(:);
    yb=yb2(:);
    zb=ht*ones(size(xb));



    % calcul de J per diferencies centrades (4 punts) com a J=rot(M)
    diffMy=diff(M2.').';
    diffMx=diff(M2);
    Jx2=(diffMy(1:end-1,:)+diffMy(2:end,:))/(2*dyHall);
    Jy2=-(diffMx(:,1:end-1)+diffMx(:,2:end))/(2*dxHall);
    Jv2=sqrt(Jx2.*Jx2+Jy2.*Jy2);
    xj02=xm2(1:end-1,1:end-1);
    xjf2=xm2(2:end,2:end);
    yj02=ym2(1:end-1,1:end-1);
    yjf2=ym2(2:end,2:end);
    xj2=(xj02+xjf2)/2;
    yj2=(yj02+yjf2)/2;


    % % calcul directe rapid, via Fourier
    % md=size(B2,1);
    % nd=size(B2,2);
    % % calcul de la G requerida pel metode de Fourier
    % xd=linspace(1-md,md-1,2*md-1)*dxHall;
    % yd=linspace(1-nd,nd-1,2*nd-1)*dyHall;
    % [xd2,yd2]=ndgrid(xd,yd);
    % xbd=xd2(:);
    % ybd=yd2(:);
    % zbd=ht*ones(size(xbd));
    % G1d=calculG2(x0,xf,y0,yf,z0,zf,xbd,ybd,zbd);
    % Gd=zeros(2*md,2*nd);
    % Gd(2:end,2:end)=reshape(G1d,2*md-1,2*nd-1);
    % tGd=fft2(Gd);
    % Mextd=zeros(2*md,2*nd);
    % Mextd(md+1:2*md,nd+1:2*nd)=M2;
    % tMd=fft2(Mextd); 
    % tBd=tGd.*tMd;
    % Bdext=real(ifft2(tBd));
    % Bd2=Bdext(1:md,1:nd);
    % % Fi del calcul directe rapid via Fourier

    % calcul directe, per via alternativa (nomes en fase de verificacio)
    % AVIS: aquest calcul directe tarda uns quants minuts, i nomes te sentit
    % fer-lo quan el resultat del calcul invers es plausible, com a verificacio
    xj02=xm2(1:end-1,1:end-1);
    xjf2=xm2(2:end,2:end);
    yj02=ym2(1:end-1,1:end-1);
    yjf2=ym2(2:end,2:end);
    xj2=(xj02+xjf2)/2;
    yj2=(yj02+yjf2)/2;
    Jx=Jx2(:);
    Jy=Jy2(:);
    xj0=xj02(:);
    xjf=xjf2(:);
    yj0=yj02(:);
    yjf=yjf2(:);
    zj0=-gruix*ones(size(xj0));
    zjf=zeros(size(xj0));
    Bd=J2Bz3dsemianalitic(Jx,Jy,xj0,xjf,yj0,yjf,zj0,zjf,xm,ym,ht*ones(size(xm)));
    Bd2=reshape(Bd,mf-m0+1,nf-n0+1);
    % la diferencia entre Bd2 i B2 es la mesura d'error del calcul que
    % interessa als usuaris.
    % FI del calcul directe que d'entrada no s'executa
    temps3=clock;

    % guarda resultats
    resultats=['calcul_fourier_' nom '.mat'];
    save(resultats,'M2','Jx2','Jy2','Jv2','B2','Bd2','xm2','ym2','xj2','yj2','xb2','yb2','gruix','ht','cbarra','sigmac','-v7');
    % M2=magnetization (filtered, cropped)
    % Jx2,Jy2=x and y components of the current
    % Jv2 current density (A/m^2)
    % B2=your measured magnetic field
    % Bd2=recomputed magnetic field that the found J would generate
    % xm2,ym2=coordinates at which M has been computed
    % xj2,yj2=coordinates at wihch J has been computed
    % xb2,yb2=coordinates at which B has been measured, and recomputed
    % gruix=thickness of the sample
    % ht=height over sample of the Hall probe
    % cbarra=error factor by which relative error in B multiplies in M and J (expected)
    % sigmac=standard deviation for cbarra


    % dibuixa figures
    figure(1)
    % figure('Visible','off')
    mesh(xb2,yb2,B2);
    xlabel('x');
    ylabel('y');
    zlabel('B_z');
    fitxerfig=['Bz_' nom '.png'];
    print('-dpng',fitxerfig);

    figure(2)
    mesh(xm2,ym2,M2);
    xlabel('x');
    ylabel('y');
    zlabel('M');
    fitxerfig=['M_' nom '.png'];
    print('-dpng',fitxerfig);

    figure(3)
    mesh(xj2,yj2,Jv2);
    xlabel('x');
    ylabel('y');
    zlabel('J_v');
    fitxerfig=['Jv_' nom '.png'];
    print('-dpng',fitxerfig);

    figure(4)
    C=contour(xj2,yj2,Jv2);
    clabel(C);
    xlabel('x');
    ylabel('y');
    fitxerfig=['contorndensitatJ_' nom '.png'];
    print('-dpng',fitxerfig);

    figure(5)
    quiver(xj2,yj2,Jx2,Jy2);
    xlabel('x');
    ylabel('y');
    fitxerfig=['mapacorrent_' nom '.png'];
    print('-dpng',fitxerfig);

    figure(6)
    plot(xb2(:,floor(size(B2,2)/2)),B2(:,floor(size(B2,2)/2)));
    hold on
    plot(xb2(:,floor(size(B2,2)/2)),Bd2(:,floor(size(B2,2)/2)),'r');
    hold off
    fitxerfig=['tall_filamig_B_Bd_' nom '.png'];
    print('-dpng',fitxerfig);

    % empaqueta les figures i les esborra (nomes funciona en Linux?)
    empaqueta=['zip figures_' nom '.zip *.png'];
    system(empaqueta);
    system('rm *.png');

    'Temps calcul inicial'
    temps1-temps0

    'Temps analisi estadistic'
    temps2-temps1

    'Temps recalcul de Bz'
    temps3-temps2
    %}

    fprintf('End of fourier\n')

    
end