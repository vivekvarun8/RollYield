function [f g h k] = alive2(sdate,database,contract_num,d)

f = 1; counter =0;x=sdate; IR = []; h={database{contract_num,1}};g=[];k=[contract_num];
[row col] = size(database);

    for i=contract_num:row-1
        
        x1 = find(datenum(sdate) == datenum(datetime(database{i,2}.TimeInfo.StartDate) + days(database{i,2}.Time)));
        
        x2 = find(datenum(sdate) == datenum(datetime(database{i+1,2}.TimeInfo.StartDate) + days(database{i+1,2}.Time)));
        c1 = database{i,1}(end-4);
        c2 = database{i+1,1}(end-4);
        
        if(~isempty(x2) && f <=100)
            f = f +1;
            g = [g, ((database{i,2}.Data(x1)/database{i+1,2}.Data(x2))-1)/d_indexing(c1,c2)];
            h(f) = {database{i+1,1}};
            k = [k,i+1];
        else
            break;
        end
    end
    
end

