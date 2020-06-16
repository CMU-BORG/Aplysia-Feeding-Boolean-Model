function figure1 = Plot_behavior(t,avec,bvec,cvec,label,xlimits,pmax,params)
figure('Position', [10 10 800 1000])
set(gcf,'Color','white')
figure1 = gcf;
%xl=16+[-1 1]; % zoom in on t=19 (for V012, when B20 starts)
%xl=12.5+[-1 1]; % for V013, zoom in on time when B4/B5 is stimulated
xl=xlimits; % show full time scale
ymin = 0;
ymax = 1;
shift = 0.04;
top = 0.95;
i=0;
left = 0.25;
width = 0.7;
height = 0.02;

%CBI-s and MCC
subplot(15,1,1)
% plot(t,avec(6,:),'k','LineWidth',2) % MCC
% set(gca,'Position',[left top-i*shift width height])
% i=i+1;
% set(gca,'FontSize',16)
% set(gca,'xtick',[])
% ylabel('MCC')
% %grid on
% ylim([ymin ymax])
% xlim(xl)
% hYLabel = get(gca,'YLabel');
% set(hYLabel,'rotation',0,'VerticalAlignment','middle','HorizontalAlignment','right','Position',get(hYLabel,'Position')-[0.05 0 0])
% set(gca,'XColor','none')
% title('Cerebal Neurons')

%External Stimuli
%subplot(15,1,1)
subplot('position',[left top width height])
i=i+1;
plot(t,cvec(6,:), 'Color', [56/255, 232/255, 123/255],'LineWidth',2) %mechanical in grasper
%pos = get(gca,'Position');
%set(gca,'Position',[pos(1)+0.1 pos(2) pos(3)-0.1 pos(4)*2])
set(gca,'FontSize',16)
%legend({'Mech. in Grapser'},'Orientation','horizontal','Box','off','Position',[0.339642123669817,0.965429403202328,0.364074321139376,0.031659387832906],'FontSize',12)

set(gca,'xtick',[])
set(gca,'ytick',[0,1])
set(gca,'YTickLabel',[]);
ylabel('Mech. in Grasper')
ylim([0 1])
grid on
%ylim([ymin ymax])
xlim(xl)
 hYLabel = get(gca,'YLabel');
 set(hYLabel,'rotation',0,'VerticalAlignment','middle','HorizontalAlignment','right','Position',get(hYLabel,'Position')-[0.05 0 0])

set(gca,'XColor','none')

subplot('position',[left top-i*shift width height])
i=i+1;
plot(t,cvec(3,:), 'Color', [70/255, 84/255, 218/255],'LineWidth',2) %chemical at lips
set(gca,'FontSize',16)
%legend({'Chem. at Lips'},'Orientation','horizontal','Box','off','Position',[0.339642123669817,0.965429403202328,0.364074321139376,0.031659387832906],'FontSize',12)

set(gca,'xtick',[])
set(gca,'ytick',[0,1])
set(gca,'YTickLabel',[]);
ylabel('Chem. at Lips')
ylim([0 1])
grid on
%ylim([ymin ymax])
xlim(xl)
 hYLabel = get(gca,'YLabel');
 set(hYLabel,'rotation',0,'VerticalAlignment','middle','HorizontalAlignment','right','Position',get(hYLabel,'Position')-[0.05 0 0])

set(gca,'XColor','none')

subplot('position',[left top-i*shift width height])
i=i+1;
plot(t,cvec(7,:), 'Color', [47/255, 195/255, 241/255],'LineWidth',2) %mechanical at lips
set(gca,'FontSize',16)
%legend({'Mech. at Lips'},'Orientation','horizontal','Box','off','Position',[0.339642123669817,0.965429403202328,0.364074321139376,0.031659387832906],'FontSize',12)

set(gca,'xtick',[])
set(gca,'ytick',[0,1])
set(gca,'YTickLabel',[]);
ylabel('Mech. at Lips')
ylim([0 1])
grid on
%ylim([ymin ymax])
xlim(xl)
 hYLabel = get(gca,'YLabel');
 set(hYLabel,'rotation',0,'VerticalAlignment','middle','HorizontalAlignment','right','Position',get(hYLabel,'Position')-[0.05 0 0])

set(gca,'XColor','none')

