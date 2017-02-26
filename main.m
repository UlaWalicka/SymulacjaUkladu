Lp=[-7.67e-4 1.0000];
Mp=[5e-007 0.001 1];
Top=0.00022;

%parametry symulacji
dT=1e-6;
Tsym=0.007;

Gp=tf(Lp,Mp);
[Ap, Bp, Cp, Dp]=ssdata(Gp);

%utworzenie wektora stanu
Xp=zeros(size(Bp));

%aby zmniejszyæ ilosæ mno¿eñ
Ap=dT*Ap; Bp=dT*Bp;

%wektor czasu
Ts=0:dT:Tsym;
N=length(Ts);
U=ones(size(Ts)); %pobudzenie - skok (same jedynki)
Uop=zeros(size(Ts)); %opóŸnienie - zera
Ys=zeros(size(Ts)); %wyjœcie obiektu - stworzenie macierzy -"rezerwacja" pamiêci

%opóŸnienie transportowe
Nop=Top/dT; %ile kroków zmieœci siê w czasie opóŸnienia
Nop=round(Nop); %zaokr¹glenie ^

%symulacja
for t=1:N-1,
    
    %symulacja opóŸnienia
    if t==Nop,
        Uop(t+1)=U(t+1-Nop);
    end;
    if t>Nop,
        Uop(t)=U(t-Nop);
        Uop(t+1)=U(t+1-Nop);
    end;
    
    Ys(t)=Cp*Xp + Dp*Uop(t);
    Xp2 = Xp + Ap*Xp + Bp*Uop(t+1);
    Xp = Xp+0.5*(Ap*Xp+Bp*Uop(t) + Ap*Xp2 +Bp*Uop(t+1));
    Ys(t+1) = Cp*Xp + Dp*Uop(t+1);
end;

%porównanie
Gp=tf(Lp, Mp);
Gop=ss(tf(Lp,Mp,'inputdelay',Top));

[Y]=step(Gop,Ts);
plot(Ts,Ys,Ts,Y);
grid on
    
        
        