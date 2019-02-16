clear all
ds = datastore('Housing1.csv','TreatAsMissing','NA',.....
    'MissingValue',0,'ReadSize',25000);
T = read(ds);
size(T);
Alpha=.001;
% For sqft top and bottom
m=length(T{:,1});
U0=T{:,2}
U=T{:,15:16};

U1=T{:,4:7};
U2=U.^2;
X=[ones(m,1) U U2];

n=length(X(1,:));
for w=2:n
    if max(abs(X(:,w)))~=0
    X(:,w)=(X(:,w)-mean((X(:,w))))./std(X(:,w));    %normailization
    end
end

Y=T{:,3}/mean(T{:,3}); % Normalised Price
Theta=zeros(n,1);
k=1;

E(k)=(1/(2*m))*sum((X*Theta-Y).^2); %Cost function intial

%Theta1=(inv(X'.*X)).*(X').*Y;

R=1;
while R==1
Alpha=Alpha*1;
Theta=Theta-(Alpha/m)*X'*(X*Theta-Y); % theta new
k=k+1
E(k)=(1/(2*m))*sum((X*Theta-Y).^2);
if E(k-1)-E(k)<0 %if error starts to increase stop
    break
end 
q=(E(k-1)-E(k))./E(k-1); % if error is so small
if q <.000001;
    R=0;
end
end
plot(E)



%***** For normal Equation *******

% while R==1
% Theta1=X.*X' % theta new
% k=k+1
% E(k)=(1/(2*m))*sum((X*Theta-Y).^2);
% if E(k-1)-E(k)<0 %if error starts to increase stop
%     break
% end 
% q=(E(k-1)-E(k))./E(k-1); % if error is so small
% if q <.000001;
%     R=0;
% end
% end