%subplot(15,1,2)
subplot('position',[left top-i*shift width height])
plot(t,avec(7,:),'k','LineWidth',2) % CBI2
%pos = get(gca,'Position');
%set(gca,'Position',[pos(1)+0.1 pos(2) pos(3)-0.1 pos(4)])
i=i+1;
set(gca,'FontSize',16)
set(gca,'xtick',[])
set(gca,'ytick',[0,1])
set(gca,'YTickLabel',[]);
ylabel('CBI-2')
%grid on
ylim([ymin ymax])
xlim(xl)
 hYLabel = get(gca,'YLabel');
 set(hYLabel,'rotation',0,'VerticalAlignment','middle','HorizontalAlignment','right','Position',get(hYLabel,'Position')-[0.05 0 0])
 set(gca,'XColor','none')
%title('Cerebal Neurons')

%subplot(15,1,3)
subplot('position',[left top-i*shift width height])
plot(t,avec(8,:),'k','LineWidth',2) % CBI3
%pos = get(gca,'Position');
%set(gca,'Position',[pos(1)+0.1 pos(2) pos(3)-0.1 pos(4)])
i=i+1;
set(gca,'FontSize',16)
set(gca,'xtick',[])
set(gca,'ytick',[0,1])
set(gca,'YTickLabel',[]);
ylabel('CBI-3')
%grid on
ylim([ymin ymax])
xlim(xl)
 hYLabel = get(gca,'YLabel');
 set(hYLabel,'rotation',0,'VerticalAlignment','middle','HorizontalAlignment','right','Position',get(hYLabel,'Position')-[0.05 0 0])
 set(gca,'XColor','none')

%subplot(15,1,4)
subplot('position',[left top-i*shift width height])
plot(t,avec(12,:),'k','LineWidth',2) % CBI4
%pos = get(gca,'Position');
%set(gca,'Position',[pos(1)+0.1 pos(2) pos(3)-0.1 pos(4)])
i=i+1;
set(gca,'FontSize',16)
set(gca,'xtick',[])
set(gca,'ytick',[0,1])
set(gca,'YTickLabel',[]);
ylabel('CBI-4')
%grid on
ylim([ymin ymax])
xlim(xl)
 hYLabel = get(gca,'YLabel');
 set(hYLabel,'rotation',0,'VerticalAlignment','middle','HorizontalAlignment','right','Position',get(hYLabel,'Position')-[0.05 0 0])
 set(gca,'XColor','none')

%Interneurons
%subplot(15,1,5)
subplot('position',[left top-i*shift width height])
plot(t,avec(9,:),'LineWidth',2, 'Color',[90/255, 131/255, 198/255]) % B64
%pos = get(gca,'Position');
%set(gca,'Position',[pos(1)+0.1 pos(2) pos(3)-0.1 pos(4)])
i=i+1;
set(gca,'FontSize',16)
set(gca,'xtick',[])
set(gca,'ytick',[0,1])
set(gca,'YTickLabel',[]);
ylabel('B64', 'Color',[90/255, 131/255, 198/255])
%grid on
ylim([ymin ymax])
xlim(xl)
 hYLabel = get(gca,'YLabel');
 set(hYLabel,'rotation',0,'VerticalAlignment','middle','HorizontalAlignment','right','Position',get(hYLabel,'Position')-[0.05 0 0])
 set(gca,'XColor','none')
%title('Buccal Interneurons')

%subplot(15,1,6)
subplot('position',[left top-i*shift width height])
plot(t,avec(10,:),'LineWidth',2, 'Color',[44/255, 166/255, 90/255]) % B20
%pos = get(gca,'Position');
%set(gca,'Position',[pos(1)+0.1 pos(2) pos(3)-0.1 pos(4)])
i=i+1;
set(gca,'FontSize',16)
set(gca,'xtick',[])
set(gca,'ytick',[0,1])
set(gca,'YTickLabel',[]);
ylabel('B20', 'Color',[44/255, 166/255, 90/255])
%grid on
ylim([ymin ymax])
xlim(xl)
 hYLabel = get(gca,'YLabel');
 set(hYLabel,'rotation',0,'VerticalAlignment','middle','HorizontalAlignment','right','Position',get(hYLabel,'Position')-[0.05 0 0])
 set(gca,'XColor','none')

%subplot(15,1,7)
subplot('position',[left top-i*shift width height])
plot(t,avec(13,:),'LineWidth',2, 'Color',[192/255, 92/255, 185/255]) % B40/B30
%pos = get(gca,'Position');
%set(gca,'Position',[pos(1)+0.1 pos(2) pos(3)-0.1 pos(4)])
i=i+1.5;
set(gca,'FontSize',16)
set(gca,'xtick',[])
set(gca,'ytick',[0,1])
set(gca,'YTickLabel',[]);
ylabel('B40/B30', 'Color',[192/255, 92/255, 185/255])
%grid on
ylim([ymin ymax])
xlim(xl)
 hYLabel = get(gca,'YLabel');
 set(hYLabel,'rotation',0,'VerticalAlignment','middle','HorizontalAlignment','right','Position',get(hYLabel,'Position')-[0.05 0 0])
 set(gca,'XColor','none')

