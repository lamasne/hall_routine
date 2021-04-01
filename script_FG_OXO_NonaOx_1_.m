clc
close all


%
Voltaga1 = data(:,3);
Voltage2 = data(:,4);
R_raw = data(:,5);
T_raw = data(:,6);
t_raw = data(:,9);

% Getting rid of the noisy values 
R_index = find(R_raw>0 & R_raw<0.22);
R = R_raw(R_index);
T = T_raw(R_index);
temp = t_raw(R_index);

% putting order in the graph 
R_heat = find(temp < max(temp));

voltage = abs(Voltaga1); %+ abs(Voltage2))/2;

figure(1);
grid on; hold on; box on;
swift = 1.054e4;
plot(temp(1:end/2-swift),R(1:end/2-swift),'ro'); 
plot(temp(end/2-swift:end),R(end/2-swift:end),'bs');
plot(temp,T.*3.25e-4,'go');

%
figure(2);
grid on; hold on; box on;
plot(T(1:end/2-swift),R(1:end/2-swift),'ro'); 
plot(T(end/2-swift:end),R(end/2-swift:end),'bs');

figure(4);
grid on; hold on; box on;
ax1 = subplot(2,1,1);
plot(temp,R);
ax2 = subplot(2,1,2);
plot(temp,T); 
%}

figure(5);
p = [10 600 3;
     -4.1 500 3;
     -3.1 450 3;
     -2.7 425 6;
     -2.4 375 6;
     -2.1 350 10;
     -1.9 325 12;
     -1.2 -0.1 0];
 
 T0 = 62;
 t0 = 0;
 p = [p(:,1)./60 p(:,2) p(:,3)*60];
 Y = []; X=[];
for i = 1:length(p(:,1))
    
    time = linspace(t0,t0+(p(i,2)-T0)/p(i,1),10);
    dwell = linspace(time(end),time(end)+ p(i,3),10);
    
    ramp = p(i,1).*(time-t0)+T0;
    plateau = ones(1,length(dwell)).*p(i,2);

    %plot(time,p(i,1)*(time-t0)+T0); hold on;
    %plot(dwell,ones(length(dwell)).*p(i,2));
    
    Y = [Y ramp plateau];
    X = [X time dwell];
    
    if p(i,2)<0
        break
    else
        T0 = p(i,2);
        t0 = time(end)+p(i,3);
    end
    
end
plot(X/60,Y,'bs'); hold on;
plot(temp/60,T,'go');
%}