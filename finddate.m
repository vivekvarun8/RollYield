function f = finddate(xt,mon,yr)

x={}; counter=1;

for i=1:numel(xt)
    
if(strcmp(xt{i}(4:6),mon)==1 && str2num(xt{i}(8:11))==yr)
    x{counter} = xt{i};
    counter=counter+1;
end
    
end
f=x;
end

