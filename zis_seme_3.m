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
rank([r2 r3])

%% prubehy u, x, y, r, f_u, f_y
sim('schema_simout.slx')
figure % vvstup u
plot(simout_u)
title('Vstup y(t)')

figure % stav x
plot(simout_x)
title('Stav x(t)')

figure % vystup y
plot(simout_y)
title('Výstup y(t)')

figure % rezidualni signal r
r = simout_y - simout_y_odhad
plot(r)
title('Residualni signal r(t)')
legend('r_1(t)','r_2(t)')

figure %chyba f_u
plot(f_u.time, f_u.signals.values)
title('Chyba akèního èlenu f_u')

figure %chyba f_y
plot(f_y.time, f_y.signals.values)
title('Chyba senzoru f_y')