%subplot(15,1,8)
subplot('position',[left top-i*shift width height*2])
plot(t,avec(3,:),'LineWidth',2, 'Color', [51/255, 185/255, 135/255]) % B4/5
%pos = get(gca,'Position');
%set(gca,'Position',[pos(1)+0.1 pos(2) pos(3)-0.1 pos(4)])
i=i+1;
set(gca,'FontSize',16)
set(gca,'xtick',[])
set(gca,'ytick',[0,1,2])
set(gca,'YTickLabel',[]);
ylabel('B4/B5', 'Color', [51/255, 185/255, 135/255])
%grid on
ylim([ymin 2])
xlim(xl)
 hYLabel = get(gca,'YLabel');
 set(hYLabel,'rotation',0,'VerticalAlignment','middle','HorizontalAlignment','right','Position',get(hYLabel,'Position')-[0.05 0 0])
 set(gca,'XColor','none')


 %motor neurons
 
%subplot(15,1,9)
subplot('position',[left top-i*shift width height])
plot(t,avec(4,:),'LineWidth',2, 'Color', [220/255, 81/255, 81/255]) % I2 input
%pos = get(gca,'Position');
%set(gca,'Position',[pos(1)+0.1 pos(2) pos(3)-0.1 pos(4)])
i=i+1;
set(gca,'FontSize',16)
set(gca,'xtick',[])
set(gca,'ytick',[0,1])
set(gca,'YTickLabel',[]);
ylabel('B31/B32','Color',[220/255, 81/255, 81/255])
%grid on
ylim([ymin ymax])
xlim(xl)
 hYLabel = get(gca,'YLabel');
 set(hYLabel,'rotation',0,'VerticalAlignment','middle','HorizontalAlignment','right','Position',get(hYLabel,'Position')-[0.05 0 0])
 set(gca,'XColor','none')
%title('Motor Neurons')


%subplot(15,1,10)
subplot('position',[left top-i*shift width height])
plot(t,avec(1,:),'LineWidth',2, 'Color', [213/255, 155/255, 196/255]) % B8a/b
%pos = get(gca,'Position');
%set(gca,'Position',[pos(1)+0.1 pos(2) pos(3)-0.1 pos(4)])
i=i+1;
set(gca,'FontSize',16)
set(gca,'xtick',[])
set(gca,'ytick',[0,1])
set(gca,'YTickLabel',[]);
ylabel('B8a/b', 'Color', [213/255, 155/255, 196/255])
%grid on
ylim([ymin ymax])
xlim(xl)
 hYLabel = get(gca,'YLabel');
 set(hYLabel,'rotation',0,'VerticalAlignment','middle','HorizontalAlignment','right','Position',get(hYLabel,'Position')-[0.05 0 0])
 set(gca,'XColor','none')

%subplot(15,1,11)
subplot('position',[left top-i*shift width height])
plot(t,avec(2,:),'LineWidth',2, 'Color', [238/255, 191/255, 70/255]) % B38
%pos = get(gca,'Position');
%set(gca,'Position',[pos(1)+0.1 pos(2) pos(3)-0.1 pos(4)])
i=i+1;
set(gca,'FontSize',16)
set(gca,'xtick',[])
set(gca,'ytick',[0,1])
set(gca,'YTickLabel',[]);
ylabel('B38', 'Color', [238/255, 191/255, 70/255])
%grid on
ylim([ymin ymax])
xlim(xl)
 hYLabel = get(gca,'YLabel');
 set(hYLabel,'rotation',0,'VerticalAlignment','middle','HorizontalAlignment','right','Position',get(hYLabel,'Position')-[0.05 0 0])
 set(gca,'XColor','none')

%subplot(15,1,12)
subplot('position',[left top-i*shift width height])
plot(t,avec(5,:),'LineWidth',2, 'Color', [90/255, 155/255, 197/255]) % B6/9/3
%pos = get(gca,'Position');
%set(gca,'Position',[pos(1)+0.1 pos(2) pos(3)-0.1 pos(4)])
i=i+1;
set(gca,'FontSize',16)
set(gca,'xtick',[])
set(gca,'ytick',[0,1])
set(gca,'YTickLabel',[]);
ylabel('B6/B9/B3', 'Color', [90/255, 155/255, 197/255])
%grid on
ylim([ymin ymax])
xlim(xl)
set(get(gca,'ylabel'),'rotation',0) 
hYLabel = get(gca,'YLabel');
 set(hYLabel,'rotation',0,'VerticalAlignment','middle','HorizontalAlignment','right','Position',get(hYLabel,'Position')-[0.05 0 0])
 set(gca,'XColor','none')
 
