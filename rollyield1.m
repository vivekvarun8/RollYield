% all the date points in a contract (as Matlab numbers)
dates = datenum(datetime(database{1,2}.TimeInfo.StartDate) + days(database{1,2}.Time));

% looking for the expiry date in alive contracts at the current date

% At expiry date 

date = dates(end); InitPrice = database{1,2}.Data(end);

% number of alive contracts 

%[num_alive IRs exppoints] =  alive1(date,InitPrice,database,1);

% standard roll strategy and Dynamic Roll Strategy

% invest $1 on the starting date, adjust for performance and roll returns over time

price_eval = []; rp=[];

%% standarad roll strategy
%{
for i=1:1:1

    expiry(i) = datetime(database{i,2}.TimeInfo.StartDate)+days(database{i,2}.Time(end));
    expiry(i+1) = datetime(database{i+1,2}.TimeInfo.StartDate)+days(database{i+1,2}.Time(end));
    
    if(i==1)
        price_eval = [price_eval;ret2price(price2ret(database{i,2}.Data),1)];
        current_price = database{i,2}.Data(end);
        new_price = database{i+2,2}.Data(exppoints(2));
        xx = price_eval(end)*(1+0.9995*(current_price-new_price)/current_price);
        price_eval(end) = xx;
        rp = [rp,(1+0.9995*(current_price-new_price)/current_price)];

    else
        data_cut1 = find(datenum(expiry(i))==datenum(datetime(database{i+2,2}.TimeInfo.StartDate) + days(database{i+2,2}.Time)));
        data_cut2 = find(datenum(expiry(i+1))==datenum(datetime(database{i+2,2}.TimeInfo.StartDate) + days(database{i+2,2}.Time)));
        price_eval = [price_eval;ret2price(price2ret(database{i+2,2}.Data(data_cut1:data_cut2)),xx)];
        
        data_cut3 = find(datenum(expiry(i))==datenum(datetime(database{i+1,2}.TimeInfo.StartDate) + days(database{i+1,2}.Time)));
        
        current_price = database{i+1,2}.Data(data_cut3);
        new_price = database{i+2,2}.Data(data_cut1);
        xx = price_eval(end)*(1+0.9995*(current_price-new_price)/current_price);
        price_eval(end) = xx;
        rp = [rp,(1+0.9995*(current_price-new_price)/current_price)];
    end
end
%}
%}
%% Dynamic Roll Strategy DRA1

price_eval1=[]; rp1 = [];

contract=1; cc=1; d=[]; sdate=datetime(database{1,2}.TimeInfo.StartDate);edate=datetime(database{1,2}.TimeInfo.StartDate)+days(15);
y=[];

for i=1:20

    %z = busdays(sdate,edate);
    
    %z(3) is the 3rd business day and so on..
    i=i+contract-1;
    %cc = i+contract-1; % cc is roll-out contract
    
    %expiry = datetime(database{cc,2}.TimeInfo.StartDate)+days(database{cc,2}.Time(end));
    expiry = (z(9));
    
    %data_cut1 = find(datenum(expiry(i))==datenum(datetime(database{i,2}.TimeInfo.StartDate) + days(database{i,2}.Time)));
    
    [num_alive IRs nextdate cdate] =  alive2(sdate,database,i);
    
    if(num_alive>11)
        IRs = IRs(1:11);
        %exppoints = exppoints(1:11);
    end
    %IRs,i
    %IRs = unique(IRs,'stable');
    
    if(numel(IRs)==1)
        y = [y;zeros(1,3)];
    elseif(numel(IRs)>=1 && numel(IRs)<4)
        t = sort(IRs,'descend');
        y=[y;-1*diff(t),zeros(1,(4-numel(IRs)))];
    else
        t = sort(IRs,'descend');
        y=[y;-1*diff(t(1:4))];
    end
        
    if(num_alive~=0)
        
    % contract Rolling-in DRA1
    contract = find(max(IRs)==IRs); % contract is i + contract
    contract = contract(1);
    % cc + contract is roll-in contract
    %expiry_next = datetime(database{j+contract,2}.TimeInfo.StartDate)+days(database{j+contract,2}.Time(end));
    d=[d,contract];
    datacut1 = find(datenum(cdate)==datenum(datetime(database{i,2}.TimeInfo.StartDate) + days(database{i,2}.Time)));
    current_price = database{i,2}.Data(datacut1:datacut1+4);
    data_cut2 = find(datenum(cdate)==datenum(datetime(database{i+contract,2}.TimeInfo.StartDate) + days(database{i+contract,2}.Time)));
    new_price = database{i+contract,2}.Data(data_cut2:data_cut2+4);
    rp1 = [rp1,0.2*0.995*(sum(current_price)-sum(new_price))/sum(current_price)];
    sdate = nextdate+calmonths(contract-1);
    
    end
     
end

x1 = y(:,1);x2=y(:,2);x3=y(:,3);
mIRs = [mean(x1(x1~=0)),mean(x1(x2~=0)),mean(x1(x3~=0))];
DRA1_freq = numel(d)/sum(d);
plot(ret2price(rp1,1));

%% DRA 2
% 
% 
% for i=1:50
% 
%     %z = busdays(sdate,edate);
%     
%     %z(3) is the 3rd business day and so on..
%     
%     cc = i+contract-1; % cc is roll-out contract
%     
%     %expiry = datetime(database{cc,2}.TimeInfo.StartDate)+days(database{cc,2}.Time(end));
%     expiry = (z(9));
%     
%     %data_cut1 = find(datenum(expiry(i))==datenum(datetime(database{i,2}.TimeInfo.StartDate) + days(database{i,2}.Time)));
%     
%     [num_alive IRs nextdate cdate] =  alive2(sdate,database,cc);
%     
%     if(num_alive>11)
%         IRs = IRs(1:11);
%         %exppoints = exppoints(1:11);
%     end
%     %IRs,i
%     %IRs = unique(IRs,'stable');
%     
%     if(num_alive~=0)
%         if(numel(IRs)==1)
%     % contract Rolling-in DRA1
%     contract = find(max(IRs)==IRs); % contract is i + contract
%     contract = contract(1);
%     % cc + contract is roll-in contract
%     %expiry_next = datetime(database{j+contract,2}.TimeInfo.StartDate)+days(database{j+contract,2}.Time(end));
%     d=[d,contract];
%     datacut1 = find(datenum(cdate)==datenum(datetime(database{cc,2}.TimeInfo.StartDate) + days(database{cc,2}.Time)));
%     current_price = database{cc,2}.Data(datacut1:datacut1+4);
%     data_cut2 = find(datenum(cdate)==datenum(datetime(database{cc+contract,2}.TimeInfo.StartDate) + days(database{cc+contract,2}.Time)));
%     new_price = database{cc+contract,2}.Data(data_cut2:data_cut2+4);
%     rp1 = [rp1,0.2*0.995*(sum(current_price)-sum(new_price))/sum(current_price)];
%     sdate = nextdate;
%         else
%             temp = [max(IRs),max(IRs(IRs~=max(IRs)))];
%             x1 = find(temp(1)==IRs);
%             x2 = find(temp(2)==IRs);
%             
%             % current contract is cc
% 
%             
%             
%         end
%         
%     
%     end
%      
% end