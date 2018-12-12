% inicializace
A = [0 1; -0.2 -0.3];
B = [0; 0.2];
C = [1 0; 0 1];
Bf = [0; 0.2];
Df = [0; 1];

ts = 0.1;
f_u.signals.values = [[0*[0:ts:19.9]] [0.2*ones(1,300)] [0*[50.1:ts:100]] ]';
f_y.signals.values = [[0*[0:ts:59.9]] [0.1*sin(0.3*[60.1:ts:90])] [0*[90.1:ts:100]] ]'; %#ok<*NBRAK>
f_u.time = [0:ts:99.9];
f_u.dimensions = 1;
f_y.time = [0:ts:99.9];
f_y.dimensions = 1;

%% vypocet matice K
K = (A + [1 0; 0 1])*inv(C);

%% Analyza chyb
r1 = C*Bf;
r2 = C*K*Df;
r3 = Df;
rank([r2 r3]);

%% Generátor rozhodnutí
sim('schema_simout.slx')
%spodní hranice
r = simout_y - simout_y_odhad;
test = r.Data(:,1).^2 + r.Data(:,2).^2;
chyba = 1e-4;
for i = 1:size(r.Data(:,1),1)
   if test(i) <= chyba
       d(i) = 0; 
   else
       d(i) = 1; 
   end
end
figure('Name','fig1');
plot(simout_y.Time,d)
title('Generátor rozhodnutí pro \epsilon = 10^{-4}')
ylabel({'Chyba'});
xlabel('Time (seconds)');
hold on
plot([0 0],[1.5 1.5])
plot([0 100],[1 1],'r','LineWidth', 1,'LineStyle',':')

%horní hranice
r = simout_y - simout_y_odhad;
test = r.Data(:,1).^2 + r.Data(:,2).^2;
chyba = 1e-11;
for i = 1:size(r.Data(:,1),1)
   if test(i) <= chyba
       d(i) = 0; 
   else
       d(i) = 1; 
   end
end
figure('Name','fig2');
plot(simout_y.Time,d)
title('Generátor rozhodnutí pro \epsilon = 10^{-11}')
ylabel({'Chyba'});
xlabel('Time (seconds)');
hold on
plot([0 0],[1.5 1.5])
plot([0 100],[1 1],'r','LineWidth', 1,'LineStyle',':')
%% prubehy u, x, y, r, f_u, f_y
figure('Name','fig3'); % vvstup u
plot(simout_u)
title('Vstup y(t)')

figure('Name','fig4'); % stav x
plot(simout_x)
title('Stav x(t)')

figure('Name','fig5'); % vystup y
plot(simout_y)
title('Výstup y(t)')

figure('Name','fig6'); % rezidualni signal r
plot(r)
title('Residuální signál r(t)')
legend('r_1(t)','r_2(t)')
ylabel('Velikost reziduálního signálu')

figure('Name','fig7'); %chyba f_u
plot(f_u.time, f_u.signals.values)
title('Chyba akèního èlenu f_u')
xlabel('Time (seconds)')
ylabel('Velikost chyby')

figure('Name','fig8'); %chyba f_y
plot(f_y.time, f_y.signals.values)
title('Chyba senzoru f_y')
xlabel('Time (seconds)')
ylabel('Velikost chyby')

%%
FolderName = tempdir;   % Your destination folder
FigList = findobj(allchild(0), 'flat', 'Type', 'figure');
for iFig = 1:length(FigList)
  FigHandle = FigList(iFig);
  FigName   = get(FigHandle, 'Name');
  %savefig(FigHandle, fullfile(FolderName, FigName, '.eps'));
  set(0, 'CurrentFigure', FigHandle);
  saveas(FigHandle, fullfile(FolderName, [FigName, '.eps']), 'epsc');
end