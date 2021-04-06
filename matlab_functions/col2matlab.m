function A=col2matlab(fitxer)
% lectura massiva de nombres des d'un fitxer de texte en format molt
% simple:
% linea inicial assenyala inici de fitxer (qualsevol contingut),
% cada fila de nombres comenc,a per una linea que conte 'L'
% els nombres de cada fila apareixen un per linea
% La funcio deixa tots aquests nombres com a columnes d'una matriu
% i si les longituds son desiguals, les mes curtes queden allargades amb
% zeros.
% INPUT: fitxer=nom complet del fitxer (amb l'extensio final, entre ' ')
% OUTPUT: A=matriu amb files les files de lectures de la sonda (allargades
% per zeros en cas de ser curtes).
%
% Jaume Amoros, UPC, Barcelona
% 2011/2/9
% Provat i funciona.

entrada=fopen(fitxer,'r')

linea=fgetl(entrada);

f=0;
cmax=0;
A=[];

while 1
    linea=fgetl(entrada);
    if ~ischar(linea) || length(linea)==0, break, end
    if (linea=='L')
        f=f+1;
        c=1;
    else
        if c>cmax
            A=[A,zeros(f,1)];
            cmax=cmax+1;
        end;
        A(f,c)=eval(linea);
        c=c+1;
    end;
end;

%A=A'; % descomentar per a que les files de lectura siguin columnes de A
fclose(entrada);


