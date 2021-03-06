%% Demo of using 'axislabel_rotation'
% Orthographic, DataAspectRatio = [1 2 3]
figure;
axes('box','on','dataaspectratio',[1 2 3],'projection','orthographic');
xlabel('This is an x label')
ylabel('This is a y label')
zlabel('This is a z label')
h = rotate3d;
set(h,'ActionPostCallback',@axislabel_rotation)

%% Demo of using 'align_axislabels'
% Perspective, DataAspectRatio = [1 1 1]
figure('color',[1 1 1])
axes('box','on','dataaspectratio',[1 1 1],'projection','perspective')
set(gca,'xlim',[-2.2,2.2],'ylim',[-2.2,2.2],'zlim',[-8.2,-3.8]);
xlabel('This is an x label')
ylabel('This is a y label')
zlabel('This is a z label')
line('xdata',[-2,-2,2,2,-2],'ydata',[-2,2,2,-2,-2],'zdata',[-4,-4,-4,-4,-4],'color',[1 0 0],'linewidth',3);
line('xdata',[-2,-2,2,2,-2],'ydata',[-2,2,2,-2,-2],'zdata',[-8,-8,-8,-8,-8],'color',[0 0 1],'linewidth',3);
line('xdata',[-2,-2],'ydata',[-2,-2],'zdata',[-4,-8],'color',[0 1 0],'linewidth',3);
line('xdata',[-2,-2],'ydata',[2,2],'zdata',[-4,-8],'color',[0 1 0],'linewidth',3);
line('xdata',[2,2],'ydata',[2,2],'zdata',[-4,-8],'color',[0 1 0],'linewidth',3);
line('xdata',[2,2],'ydata',[-2,-2],'zdata',[-4,-8],'color',[0 1 0],'linewidth',3);
line('xdata',[0,1],'ydata',[0,0],'zdata',[-6,-6],'color',[1 0 0],'linewidth',3)
line('xdata',[0,0],'ydata',[0,1],'zdata',[-6,-6],'color',[0 1 0],'linewidth',3)
line('xdata',[0,0],'ydata',[0,0],'zdata',[-6,-5],'color',[0 0 1],'linewidth',3)
h = rotate3d;
set(h,'ActionPostCallback',@align_axislabels)

%% Demo of setting text properties
% Perspective, DataAspectRatio = [1 1 0.5]
z = peaks;
surf(z);
set(gca,'dataaspectratio',[1 1 0.5],'projection','perspective','box','on')
xlabel('This is an x label','fontsize',14,'fontweight','bold','color',[1 0 0])
ylabel('This is a y label','fontsize',14,'fontweight','bold','color',[0 0 0])
zlabel('This is a z label','fontsize',14,'fontweight','bold','color',[0 0 1])
h = rotate3d;
set(h,'ActionPostCallback',@align_axislabels)
