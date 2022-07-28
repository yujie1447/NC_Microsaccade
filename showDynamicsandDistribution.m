
cto = [0.85 0.33 0.1];
caw = [0 0.45 0.74];

c2 = [49 234 247]./255;
c1 = [0.3 0.3 0.3];

xxlim= [-150 450];
yylim = [-0.1 0.1];

msupwin_V1 = [126 450];
MSTT = -198:600; 
%% Show Figure1 %%

figure('Position',[587,278,884,717])

% ---------------------- V1 MS response -------------------
subplot('Position',[0.65 0.75 0.25 0.17])

patch([msupwin_V1 msupwin_V1(end:-1:1)],[-0.12 -0.12 0.12 0.12],'k','facealpha',0.07,'edgealpha',0);
hold on
shadedErrorBar(MSTT,V1toward_avg,V1toward_se,{'color',cto,'linewidth',1.5},1);
hold on;
shadedErrorBar(MSTT,V1away_avg,V1away_se,{'color',caw,'linewidth',1.5},1);
hold on; 
plot([MSTT(1) MSTT(end)],[1 1]*0,'k:');

xlim(xxlim);
ylim(yylim);box off
set(gca,'ytick',[-0.1 0 0.1]);
ylabel('Norm. MUA','FontName','arial','FontSize',12)
title('V1','FontName','arial','FontSize',15,'FontWeight','Bold')

% ---------------------- V2 MS response -------------------
subplot('Position',[0.65 0.51 0.25 0.17])

patch([msupwin_V2 msupwin_V2(end:-1:1)],[-0.12 -0.12 0.12 0.12],'k','facealpha',0.07,'edgealpha',0);
hold on
shadedErrorBar(MSTT,V2toward_avg,V2toward_se,{'color',cto,'linewidth',1.5},1);
hold on;
shadedErrorBar(MSTT,V2away_avg,V2away_se,{'color',caw,'linewidth',1.5},1);
hold on; 
plot([MSTT(1) MSTT(end)],[1 1]*0,'k:');
xlim(xxlim);
ylim(yylim);box off
set(gca,'ytick',[-0.1 0 0.1]);
ylabel('Norm. MUA','FontName','arial','FontSize',12)
xlabel('Time to MS Onset (ms)','FontName','arial','FontSize',12)
title('V2','FontName','arial','FontSize',15,'FontWeight','Bold')

%----------------------- V1 tuning ----------------------------
xx = -180:45:180;
yylim=[-0.06 0.06];
subplot('Position',[0.15 0.11 0.18 0.27])
bkbound = 202.5;
patch([-bkbound -112.5 -112.5 -bkbound],[yylim(1) yylim yylim(end)],'k','facecolor',caw,'facealpha',0.07,'edgealpha',0);hold on
patch([bkbound 112.5 112.5 bkbound],[yylim(1) yylim yylim(end)],'k','facecolor',caw,'facealpha',0.07,'edgealpha',0);hold on
patch([-67.5 67.5 67.5 -67.5],[yylim(1) yylim yylim(end)],'k','facecolor',cto,'facealpha',0.07,'edgealpha',0);hold on

hold on;
shadedErrorBar(xx, V1tuning_avg',V1tuning_se',{'o-','color','k','markerfacecolor','k'},1)
hold on;
plot([-225 225],[1 1]*0,'k:')

ylim(yylim);
set(gca,'FontSize',10,'FontName','arial');
title(['V1'],'FontSize',15,'FontName','arial','FontWeight','Bold');
set(gca,'xtick',[-180:90:180],'xticklabel',{'-180' '-90'  '0'  '90' '180'},'ytick',[-0.06 -0.03 0 0.03 0.06],'tickdir','out'); box off;
ylabel(['Average Norm. MUA'],'FontSize',12,'FontName','arial');
xlabel(['MS Direction Relative to RF (\circ)'],'FontSize',12,'FontName','arial');


%----------------------- V2 tuning ----------------------------
subplot('Position',[0.37 0.11 0.18 0.27])
patch([-bkbound -112.5 -112.5 -bkbound],[yylim(1) yylim yylim(end)],'k','facecolor',caw,'facealpha',0.07,'edgealpha',0);hold on
patch([bkbound 112.5 112.5 bkbound],[yylim(1) yylim yylim(end)],'k','facecolor',caw,'facealpha',0.07,'edgealpha',0);hold on
patch([-67.5 67.5 67.5 -67.5],[yylim(1) yylim yylim(end)],'k','facecolor',cto,'facealpha',0.07,'edgealpha',0);hold on
hold on;
plot([-225 225],[1 1]*0,'k:')
hold on; 
shadedErrorBar(xx, V2tuning_avg',V2tuning_se',{'o-','color','k','markerfacecolor','k'},1)
hold on;

ylim([yylim]);
set(gca,'xtick',[-180:90:180],'xticklabel',{'-180' '-90'  '0'  '90' '180'},'ytick',[-0.06 -0.03 0 0.03 0.06],'tickdir','out'); box off;
set(gca,'FontSize',10,'FontName','arial');
title(['V2'],'FontSize',15,'FontName','arial');

%----------------------- histogram of DMI ---------------------
subplot('Position',[0.65 0.11 0.26 0.28])

[counts,centers] = hist(DMI_V1,[-1:0.1:1]);
b=bar(centers,counts/sum(counts));hold on
set(b,'facecolor',c1,'edgecolor','w','facealpha',0.5)

[counts,centers] = hist(DMI_V2,[-1:0.1:1]);
b=bar(centers,counts/sum(counts));
set(b,'facecolor','c','edgecolor','w','facealpha',0.5)

set(gca,'FontSize',10,'FontName','arial');
hold on;plot([1 1]*0,[0 0.225],'k--','linewidth',1.5)
hold on;plot(mean(DMI_V1),0.2,'v','markerfacecolor',c1,'markeredgecolor','w','MarkerSize',8)
hold on;plot(mean(DMI_V2),0.2,'v','markerfacecolor',c2,'markeredgecolor','w','MarkerSize',8)

legend({['V1'],['V2']},'FontSize',12,'FontName','arial')
legend('boxoff')
box off
xlim([-1.1 1])
ylim([0 0.2])
xlabel(['Direction Modulation Index'],'FontSize',12,'FontName','arial');
ylabel(['Frequency'],'FontSize',12,'FontName','arial');
