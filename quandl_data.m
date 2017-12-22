function database = dldata(m,symbol,hist)

%api_key=('n41pyw2wd2u5yTEHQ6L3');
Quandl.api_key('n41pyw2wd2u5yTEHQ6L3');

month = m;
xy = char(symbol);
baseyear = str2num(xy(end-3:end))-1;
% baseyear = 2021; % remove this after testing
z = find(strcmp(xy(end-4),m));
xy = xy(1:end-5);
counter=1;
database = {};trigger=0;

for i =1:hist
    for j=z:numel(month)
    symbol = strcat(xy,month(j),num2str(baseyear+i));
    
    try
        
    eval(['data_' num2str(counter) ' = Quandl.get(symbol)';]);
    
    eval(['get(data_' num2str(counter) ')';]);
    database{1,counter} = eval(['data_' num2str(counter) '.Name';]);
    database{2,counter} = eval(['data_' num2str(counter) '.Settle';]);
    eval(['x = get(data_' num2str(counter) ')';]);
    
    if(isfield(x,'PreviousDayOpenInterest'))
    database{3,counter} = eval(['data_' num2str(counter) '.PreviousDayOpenInterest';]);
    elseif(isfield(x,'Prev_DayOpenInterest'))
       database{3,counter} = eval(['data_' num2str(counter) '.Prev_DayOpenInterest';]);
    else
        database{3,counter} = eval(['data_' num2str(counter) '.OpenInterest';]);
    end
    
    catch
         return          
    end
        counter = counter+1;
    end  
    z=1;
    


end
database=database';
end
