function [f, g, h] = roll(date1,date2,price,xtime,contract_num,contract_in_num,database)

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
  
 %xtime = [xtime;bdays(5:9)];
 xtime = [xtime;xt(x1:x2)];
 roll_mat = cumsum(1/(x2-x1+1)*ones(1,(x2-x1+1)));
 %roll_ret = 0.2*(current_price(2:end)-new_price(2:end))./new_price(2:end);
 
 
 xx = ret2price(roll_mat'.*price2ret(new_price) + (1-roll_mat').*price2ret(current_price),price(end));
 price(end+1:end+5) = xx(2:end);
 %price_new(end+1:end+5) = roll_mat'.*new_price(2:end)+(1-roll_mat').*current_price(2:end)

 end
f = price; g = xtime; h=contract_in_num; 
end
