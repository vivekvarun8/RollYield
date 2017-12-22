function [f, g] = rollx(xt3,xt4,current_price,new_price)

r=0.2;count1=1;count2=1;

for i=1:numel(xt3)
    
    if(strcmp(xt3(count2),xt4(count1)))
        % roll 20%
        f(count2) = r*new_price(count1+1)+(1-r)*current_price(count2+1); r=r+0.2;count1=count1+1;count2=count2+1;
    else
        r=r-0.2;
        f(count2) = r*new_price(count1+1)+(1-r)*current_price(count2+1);
        r=r+0.2;count2=count2+1;
    end
end
    f= [current_price(1),f];
    g = xt3;
    
end