function Plot_behavior(t,avec,bvec,cvec,label,xlimits)
figure('Position', [10 10 500 800])
set(gcf,'Color','white')
%xl=16+[-1 1]; % zoom in on t=19 (for V012, when B20 starts)
%xl=12.5+[-1 1]; % for V013, zoom in on time when B4/B5 is stimulated
xl=xlimits; % show full time scale
ymin = 0;
ymax = 2;
shift = 0.05;
top = 0.9;
i=0;
left = 0.25;
width = 0.7;
height = 0.025;

%CBI-s and MCC
subplot(13,1,1)
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
subplot('position',[left top width height*2.5])
i=i+1;
plot(t,cvec(6,:)*0.75+2, 'Color', [56/255, 232/255, 123/255],'LineWidth',2) %mechanical in grasper
%pos = get(gca,'Position');
%set(gca,'Position',[pos(1)+0.1 pos(2) pos(3)-0.1 pos(4)*2])
hold on
plot(t,cvec(3,:)*0.75+1, 'Color', [70/255, 84/255, 218/255],'LineWidth',2) %chemical at lips
plot(t,cvec(7,:)*0.75, 'Color', [47/255, 195/255, 241/255],'LineWidth',2) %mechanical at lips
hold off
set(gca,'FontSize',16)
legend({'Mech. in Grapser', 'Chem. at Lips', 'Mech. at Lips'},'Orientation','horizontal','Box','off','Position',[0.339642123669817,0.965429403202328,0.364074321139376,0.031659387832906],'FontSize',12)

set(gca,'xtick',[])
set(gca,'ytick',[0,1,2])
set(gca,'YTickLabel',[]);
ylabel('Stimuli')
ylim([0 3])
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
i=i+1;
set(gca,'FontSize',16)
set(gca,'xtick',[])
set(gca,'YTickLabel',[]);
ylabel('B40/B30', 'Color',[192/255, 92/255, 185/255])
%grid on
ylim([ymin ymax])
xlim(xl)
 hYLabel = get(gca,'YLabel');
 set(hYLabel,'rotation',0,'VerticalAlignment','middle','HorizontalAlignment','right','Position',get(hYLabel,'Position')-[0.05 0 0])
 set(gca,'XColor','none')

%subplot(15,1,8)
subplot('position',[left top-i*shift width height])
plot(t,avec(3,:),'LineWidth',2, 'Color', [51/255, 185/255, 135/255]) % B4/5
%pos = get(gca,'Position');
%set(gca,'Position',[pos(1)+0.1 pos(2) pos(3)-0.1 pos(4)])
i=i+1;
set(gca,'FontSize',16)
set(gca,'xtick',[])
set(gca,'YTickLabel',[]);
ylabel('B4/B5', 'Color', [51/255, 185/255, 135/255])
%grid on
ylim([ymin ymax])
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
set(gca,'YTickLabel',[]);
ylabel('B7', 'Color', [56/255, 167/255, 182/255])
%grid on
ylim([ymin ymax])
xlim(xl)
 hYLabel = get(gca,'YLabel');
 set(hYLabel,'rotation',0,'VerticalAlignment','middle','HorizontalAlignment','right','Position',get(hYLabel,'Position')-[0.05 0 0])
 set(gca,'XColor','none')
 
 %Grasper Motion
%subplot(15,1,14)
subplot('position',[left top-i*shift width height*3.5])
plot(t,(bvec(6,:)-bvec(8,:)),'b','LineWidth',2)
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


%subplot(15,1,15)
subplot('position',[left top-i*shift width height*3.5])
plot(t,bvec(7,:),'k','LineWidth',2)
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
ylim([-1 1])
xlim(xl)
set(gca,'XColor','none')
 hYLabel = get(gca,'YLabel');
 set(hYLabel,'rotation',0,'VerticalAlignment','middle','HorizontalAlignment','right','Position',get(hYLabel,'Position')-[0.05 0 0])
 set(gca,'XColor','none')
 
saveas(gcf,[label '_all.png'])

end