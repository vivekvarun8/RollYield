load MarketList.mat
%Quandl.api_key = 'n41pyw2wd2u5yTEHQ6L3';

results = struct;startdate='01-Dec-2009';
%DB = struct;
enddate = '08-Aug-2017';counter=1;error_contracts={};
i=1;

l_month = {    'F'    'G'    'H'    'J'    'K'    'M'    'N'    'Q'    'U'    'V'    'X'    'Z'};
month_schedule = {'Jan'  'Feb'  'Mar'  'Apr'  'May'  'Jun'  'Jul'  'Aug'  'Sep'  'Oct'  'Nov'  'Dec'};

[m1 m2]= month(startdate);
m3 = l_month(find(strcmp(m2,month_schedule)));


while(i<=10)
    
    
    
    avail_month = cellstr(char(MarketList.Months(i))')';
    %baseyear = year(datetime(MarketList.StartDate(i)));
    baseyear = year(startdate);
    symbol = char(MarketList.FirstContract(i));
    
    if(d_indexing(m3,avail_month(1))>1)
        symbol(end-4) = char(avail_month(1));
    else 
        symbol(end-4) = char(avail_month(1));
    end
    
    symbol = strcat(char(MarketList.Exchange(i)),'/',char(MarketList.Symbol(i)),symbol);
    hist = 2050-baseyear;
    database = quandl_data(avail_month,symbol,hist);
    database = database';
    %eval([ 'DB.' char(MarketList.Symbol(i)) '= database';])
    temp1=symbol(1:end-5);
    temp1(4)='_';
    eval([ 'DB.' temp1 '= database';])
    eval([ 'save DB.mat DB'])
    
    try
    [T H L Q] = MP1(database,11,MarketList.ContractSize(i),symbol,avail_month,enddate);
    eval([ 'results.' char(MarketList.Symbol(i)) '.summary' '= T';])  
    eval([ 'results.' char(MarketList.Symbol(i)) '.database' '= database';])
    eval([ 'results.' char(MarketList.Symbol(i)) '.performance.Data' '= H';])
    eval([ 'results.' char(MarketList.Symbol(i)) '.Exhibit_6' '= L';])
    eval([ 'results.' char(MarketList.Symbol(i)) '.Exhibit_9' '= Q';])
    eval([ 'save results4.mat results'])
    
    catch
        display(char(symbol))
        error_contracts(counter) = {symbol(1:end-5)}; counter=counter+1;
        
    end
    i=i+1;
end

