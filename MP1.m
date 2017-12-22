function [G H L Q] = MP1(database,spanRM,lotsize,symbol,m,enddate)

w = waitbar(0,'running:standard Algo');

[T P X]=standard1(database,symbol,m,enddate);
T.Properties.VariableNames = {'Standard'};
price_standard = P; xtime_standard = X;

waitbar(0.15,w,'running: DRA1');
[T1 P X e6 e9] = DynamicRoll(database,spanRM,lotsize,1,enddate);
T = [T T1];
T.Properties.VariableNames = {'Standard', 'DRA1'};
price_DRA1 = P; xtime_DRA1 = X;exhibit6 = e6;exhibit_9 = e9;

waitbar(0.30,w,'running: DRA2');
[T1 P X e6 e9] = DynamicRoll(database,spanRM,lotsize,2,enddate);
T = [T T1];
T.Properties.VariableNames = {'Standard', 'DRA1','DRA2'};
price_DRA2 = P; xtime_DRA2 = X;exhibit6_DRA2 = e6;exhibit9_DRA2 = e9;

waitbar(0.55,w,'running: DRA3');
[T1 P X e6 e9] = DynamicRoll(database,spanRM,lotsize,3,enddate);
T = [T T1];
T.Properties.VariableNames = {'Standard', 'DRA1','DRA2','DRA3'};
price_DRA3 = P; xtime_DRA3 = X;exhibit6_DRA3 = e6;exhibit9_DRA3 = e9;

waitbar(0.80,w,'running: DRA4');
[T1 P X e6 e9] = DynamicRoll(database,spanRM,lotsize,4,enddate);
T = [T T1];
T.Properties.VariableNames = {'Standard', 'DRA1','DRA2','DRA3','DRA4'};
price_DRA4 = P; xtime_DRA4 = X;exhibit6_DRA4 = e6;exhibit9_DRA4 = e9;

waitbar(0.95,w,'collecting results');
G=T;

try
    H=performance(price_standard,price_DRA1,price_DRA2,price_DRA3,price_DRA4,xtime_standard,xtime_DRA1,xtime_DRA2,xtime_DRA3,xtime_DRA4);
    
catch
    display('dimension mismatch');
    H= struct;
    H.standard = price_standard;H.DRA1 = price_DRA1;
    H.DRA2 = price_DRA2;H.DRA3 = price_DRA3;H.DRA4 = price_DRA4;
    
    K=struct;
    K.standard = xtime_standard;K.DRA1 = xtime_DRA1;
    K.DRA2 = xtime_DRA2;K.DRA3 = xtime_DRA3;K.DRA4 = xtime_DRA4;
    
    H = [H K];

end

L= struct;
L.exhibit6 = exhibit6;

L=L;

Q= struct;
Q.exhibit_9 = exhibit_9;
x=cell2mat(exhibit_9(:,2));
x1=x(:,1);x2=x(:,2);x3=x(:,3);
Q.exhibit9_average = 100*[mean(x1(x1~=0)) mean(x2(x2~=0)) mean(x3(x3~=0))];
Q=Q;

close(w);
end

