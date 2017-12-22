function f = d_index(c1,c2)

    l_month = {    'F'    'G'    'H'    'J'    'K'    'M'    'N'    'Q'    'U'    'V'    'X'    'Z'};
    
    x1 = find(strcmp(c1,l_month));
    x2 = find(strcmp(c2,l_month));
    
    if(x2>x1)
        f=x2-x1;
    else
        f=12-(x1-x2);
    end
end

