    
% Only input required !
options=1:4;


for option = options

    inputs = {
        'G:/My Drive/PhD/EXPERIMENTS/Hall_routine/outputs/Normal_tapes/FESC_normal_tape_3cm_2021_7_16_13_8/calcul_fourier_FESC_normal_tape_3cm_2021_7_16_13_8.mat', ...        
        'G:/My Drive/PhD/EXPERIMENTS/Hall_routine/outputs/Only_delamination/FESC_edge_removal_study_I_2021_8_6_14_29/calcul_fourier_FESC_delam_study_2021_8_6_14_29.mat', ...
        'G:/My Drive/PhD/EXPERIMENTS/Hall_routine/outputs/Only_delamination/FESC_edge_removal_study_II_2021_8_10_15_54/calcul_fourier_FESC_edge_removal_study_II_2021_8_10_15_54.mat', ...
        'G:/My Drive/PhD/EXPERIMENTS/Hall_routine/outputs/FESC_Cu_cut_polished_plate_2021_9_1_14_41/calcul_fourier_FESC_Cu_cut_polished_plate_2021_9_1_14_41.mat'
    };


    outputs = {
        'G:/My Drive/PhD/ANALYSIS/Experimental/Delamination technique/FESC_normal_tape_3cm_2021_7_16_13_8/', ...        
        'G:/My Drive/PhD/ANALYSIS/Experimental/Delamination technique/I/', ...
        'G:/My Drive/PhD/ANALYSIS/Experimental/Delamination technique/II/', ...
        'G:/My Drive/PhD/ANALYSIS/Experimental/Delamination technique/III/'
    };

    input = char(inputs(option));
    output = char(outputs(option));

    % Get input
    load(input)

    % Create output
    if ~exist(output, 'dir')
       mkdir(output)
    end

    % init J_filtered
    J_filtered=filter_J(Jv2);
    
    % plot
    mesh(xj2*1e3,yj2*1e3,J_filtered);
    view(0,0);

    % Do it once for the whole thing
    % individual_J_avg(J_filtered, Jv2, xj2, yj2, 1, size(J_filtered,2), output)

    % Split each tape
    % start advancing in Hall scan's y direction
    j_max=size(Jv2,2);
    j=1;
    while j<j_max
        % fast forward in y direction until start of tape (j)
        while nnz(J_filtered(:,j))==0 && j<j_max 
            j=j+1;
        end
        % if no more tape, exit loop 
        if j == j_max
            break
        end
        k=j;
        % fast forward in y direction until end of tape(k)
        while nnz(J_filtered(:,k))>0 && k<j_max
            k=k+1;
        end
        % compute J_norm for this section (j->k) of the scan
        individual_J_avg(J_filtered, Jv2, xj2, yj2, j, k, output)
        % update start of next tape from j to k
        j=k;
    end
    fprintf('\n')

    
end
    



