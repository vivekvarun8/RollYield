function f = optcontract(IRY,contract_allowed_num,contract_num,spanRM)

if(numel(contract_allowed_num)>spanRM)
    contract_allowed_num = contract_allowed_num(1:spanRM);
    IRY = IRY(1:spanRM-1);
end

a = sort(IRY,'descend'); g=[];
%contract_allowed_num = contract_allowed_num(contract_allowed_num>=contract_num);
contract_allowed_num = contract_allowed_num(1:end); counter=1; j=1;

IRY = unique(IRY,'stable');

while(j<=numel(IRY))
    
    if( numel(find(a(j)==IRY))==1)
        g(j) = contract_allowed_num(find(a(j)==IRY));
        j=j+1;
    else
       h = numel(find(a(j)==IRY));
       g(j:j+h-1) = contract_allowed_num(find(a(j)==IRY));
       j=j+h;
       
    end
    

end
%g(j)=setdiff(contract_allowed_num,g);
% if(numel(g)<cut)
%     f=g;
% else
% f = g(1:cut);
% end

f=g;

end