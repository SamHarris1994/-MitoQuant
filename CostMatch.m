function [CM]=CostMatch(FC,threshold)
% find the minimum cost with a certain threshold

FC=FC.*(FC<=threshold);

CM1=zeros(size(FC));
CM2=zeros(size(FC));
for pn=1:size(FC,1)
    costmin1=min(FC(pn,:));
    if costmin1~=Inf
        CM1(pn,:)=FC(pn,:)==costmin1;
    end
end
for dn=1:size(FC,2)
    costmin2=min(FC(:,dn));
    if costmin2~=Inf
        CM2(:,dn)=FC(:,dn)==costmin2;
    end
end
CM=CM1.*CM2;