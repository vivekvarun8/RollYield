function [T P X, exhibit_6 exhibit_9] = DynamicR(database,spanRM,lotsize,cut,enddate)


clear month; clear price; clear xtime;
sdate = database{1,2}.TimeInfo.StartDate;
%sdate=sd1;
sdate1=sdate;
contract = database{1,1};
contract_num = 1;%spanRM = 11;lotsize = 1000;cut=1;
pmonth = [];
l_month = {    'F'    'G'    'H'    'J'    'K'    'M'    'N'    'Q'    'U'    'V'    'X'    'Z'};
d = [1 1 1 1 1 1 1 1 1 1 1]; price = []; xtime=[]; j=1;roll2=0;price_new=[];rol2 = [];flag=0; p=[];tt=[];[row col] = size(database);
exhibit_9={};exhibit_6={};counter=1;counter1=1;

if(numel(database{1,2}.Data)<15)
    database = database(2:end,:);
    symbol = database{1,1};
end

h=waitbar(0,'...DRA');

for i=1:700
    
    waitbar(i/700,h,sprintf('%d%...',i));
    if(contract_num>row)
        break;
    end
    
%     if(datenum(sdate)>datenum('01-Oct-1984'))
%         xd=1;
%     end
%         
    
sdate = datestr(sdate);    
[current_m_num current_m] = month(sdate);
contract; contract_num;
current_year = year(datetime(sdate));

xt = getabstime(database{contract_num,2});
xt_cur = finddate(xt,current_m,current_year);
if(isempty(xt_cur))
    break;
end
    
first_busday = xt_cur(1);
last_busday = xt_cur(end);

if(numel(xt_cur)>=10)
    

if(datenum(datetime(database{j,2}.TimeInfo.StartDate)+database{j,2}.Time(end))-datenum(sdate)<0)
    j=j+1;
end


[num_alive, IRY, contracts_allowed, contract_allowed_num] = alive2(xt_cur(3),database,j,d);

exhibit_9(counter1,:) = {xt_cur(3),exhibit9(IRY)}; counter1=counter1+1;

if(num_alive==1)
 % do something   
 [price xtime contract_num] = rolling(first_busday,last_busday,price,xtime,contract_num,contract_num,database);
 p=[price(1);price(end)];pmonth = [pmonth;price(1),price(end)];

elseif(num_alive>1 && numel(IRY)==1 && contract_num==contract_allowed_num(2))

  
  [price,xtime,contract_num] = rolling(first_busday,last_busday,price,xtime,contract_num,contract_num,database);
  p=[p;price(end)];pmonth = [pmonth;price(1),price(end)];

elseif(num_alive>1 && numel(IRY)==1 && contract_num~=contract_allowed_num(2))
  contract_in_num = contract_allowed_num(2);  contract = database{contract_in_num,1};
  [price,xtime,contract_num] = rolling(first_busday,xt_cur(4),price,xtime,contract_num,contract_num,database);
  [price,xtime,contract_num] = rolling(xt_cur(5),xt_cur(9),price,xtime,contract_num,contract_in_num,database);
  
  xt1 = getabstime(database{contract_in_num,2});
  xt_cur1 = finddate(xt1,current_m,current_year);
 x1= find(datenum(xt_cur(10))==datenum(xt_cur1));
     [price,xtime,contract_num] = rolling(xt_cur1(x1),xt_cur1(end),price,xtime,contract_in_num,contract_in_num,database);
 % [price,xtime,contract_num] = rolling(xt_cur1(10-(numel(xt_cur)-numel(xt_cur1))),xt_cur1(end),price,xtime,contract_in_num,contract_in_num,database);
  rol2 = [rol2,1];p=[p;price(end)]; pmonth = [pmonth;price(end-numel(xt_cur)+1),price(end)];
 

elseif(num_alive>1 && numel(IRY)>1)
        % extend the optimum set to 2
