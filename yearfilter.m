function f = yearfilter(contract,z,c_num_allowed)

cyear = str2num(contract(end-3:end)); y=[];

for i=1:numel(z)
   
    s = char(z(i));
    y = [y,str2num(s(end-3:end))];
    
end

f = c_num_allowed(find(cyear+4>y));

end