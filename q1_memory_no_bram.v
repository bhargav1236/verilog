//Read from memory and display
`timescale 1ns/1ps

module memory_module(clk);
wire [7:0] data;
wire [7:0] din;
wire [8:0] dout2;
reg [8:0] din2;
reg wea1,ena1; //created due to block ram ena:enablea to enable port wea:write enable to port
reg wea2,ena2;
reg [3:0]counter;
reg reset;
input clk; //no testbench here for this code
reg [7:0] register1; //declare an 8-byte memory
reg [7:0] register2; //declare an 8-byte memory

reg [2:0] address1; //3 bit address
reg [2:0] address2; //3 bit address
integer file1;
integer count=0;


blk_mem_gen_0 your_instance_name (
  .clka(clk),    // input wire clka
  .ena(ena1),      // input wire ena
  .wea(wea1),      // input wire [0 : 0] wea
  .addra(address1),  // input wire [2 : 0] addra
  .dina(din),    // input wire [7 : 0] dina
  .douta(data)  // output wire [7 : 0] douta
);

//vio_0 vio_instance (
//  .clk(clk),                // input wire clk
//  .probe_in0(din2),    // input wire [8 : 0] probe_in0
//  .probe_out0(reset)  // output wire [0 : 0] probe_out0
//);

ila_0 ila_instance (
	.clk(clk), // input wire clk


	.probe0(address1), // input wire [2:0]  probe0  
	.probe1(address2), // input wire [2:0]  probe1 
	.probe2(register1), // input wire [7:0]  probe2 
	.probe3(register2), // input wire [7:0]  probe3 
	.probe4(data), // input wire [7:0]  probe4 
	.probe5(din2), // input wire [8:0]  probe5 
	.probe6(dout2), // input wire [8:0]  probe6
	.probe7(counter) // input wire [3:0]  probe7

);

blk_mem_gen_1 blk_instance_2 (
  .clka(clk),    // input wire clka
  .ena(ena2),      // input wire ena
  .wea(wea2),      // input wire [0 : 0] wea
  .addra(address2),  // input wire [2 : 0] addr
  .dina(din2),    // input wire [8 : 0] dina
  .douta(dout2)  // output wire [8 : 0] douta
);

//initial begin
//reset=1;
//#10;
//reset=0;
//end

initial
begin
ena1=1;
wea1=0; //read only
ena2=1;
wea2=1; //write
//clk=0;
address1=3'b000;
address2=3'b000;
reset=0;
counter=4'b0000;
//read memory file init.dat. address locations given in memory starting with @
//$readmemb("init.dat", memory);
//file1=$fopen("output.txt");


//$dumpfile ("mem_out.vcd"); 
//$dumpvars(0,memory_module);

end
//always
//#5 clk=~clk;

always@(posedge clk)
begin
counter=counter+1;
end
always@(posedge counter[3])
count<=count+1;
always @(posedge counter[3])
begin
if(count%3==0)
begin
	register1<=data;
	address1<=address1+3'b001;
end
	//$display("Memory [%0d] = %b", address, data);
	//address=address+3'b001;
end

always @(posedge counter[3])
begin
if(count%3==1)

register2<=data;
	//address2=address2+3'b001;
end

always @(posedge counter[3])
begin
if(count%3==2)
begin
    din2<=register1+register2;
	address2<=address2+3'b001;
	end
end
//$fdisplay(file1,"Memory [%0d] = %b", address,data);
//$fclose(file1);
//initial #800 $finish;
endmodule