%subplot(15,1,13)
subplot('position',[left top-i*shift width height])
plot(t,avec(11,:),'LineWidth',2, 'Color', [56/255, 167/255, 182/255]) % B7
%pos = get(gca,'Position');
%set(gca,'Position',[pos(1)+0.1 pos(2) pos(3)-0.1 pos(4)])
i=i+2.5;
set(gca,'FontSize',16)
set(gca,'xtick',[])
set(gca,'ytick',[0,1])
set(gca,'YTickLabel',[]);
ylabel('B7', 'Color', [56/255, 167/255, 182/255])
%grid on
ylim([ymin ymax])
xlim(xl)
 hYLabel = get(gca,'YLabel');
 set(hYLabel,'rotation',0,'VerticalAlignment','middle','HorizontalAlignment','right','Position',get(hYLabel,'Position')-[0.05 0 0])
 set(gca,'XColor','none')
 
 
 %Determine locations of protraction retraction boxes
 tstep = t(2)-t(1);
 startnum = round(xl(1)/tstep)
 endnum = round(xl(2)/tstep)
 grasper_rel_pos = (bvec(6,:)-bvec(8,:));
 numProtractionBoxes = 0;
 numRetractionBoxes = 0;
 protraction = 1;
 protractionRectangles=[0,0];
 retractionRectangles=[0,0];
 for ind=startnum:endnum
    if grasper_rel_pos(ind) > grasper_rel_pos(ind-1)
        %protraction
        if(protraction == 0)
            numProtractionBoxes=numProtractionBoxes+1;
            protraction = 1;
            %end the last retractionrectangle
            if(numRetractionBoxes>0)
                retractionRectangles(numRetractionBoxes,2) = ind;
            end
            %start a new protractionrectangle
            protractionRectangles(numProtractionBoxes,1) = ind;
        end
    else
        %retraction
        if(protraction == 1)
            numRetractionBoxes=numRetractionBoxes+1;
            protraction = 0;
            %end the last retractionrectangle            
            retractionRectangles(numRetractionBoxes,1) = ind;
            %start a new protractionrectangle
            if(numProtractionBoxes>0)
                protractionRectangles(numProtractionBoxes,2) = ind; 
            end
        end     
    end
 end
 
 if retractionRectangles(end,2) ==0
     retractionRectangles(end,2) = endnum;
 end
 
 if protractionRectangles(end,2) ==0
     protractionRectangles(end,2) = endnum;
 end
 
 
%Muscles and Forces
buccalM_K = params{13,1}; % spring constant representing boddy from buccal mass to ground
buccalM_rest = params{14,1}; % resting position of body
grasper_K = params{23,1}; % spring constant representing boddy from buccal mass to ground
grasper_rest = params{24,1}; % resting position of body
subplot('position',[left top-i*shift width height*3.5])
I2 = bvec(4,:);
I3 = bvec(3,:);
hinge = bvec(12,:);
position_grasper_relative = bvec(6,:)-bvec(8,:);
pinch = bvec(9,:).*min(max((1-(position_grasper_relative).^2),0),1);
headspring = -(buccalM_rest-bvec(8,:))*buccalM_K;
grasperspring = -(grasper_rest-position_grasper_relative)*grasper_K;
pressure = bvec(2,:)/pmax;
%scaled_spring = spring.*pressure;

hold on
plot(t,I2,'LineWidth',2,'Color', [220/255, 81/255, 81/255])
plot(t,I3,'LineWidth',2,'Color', [90/255, 155/255, 197/255])
plot(t,hinge,'LineWidth',2, 'Color', [56/255, 167/255, 182/255])
plot(t,pinch,'LineWidth',2, 'Color', [238/255, 191/255, 70/255])
plot(t,headspring,'k','LineWidth',2)
plot(t,grasperspring,'--k','LineWidth',2)
plot(t,pressure,'LineWidth',2, 'Color', [213/255, 155/255, 196/255])
%plot(t,scaled_spring,'--k','LineWidth',2)
hold off

i=i+2.5;
xlim(xl)


 
%Grasper Motion
%subplot(15,1,14)
subplot('position',[left top-i*shift width height*3.5])
grasper_motion = (bvec(6,:)-bvec(8,:));
grasper_pressure = bvec(18,:);
idx = grasper_pressure >=1;%pmax*0.6;
idy = grasper_pressure <1;%pmax*0.6;

