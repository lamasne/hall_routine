clear
clc
close all

load('calcul_fourier_SDP-FG-93(3)_2018_6_25_15_1__filtrat')

Thick = 3.0e-6;
width = 1.2;

figure(7)
mesh(Jx2);
%mesh(xj2*1e3,yj2*1e3,Jx2);
title('X component of J_c')
xlabel('x [mm]','FontSize', 20);
ylabel('y [mm]','FontSize', 20);
set(gca,'fontsize',14); set(gcf,'Color','white');

figure(8)
mesh(Jy2);
%mesh(xj2*1e3,yj2*1e3,Jy2);
title('Y component of J_c')
xlabel('x [mm]','FontSize', 20);
ylabel('y [mm]','FontSize', 20);
set(gca,'fontsize',14); set(gcf,'Color','white');

figure(9)
Line = 158;
plot(yj2(1,1:end/2),Jx2(Line,1:end/2),'rs'); hold on;
plot(yj2(1,end/2:end),Jx2(Line,end/2:end),'go');
plot(yj2(1,:),Jx2(Line,:),'b-');
JycPos=trapz(yj2(1,1:end/2),Jx2(Line,1:end/2));
JycNeg=trapz(yj2(1,end/2:end),Jx2(Line,end/2:end));
JycMean = 0.5*(JycPos-JycNeg);
IycPos = 2*JycPos*Thick/width;
IycNeg = 2*JycNeg*Thick/width;

figure(10)
Line = 158;
plot(xj2(end/2-1:end,1),Jy2(end/2-1:end,Line),'rs'); hold on;
plot(xj2(1:end/2-1,1),Jy2(1:end/2-1,Line),'go');
plot(xj2(:,1),Jy2(:,Line),'b-');
JxcPos=trapz(xj2(end/2-1:end,1),Jy2(end/2-1:end,Line));
JxcNeg=trapz(xj2(1:end/2-1,1),Jy2(1:end/2-1,Line));
JxcMean = 0.5*(JxcPos-JxcNeg);
IxcPos = 2*JxcPos*Thick/width;
IxcNeg = 2*JxcNeg*Thick/width;