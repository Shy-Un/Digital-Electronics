*** Hybrid XOR-XNOR Based FA ***
.include "C:\Users\SHAYAN\Desktop\UNi stuff\8\Digital Elec\Vol Project\45nm.pm"


****
.PARAM supply=1v
.PARAM Wmin=45n **2xlanda
.PARAM Lmin=45n **2xlanda
.PARAM my_cload= 6fF
****
.subckt XORXNOR A B Vdd xor xnor ind
Mp1 xor B A Vdd pmos w='240nm' l='45nm'
Mp2 xor A B Vdd pmos w='240nm' l='45nm'
Mn1 xor B ind 0 nmos w='240nm' l='45nm'
Mn2 ind A 0 0 nmos w='240nm' l='45nm'
Mn3 xor ind B 0 nmos w='240nm' l='45nm'
Mp3 ind A Vdd Vdd pmos w='480nm' l='45nm'
Mp4 xnor B ind Vdd pmos w='480nm' l='45nm'
Mp5 xnor ind B Vdd pmos w='480nm' l='45nm'
Mn4 xnor A B 0 nmos w='120nm' l='45nm'
Mn5 xnor B A 0 nmos w='120nm' l='45nm'
.ends XORXNOR



.subckt SumCircuit xor xnor sum cin CI vdd
Mn6 xor CI sum 0 nmos w='120nm' l='45nm'
Mp6 sum cin xor Vdd pmos w='240nm' l='45nm'
Mn7 xnor cin sum 0 nmos w='120nm' l='45nm'
Mp7 sum CI xnor Vdd pmos w='240nm' l='45nm'
.ends SumCircuit


.subckt CarryCircuit cin cout CI xor xnor ind Vdd B
Mp8 notcout B ind Vdd pmos w='240nm' l='45nm'
Mn8 notcout B ind GND nmos w='120nm' l='45nm'
Mp10 CI cin Vdd Vdd pmos w='360nm' l='45nm'
Mp9 notcout xnor CI Vdd pmos w='360nm' l='45nm'
Mn9 notcout xor CI GND nmos w='180nm' l='45nm'
Mn10 CI cin GND GND nmos w='180nm' l='45nm'
Mp11 cout notcout Vdd Vdd pmos w='240nm' l='45nm'
Mn11 cout notcout GND GND nmos w='120nm' l='45nm'
.ends CarryCircuit

  ** Main Circuit  *

X1 A B sup xor xnor ind XORXNOR
X2 xor xnor sum cin CI sup SumCircuit
X3 cin cout CI xor xnor ind sup B CarryCircuit 
*cload1 and 0 my_cload

  ** Define Stimuli  *

Vdd sup 0 supply 
Vb B 0 PWL(0ns 0v, 5ns 0v, 5.01ns 1v, 10ns 1v,10.01ns 0v,15ns 0v,15.01ns 1v,20ns 1v,20.01ns 0v,25ns 0v,25.01ns 1v,30ns 1v,30.01ns 0v, 35ns 0v,35.01ns 1v,40ns 1v,40.01ns 0v)
Va A 0 PWL(0ns 0v, 10ns 0v, 10.01ns 1v, 20ns 1v,20.01ns 0v,30ns 0v,30.01ns 1v,40ns 1v,40.01ns 0v)
Vcin cin 0 PWL(0ns 0v,20ns 0v, 20.01ns 1v, 40ns 1v, 40.01ns 0v)

  **  Analysis options  *
.tran 0.01n 40n
*.DC  Vdd 0.3 0.75 0.15
.measure tran pow avg power from=0ns to=40ns
.MEASURE TRAN delay1 TRIG V(A) VAL='supply/2' RISE=1 TARG V(sum) VAL='supply/2' FALL=1
.MEASURE TRAN delay2 TRIG V(A) VAL='supply/2' FALL=1 TARG V(sum) VAL='supply/2' RISE=1
.MEASURE TRAN delay3 TRIG V(A) VAL='supply/2' RISE=2 TARG V(sum) VAL='supply/2' FALL=2
.MEASURE TRAN d1 PARAM='max(delay1,delay2)'
.MEASURE TRAN tp1 PARAM='max(d1,delay3)'
.MEASURE TRAN delay4 TRIG V(B) VAL='supply/2' RISE=1 TARG V(sum) VAL='supply/2' FALL=1
.MEASURE TRAN delay5 TRIG V(B) VAL='supply/2' FALL=1 TARG V(sum) VAL='supply/2' RISE=1
.MEASURE TRAN delay6 TRIG V(B) VAL='supply/2' RISE=2 TARG V(sum) VAL='supply/2' FALL=2
.MEASURE TRAN d2 PARAM='max(delay4,delay5)'
.MEASURE TRAN tp2 PARAM='max(d2,delay6)'
**.MEASURE TRAN delay7 TRIG V(Cin) VAL='supply/2' RISE=1 TARG V(sum) VAL='supply/2' FALL=1
**.MEASURE TRAN delay8 TRIG V(cin) VAL='supply/2' FALL=1 TARG V(sum) VAL='supply/2' RISE=1
**.MEASURE TRAN delay9 TRIG V(cin) VAL='supply/2' RISE=2 TARG V(sum) VAL='supply/2' FALL=2
**.MEASURE TRAN d3 PARAM='max(delay7,delay8)'
**.MEASURE TRAN tp3 PARAM='max(d3,delay9)'
.MEASURE TRAN tp PARAM='max(tp1,tp2)'
**.MEASURE TRAN tp PARAM='max(tp4,tp3)'
.MEASURE TRAN pdp PARAM='tp*pow'

.end