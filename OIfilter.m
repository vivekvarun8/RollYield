function f = OI_filter(contracts,rolld,database,lotsize)

x = numel(contracts);
f=[];topin=0;topin1=0;g=[];

for i=1:x
    rd = find(datenum(rolld)==datenum(datetime(database{contracts(i),2}.TimeInfo.StartDate) + days(database{contracts(i),2}.Time))); 
    topin = topin+ database{contracts(i),3}.Data(rd);
end

for i=1:x
    rd = find(datenum(rolld)==datenum(datetime(database{contracts(i),2}.TimeInfo.StartDate) + days(database{contracts(i),2}.Time))); 
    topin1 = topin1+ database{contracts(i),3}.Data(rd);
     g = [g,contracts(i)];
    if(topin1>=0.8*topin)
       break;
    end
end

for i=1:x
   
   rd = find(datenum(rolld)==datenum(datetime(database{contracts(i),2}.TimeInfo.StartDate) + days(database{contracts(i),2}.Time))); 
   xd = lotsize*database{contracts(i),3}.Data(rd)*database{contracts(i),2}.Data(rd)/100000000;
    
   if(xd>=1)
       f = [f,contracts(i)];
   end
     
end
f=intersect(f,g);
end

