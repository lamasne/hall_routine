    

function J_filtered = filter_J(Jv2)
    [i_max, j_max]=size(Jv2);
    J_filtered=Jv2;
    J_max=max(max(Jv2));

    for i = 1:i_max
        for j=1:j_max
            if Jv2(i,j) < J_max/4
                J_filtered(i,j)=0;
            end
        end
    end
    
end