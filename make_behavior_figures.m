function make_behavior_figures(filename)

target_name='ear';


data1=modify_DLC_tracking_csv(filename);


%shift mid of x-coor to zero
data1(:,[1,4, 7,10])=data1(:,[1, 4, 7,10])-1279;

%flip y-axis
data1(:,[2, 5, 8, 11])=1438-data1(:,[2, 5, 8, 11]);

Time_all=[1/25:1/25:size(data1,1)/25];
index_0_5min=[1:25*60*5];
index_5_10min=[25*60*5+1:25*60*10];
index_10_15min=[25*60*10+1:25*60*15];
index_0_10min=[1:25*60*10];
index_5_15min=[25*60*5+1:25*60*15];



xy1.tailbase=data1(:,[1,2]);
xy1.snout=data1(:,[4,5]);
xy1.earl=data1(:,[7,8]);
xy1.earr=data1(:,[10,11]);
xy1.head=nanmean([xy1.snout(:,1), xy1.earl(:,1), xy1.earr(:,1)],2);
xy1.head(:,2)=nanmean([xy1.snout(:,2), xy1.earl(:,2), xy1.earr(:,2)],2);

xy1.ear=nanmean([xy1.earl(:,1), xy1.earr(:,1)],2);
xy1.ear(:,2)=nanmean([xy1.earl(:,2), xy1.earr(:,2)],2);



%%%%%%%%%%%%%%%%%%%%%%%%%%5
vel1.head=xy1.head(2:end,:)-xy1.head(1:end-1,:);
vel1.ear=xy1.ear(2:end,:)-xy1.ear(1:end-1,:);


velA1.head=sqrt(vel1.head(:,1).^2+vel1.head(:,2).^2);
velA1.ear=sqrt(vel1.ear(:,1).^2+vel1.ear(:,2).^2);




%%%%%%%%%%%%%%%%%%%%%%%%%%5

velA1.head=movmean(velA1.head,5);
velA1.ear=movmean(velA1.ear,5);

%%%%%%%%%%%%%%%%%%%%%%%%%%5


%XY_plot=xy1.head;
%Vel=velA1.head;
eval(['XY_plot=xy1.', target_name, ';']);
eval(['Vel=velA1.', target_name, ';']);





%%%%%%%%%%%%%%%%%%%%%%%%%%5
%Total distance
if endsWith(filename,'day1')|endsWith(filename,'day4')
    TotalDistance=[sum(Vel(index_0_5min)), sum(Vel(index_5_10min)), sum(Vel(index_10_15min))];
else
    TotalDistance=[sum(Vel(index_0_5min)), sum(Vel(index_5_10min)), NaN];
end
figure
bar(TotalDistance)
ylabel('Total distance')
if endsWith(filename,'day1')|endsWith(filename,'day4')
    xlim([0 4])
    xticks([1 2 3])
    xticklabels({'0-5 min','5-10 min','10-15 min'})
else
    xlim([0 3])
    xticks([1 2])
    xticklabels({'0-5 min','5-10 min'})
end
title(['total: ', num2str(nansum(TotalDistance))])




%%%%%%%%%%%%%%%%%%%%%%%%%%5

%RL=discretize(XY_plot(:,1),2)-1;
RL=discretize(XY_plot(:,1),[-1279 0 1279])-1;

if endsWith(filename,'day1')|endsWith(filename,'day4')
    RL_bar=[mean(RL(index_0_5min)), mean(RL(index_5_10min)), mean(RL(index_10_15min))];
else
    RL_bar=[mean(RL(index_0_5min)), mean(RL(index_5_10min)), NaN];
end


figure
bar(RL_bar)
ylim([0 1])
ylabel('P(right)')
if endsWith(filename,'day1')|endsWith(filename,'day4')
    xlim([0 4])
    xticks([1 2 3])
    xticklabels({'0-5 min','5-10 min','10-15 min'})
else
    xlim([0 3])
    xticks([1 2])
    xticklabels({'0-5 min','5-10 min'})
end
title(['total: ', num2str(mean(RL))])






%%%%%%%%%%%%%%%%%%%%%%%%%%5


figure
plot(XY_plot(:,1),XY_plot(:,2))
xlim([-1300 1300])
title('trajectory')

%%%%%%%%%%%%%%%%%%%%%%%%%%5


X=discretize(XY_plot(:,1),[-1279:1279/6:1279]);
Y=discretize(XY_plot(:,2),[400:880/6:1280]);



for i=1:12
    for j=1:6
        HM_all(j,i)=sum(X==i & Y==7-j);
        HM_0_5min(j,i)=sum(X(index_0_5min)==i & Y(index_0_5min)==7-j);
        HM_5_10min(j,i)=sum(X(index_5_10min)==i & Y(index_5_10min)==7-j);
        if endsWith(filename,'day1')|endsWith(filename,'day4')
            HM_10_15min(j,i)=sum(X(index_10_15min)==i & Y(index_10_15min)==7-j);
        end
    end
end



%%%%%%%5

resol_X=100;
resol_Y=100;

X=discretize(XY_plot(:,1),[-1279:1279/(resol_X/2):1279]);
Y=discretize(XY_plot(:,2),[400:880/resol_Y:1280]);

for i=1:resol_X
    for j=1:resol_Y
        HM_0_10min(j,i)=sum(X(index_0_10min)==i & Y(index_0_10min)==resol_Y+1-j);
        if endsWith(filename,'day1')|endsWith(filename,'day4')
            HM_5_15min(j,i)=sum(X(index_5_15min)==i & Y(index_5_15min)==resol_Y+1-j);
        end
    end
end


sigma=1.5;
HM_0_10min_fltd = imgaussfilt(HM_0_10min,sigma);


figure
h = imagesc(HM_0_10min_fltd,[0 30]);
colormap(jet);
title('0-10min')

if endsWith(filename,'day1')|endsWith(filename,'day4')
    HM_5_15min_fltd = imgaussfilt(HM_5_15min,sigma);
    
    figure
    h = imagesc(HM_5_15min_fltd,[0 30]);
    colormap(jet);
    title('5-15min')
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%5






