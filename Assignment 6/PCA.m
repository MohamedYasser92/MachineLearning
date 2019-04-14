clc
clear all
close all

ds = datastore('Housing.csv','TreatAsMissing','NA',.....
    'MissingValue',0,'ReadSize',25000);
T = read(ds);
size(T);
alpha=.01;
%Part A
x=T{:,4:21};
n=length(x(1,:));
for w=1:n
    if max(abs(x(:,w)))~=0
    x(:,w)=(x(:,w)-mean((x(:,w))))./std(x(:,w));
    end
end
Corr_x = corr(x);
x_cov=cov(x) ; 
[U S V] =  svd(x_cov);
Ev=diag(S);
k=1;
lambda=0;
m=length(S);
alpha=1-(sum(Ev(1:k)./sum(Ev(1:m))));
while alpha>0.0001
   
    alpha=1-(sum(Ev(1:k))./sum(Ev(1:m)));
    k=k+1;
    
end

%PartB

R= (U(:,1:k)')*(x');
xapprox=(U(:,1:k))*R;
b=1;
x=x'
for i=1:1:18
    for j=1:1:21607
        meanerror(b)=(x(i,j)-xapprox(i,j))^2;
        b=b+1;
    end
end
error=(1/length(meanerror))*(sum((meanerror).^2));






%Linear regression


m=length(T{:,1});
xnew=[ones(m,1) xapprox'];
% n=length(x(1,:));
% for w=2:n
%     if max(abs(x(:,w)))~=0
%     X(:,w)=(x(:,w)-mean((x(:,w))))./std(x(:,w));    
%     end
% end

Y=T{:,3}/mean(T{:,3}); % Normalised Price
Theta=zeros(n+1,1);
k=1;

%E(k)=(1/(2*m))*sum((X*Theta-Y).^2); %Cost function intial
E(k)=(1/(2*m))*sum((xnew*Theta-Y).^2);

R=1;
while R==1
alpha=alpha*1;
Theta=Theta-(alpha/m)*xnew'*(xnew*Theta-Y); % theta new
k=k+1;
E(k)=(1/(2*m))*sum((xnew*Theta-Y).^2);
if E(k-1)-E(k)<0 %if error starts to increase stop
    break
end 
q=(E(k-1)-E(k))./E(k-1); % if error is so small
if q <.0001;
    R=0;
end
end
plot(1:length(E),E)
%plot(1:length(E1),E1)


%K-mean clustring

k=2;
centroids =zeros(k, size(x, 2));
randidx =randperm(size(k,1));
centroids =x(randidx(1:k), :);





%anamoly
u=mean(x);
