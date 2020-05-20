0
clc
clear
close all

delimiterIn    = ' ';
headerlinesIn  = 21;
format long;

n = 10;

for i=1 : n
    %filename = ['MainWing_' num2str(i) 'AR.txt'];
    filename = ['MainWing_a=5.00_v=50.00ms_' num2str(i) 'AR.txt'];
   
    if exist(filename, 'file')
        analysis_struct = importdata(filename, delimiterIn, headerlinesIn);

        fields = fieldnames(analysis_struct);
        analysis = char(fields(1));

        wing_analysis = analysis_struct.(analysis);

        cl = wing_analysis(:,4);
        cd = wing_analysis(:,6);
        yw = wing_analysis(:,1);

        norm_yw = max(yw);

        yw = yw / norm_yw;

        % grafico - Cl vs Wingspan 
        figure(1);
        hold on;
        if i == n
            plot(yw, cl, '-', 'MarkerSize', 20, 'LineWidth', 2, 'Color', [0 0 1]);
        else
            plot(yw, cl, '-', 'MarkerSize', 20, 'LineWidth', 2, 'Color', [0 (1 - (0.07 * (i - 1))) 1]);
        end

        if i == 10
            %text(0.10, (cl(22) + 0.008), strcat('\bf\downarrow AR = ', {' '}, num2str(i)), 'Color', 'red')
            text(0.10, (cl(22) + 0.011), strcat('\bf\downarrow AR = ', {' '}, num2str(i)), 'Color', 'red')
        elseif i == 7 || i == 9
            text(-0.10, (cl(17) - 0.003), strcat('\bf\uparrow AR = ', {' '}, num2str(i)), 'Color', 'red', 'HorizontalAlignment', 'right')
        elseif mod(i, 2) == 0 % 'i' pari
            text(0.10, (cl(22) - 0.003), strcat('\bf\uparrow AR = ', {' '}, num2str(i)), 'Color', 'red')
        else % 'i' dispari
            text(-0.10, (cl(17) + 0.008), strcat('\bf\downarrow AR = ', {' '}, num2str(i)), 'Color', 'red', 'HorizontalAlignment', 'right')
        end
        hold off;    
       
        %  grafico - Cd vs Wingspan
        figure(2);
        hold on;
        if i == n
            plot(yw, cd, '-', 'MarkerSize', 20, 'LineWidth', 2, 'Color', [0 0 1]);
        else
            plot(yw, cd, '-', 'MarkerSize', 20, 'LineWidth', 2, 'Color', [0 (1 - (0.07 * (i - 1))) 1]);
        end

        if i == 1
            %text(0.10, (cd(22) + 0.00015), strcat('\bf\downarrow AR = ', {' '}, num2str(i)), 'Color', 'red')
            text(0.10, (cd(22) + 0.0002), strcat('\bf\downarrow AR = ', {' '}, num2str(i)), 'Color', 'red')
        elseif i == 2
            text(0.10, (cd(22) - 0.00004), strcat('\bf\uparrow AR = ', {' '}, num2str(i)), 'Color', 'red')
        elseif i == 4
            %text(0.10, (cd(22) - 0.0001), strcat('\bf\uparrow AR = ', {' '}, num2str(i)), 'Color', 'red')
            text(0.10, (cd(22) - 0.00015), strcat('\bf\uparrow AR = ', {' '}, num2str(i)), 'Color', 'red')
        elseif i == 6
            %text(-0.10, (cd(17) + 0.0001), strcat('\bf\downarrow AR = ', {' '}, num2str(i)), 'Color', 'red', 'HorizontalAlignment', 'right')
            text(-0.10, (cd(17) + 0.00015), strcat('\bf\downarrow AR = ', {' '}, num2str(i)), 'Color', 'red', 'HorizontalAlignment', 'right')
        elseif i == 7 || mod(i, 2) == 0 % 'i' pari
            %text(0.10, (cd(22) - 0.00015), strcat('\bf\uparrow AR = ', {' '}, num2str(i)), 'Color', 'red')
            text(0.10, (cd(22) - 0.0002), strcat('\bf\uparrow AR = ', {' '}, num2str(i)), 'Color', 'red')
        else % 'i' dispari
            %text(-0.10, (cd(17) + 0.0001), strcat('\bf\downarrow AR = ', {' '}, num2str(i)), 'Color', 'red', 'HorizontalAlignment', 'right')
            text(-0.10, (cd(17) + 0.00015), strcat('\bf\downarrow AR = ', {' '}, num2str(i)), 'Color', 'red', 'HorizontalAlignment', 'right')
        end
        hold off;
      
    end
    
    if i == n
        figure(1)
        title(strcat('(Cl vs Wingspan)'));

        xlabel('yw');
        ylabel('Cl');
        xline(0, '-k');
        yline(0, '-k');
        %axis([-1.05 1.05 0.0 0.4])
        axis([-1.05 1.05 0.0 0.5])
        grid on

        set(gcf, 'Position', get(0, 'Screensize'));
        saveas(gcf, strcat(fileparts(mfilename('fullpath')), '\ClvsWingspan.png'))
        
        
        figure(2)
        title(strcat('Resistenza indotta al variare di AR'));

        xlabel('yw');
        ylabel('Cd');
        xline(0, '-k');
        yline(0, '-k');
        %axis([-1.05 1.05 0.0002 0.006])
        axis([-1.05 1.05 0.0004 0.0093])
        grid on
            
        set(gcf, 'Position', get(0, 'Screensize'));
        saveas(gcf, strcat(fileparts(mfilename('fullpath')), '\CdvsWingspan.png'))
    end
end

