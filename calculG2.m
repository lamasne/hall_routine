function [ G ] = calculG2(Xo,Xf,Yo,Yf,Zo,Zf,Xb,Yb,Zb )
% Abel Purti, UPC, Barcelona
% Versio vectorial: calcula cada columna de G d'un sol cop
% 2016/3/2
% provat i funciona

%Calcul matriu G
Nel=length(Xo);
G=[];
Nef=length(Xb);

for k=1:Nel,
    
    %Es tracta d'una suma de arcs tangents
    F11=atan(((Zb-Zf(k)).*(Xb-Xf(k)))./((Yb-Yf(k)).*sqrt((Zb-Zf(k)).^2+(Xb-Xf(k)).^2+(Yb-Yf(k)).^2)));
    F12=atan(((Zb-Zf(k)).*(Xb-Xo(k)))./((Yb-Yf(k)).*sqrt((Zb-Zf(k)).^2+(Xb-Xo(k)).^2+(Yb-Yf(k)).^2)));
    F13=atan(((Zb-Zo(k)).*(Xb-Xf(k)))./((Yb-Yf(k)).*sqrt((Zb-Zo(k)).^2+(Xb-Xf(k)).^2+(Yb-Yf(k)).^2)));
    F14=atan(((Zb-Zo(k)).*(Xb-Xo(k)))./((Yb-Yf(k)).*sqrt((Zb-Zo(k)).^2+(Xb-Xo(k)).^2+(Yb-Yf(k)).^2)));
    
    F1=F11-F12-F13+F14;
    
    F21=atan(((Zb-Zf(k)).*(Xb-Xf(k)))./((Yb-Yo(k)).*sqrt((Zb-Zf(k)).^2+(Xb-Xf(k)).^2+(Yb-Yo(k)).^2)));
    F22=atan(((Zb-Zf(k)).*(Xb-Xo(k)))./((Yb-Yo(k)).*sqrt((Zb-Zf(k)).^2+(Xb-Xo(k)).^2+(Yb-Yo(k)).^2)));
    F23=atan(((Zb-Zo(k)).*(Xb-Xf(k)))./((Yb-Yo(k)).*sqrt((Zb-Zo(k)).^2+(Xb-Xf(k)).^2+(Yb-Yo(k)).^2)));
    F24=atan(((Zb-Zo(k)).*(Xb-Xo(k)))./((Yb-Yo(k)).*sqrt((Zb-Zo(k)).^2+(Xb-Xo(k)).^2+(Yb-Yo(k)).^2)));
    
    F2=F21-F22-F23+F24;
    
    F31=atan(((Zb-Zf(k)).*(Yb-Yf(k)))./((Xb-Xf(k)).*sqrt((Zb-Zf(k)).^2+(Xb-Xf(k)).^2+(Yb-Yf(k)).^2)));
    F32=atan(((Zb-Zf(k)).*(Yb-Yo(k)))./((Xb-Xf(k)).*sqrt((Zb-Zf(k)).^2+(Xb-Xf(k)).^2+(Yb-Yo(k)).^2)));
    F33=atan(((Zb-Zo(k)).*(Yb-Yf(k)))./((Xb-Xf(k)).*sqrt((Zb-Zo(k)).^2+(Xb-Xf(k)).^2+(Yb-Yf(k)).^2)));
    F34=atan(((Zb-Zo(k)).*(Yb-Yo(k)))./((Xb-Xf(k)).*sqrt((Zb-Zo(k)).^2+(Xb-Xf(k)).^2+(Yb-Yo(k)).^2)));
    
    F3=F31-F32-F33+F34;
    
    F41=atan(((Zb-Zf(k)).*(Yb-Yf(k)))./((Xb-Xo(k)).*sqrt((Zb-Zf(k)).^2+(Xb-Xo(k)).^2+(Yb-Yf(k)).^2)));
    F42=atan(((Zb-Zf(k)).*(Yb-Yo(k)))./((Xb-Xo(k)).*sqrt((Zb-Zf(k)).^2+(Xb-Xo(k)).^2+(Yb-Yo(k)).^2)));
    F43=atan(((Zb-Zo(k)).*(Yb-Yf(k)))./((Xb-Xo(k)).*sqrt((Zb-Zo(k)).^2+(Xb-Xo(k)).^2+(Yb-Yf(k)).^2)));
    F44=atan(((Zb-Zo(k)).*(Yb-Yo(k)))./((Xb-Xo(k)).*sqrt((Zb-Zo(k)).^2+(Xb-Xo(k)).^2+(Yb-Yo(k)).^2)));
    
    F4=F41-F42-F43+F44;
    G1=-F1+F2-F3+F4;
    G=[G,G1];
end




G=1e-7*G;