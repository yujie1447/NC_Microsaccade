

cto = [0.85 0.33 0.1];
caw = [0 0.45 0.74];
MSTT = -198:2:600;
%% % ------------------ Fig 2a ----------------------------
xxlim= [-150 450];
yylim = [-0.07 0.07];

figure
% ---------------------- V1 MS response -------------------
subplot(211)
shadedErrorBar(MSTT,V1blank_toward_avg,V1blank_toward_se,{'color',cto,'linewidth',1.5},1);
hold on;
shadedErrorBar(MSTT,V1blank_away_avg,V1blank_away_se,{'color',caw,'linewidth',1.5},1);
hold on; 
plot([MSTT(1) MSTT(end)],[1 1]*0,'k:');

xlim(xxlim);
ylim(yylim);box off
set(gca,'ytick',[-0.1 0 0.1]);
ylabel('Norm. MUA','FontName','arial','FontSize',12)
title('V1 blank','FontName','arial','FontSize',15,'FontWeight','Bold')

% ---------------------- V2 MS response -------------------
subplot(212)
shadedErrorBar(MSTT,V2blank_toward_avg,V2blank_toward_se,{'color',cto,'linewidth',1.5},1);
hold on;
shadedErrorBar(MSTT,V2blank_away_avg,V2blank_away_se,{'color',caw,'linewidth',1.5},1);
hold on; 
plot([MSTT(1) MSTT(end)],[1 1]*0,'k:');
xlim(xxlim);
ylim(yylim);box off
set(gca,'ytick',[-0.1 0 0.1]);
ylabel('Norm. MUA','FontName','arial','FontSize',12)
xlabel('Time to MS Onset (ms)','FontName','arial','FontSize',12)
title('V2 blank','FontName','arial','FontSize',15,'FontWeight','Bold')

%% % ------------------ Fig 2b ----------------------------
figure
subplot(211)

[counts,centers] = hist(baseFR_V1,[0:0.05:1]);
b=bar(centers,counts/sum(counts).*100);hold on
set(b,'facecolor',c1,'edgecolor','w','facealpha',0.5)

[counts,centers] = hist(baseFR_V2,[0:0.05:1]);
b=bar(centers,counts/sum(counts).*100);
set(b,'facecolor',c2,'edgecolor','w','facealpha',0.5)
set(gca,'FontSize',10,'FontName','arial');
ylabel('% channels','FontSize',12,'FontName','arial');box off


subplot(212)
plot([-10 110],[0 0],'k--','linewidth',1)

hold on; 
boxplot([AT_EI_V1, AT_EI_V2],[G_V1 G_V2+0.6],'PlotStyle','compact','Symbol','k','colors',[0.3 0.3 0.3; c2],'widths',1)

set(gca,'ytick',[-1 0 1],'xtick',1.5:2:9.5,'xticklabel',{'<0.15'   '0.15~0.2'   '0.2~0.25'    '0.25~0.36'   '>0.36' },'FontSize',10,'FontName','arial')
xlabel('Norm. Firing Rates (before microsaccades)','FontSize',12,'FontName','arial')
ylabel('Direction Mod. Indx','FontSize',12,'FontName','arial')
box off

%% % ------------------ Fig 2d ----------------------------
mualim = [-0.2 0.2];
yylim = mualim;
xxlim=[-150 450];

figure
subplot(121)
shadedErrorBar(MSTT,V2Sham_away_avg,V2Sham_away_se,{'color',caw,'linewidth',1.5},1);hold on
hold on
shadedErrorBar(MSTT,V2Sham_toward_avg,V2Sham_toward_se,{'color',cto,'linewidth',1.5},1);hold on
hold on; plot([MSTT(1) MSTT(end)],[1 1]*0,'k:');hold on
hold on; plot([MSTT(1) MSTT(end)].*0,[-0.2 0.2],'k--');hold on

set(gca,'FontSize',10,'FontName','arial','tickdir','out');
ylabel('Norm. MUA','FontName','arial','FontSize',12)
xlabel('Time to Surface Motion/Sham MS (ms)','FontName','arial','FontSize',12)
title('V2','FontName','arial','FontSize',15)
xlim(xxlim);
ylim(yylim);box off
hold on; plot([50 100],[1 1]*0.17,'-','color',cto,'linewidth',2); text(110,0.17,'Sham MS Toward','FontName','arial','FontSize',12)
hold on; plot([50 100],[1 1]*0.14,'-','color',caw,'linewidth',2); text(110,0.14,'Sham MS Away','FontName','arial','FontSize',12)

subplot(122)
shadedErrorBar(MSTT,V2away_avg,V2away_se,{'color',caw,'linewidth',1.5},1);hold on
hold on
shadedErrorBar(MSTT,V2toward_avg,V2toward_se,{'color',cto,'linewidth',1.5},1);hold on
hold on; plot([MSTT(1) MSTT(end)],[1 1]*0,'k:');hold on
hold on; plot([MSTT(1) MSTT(end)].*0,[-0.2 0.2],'k--');hold on
set(gca,'FontSize',10,'FontName','arial','tickdir','out');
xlabel('Time to Real MS (ms)','FontName','arial','FontSize',12)
title('V2','FontName','arial','FontSize',15)
ylabel('Norm. MUA','FontName','arial','FontSize',12)
xlim(xxlim);ylim(yylim);box off
hold on; plot([50 100],[1 1]*0.17,'-','color',cto,'linewidth',2); text(110,0.17,'MS Toward','FontName','arial','FontSize',12)
hold on; plot([50 100],[1 1]*0.14,'-','color',caw,'linewidth',2); text(110,0.14,'MS Away','FontName','arial','FontSize',12)

