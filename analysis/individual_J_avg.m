

% Get mean
function compute_J_norm(J_filtered, J_tot, xj2, yj2, j, k, output)
    
    fprintf('j=%d, k=%d\n', j, k)    

    % init useful values surface
    real_width = 12;
    delta_x=(xj2(2,1)-xj2(1,1))*1e3;
    delta_y=(yj2(1,2)-yj2(1,1))*1e3;
    J_tmp = J_filtered(:,j:k);
    x = xj2(:,j:k)*1e3;
    y = yj2(:,j:k)*1e3;
    tol = 2; %2mm of tolerancia for tot width

    % Get dimensions
    [tot_width, tot_length, start_width, end_width, start_length, end_length] = get_dimensions(J_tmp, delta_x, delta_y);
    fprintf('tot_width=%4.2f, tot_length=%4.2f, start_width=%d, end_width=%d, start_length=%d, end_length=%d \n', tot_width, tot_length, start_width, end_width, start_length, end_length)
        
    % Change indices to match the tape's real dimensions
    % check if tape is horizontal or vertical
    if norm(tot_width-real_width) < norm(tot_length-real_width) % tape in hall scan y direction
        if tot_width < real_width + tol
            missing_width = (real_width - tot_width);
            missing_pts = missing_width/delta_x;
            a = floor(start_width-missing_pts/2);
            b = floor(end_width+missing_pts/2);            
            if a<=0
                a = 1;
                b = floor(end_width+missing_pts);
            elseif b>size(J_tot,1)
                a = floor(start_width-missing_pts);
                b = size(J_tot,1);
            end
            fprintf('Correcting width: a=%d, b=%d, c=%d, d=%d\n', a,b,j,k)
            J_tmp = J_tot(a:b,j:k);
            x = xj2(a:b,j:k)*1e3;
            y = yj2(a:b,j:k)*1e3;
        end
    else
        if tot_length < real_width + tol
            missing_width = (real_width - tot_length);
            % fprintf('Correcting width=%4.2f\n', missing_width)
            missing_pts = missing_width/delta_y;
            a = floor(j+start_length-1-missing_pts/2);
            b = floor(j+end_length-1+missing_pts/2);         
            if a<=0
                a = 1;
                b = floor(j+end_length-1+missing_pts);         
            elseif b>size(J_tot,2)
                a = floor(j+start_length-1-missing_pts);
                b = size(J_tot,2);
            end            
            fprintf('Correcting length: a=%d, b=%d, c=%d, d=%d\n', start_width,end_width,a,b)
            J_tmp = J_tot(start_width:end_width,a:b);
            x = xj2(start_width:end_width,a:b)*1e3;
            y = yj2(start_width:end_width,a:b)*1e3;                
        end
    end

    % computes new width_filtered
    [tot_width, tot_length, ~] = get_dimensions(J_tmp, delta_x, delta_y);
    fprintf('Corrected: tot_width=%4.2f, tot_length=%4.2f\n', tot_width, tot_length)

    % computes mean value of J
    J_norm=mean(mean(J_tmp));
    cut_ratio = max(max(J_tmp))/min(min(J_tmp));
    fprintf('J_norm=%e, cut_ratio=%e\n', J_norm, cut_ratio)
    
    % Save
    matfile_name = [output 'analysis_' num2str(j,'%03d') '-' num2str(k,'%03d') '.mat'];
    save('-v7', matfile_name, 'J_tmp', 'J_norm', 'tot_width', 'tot_length', 'cut_ratio');
    
    
    % figure
    figure(1)
    xlabel('x [mm]','FontSize', 20);
    ylabel('y [mm]','FontSize', 20);
    set(gca,'fontsize',14); set(gcf,'Color','white');
    zlabel('J_v [A/m^2]');
    mesh(x,y,J_tmp);
    view(90,0);
    % png
    fitxerfig=[output 'Jv_' num2str(j,'%03d') '-' num2str(k,'%03d') '.png'];
    print('-dpng',fitxerfig);
    % fig
    textfig=[output 'Jv_' num2str(j,'%03d') '-' num2str(k,'%03d') '.fig'];
    saveas(gcf,textfig);

end

function [tot_width, tot_length, start_width, end_width, start_length, end_length] = get_dimensions(J_tmp, delta_x, delta_y)
    tot_width=0;
    tot_length=0;
    start_width = 1;
    end_width = size(J_tmp,1);
    start_length = 1;
    end_length = size(J_tmp,2);
    
    counter=0;    
    % computes tot_width
    % for each line of width
    for i = 1:size(J_tmp,1)
        % check if length is not empty
        if nnz(J_tmp(i,:)) > 0
            % mark start of tape
            if counter == 0
                start_width = i;
            end
            tot_width=tot_width+delta_x;
            counter=counter+1;
        else
            if counter > 0
                end_width = i;
                break
            end
        end
    end
    counter=0;    
    % computes tot_length
    % for each line of length
    for j = 1:size(J_tmp,2)
        % check if width is not empty
        if nnz(J_tmp(:,j)) > 0
            % mark start of tape
            if counter == 0
                start_length = j;
            end
            tot_length=tot_length+delta_y;
            counter=counter+1;
        else
            if counter > 0
                end_length = j;
                break
            end
        end
    end
end
