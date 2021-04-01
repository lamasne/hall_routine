function Bd=J2Bz3dsemianalitic(Jx,Jy,x0,xf,y0,yf,z0,zf,xb,yb,zb)
% Calcul del camp magnetic vertical Bz induit en una llista de
% punts amb coordenades xb,yb,zb 
% per un corrent electric pla Jx,Jy que es constant en cada element
% d'una llista d'elements rectangulars [x0,xf]x[y0,yf]x[z0,zf].
% La integral de Biot-Savart doble esta calculada analiticament, i aqui
% nomes s'evalua.
%
% Jaume Amoros, UPC, Barcelona
% 2014/12/18
% Provat i funciona.


% pesos i abcisses gaussianes
w=[0.033336,0.074726,0.109543,0.134633,0.147762,0.147762,0.134633,0.109543,0.074726,0.033336];
h=[0.013047,0.067468,0.160295,0.283302,0.425563,0.574437,0.716698,0.839705,0.932532,0.986953];

% abcisses en z (fila=element de corrent,columna=abcisa gaussiana
z=z0*ones(1,10)+(zf-z0)*h;

% x0,xf,y0,yf per la integracio
x0i=x0*ones(1,10);
xfi=xf*ones(1,10);
y0i=y0*ones(1,10);
yfi=yf*ones(1,10);
Jxi=Jx*ones(1,10);
Jyi=Jy*ones(1,10);

% pesos per integracio
wi=ones(size(x0))*w;


for k=1:length(xb),
    r00=sqrt((xb(k)-x0i).*(xb(k)-x0i)+(yb(k)-y0i).*(yb(k)-y0i)+(zb(k)-z).*(zb(k)-z));
    r0f=sqrt((xb(k)-x0i).*(xb(k)-x0i)+(yb(k)-yfi).*(yb(k)-yfi)+(zb(k)-z).*(zb(k)-z));
    rf0=sqrt((xb(k)-xfi).*(xb(k)-xfi)+(yb(k)-y0i).*(yb(k)-y0i)+(zb(k)-z).*(zb(k)-z));
    rff=sqrt((xb(k)-xfi).*(xb(k)-xfi)+(yb(k)-yfi).*(yb(k)-yfi)+(zb(k)-z).*(zb(k)-z));
    lnx00=log((xb(k)-x0i)+r00);
    lnx0f=log((xb(k)-x0i)+r0f);
    lnxf0=log((xb(k)-xfi)+rf0);
    lnxff=log((xb(k)-xfi)+rff);
    lny00=log((yb(k)-y0i)+r00);
    lny0f=log((yb(k)-yfi)+r0f);
    lnyf0=log((yb(k)-y0i)+rf0);
    lnyff=log((yb(k)-yfi)+rff);
    % integrand complet (taula de valors en abcisses gaussianes de un
    % element en cada fila)
    f=Jxi.*(-lnxff+lnx0f+lnxf0-lnx00)-Jyi.*(-lnyff+lnyf0+lny0f-lny00);
    Bdllista=sum((f.').*(wi.')).'; % les sumes gaussianes per tots els elements de corrent, en columna
    Bdllista=Bdllista.*(zf-z0); % la integral ajustada al domini
    
    Bd(k)=sum(Bdllista); % la suma de les integrals de tots els elements dona el camp en el punt
end;

Bd=1e-7*Bd; % multipliquem per la constant de permeabilitat magnetica del buid
    
 