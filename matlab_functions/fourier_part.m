     % DO THIS BY HAND AFTER SEEING M2 IN THE SCREEN
% Simply eliminate the first and last rows and columns of M2 (the edges) 
% to get rid of the edge area where spurious M has been found
% retall de M2: 
% ES FA A MA !!
% Es mira el grafic original de M2 i es decideix a ull quines files i
% columnes de la vora s'exclouen. 
% Ens quedarem amb la finestra (m0:mf,n0:nf) de M2


function fourier_part(m0, mf, n0, nf)

    load('global_params.mat', samplename, outputPath, ht, gruix);

    'Starting fourier_part'

    fprintf('Window selected:\n m0=%d, mf=%d, no=%d, nf=%d\n', m0, mf, n0, nf)

    input = strcat(outputPath, '\', sampleName, '_fourier.mat');
    load(input);

    % WHAT FOLLOWS IS AUTOMATIC
    M2=M2(m0:mf,n0:nf);
    m=mf-m0+1;
    n=nf-n0+1;

    %Fem SSA sobre M2. L = 20. Eigen files = 5 i per columnes = 5. (es pot
    %acabar d'ajustar amb m�s precisi�, per� el canvi �s poc significatiu).

    M2 = SSA_files(M2,20,4);
    M2 = SSA_columnes(M2,20,4);

    % els elements per la M calculada son rectangles dx x dy centrats en cada
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
    Jx2=(diffMy(1:end-1,:)+diffMy(2:end,:))/(2*dy);
    Jy2=-(diffMx(:,1:end-1)+diffMx(:,2:end))/(2*dx);
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
    % xd=linspace(1-md,md-1,2*md-1)*dx;
    % yd=linspace(1-nd,nd-1,2*nd-1)*dy;
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

    fprintf('fourier_part computation finished')

    
    % guarda resultats
    resultats=[outputPath '\calcul_fourier_' sampleName '.mat'];
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
    mesh(xb2*1e3,yb2*1e3,B2);
    xlabel('x [mm]','FontSize', 20);
    ylabel('y [mm]','FontSize', 20);
    set(gca,'fontsize',14); set(gcf,'Color','white');
    zlabel('B_z [T]','FontSize', 20);
    fitxerfig=[outputPath '\Bz_' sampleName '.png'];
    textfig=[outputPath '\Bz_' sampleName '.fig'];
    print('-dpng',fitxerfig);
    saveas(gcf,textfig);

    figure(2)
    mesh(xm2*1e3,ym2*1e3,M2);
    xlabel('x [mm]','FontSize', 20);
    ylabel('y [mm]','FontSize', 20);
    set(gca,'fontsize',14); set(gcf,'Color','white');
    zlabel('M [A/m]');
    fitxerfig=[outputPath '\M_' sampleName '.png'];
    textfig=[outputPath '\M_' sampleName '.fig'];
    print('-dpng',fitxerfig);
    saveas(gcf,textfig);

    figure(3)
    mesh(xj2*1e3,yj2*1e3,Jv2);
    xlabel('x [mm]','FontSize', 20);
    ylabel('y [mm]','FontSize', 20);
    set(gca,'fontsize',14); set(gcf,'Color','white');
    zlabel('J_v [A/m^2]');
    fitxerfig=[outputPath '\Jv_' sampleName '.png'];
    textfig=[outputPath '\Jv_' sampleName '.fig'];
    print('-dpng',fitxerfig);
    saveas(gcf,textfig);

    figure(4)
    C=contour(xj2*1e3,yj2*1e3,Jv2);
    clabel(C);
    xlabel('x [mm]','FontSize', 20);
    ylabel('y [mm]','FontSize', 20);
    set(gca,'fontsize',14); set(gcf,'Color','white');
    fitxerfig=[outputPath '\contorndensitatJ_' sampleName '.png'];
    textfig=[outputPath '\contorndensitatJ_' sampleName '.fig'];
    print('-dpng',fitxerfig);
    saveas(gcf,textfig);

    figure(5)
    quiver(xj2*1e3,yj2*1e3,Jx2,Jy2);
    xlabel('x [mm]','FontSize', 20);
    ylabel('y [mm]','FontSize', 20);
    set(gca,'fontsize',14); set(gcf,'Color','white');
    fitxerfig=[outputPath '\curl(M)_' sampleName '.png'];
    textfig=[outputPath '\curl(M)_' sampleName '.fig'];
    print('-dpng',fitxerfig);
    saveas(gcf,textfig);

    figure(6)
    plot(xb2(:,floor(size(B2,2)/2)),B2(:,floor(size(B2,2)/2)));
    hold on
    plot(xb2(:,floor(size(B2,2)/2)),Bd2(:,floor(size(B2,2)/2)),'r');
    hold off
    fitxerfig=[outputPath '\tall_filamig_B_Bd_' sampleName '.png'];
    textfig=[outputPath '\tall_filamig_B_Bd_' sampleName '.fig'];
    print('-dpng',fitxerfig);
    saveas(gcf,textfig);

    % empaqueta les figures i les esborra (nomes funciona en Linux?)
    % empaqueta=['zip Pictures_' sampleName '.zip ' outputPath '\*.png'];
    % system(empaqueta);
    % system(['del ' outputPath '\*.png']);


    fprintf('Temps recalcul de Bz')
    temps3-temps2
    %}


end