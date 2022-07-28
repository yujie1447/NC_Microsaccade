cto = [0.85 0.33 0.1];
caw = [0 0.45 0.74];

c2 = [49 234 247]./255;
c1 = [0.3 0.3 0.3];

MSTT = -198:600; 

%% % ------------ Fig.3b ---------------------------------
xxlim=[0 400];
yylim = [-0.08 0.08];

figure
for ii = 1:9
     subplot('Position',[0.1+0.042*(ii-1) 0.62 0.04 0.31])

    shadedErrorBar(MSTT,V1_dir_avg(:,ii),V1_dir_se(:,ii),{'color',c1,'linewidth',1.5},1);hold on

    shadedErrorBar(MSTT,V2_dir_avg(:,ii),V2_dir_se(:,ii),{'color',c2,'linewidth',1.5},1);hold on
    hold on; plot([MSTT(1) MSTT(end)],[1 1]*0,'k:','linewidth',1);
    set(gca,'FontSize',10,'FontName','arial');
    ylabel('Norm. MUA','FontName','arial','FontSize',12)
    xlabel('Time to MS Onset (ms)','FontName','arial','FontSize',12)
    ylim(yylim);box off
    xlim(xxlim);
end

%% % ------------ Fig.3d ---------------------------------
% -------------------------V1 --------------------------
subplot(211)

hold on;plot(V1_amp_toward,V1_mua_toward,'o','markerfacecolor',cto,'markeredgecolor',[1 1 1].*0.5,'linewidth',1)
hold on;plot(V1_amp_away,V1_mua_away,'o','markerfacecolor',caw,'markeredgecolor',[1 1 1].*0.5,'linewidth',1)

% --- fitted line---

xtest = 0.1:0.1:0.9;
[p,s] = polyfit(V1_amp_toward,V1_mua_toward,1);
[yfit,dy] = polyconf(p,xtest,s,'predopt','curve','simopt','on');
line(xtest,yfit,'color',cto,'LineWidth',1)

xtest = 0.1:0.1:0.9;
[p,s] = polyfit(V1_amp_away,V1_mua_away,1);
[yfit,dy] = polyconf(p,xtest,s,'predopt','curve','simopt','on');
line(xtest,yfit,'color',caw,'LineWidth',1)
    
  % -------------------------V2 --------------------------
subplot(212)
hold on;plot(V2_amp_toward,V2_mua_toward,'o','markerfacecolor',cto,'markeredgecolor',[1 1 1].*0.5,'linewidth',1)
hold on;plot(V2_amp_away,V2_mua_away,'o','markerfacecolor',caw,'markeredgecolor',[1 1 1].*0.5,'linewidth',1)

% --- fitted line---

xtest = 0.1:0.1:0.9;
[p,s] = polyfit(V2_amp_toward,V2_mua_toward,1);
[yfit,dy] = polyconf(p,xtest,s,'predopt','curve','simopt','on');
line(xtest,yfit,'color',cto,'LineWidth',1)

xtest = 0.1:0.1:0.9;
[p,s] = polyfit(V2_amp_away,V2_mua_away,1);
[yfit,dy] = polyconf(p,xtest,s,'predopt','curve','simopt','on');
line(xtest,yfit,'color',caw,'LineWidth',1)


% --- confidence interval---

yP=[yfit-dy,fliplr(yfit+dy)];
xP=[xtest,fliplr(xtest)];

%remove any nans otherwise patch won't work
xP(isnan(yP))=[];
yP(isnan(yP))=[];

hold on;patch(xP,yP,1,'facecolor',caw,...
    'edgecolor','none',...
    'facealpha',0.1);