%Function Bloch_Visualyzer
%------------------------------------------------------------------------
%Description:
%Script to aid visualization of quantum gates on a qubits state via the
%bloch sphere

%Required Files:
%N/A
%------------------------------------------------------------------------
%INPUT: 
% User prompted

%OUTPUT: 
%  N/A
%------------------------------------------------------------------------

function blochVisualizer()
%                       ENVIRONMENT SETUP
%--------------------------------------------------------------------
    clf;
    clc;
    disp('Quantum Gate Visualizer')
    disp('--------------------------------------------');
    disp('Author: Christian Sargusingh')
    disp('Date: 2018-02-16')
    disp('--------------------------------------------');
    disp('Operations: [X] [Z] [H] [S] [S+] [T] [T+] [Any key] to quit');
    
    %construct Bloch Sphere
    [x,y,z] = sphere(100);
    h = surf(x,y,z);
    h.LineStyle = ':';
    h.EdgeColor = [0.8 0.8 0.8];
    alpha 0.1;
    
    g =gcf;
    g.Color = [0.1 0.1 0.1];
    
    %Set axis properties
    a = gca;
    a.GridLineStyle = 'none';
    colormap spring; 
    hold on;
    axis tight;
    axis equal;
    axis off;
    
    %plot axis and state vector
    plot3([0;1],[0;0],[0;0],'LineWidth',2,'Color','g');
    plot3([0;0],[0;1],[0;0],'LineWidth',2,'Color','r');
    plot3([0;0],[0;0],[0;1],'LineWidth',2,'Color','b');
    v = plot3([0;0],[0;0],[0;1],'LineWidth',3,'Color','m');
    %assign via loop?
    txt = text(0,1.2,0,'|+>');
    txt1 = text(0,-1.2,0,'|->');
    txt2 = text(1.2,0,0,'ø');
    txt3 = text(-1.2,0,0,'ø');
    txt4 = text(0,0,1.2,'1');
    txt5 = text(0,0,-1.2,'0');
    
    txt.Color = [1 1 1];
    txt1.Color = [1 1 1];
    txt2.Color = [1 1 1];
    txt3.Color = [1 1 1];
    txt4.Color = [1 1 1];
    txt5.Color = [1 1 1];

    %set viewframe
    view([-15,-20]);
    camzoom(1.5);
    
    
 
%                 MAIN PROGRAM EVENT LOOP
%--------------------------------------------------------------------
    while true
        %gate input from user
        prompt = 'Input a Quantum Gate: ';
        str = input(prompt,'s');

        %set transformation parameters
        if str == 'X'
            rax = [0 1 0];
            theta = 180;
        elseif str == 'Z'
            rax = [0 0 1];
            theta = 180;
        elseif str == 'H'
            rax = [0 1 1];
            theta = 180;
        elseif str == 'S'
            rax = [0 0 1];
            theta = 90;
        elseif str == 'S+'
            rax = [0 0 1];
            theta = -90;
        elseif str == 'T'
            rax = [0 0 1];
            theta = 45;
        elseif str == 'T+'
            rax = [0 0 1];
            theta = -45;
        else
            disp('Exiting program...');
            close(gcf);
            return;
        end
        
        %plot rotational axis
        plot3([-rax(1);rax(1)],[-rax(2);rax(2)],[-rax(3);rax(3)],'LineWidth',2,'Color','w','LineStyle',':');
        
        %create a tag for each axis
        if rax(2)+rax(3) > 1
            ax = 'X+Z';
        elseif rax(2) > 0
            ax = 'X';
        else
            ax = 'Z';
        end
        
        %print transformation results
        T = table({ax},theta);
        T.Properties.VariableNames = {'Axis','Angle'};
        disp(T)
        
        %Animate Transformations
        if theta < 0
            dir = -1;
        else
            dir = 1;
        end
        
        %This algorithm boosts animation efficiency by removing alot of the
        %calculations outside the animation loop. Instead using an array,
        %the animation loop simply traverses through a precalculated matrix
        
        %preallocate speed array for efficiency
        s = zeros(180,1);
        syms t;
        
        %fill a with all positive angles from 1 to the max rotation angle
        if abs(theta) == 180
            u = linspace(1,180,180)';
            d = int(-0.001*t.^2+(abs(theta))/1000*t,t,1,180);
            for j = 1:1:length(u)
                s(j,1) = -0.001*u(j,1)^2+(abs(theta))/1000*u(j,1);
            end
        elseif abs(theta) == 90
            u = linspace(1,90,90)';
            d = int((-0.01*t.^2+(abs(theta))/100*t)/2,t,1,90);
            for j = 1:1:length(u)
                s(j,1) = (-0.01*u(j,1)^2+(abs(theta))/100*u(j,1))/2;
            end
        else
            u = linspace(1,45,45)';
            d = int(-0.01*t.^2+(abs(theta))/100*t,t,1,45);
            for j = 1:1:length(u)
                s(j,1) = -0.01*u(j,1)^2+(abs(theta))/100*u(j,1);
            end
        end
        
        %angular displacement constant
        c = dir*double(abs(theta)/d);
        
        for j = 1:1:length(u)
            %animate transformations
            rotate(h,rax,c*s(j,1));
            rotate(v,rax,c*s(j,1)); 
            drawnow;
        end
    end
    
    
end %end of script