grasper_motion_pressure(idx) = grasper_motion(idx);
grasper_motion_pressure(idy)=NaN;

plot(t,grasper_motion_pressure,'b','LineWidth',4)
hold on
plot(t,grasper_motion,'b','LineWidth',2)
hold off


%pos = get(gca,'Position')
%[pos(1)+0.1 pos(2)-0.017 pos(3)-0.1 pos(4)*1.5]
%set(gca,'Position',[pos(1)+0.1 pos(2)-0.017 pos(3)-0.1 pos(4)*1.5])
i=i+2.5;
set(gca,'FontSize',16)
set(gca,'xtick',[])
set(gca,'YTickLabel',[]);
ylabel({'Grasper';'Motion'}, 'Color', [0/255, 0/255, 255/255])
%grid on
ylim([ymin 1.5])
xlim(xl)
set(gca,'XColor','none')
hYLabel = get(gca,'YLabel');
set(hYLabel,'rotation',0,'VerticalAlignment','middle','HorizontalAlignment','right','Position',get(hYLabel,'Position')-[0.05 0 0])
set(gca,'XColor','none')

positionAxesCell = get(gca,{'Position'});
positionAxes = positionAxesCell{1};
leftAxes = positionAxes(1)
widthAxes = positionAxes(3)
bottomAxes = positionAxes(2)+positionAxes(4)

hold on
for retract = 1:length(retractionRectangles)
h=rectangle('Position', [retractionRectangles(retract,1)*tstep 1.25 (retractionRectangles(retract,2)-retractionRectangles(retract,1))*tstep 0.1]);  
h.FaceColor = 'black';
end
hold off

hold on
for protract = 1:length(protractionRectangles)
h=rectangle('Position', [protractionRectangles(protract,1)*tstep 1.25 (protractionRectangles(protract,2)-protractionRectangles(protract,1))*tstep 0.1]);  
h.FaceColor = 'white';
end
hold off


% for retract = 1:length(retractionRectangles)
% h=annotation(gcf,'rectangle',...
%     [retractionRectangles(retract,1) bottomAxes retractionRectangles(retract,2)-leftAxes 0.01]);  
% h.FaceColor = 'black';
% end
% for protract = 1:length(protractionRectangles)
% h=annotation(gcf,'rectangle',...
%     [(protractionRectangles(protract,1)-startnum)*scale+leftAxes bottomAxes (protractionRectangles(protract,2)-startnum)*widthAxes/(endnum-startnum) 0.01]);  
% h.FaceColor = 'white';
% end

% spearate kinetic and static friction
idx = bvec(18,:) >=1;%pmax*0.6;
idy = bvec(18,:) <1;%pmax*0.6;

grasper_friction(idx) = bvec(20,idx);
grasper_friction(idy)=NaN;

jdx = bvec(19,:) >=1;%pmax*0.6;
jdy = bvec(19,:) <1;%pmax*0.6;

pinch_friction(jdx) = bvec(21,jdx);
pinch_friction(jdy)=NaN;

%subplot(15,1,15)
subplot('position',[left top-i*shift width height*3.5])


plot(t,bvec(20,:),'LineWidth',2, 'Color', [213/255, 155/255, 196/255])
hold on
plot(t,grasper_friction,'LineWidth',4, 'Color', [213/255, 155/255, 196/255])
plot(t,bvec(21,:),'LineWidth',2, 'Color', [238/255, 191/255, 70/255])
plot(t,pinch_friction,'LineWidth',4, 'Color', [238/255, 191/255, 70/255])
plot(t,bvec(7,:),'k','LineWidth',2)
hold off
yticks([-1 0 1])
yticklabels({'','0',''})
%pos = get(gca,'Position')
%[pos(1)+0.1 pos(2)-0.04 pos(3)-0.1 pos(4)]
%set(gca,'Position',[pos(1)+0.1 pos(2)-0.04 pos(3)-0.1 pos(4)])
i=i+1.5;
set(gca,'FontSize',16)
set(gca,'xtick',[])
ylabel('Force', 'Color', [0/255, 0/255, 0/255])
%grid on
%ylim([-0.5 0.5])
xlim(xl)
set(gca,'XColor','none')
 hYLabel = get(gca,'YLabel');
 set(hYLabel,'rotation',0,'VerticalAlignment','middle','HorizontalAlignment','right','Position',get(hYLabel,'Position')-[0.05 0 0])
 set(gca,'XColor','none')
 
saveas(gcf,[label '_all.png'])

end