function FC=FrameCost(D1,D2)
% calculate the cost between prediction and detection in the same frame

num1=size(D1,1);
num2=size(D2,1);

cost_dist=zeros(num1,num2);
cost_distx=zeros(num1,num2);
cost_disty=zeros(num1,num2);
cost_Intensity=zeros(num1,num2);
cost_Area=zeros(num1,num2);

for n1=1:num1
    for n2=1:num2
        coordinate1=D1(n1).Centroid;
        coordinate2=D2(n2).Centroid;
        cost_dist(n1,n2)=norm(coordinate1-coordinate2);
        cost_distx(n1,n2)=abs(coordinate1(1)-coordinate2(1));
        cost_disty(n1,n2)=abs(coordinate1(2)-coordinate2(2));
        cost_Intensity(n1,n2)=abs(D1(n1).Intensity-D2(n2).Intensity)/D1(n1).Intensity;
        cost_Area(n1,n2)=abs(D1(n1).Area-D2(n2).Area)/D1(n1).Area;
    end
end

ind= ~((cost_distx<15).*(cost_disty<10));
cost=0.25*(cost_dist/10)+0.4*cost_Intensity+0.35*cost_Area;
cost(ind)=inf;
FC=cost;