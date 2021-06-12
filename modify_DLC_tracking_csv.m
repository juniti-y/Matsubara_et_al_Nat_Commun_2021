function output=modify_DLC_tracking_csv(filename)

data1=csvread(filename);



%shift mid of x-coor to zero
data1(:,[1,4, 7,10])=data1(:,[1, 4, 7,10])-1279;

%flip y-axis
data1(:,[2, 5, 8, 11])=1438-data1(:,[2, 5, 8, 11]);


Time1=[1/25:1/25:size(data1,1)/25];



xy1.tailbase=data1(:,[1,2]);
xy1.snout=data1(:,[4,5]);
xy1.earl=data1(:,[7,8]);
xy1.earr=data1(:,[10,11]);

likelihood1.tailbase=data1(:,[3]);
likelihood1.snout=data1(:,[6]);
likelihood1.earl=data1(:,[9]);
likelihood1.earr=data1(:,[12]);

%%%%%%%%%%%%%%%%%%%%%%%%%%5
LH_thres=0.8;


index_lowLH1.tailbase=find(likelihood1.tailbase<LH_thres);
index_lowLH1.snout=find(likelihood1.snout<LH_thres);
index_lowLH1.earl=find(likelihood1.earl<LH_thres);
index_lowLH1.earr=find(likelihood1.earr<LH_thres);

xy1.tailbase(index_lowLH1.tailbase,:)=NaN;
xy1.snout(index_lowLH1.snout,:)=NaN;
xy1.earl(index_lowLH1.earl,:)=NaN;
xy1.earr(index_lowLH1.earr,:)=NaN;




%%%%%%%%%%%%%%%%%%%%%%%%%%5
xy1.tailbase=find_fill_NaN(xy1.tailbase);
xy1.snout=find_fill_NaN(xy1.snout);
xy1.earl=find_fill_NaN(xy1.earl);
xy1.earr=find_fill_NaN(xy1.earr);



%%%%%%%%%%%%%%%%%%%%%%%%%%5
vel1.tailbase=xy1.tailbase(2:end,:)-xy1.tailbase(1:end-1,:);
vel1.snout=xy1.snout(2:end,:)-xy1.snout(1:end-1,:);
vel1.earl=xy1.earl(2:end,:)-xy1.earl(1:end-1,:);
vel1.earr=xy1.earr(2:end,:)-xy1.earr(1:end-1,:);

velA1.tailbase=sqrt(vel1.tailbase(:,1).^2+vel1.tailbase(:,2).^2);
velA1.snout=sqrt(vel1.snout(:,1).^2+vel1.snout(:,2).^2);
velA1.earl=sqrt(vel1.earl(:,1).^2+vel1.earl(:,2).^2);
velA1.earr=sqrt(vel1.earr(:,1).^2+vel1.earr(:,2).^2);


vel_thres=100;

index_missing1.tailbase=find(abs(velA1.tailbase)>vel_thres);
index_missing1.snout=find(abs(velA1.snout)>vel_thres);
index_missing1.earl=find(abs(velA1.earl)>vel_thres);
index_missing1.earr=find(abs(velA1.earr)>vel_thres);

index_missing1.tailbase=[index_missing1.tailbase, index_missing1.tailbase+1];
index_missing1.snout=[index_missing1.snout, index_missing1.snout+1];
index_missing1.earl=[index_missing1.earl, index_missing1.earl+1];
index_missing1.earr=[index_missing1.earr, index_missing1.earr+1];

xy1.tailbase(index_missing1.tailbase,:)=NaN;
xy1.snout(index_missing1.snout,:)=NaN;
xy1.earl(index_missing1.earl,:)=NaN;
xy1.earr(index_missing1.earr,:)=NaN;

%%%%%%%%%%%%%%%%%%%%%%%%%%5
xy1.tailbase=find_fill_NaN(xy1.tailbase);
xy1.snout=find_fill_NaN(xy1.snout);
xy1.earl=find_fill_NaN(xy1.earl);
xy1.earr=find_fill_NaN(xy1.earr);

%%%%%%%%%%%%%%%%%%%%%%%%%%5
xy1.head=mean([xy1.snout(:,1), xy1.earl(:,1), xy1.earr(:,1)],2);
xy1.head(:,2)=mean([xy1.snout(:,2), xy1.earl(:,2), xy1.earr(:,2)],2);

distance_head.snout=sqrt((xy1.snout(:,1)-xy1.head(:,1)).^2+(xy1.snout(:,2)-xy1.head(:,2)).^2);
distance_head.earl=sqrt((xy1.earl(:,1)-xy1.head(:,1)).^2+(xy1.earl(:,2)-xy1.head(:,2)).^2);
distance_head.earr=sqrt((xy1.earr(:,1)-xy1.head(:,1)).^2+(xy1.earr(:,2)-xy1.head(:,2)).^2);



%%%%%%%%%%%%%%%%%%%%%%%%%%5
headdist_thres=80;

index_head_distance.snout=find(distance_head.snout>headdist_thres*2 & distance_head.snout>distance_head.earl & distance_head.snout>distance_head.earr);
index_head_distance.earl=find(distance_head.earl>headdist_thres & distance_head.earl>distance_head.snout & distance_head.earl>distance_head.earr);
index_head_distance.earr=find(distance_head.earr>headdist_thres & distance_head.earr>distance_head.snout & distance_head.earr>distance_head.earl);

xy1.snout(index_head_distance.snout,:)=NaN;

xy1.earr(index_head_distance.earl,:)=NaN;

xy1.earl(index_head_distance.earl,:)=NaN;


xy1.snout=find_fill_NaN(xy1.snout);
xy1.earr=find_fill_NaN(xy1.earr);
xy1.earl=find_fill_NaN(xy1.earl);


%%%%%%%%%%%%%%%%%%%%%%%%%%5

xy1.head=mean([xy1.snout(:,1), xy1.earl(:,1), xy1.earr(:,1)],2);
xy1.head(:,2)=mean([xy1.snout(:,2), xy1.earl(:,2), xy1.earr(:,2)],2);

distance_head.snout=sqrt((xy1.snout(:,1)-xy1.head(:,1)).^2+(xy1.snout(:,2)-xy1.head(:,2)).^2);
distance_head.earl=sqrt((xy1.earl(:,1)-xy1.head(:,1)).^2+(xy1.earl(:,2)-xy1.head(:,2)).^2);
distance_head.earr=sqrt((xy1.earr(:,1)-xy1.head(:,1)).^2+(xy1.earr(:,2)-xy1.head(:,2)).^2);



%%%%%%%%%%%%%%%%%%%%%%%%%%5
LH=ones(size(likelihood1.tailbase)) *0.99;
LH0=zeros(size(likelihood1.tailbase)) ;
output=[xy1.tailbase, LH0, xy1.snout, LH0, xy1.earl, LH, xy1.earr, LH];

output(:,[1,4, 7,10])=output(:,[1, 4, 7,10])+1279;

%flip y-axis
output(:,[2, 5, 8, 11])=1438-output(:,[2, 5, 8, 11]);


end





%%%%%%%%%%%%%%%%%%%%%%%%%%5
    function xy=find_fill_NaN(xy)
        
        
        xy=fillmissing(xy, 'movmean',10,'EndValues','nearest');
        xy=fillmissing(xy, 'linear');
    end