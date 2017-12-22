function [T,P,X] = standard1(database,symbol,m,enddate)

clear month; 
sdate = database{1,2}.TimeInfo.StartDate;
%sdate = sd1;
sdate1=sdate;
contract = database{1,1};
contract_num = 1;
l_month = {    'F'    'G'    'H'    'J'    'K'    'M'    'N'    'Q'    'U'    'V'    'X'    'Z'};
roll_s = { 'Dec' 'Jan'  'Feb'  'Mar'  'Apr'  'May'  'Jun'  'Jul'  'Aug'  'Sep'  'Oct'  'Nov'};
roll_schecdule = {'H'    'J'    'K'    'M'    'N'    'Q'    'U'    'V'    'X'    'Z'   'F'    'G'};
month_schedule = {'Jan'  'Feb'  'Mar'  'Apr'  'May'  'Jun'  'Jul'  'Aug'  'Sep'  'Oct'  'Nov'  'Dec'};

d = [1 1 1 1 1 1 1 1 1 1 1]; price = []; xtime=[]; j=1; roll=0; zzz = [];price_new=[];roll_ret = []; xx1=[]; xx_roll1=[];
rol2=[];pmonth=[];contract_in_num=1;p=[];
[row col] = size(database);

if(numel(database{1,2}.Data)<15)
    database = database(2:end,:);
    symbol = database{1,1};
end

for i=1:700

sdate = datestr(sdate);    
[current_m_num current_m] = month(sdate);
contract=char(contract); contract_num;
current_year = year(datetime(sdate));

xt = getabstime(database{contract_num,2});
xt_cur = finddate(xt,current_m,current_year);
if(isempty(xt_cur))
    break;
end
first_busday = xt_cur(1);
last_busday = xt_cur(end);

sm = find(strcmp(current_m,month_schedule));

trigger = d_indexing(l_month(sm),symbol(end-4));
if(numel(xt_cur)<10)
    trigger=0;
end

if(trigger==1 && contract_num < row)
    % roll
  contract_in_num = contract_num +1; symbol = database{contract_in_num,1};
 [price,xtime,contract_num] = rolling(first_busday,xt_cur(4),price,xtime,contract_num,contract_num,database);
 [price,xtime,contract_num] = rolling(xt_cur(5),xt_cur(9),price,xtime,contract_num,contract_in_num,database);
  
 xt1 = getabstime(database{contract_in_num,2});
 xt_cur1 = finddate(xt1,current_m,current_year);

 x1= find(datenum(xt_cur(10))==datenum(xt_cur1));
 
 [price,xtime,contract_num] = rolling(xt_cur1(x1),xt_cur1(end),price,xtime,contract_in_num,contract_in_num,database);
 rol2 = [rol2,1];p=[p;price(end)]; pmonth = [pmonth;price(end-numel(xt_cur)+1),price(end)];
 
else
    %continue
 [price xtime contract_num] = rolling(first_busday,last_busday,price,xtime,contract_num,contract_num,database);
 p=[price(1);price(end)];pmonth = [pmonth;price(1),price(end)];rol2=[rol2,0];
 
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
end