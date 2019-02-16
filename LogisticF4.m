clear all
ds = datastore('heart.csv','TreatAsMissing','NA',.....
    'MissingValue',0,'ReadSize',25000);
T = read(ds);
size(T);
Alpha=.01;

m=length(T{:,1});
U0=T{:,3:4};
U=T{:,5:8};
U1=T{:,9:11};

%U1=T{:,10:11};
U2=U0.^2;
U3=U.^8;
U4=U1.^5;


%U3=U.^3;

X=[ones(m,1) U0 U2 U3 U4];

n=length(X(1,:));
for w=2:n
    if max(abs(X(:,w)))~=0
    X(:,w)=(X(:,w)-mean((X(:,w))))./std(X(:,w));    %normailization
    end
end

Y=T{:,14}/mean(T{:,14}); % Normalised Price
Theta=zeros(n,1);
k=1;
H=sigmoid(X*Theta);

%E(k)=(1/(2*m))*sum((X*Theta-Y).^2); %Cost function intial
E(k)=(-1/(m))*sum(Y.*log(H)+(1-Y).*log(1-(H)));

R=1;
while R==1
%H=sigmoid(X*Theta);
Alpha=Alpha*1;
Theta=Theta-(Alpha/m)*X'*((H)-Y); % theta new
k=k+1
H=sigmoid(X*Theta);
E(k)=(-1/(m))*sum(Y.*log(H)+(1-Y).*log(1-(H)));
if E(k)<0 %if error starts to increase stop
    break
end 
q=(E(k-1)-E(k))./E(k-1); % if error is so small
if q <.000001;
    R=0;
end
end
E1=E(1,1:(length(E)-1));
plot(1:length(E1),E1)
 xlabel('n')
 ylabel('Mean square error') 
