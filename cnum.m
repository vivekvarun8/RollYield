function f = cnum(contract_in,database,j)

for i=j:1000
    if(strcmp(contract_in,database{i,1}))
        f=i;
        break;
    end
end
end
