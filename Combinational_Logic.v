/**
 * Combinational Logic - Part 2
 * Group Memebers: Anon Laosirilurchakai, Peter Glass, Brianne Mclemore, Grayson Ayres, Marco Myers
 * 
 * Description: Our project for this semester is to create an arithmetic logic unit (ALU) using a 
 * virtual hardware design language. The ALU will be capable of doing math functions (add, subtract, 
 * multiply, divide, modulus), logic functions (and, or, xor, not, nand, nor, xnor), support functions 
 * (no operation, shift left, shift right, reset, clear) and be able to catch errors (divide by zero, 
 * overflow). The ALU will also have the additional ability to store the first and second inputs, 
 * store the result of an operation and use the result of an operation as an input. The ALU will 
 * accept up to a 16-bit integer as input and the output will support 32-bits.
 *
 * Module List: Half Adder, Full Adder, Subtractor, Multiplier, Multiplexor, Left Arbiter, Right
 * Arbiter, Encoder, Decoder
 *
 * The software used to compile this program is Icarus Verilog for Windows v11
 * Source: http://bleyer.org/icarus/
**/

//=============================================
// Decoder: 4 bit to 16 hot bit
//=============================================
module DEC(in, out); 
	input [3:0] in;
	output [15:0] out;
	wire [15:0] out;
	and(out[0], ~in[3], ~in[2], ~in[1], ~in[0]);
	and(out[1], ~in[3], ~in[2], ~in[1], in[0]);
	and(out[2], ~in[3], ~in[2], in[1], ~in[0]);
	and(out[3], ~in[3], ~in[2], in[1], in[0]);
	and(out[4], ~in[3], in[2], ~in[1], ~in[0]);
	and(out[5], ~in[3], in[2], ~in[1], in[0]);
	and(out[6], ~in[3], in[2], in[1], ~in[0]);
	and(out[7], ~in[3], in[2], in[1], in[0]);
	and(out[8], in[3], ~in[2], ~in[1], ~in[0]);
	and(out[9], in[3], ~in[2], ~in[1], in[0]);
	and(out[10], in[3], ~in[2], in[1], ~in[0]);
	and(out[11], in[3], ~in[2], in[1], in[0]);
	and(out[12], in[3], in[2], ~in[1], ~in[0]);
	and(out[13], in[3], in[2], ~in[1], in[0]);
	and(out[14], in[3], in[2], in[1], ~in[0]);
	and(out[15], in[3], in[2], in[1], in[0]);
 endmodule
 
//=============================================
// Encoder: 16 hot bit to 4 bit
//=============================================
module ENC(in, out);
	input [15:0] in;
	output [3:0] out;
	wire [3:0] out;
	or(out[0], in[1], in[3], in[5], in[7], in[9], in[11], in[13], in[15]);
	or(out[1], in[2], in[3], in[6], in[7], in[10], in[11], in[14], in[15]);
	or(out[2], in[4], in[5], in[6], in[7], in[12], in[13], in[14], in[15]);
	or(out[3], in[8], in[9], in[10], in[11], in[12], in[13], in[14], in[15]);
endmodule

//=============================================
// Right Arbitrer: 16 bit to 16 hot bit 
// Base Code Source: Dally, WIlliam J., Harting, 
// Curtis, R. DIgital Design, A Systems Approach, 
// Cambridge, Cambridge University Press, 2012
//=============================================
module RArb(r, g);
  input  [15:0] r ;
  output [15:0] g ;
  wire   [15:0] c = {(~r[14:0] & c[14:0]),1'b1} ;
  assign g = r & c ;
endmodule

//=============================================
// Left Arbitrer: 16 bit to 16 hot bit 
// Base Code Source: Dally, WIlliam J., Harting, 
// Curtis, R. DIgital Design, A Systems Approach, 
// Cambridge, Cambridge University Press, 2012
//=============================================
module LArb(r, g);
  input  [15:0] r ;
  output [15:0] g ;
  wire   [15:0] c = {1'b1,(~r[15:1] & c[15:1])} ;
  assign g = r & c ;
endmodule

module testbench();

	reg [3:0] dIn;
	reg [15:0] eIn, laIn, raIn;
	wire [15:0] dOut, laOut, raOut;
	wire [3:0] eOut;
	
	DEC decoder(dIn, dOut);
	ENC encoder(eIn, eOut);
	RArb rarb(raIn, raOut);
	LArb larb(laIn, laOut);
	
	initial begin
		dIn = 4'b0011;
		eIn = 16'b0010000000000000;
		laIn = 16'b0001010101010101;
		raIn = 16'b1001100100111100;
		#10;
		$display("Decoder:\nInput: %b\nOutput: %b\n", dIn, dOut);
		$display("Encoder:\nInput: %b\nOutput: %b\n", eIn, eOut);
		$display("Right Arbiter:\nInput: %b\nOutput: %b\n", raIn, raOut);
		$display("Left Arbiter:\nInput: %b\nOutput: %b", laIn, laOut);
	end
endmodule
