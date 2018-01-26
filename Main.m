%clear all

clearvars
clearvars -GLOBAL
close all

global C
global X Y

    C.q_0 = 1.60217653e-19;             % electron charge
    C.hb = 1.054571596e-34;             % Dirac constant
    C.h = C.hb * 2 * pi;                % Planck constant
    C.m_0 = 9.10938215e-31;             % electron mass
    C.kb = 1.3806504e-23;               % Boltzmann constant
    C.eps_0 = 8.854187817e-12;          % vacuum permittivity
    C.mu_0 = 1.2566370614e-6;           % vacuum permeability
    C.c = 299792458;                    % speed of light
    C.g = 9.80665;                      % metres (32.1740 ft) per s²
    
mn=0.26*C.m_0; %electron mass
Temp = 300; %Given in kelvin
rTime=1000; %run time in timesteps

%thermal velocity
Vth = sqrt(2*C.kb*Temp/mn);

%establish inital electron positions
%working area 200nm x 100nm
workX=200*10^-9;
workY=100*10^-9;

size=10;

X= rand(2,size);
Y= rand(2,size);

%positions
X(1,:)= X(1,:)*workX;
Y(1,:)= Y(1,:)*workY;

colour = rand(1,size);
%initial direction of each particle
angle(1,:) = X(2,:)*2*pi;

%velocity of each particle
X(2,:) = Vth*cos(angle(1,:));
Y(2,:) = Vth*sin(angle(1,:));

%set timestep of function
spacStep = 0.01*workY;
dt = spacStep/Vth;
steps = 1000;

%variable change
%setup mapping
Xpos = X(1,:);
Ypos = Y(1,:);

Xvel = X(2,:)*dt;
Yvel = Y(2,:)*dt;

figure(1)
%main function
for i = 1:1:steps
    %advance position
    for j =1:1:size
        if(Xpos(1,j)+Xvel(1,j)>2e-7)%check boundaries
            Xpos(1,j) = (Xpos(1,j)+Xvel(1,j))-workX;%loop around to 0
        elseif(Xpos(1,j)+Xvel(1,j)<0)
            Xpos(1,j) = (Xpos(1,j)+Xvel(1,j))+workX;
        else
            Xpos(1,j) = Xpos(1,j)+Xvel(1,j);
        end
        
        if(Ypos(1,j)+Yvel(1,j)>1e-7 || Ypos(1,j)+Yvel(1,j)<0)
            Yvel(1,j) = Yvel(1,j)*(-1);
            Ypos(1,j) = Ypos(1,j)+Yvel(1,j);
        else
            Ypos(1,j) = Ypos(1,j)+Yvel(1,j);
        end
    end
    
    calcTemp = 1/(2*C.kb)*mn*sqrt((Yvel/dt).^2+(Xvel/dt).^2).^2;
    averageTemp = sum(calcTemp(1,:))/size;
    
    prevX(i,:) =Xpos(1,:);
    prevY(i,:) =Ypos(1,:);
    
    %plotting here
    for j = 1:1:size
        plot(prevX(:,j),prevY(:,j),'color',[colour(1,j) 0 j/size])
        xlim([0 workX])
        ylim([0 workY])
        legend(['Temperature:' num2str(averageTemp)])
        drawnow
        hold on
    end
    
    
end