clear
close all


%the value was adjusted so that the amplitude at the surface of the ball was  2.1 uW.cm2.
Amp=2.1/1.6681e+03;% uW/cm2

%amplitude was 67.25% at 200 um
tau=100.8; %assume 1 pixel = 5 um

scale=5; %1 pixel = 5 um

Flt_size=401;
Flt_mid=201;

EDfilter=zeros(Flt_size, Flt_size, Flt_size);

for x=1:Flt_size
	for y=1:Flt_size
		for z=1:Flt_size
			EDfilter(x,y,z)=exp(-sqrt((x-Flt_mid)^2+(y-Flt_mid)^2+(z-Flt_mid)^2)/tau)*Amp;
		end
	end
end



%%%%%%%%%%%%%%%%%%
Brain_space=401;
Brain_space_mid=201;



%%%%%%%%%%%%%%%%%%
Ball_powder=zeros(Brain_space,Brain_space,Brain_space);
for x=1:size(Ball_powder,1)
	for y=1:size(Ball_powder,2)
		for z=1:size(Ball_powder,3)
			if sqrt((x-Brain_space_mid)^2+(y-Brain_space_mid)^2+(z-Brain_space_mid)^2) < 61/scale && sqrt((x-Brain_space_mid)^2+(y-Brain_space_mid)^2+(z-Brain_space_mid)^2) > 55/scale  %115-120 um
				Ball_powder(x,y,z)=1;
			end
		end
	end
end
Ball_light=imfilter(Ball_powder, EDfilter);
title('Distribution of power')

figure
hold on
imagesc(squeeze(Ball_powder(:,:,Brain_space_mid)))
xlim([0 Brain_space])
ylim([0 Brain_space])
xticks(0:80:400)
xticklabels(-1000:400:1000)
xlabel('um')
yticks(0:80:400)
yticklabels(-1000:400:1000)
ylabel('um')
colorbar


figure
hold on
imagesc(squeeze(Ball_light(:,:,Brain_space_mid)))
xlim([0 Brain_space])
ylim([0 Brain_space])
xticks(0:80:400)
xticklabels(-1000:400:1000)
xlabel('um')
yticks(0:80:400)
yticklabels(-1000:400:1000)
ylabel('um')
colorbar
title('Distribution of light amplitude')
