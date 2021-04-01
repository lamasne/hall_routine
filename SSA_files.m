function F = SSA_files(F,L,eigen)
%Realitza un filtratge SSA per files de la matriu F amb window length L i
%agafant I =1:eigen eigentriples per definir la component sense soroll.
%
% Arnau Duran, UPC, Barcelona
% 2017/3/19

% provat i funciona


%Nombre de files de la matriu:

files = length(F(:,1));


%Treballarem sobre la matriu F.

for h = 1:files
    x1 = F(h,:);
    N=length(x1);
    
    %%%%%%%
    % 1a part: Descomposici� amb la L imposada.


    
    % Creem la trajectory matrix:

    if L>N/2;L=N-L;end
    K=N-L+1; 
    X=zeros(L,K);  
    for i=1:K
        X(1:L,i)=x1(i:L+i-1); 
    end

    %Fem la SVD

    S=X*X'; 
    [U,autoval]=eig(S);
    [d,i]=sort(-diag(autoval));  
    d=-d; %d cont� els valors propis ordenats de gran a petit
    U=U(:,i); %ara ordenem tamb� els veps amb el mateix ordre que els vaps.
    V = (X')*U; %la columna i-�ssima de la matriu �s el vector Vi dels apunts.
    
    %Reconstrucci�
    
    I = 1:eigen; %Aqu� fixem quins grups volem que formin part del trend
    
    Vt=V';
    rca=U(:,I)*Vt(I,:);


    y=zeros(N,1);  
    Lp=min(L,K);
    Kp=max(L,K);

    for k=0:Lp-2
      for m=1:k+1;
       y(k+1)=y(k+1)+(1/(k+1))*rca(m,k-m+2);
      end
    end

    for k=Lp-1:Kp-1
      for m=1:Lp;
       y(k+1)=y(k+1)+(1/(Lp))*rca(m,k-m+2);
      end
    end

    for k=Kp:N
       for m=k-Kp+2:N-Kp+1;
        y(k+1)=y(k+1)+(1/(N-k))*rca(m,k-m+2);
       end
    end
   
    F(h,:) = y';
end


end

