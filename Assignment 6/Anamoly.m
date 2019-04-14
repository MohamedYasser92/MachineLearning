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
m=length(x(:,1));
n=length(x(1,:));
for w=1:n
    if max(abs(x(:,w)))~=0
    x(:,w)=(x(:,w)-mean((x(:,w))))./std(x(:,w));
    end
end
e=0.001;
anomly=0;
total=1;
for i=1:m
    for j=1:n
        if(qfunc(x(i,j))<e || qfunc(x(i,j))>1-e)
            anomly=anomly+1;
        end
       
    end
end
total=m*n;
percent=(anomly/total)*100;