% z1 = find(max(IRY)==IRY);
 %z2 = contract_allowed_num(2:end);
 z2 = yearfilter(contract,contracts_allowed,contract_allowed_num); %1
 z1 = OIfilter(contract_allowed_num,xt_cur(3),database,lotsize); % a and b
 if(isempty(z1))
     z1=contract_num;
 end
 r1 = char(contracts_allowed(sort(z1)-j+1));
 r2=r1(:,end-4:end);
 r3 = cellstr(r2)';
 exhibit_6(counter,:) = {xt_cur(3),r3};counter=counter+1;
 
 z = optcontract(IRY,z2,contract_num,spanRM);
 z = intersect(z,z1,'stable');
 if(isempty(z))
     z=contract_num;
 end
 if(numel(z)==1 && contract_num>z)
     z=contract_num;
 end
 

  
 
 if(numel(z)==1 && contract_num ==z(1))
      if(datenum(xt(end))<datenum(datetime(sdate)+calmonths(1)))
            contract_in_num = contract_num+1;
            contract = database{contract_in_num,1};
            xt1 = getabstime(database{contract_in_num,2});
            xt_cur1 = finddate(xt1,current_m,current_year);
            [price,xtime,contract_num] = rolling(first_busday,xt_cur(4),price,xtime,contract_num,contract_num,database);
            [price,xtime,contract_num] = rolling(xt_cur(5),xt_cur(9),price,xtime,contract_num,contract_in_num,database);
            x1= find(datenum(xt_cur(10))==datenum(xt_cur1));
            [price,xtime,contract_num] = rolling(xt_cur1(x1),xt_cur1(end),price,xtime,contract_in_num,contract_in_num,database);
            rol2 = [rol2,1];p=[p;price(end)];pmonth = [pmonth;price(end-numel(xt_cur)+1),price(end)];
      else
           [price,xtime,contract_num] = rolling(first_busday,last_busday,price,xtime,contract_num,contract_num,database);
            p=[p;price(end)];pmonth = [pmonth;price(1),price(end)];rol2 = [rol2,0];
      end
 elseif(numel(z)==1 && contract_num ~=z(1))
            contract_in_num = z;
            contract = database{contract_in_num,1};
            xt1 = getabstime(database{contract_in_num,2});
            xt_cur1 = finddate(xt1,current_m,current_year);
            [price,xtime,contract_num] = rolling(first_busday,xt_cur(4),price,xtime,contract_num,contract_num,database);
            [price,xtime,contract_num] = rolling(xt_cur(5),xt_cur(9),price,xtime,contract_num,contract_in_num,database);
            x1= find(datenum(xt_cur(10))==datenum(xt_cur1));
            [price,xtime,contract_num] = rolling(xt_cur1(x1),xt_cur1(end),price,xtime,contract_in_num,contract_in_num,database);
            rol2 = [rol2,1];p=[p;price(end)];pmonth = [pmonth;price(end-numel(xt_cur)+1),price(end)];
  
  
elseif(numel(z)>1)
     
     if(numel(z)>cut)
         z3=z(1:cut);
     else
         z3=z;
     end
 
 % check for forced rolling 
 
 if(datenum(xt(end))<datenum(datetime(sdate)+calmonths(1)))
     z3 = z3(z3~=contract_num);
          if(numel(z3)>cut)
         z3=z3(1:cut);
          elseif(isempty(z3))
              z3=contract_num+1;
     end
 end
 
 if(any(contract_num==z3))
    
         
  [price,xtime,contract_num] = rolling(first_busday,last_busday,price,xtime,contract_num,contract_num,database);
  rol2 = [rol2,0];p=[p;price(end)];pmonth = [pmonth;price(end-numel(xt_cur)+1),price(end)];
 
 elseif(contract_num>z3(1))
     
     [price,xtime,contract_num] = rolling(first_busday,last_busday,price,xtime,contract_num,contract_num,database);
     rol2 = [rol2,0];p=[p;price(end)];pmonth = [pmonth;price(end-numel(xt_cur)+1),price(end)];

 else
     
     contract_in_num = z3(1);contract = database{contract_in_num,1};
     xt1 = getabstime(database{contract_in_num,2});
     xt_cur1 = finddate(xt1,current_m,current_year);
     [price,xtime,contract_num] = rolling(first_busday,xt_cur(4),price,xtime,contract_num,contract_num,database);
     [price,xtime,contract_num] = rolling(xt_cur(5),xt_cur(9),price,xtime,contract_num,contract_in_num,database);
     x1= find(datenum(xt_cur(10))==datenum(xt_cur1));
     [price,xtime,contract_num] = rolling(xt_cur1(x1),xt_cur1(end),price,xtime,contract_in_num,contract_in_num,database);
     rol2 = [rol2,1];p=[p;price(end)];pmonth = [pmonth;price(end-numel(xt_cur)+1),price(end)];
 end

 end
 
end

end
sdate = datetime(sdate) + calmonths(1);
if(datenum(sdate)>=datenum(enddate))
    break;
end
end

ret = 100*(price(end)-1);
vol = 100*std(price2ret(price))*sqrt(225);
y= etime(datevec(sdate),datevec(sdate1))/(24*3600*30);
IRR = 100*(price(end)^(12/y)-1);
MaxDrawDown1 = -100*maxdrawdown(price);
VaR_5d = 100*sqrt(5)*computeHistoricalVaR(price2ret(price),0.95,'False');
roll_f = 100*sum(rol2)/numel(rol2);
bestmonth = 100*max((pmonth(:,2)-pmonth(:,1))./pmonth(:,1));
worstmonth = 100*min((pmonth(:,2)-pmonth(:,1))./pmonth(:,1));

% Make Table

Name = {'Return (%)';'Volatility (%)';'IRR (%)';'MaxDrawDown (%)';'VaR_5d_95%';'Roll (%)';'BestMonth(%)';'WorstMonth (%)'};
DR1 = [ret;vol;IRR;MaxDrawDown1;VaR_5d;roll_f;bestmonth;worstmonth];

T = table(DR1,'RowNames',Name);
P = price;
X = xtime;
exhibit_6=exhibit_6;
exhibit_9=exhibit_9;
close(h);
end
