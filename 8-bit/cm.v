module NAND(in1,in2,in3,out1);

output out1;
input in1,in2,in3;

assign out1 = ~(in1 & in2 & in3);

endmodule

module SR_latch (set,reset,Q,Q_dash);

input set,reset;
output Q,Q_dash;

NAND A1 (set,Q_dash,1'b1,Q);
NAND A2 (reset,Q,1'b1,Q_dash);

endmodule

module D_ff (D,clk,clear,Q,Qbar);

input D,clk,clear;
output Q,Qbar;

wire set,reset,sbar,rbar,clearbar;

NAND nand0(clear,clear,1'b1,clearbar);
NAND nand1(set,rbar,1'b1,sbar);
NAND nand2(sbar,clk,clearbar,set);	
NAND nand3(set,rbar,clk,reset);
NAND nand4(reset,D,clearbar,rbar);
NAND nand5(set,Qbar,1'b1,Q);
NAND nand6(reset,Q,clearbar,Qbar);

endmodule

module SIPO (D_in,clk,clear,D_out);

input D_in,clk,clear;
output [7:0] D_out;

D_ff D7(D_in,clk,clear,D_out[7],);
D_ff D6(D_out[7],clk,clear,D_out[6],);
D_ff D5(D_out[6],clk,clear,D_out[5],);
D_ff D4(D_out[5],clk,clear,D_out[4],);
D_ff D3(D_out[4],clk,clear,D_out[3],);
D_ff D2(D_out[3],clk,clear,D_out[2],);
D_ff D1(D_out[2],clk,clear,D_out[1],);
D_ff D0(D_out[1],clk,clear,D_out[0],);

endmodule

module bit_SISO(D_in,clk,clear,load,ctr,D_out,B_out);

input D_in,clk,clear,load,ctr;
output D_out,B_out;

wire  D,loadbar,in_1,in_2,out;

NAND not_load(load,load,1'b1,loadbar);
NAND Q_nand(D_in,loadbar,1'b1,in_1);
NAND D_nand(D_out,load,1'b1,in_2);
NAND in(in_1,in_2,1'b1,D);
D_ff ff(D,clk,clear,D_out,);
bufif0(B_out,D_out,ctr);

endmodule

module SISO (D_in,clk,clear,load,ctr,D_out,B_out);

input [7:0] D_in;
input clk,clear,load,ctr;
output [7:0] D_out;
output [7:0] B_out;

bit_SISO D7(D_in[7],clk,clear,load,ctr,D_out[7],B_out[7]);
bit_SISO D6(D_in[6],clk,clear,load,ctr,D_out[6],B_out[6]);
bit_SISO D5(D_in[5],clk,clear,load,ctr,D_out[5],B_out[5]);
bit_SISO D4(D_in[4],clk,clear,load,ctr,D_out[4],B_out[4]);
bit_SISO D3(D_in[3],clk,clear,load,ctr,D_out[3],B_out[3]);
bit_SISO D2(D_in[2],clk,clear,load,ctr,D_out[2],B_out[2]);
bit_SISO D1(D_in[1],clk,clear,load,ctr,D_out[1],B_out[1]);
bit_SISO D0(D_in[0],clk,clear,load,ctr,D_out[0],B_out[0]);

endmodule

module SISO_I (D_in,clk,clear,load,ctr,D_out,B_out);

input [7:0] D_in;
input clk,clear,load,ctr;
output [3:0] D_out;
output [3:0] B_out;

bit_SISO D7(D_in[7],clk,clear,load,ctr,D_out[3],);
bit_SISO D6(D_in[6],clk,clear,load,ctr,D_out[2],);
bit_SISO D5(D_in[5],clk,clear,load,ctr,D_out[1],);
bit_SISO D4(D_in[4],clk,clear,load,ctr,D_out[0],);
bit_SISO D3(D_in[3],clk,clear,load,ctr,,B_out[3]);
bit_SISO D2(D_in[2],clk,clear,load,ctr,,B_out[2]);
bit_SISO D1(D_in[1],clk,clear,load,ctr,,B_out[1]);
bit_SISO D0(D_in[0],clk,clear,load,ctr,,B_out[0]);

endmodule

module fulladder(A,B,c_in,Eout,sum,bsum,c_out);

input A,B,c_in,Eout;
output sum,c_out,bsum;

wire mid1,mid2,out1,out2,out3,ou4,cbar1,cbar2,sum1;

NAND xor1(A,B,1'b1,mid1);
NAND xor2(A,mid1,1'b1,out1);
NAND xor3(B,mid1,1'b1,out2);
NAND xor4(out1,out2,1'b1,sum1);

NAND and1(A,B,1'b1,cbar1);

NAND xor5(sum1,c_in,1'b1,mid2);
NAND xor6(sum1,mid2,1'b1,out3);
NAND xor7(c_in,mid2,1'b1,out4);
NAND xor8(out3,out4,1'b1,sum);

NAND and2(sum1,c_in,1'b1,cbar2);

NAND or1(cbar1,cbar2,1'b1,c_out);

bufif0(bsum,sum,Eout);

endmodule

module first_co(D,m,out);

input D,m;
output out;

wire mid,out1,out2;

NAND xor1(D,m,1'b1,mid);
NAND xor2(D,mid,1'b1,out1);
NAND xor3(m,mid,1'b1,out2);
NAND xor4(out1,out2,1'b1,out);

endmodule

module ALU(A,B,sub,Eout,sum,bsum,c_out);

input [7:0] A;
input [7:0] B;
input sub,Eout;
output [7:0] sum;
output [7:0] bsum;
output c_out;

wire [7:0] Bco;
wire c1,c2,c3,c4,c5,c6,c7;

first_co B7(B[7],sub,Bco[7]);
first_co B6(B[6],sub,Bco[6]);
first_co B5(B[5],sub,Bco[5]);
first_co B4(B[4],sub,Bco[4]);
first_co B3(B[3],sub,Bco[3]);
first_co B2(B[2],sub,Bco[2]);
first_co B1(B[1],sub,Bco[1]);
first_co B0(B[0],sub,Bco[0]);

fulladder A7(A[7],Bco[7],c7,Eout,sum[7],bsum[7],c_out);
fulladder A6(A[6],Bco[6],c6,Eout,sum[6],bsum[6],c7);
fulladder A5(A[5],Bco[5],c5,Eout,sum[5],bsum[5],c6);
fulladder A4(A[4],Bco[4],c4,Eout,sum[4],bsum[4],c5);
fulladder A3(A[3],Bco[3],c3,Eout,sum[3],bsum[3],c4);
fulladder A2(A[2],Bco[2],c2,Eout,sum[2],bsum[2],c3);
fulladder A1(A[1],Bco[1],c1,Eout,sum[1],bsum[1],c2);
fulladder A0(A[0],Bco[0],sub,Eout,sum[0],bsum[0],c1);

endmodule

module address(adr1,adr2,en,out);

input [3:0] adr1;
input [3:0] adr2;
input en;
output out;

wire [3:0] adr;
wire [3:0] adrbar;
wire bar,in1;

first_co xor3(adr1[3],adr2[3],adrbar[3]);
first_co xor2(adr1[2],adr2[2],adrbar[2]);
first_co xor1(adr1[1],adr2[1],adrbar[1]);
first_co xor0(adr1[0],adr2[0],adrbar[0]);

NAND not3(adrbar[3],adrbar[3],1'b1,adr[3]);
NAND not2(adrbar[2],adrbar[2],1'b1,adr[2]);
NAND not1(adrbar[1],adrbar[1],1'b1,adr[1]);
NAND not0(adrbar[0],adrbar[0],1'b1,adr[0]);

NAND nand1(adr[0],adr[1],adr[2],bar);
NAND nand2(bar,bar,1'b1,in1);
NAND nand3(in1,adr[3],en,out);

endmodule

module RAM_byte(D_in,clk,clear,we,oe,address1,address2,D_out);

input [7:0] D_in;

input [3:0] address1;
input [3:0] address2;

input clk,clear,we,oe;

output [7:0] D_out;

wire wout,oout,wbar;

address we_gate(address1,address2,we,wout);
address oe_gate(address1,address2,oe,oout);

SISO byte(D_in,clk,clear,wout,oout,,D_out);

endmodule

module multiplexer(in1,in2,m,out);

input in1,in2,m;
output out;

wire mbar,or1,or2;

NAND n1(m,m,1'b1,mbar);
NAND n2(in1,m,1'b1,or1);
NAND n3(in2,mbar,1'b1,or2);
NAND n4(or1,or2,1'b1,out);

endmodule

module RAM(D_in,prog_in,clk,clear,we,oe,prog,add,prog_add,D_out);

input [7:0] D_in;
input [7:0] prog_in;
input [3:0] add;
input [3:0] prog_add;
input clk,clear,we,oe,prog;
output [7:0] D_out;

wire [7:0] DL;
wire [3:0] AL;

wire wec;

multiplexer b7(prog_in[7],D_in[7],prog,DL[7]);
multiplexer b6(prog_in[6],D_in[6],prog,DL[6]);
multiplexer b5(prog_in[5],D_in[5],prog,DL[5]);
multiplexer b4(prog_in[4],D_in[4],prog,DL[4]);
multiplexer b3(prog_in[3],D_in[3],prog,DL[3]);
multiplexer b2(prog_in[2],D_in[2],prog,DL[2]);
multiplexer b1(prog_in[1],D_in[1],prog,DL[1]);
multiplexer b0(prog_in[0],D_in[0],prog,DL[0]);

multiplexer A3(prog_add[3],add[3],prog,AL[3]);
multiplexer A2(prog_add[2],add[2],prog,AL[2]);
multiplexer A1(prog_add[1],add[1],prog,AL[1]);
multiplexer A0(prog_add[0],add[0],prog,AL[0]);

multiplexer RI(1'b1,we,prog,wec);

RAM_byte rw15(DL,clk,clear,wec,oe,AL,4'b1111,D_out);
RAM_byte rw14(DL,clk,clear,wec,oe,AL,4'b1110,D_out);
RAM_byte rw13(DL,clk,clear,wec,oe,AL,4'b1101,D_out);
RAM_byte rw12(DL,clk,clear,wec,oe,AL,4'b1100,D_out);
RAM_byte rw11(DL,clk,clear,wec,oe,AL,4'b1011,D_out);
RAM_byte rw10(DL,clk,clear,wec,oe,AL,4'b1010,D_out);
RAM_byte rw09(DL,clk,clear,wec,oe,AL,4'b1001,D_out);
RAM_byte rw08(DL,clk,clear,wec,oe,AL,4'b1000,D_out);
RAM_byte rw07(DL,clk,clear,wec,oe,AL,4'b0111,D_out);
RAM_byte rw06(DL,clk,clear,wec,oe,AL,4'b0110,D_out);
RAM_byte rw05(DL,clk,clear,wec,oe,AL,4'b0101,D_out);
RAM_byte rw04(DL,clk,clear,wec,oe,AL,4'b0100,D_out);
RAM_byte rw03(DL,clk,clear,wec,oe,AL,4'b0011,D_out);
RAM_byte rw02(DL,clk,clear,wec,oe,AL,4'b0010,D_out);
RAM_byte rw01(DL,clk,clear,wec,oe,AL,4'b0001,D_out);
RAM_byte rw00(DL,clk,clear,wec,oe,AL,4'b0000,D_out);

endmodule

module counter(D_in,ce,co,load,clk,clear,out,B_out);

input [3:0] D_in;
input clk,clear,ce,co,load;
output [3:0] out;
output [3:0] B_out;

wire D0,D1,D2,D3,clk0,clk1,clk2,clk3,cebar,or1,or2,loadbar;
wire or0_1,or0_2,or1_1,or1_2,or2_1,or2_2,or3_1,or3_2;
wire [3:0] DL;

NAND n1(ce,ce,1'b1,cebar);
NAND n2(clk,ce,1'b1,or1);
NAND n3(1'b0,cebar,1'b1,or2);
NAND n4(or1,or2,1'b1,clk0);

NAND n31(load,load,1'b1,loadbar);
NAND n32(D3,load,1'b1,or3_1);
NAND n33(D_in[3],loadbar,1'b1,or3_2);
NAND n34(or3_1,or3_2,1'b1,DL[3]);

NAND n21(load,load,1'b1,loadbar);
NAND n22(D2,load,1'b1,or2_1);
NAND n23(D_in[2],loadbar,1'b1,or2_2);
NAND n24(or2_1,or2_2,1'b1,DL[2]);

NAND n11(load,load,1'b1,loadbar);
NAND n12(D1,load,1'b1,or1_1);
NAND n13(D_in[1],loadbar,1'b1,or1_2);
NAND n14(or1_1,or1_2,1'b1,DL[1]);

NAND n01(load,load,1'b1,loadbar);
NAND n02(D0,load,1'b1,or0_1);
NAND n03(D_in[0],loadbar,1'b1,or0_2);
NAND n04(or0_1,or0_2,1'b1,DL[0]);

D_ff c3(DL[3],DL[2],clear,out[3],D3);
D_ff c2(DL[2],DL[1],clear,out[2],D2);
D_ff c1(DL[1],DL[0],clear,out[1],D1);
D_ff c0(DL[0],clk0,clear,out[0],D0);

bufif0(B_out[3],out[3],co);
bufif0(B_out[2],out[2],co);
bufif0(B_out[1],out[1],co);
bufif0(B_out[0],out[0],co);

endmodule

module counterI(clk,clear,ce,out);

input clk,clear,ce;
output [2:0] out;

wire D0,D1,D2,clearbar,or1,or3,clr,clk0;

NAND n1(ce,ce,1'b1,cebar);
NAND n2(clk,ce,1'b1,or1);
NAND n3(1'b0,cebar,1'b1,or2);
NAND n4(or1,or2,1'b1,clk0);

D_ff c2(D2,D1,clr,out[2],D2);
D_ff c1(D1,D0,clr,out[1],D1);
D_ff c0(D0,clk0,clr,out[0],D0);

NAND not1(clear,clear,1'b1,clearbar);
NAND N1(out[0],D1,out[2],or3);
NAND N2(or3,clearbar,1'b1,clr);

endmodule

module control(in1,in2,in3,in4,in5,in6,in7,out);

input in1,in2,in3,in4,in5,in6,in7;
output out;

wire out1,out2,out3,out4;

NAND n1(in1,in2,in3,out1);
NAND n2(in4,in5,in6,out2);
NAND n3(out1,out1,1'b1,out3);
NAND n4(out2,out2,1'b1,out4);
NAND n5(in7,out3,out4,out);
//NAND n6(out5,out5,1'b1,out);

endmodule

module CPU(step,inst,AI,AO,BI,SU,EO,CE,CO,J,MI,RI,RO,II,IO,OI,hlt);

input [2:0] step;
input [3:0] inst;
output AI,AO,BI,SU,EO,CE,CO,J,MI,RI,RO,II,IO,OI,hlt;

wire [2:0] stepbar;
wire [3:0] instbar;

NAND not6(inst[3],inst[3],1'b1,instbar[3]);
NAND not5(inst[2],inst[2],1'b1,instbar[2]);
NAND not4(inst[1],inst[1],1'b1,instbar[1]);
NAND not3(inst[0],inst[0],1'b1,instbar[0]);
NAND not2(step[2],step[2],1'b1,stepbar[2]);
NAND not1(step[1],step[1],1'b1,stepbar[1]);
NAND not0(step[0],step[0],1'b1,stepbar[0]);

wire AI1,AI2;
control AIc1(instbar[3],instbar[2],instbar[1],inst[0],stepbar[2],step[1],step[0],AI1);
control AIc2(instbar[3],instbar[2],inst[1],1'b1,step[2],stepbar[1],stepbar[0],AI2);
NAND    AIc (AI1,AI2,1'b1,AI);

wire AO1;
control AOc1(inst[3],inst[2],inst[1],instbar[0],stepbar[2],step[1],stepbar[0],AO1);
NAND    AOc (AO1,AO1,1'b1,AO);

wire BI1;
control BIc1(instbar[3],instbar[2],inst[1],1'b1,stepbar[2],step[1],step[0],BI1);
NAND    BIc (BI1,BI1,1'b1,BI);

wire EO1;
control EOc1(instbar[3],instbar[2],inst[1],1'b1,step[2],stepbar[1],stepbar[0],EO1);
NAND    EOc (EO1,EO1,1'b1,EO);

wire OI1;
control OIc1(inst[3],inst[2],inst[1],instbar[0],stepbar[2],step[1],stepbar[0],OI1);
NAND    OIc (OI1,OI1,1'b1,OI);

wire CE1;
NAND CEc1(stepbar[2],stepbar[1],step[0],CE1);
NAND CEc (CE1,CE1,1'b1,CE);

wire CO1;
NAND COc1(stepbar[2],stepbar[1],stepbar[0],CO1);
NAND COc (CO1,CO1,1'b1,CO);

wire II1;
NAND IIc1(stepbar[2],stepbar[1],step[0],II1);
NAND IIc (II1,II1,1'b1,II);

wire IO1,IO2;
control IOc1(instbar[3],instbar[2],instbar[1],inst[0],stepbar[2],step[1],stepbar[0],IO1);
control IOc2(instbar[3],instbar[2],inst[1],1'b1,stepbar[2],step[1],stepbar[0],IO2);
NAND    IOc (IO1,IO2,1'b1,IO);

wire RO1,RO2,RO3;
NAND    ROc1(stepbar[2],stepbar[1],step[0],RO1);
control ROc2(instbar[3],instbar[2],instbar[1],inst[0],stepbar[2],step[1],step[0],RO2);
control ROc3(instbar[3],instbar[2],inst[1],1'b1,stepbar[2],step[1],step[0],RO3);
NAND    ROc (RO1,RO2,RO3,RO);

wire MI1,MI2,MI3;
NAND    MIc1(stepbar[2],stepbar[1],stepbar[0],MI1);
control MIc2(instbar[3],instbar[2],instbar[1],inst[0],stepbar[2],step[1],stepbar[0],MI2);
control MIc3(instbar[3],instbar[2],inst[1],1'b1,stepbar[2],step[1],stepbar[0],MI3);
NAND    MIc (MI1,MI2,MI3,MI);

wire SU1;
control SUc1(instbar[3],instbar[2],inst[1],inst[0],step[2],stepbar[1],stepbar[0],SU1);
NAND    SUc (SU1,SU1,1'b1,SU);

wire hlt1;
control hltc1(inst[3],inst[2],inst[1],inst[0],stepbar[2],step[1],stepbar[0],hlt1);
NAND    hltc (hlt1,hlt1,1'b1,hlt);

assign RI = 1'b0;
assign J  = 1'b0;

endmodule
