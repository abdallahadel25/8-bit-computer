module BUS();

wire [7:0] Bus;
reg clk = 1'b0,clr = 1'b0;

wire AI,AO,BI,SU,EO,CE,CO,J,MI,RI,RO,II,IO,OI,hlt;

//reg AI = 1'b0,AO = 1'b0,BI = 1'b0;
wire [7:0] Aout,Bout;
SISO A_reg(Bus,clk,clr,~AI,~AO,Aout,Bus);
SISO B_reg(Bus,clk,clr,~BI,1'b1,Bout,Bus);

//reg SU = 1'b0,EO = 1'b0;
wire CF;
ALU CALU(Aout,Bout,SU,~EO,,Bus,CF);

//reg CE = 1'b0,CO = 1'b0,J = 1'b0;
counter ProgramCounter(Bus[3:0],CE,~CO,~J,clk,clr,,Bus[3:0]);

//reg MI = 1'b0;
wire [7:0] Addr;
SISO MAR(Bus,clk,clr,~MI,1'b0,Addr,);

//reg RI = 1'b0,RO = 1'b0;
reg PR = 1'b0;
reg [7:0] Prog;
reg [3:0] AddrM;
RAM MEM(Bus,Prog,clk,clr,RI,RO,PR,Addr[3:0],AddrM,Bus);

//reg II = 1'b0,IO = 1'b0;
wire [3:0] CPUin;
SISO_I Inestruction(Bus,clk,clr,~II,~IO,CPUin,Bus[3:0]);

reg IC = 1'b0;
wire [2:0] count;
counterI InstructionCounter(~clk,clr,IC,count);

wire [7:0] CMout;
SISO Output_reg(Bus,clk,clr,~OI,1'b0,CMout,);

CPU CMCPU(count,CPUin,AI,AO,BI,SU,EO,CE,CO,J,MI,RI,RO,II,IO,OI,hlt);

always #5 clk=~clk;
always@(posedge hlt) $finish;


initial
begin

//$monitor("OUTPUT = %8b CPU = %4b%3b %14b",Bus,CPUin,count,AI,AO,BI,SU,EO,CE,CO,J,MI,RI,RO,II,IO,OI);

clr = 1'b1; #10 clr=1'b0;

PR = 1'b1; #10
AddrM = 4'b0000; Prog = 8'b0001_1110; #10
AddrM = 4'b0001; Prog = 8'b0010_1111; #10
AddrM = 4'b0010; Prog = 8'b1110_0000; #10
AddrM = 4'b0011; Prog = 8'b1111_0000; #10
AddrM = 4'b1110; Prog = 8'b0000_1111; #10
AddrM = 4'b1111; Prog = 8'b0000_1011; #10
PR = 1'b0; #10

IC = 1'b1;

$monitor("OUTPUT = %8b",CMout);

/*CO = 1'b1; MI = 1'b1; #10 CO = 1'b0; MI = 1'b0;
RO = 1'b1; II = 1'b1; #10 RO = 1'b0; II = 1'b0;
CE = 1'b1; #10 CE = 1'b0;

IO = 1'b1; MI = 1'b1; #10 IO = 1'b0; MI = 1'b0;
RO = 1'b1; AI = 1'b1; #10 RO = 1'b0; AI = 1'b0;

CO = 1'b1; MI = 1'b1; #10 CO = 1'b0; MI = 1'b0;
RO = 1'b1; II = 1'b1; #10 RO = 1'b0; II = 1'b0;
CE = 1'b1; #10 CE = 1'b0;

IO = 1'b1; MI = 1'b1; #10 IO = 1'b0; MI = 1'b0;
RO = 1'b1; BI = 1'b1; #10 RO = 1'b0; BI = 1'b0;
EO = 1'b1; AI = 1'b1; #10 EO = 1'b0; AI = 1'b0;

AO = 1'b1; #10 AO = 1'b0;*/

end
endmodule
