function [f, g, h] = rolling(date1,date2,price,xtime,contract_num,contract_in_num,database)

[current_m_num current_m] = month(date1);current_year = year(datetime(date1));

xt = getabstime(database{contract_num,2});
xt_cur = finddate(xt,current_m,current_year);


 if(contract_num==contract_in_num)
     %do something
      x1 = find(datenum(date1)==datenum(datetime(database{contract_num,2}.TimeInfo.StartDate) + days(database{contract_num,2}.Time)));
      x2 = find(datenum(date2)==datenum(datetime(database{contract_num,2}.TimeInfo.StartDate) + days(database{contract_num,2}.Time)));
 
      if(isempty(price))
          price = [price;ret2price(price2ret(database{contract_num,2}.Data(x1:x2)),1)];
      else
          xx = ret2price(price2ret(database{contract_num,2}.Data(x1-1:x2)),price(end));
          price = [price;xx(2:end)];
      end 
      
      xtime = [xtime;xt(x1:x2)];
      %price_new = [price_new;database{contract_num,2}.Data(x1:x2)];
 else
     %do something
     [current_m_num current_m] = month(date1);

     
     xt1 = getabstime(database{contract_in_num,2});
     xt_cur1 = finddate(xt1,current_m,current_year);
 
     x1 = find(datenum(date1)==datenum(datetime(database{contract_num,2}.TimeInfo.StartDate) + days(database{contract_num,2}.Time)));
     x1_new = find(datenum(date1)==datenum(datetime(database{contract_in_num,2}.TimeInfo.StartDate) + days(database{contract_in_num,2}.Time)));
 
     x2 = find(datenum(date2)==datenum(datetime(database{contract_num,2}.TimeInfo.StartDate) + days(database{contract_num,2}.Time)));
     x2_new = find(datenum(date2)==datenum(datetime(database{contract_in_num,2}.TimeInfo.StartDate) + days(database{contract_in_num,2}.Time)));


 % rolling starts 5th-9th business day
 current_price = database{contract_num,2}.Data(x1-1:x2);
 new_price = database{contract_in_num,2}.Data(x1_new-1:x2_new);
 
%  if(numel(current_price)~=numel(new_price))
%      new_price(end+1)=new_price(end);
%  end
  
 %xtime = [xtime;bdays(5:9)];

 %roll_mat = cumsum(1/(x2-x1+1)*ones(1,(x2-x1+1)));

 c = strcmp(xt_cur(5:9),xt_cur1(5:9));
 
roll_mat(1)=0.2; roll_mat(5)=1;

adj=0;

for i=2:4
    if(c(i)==1)
        roll_mat(i) = roll_mat(i-1)+0.2+adj;adj=0;
    else 
        roll_mat(i)=roll_mat(i-1);adj=adj+0.2;
    end
end
 %roll_ret = 0.2*(current_price(2:end)-new_price(2:end))./new_price(2:end);
 xt3 = xt_cur(find(strcmp(date1,xt_cur)):find(strcmp(date2,xt_cur)));
 xt4 = xt_cur1(find(strcmp(date1,xt_cur1)):find(strcmp(date2,xt_cur1)));
  xtime = [xtime;xt3'];
% [p1 ~] = rollx(xt3,xt4,current_price,new_price);
 %xx = ret2price(price2ret(p1),price(end));
 xx = ret2price(roll_mat'.*price2ret(new_price) + (1-roll_mat').*price2ret(current_price),price(end));
 price(end+1:end+5) = xx(2:end);
 %price_new(end+1:end+5) = roll_mat'.*new_price(2:end)+(1-roll_mat').*current_price(2:end)

 end
f = price; g = xtime; h=contract_in_num; 
end
