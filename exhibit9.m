function f = exhibit9(IRs)    

y=[];

if(isempty(IRs))
    y=[];

elseif(numel(IRs)==1)
        y = [y;zeros(1,3)];
    elseif(numel(IRs)>=1 && numel(IRs)<4)
        t = sort(IRs,'descend');
        y=[y;-1*diff(t),zeros(1,(4-numel(IRs)))];
    else
        t = sort(IRs,'descend');
        y=[y;-1*diff(t(1:4))];
end
    
f=y;

end