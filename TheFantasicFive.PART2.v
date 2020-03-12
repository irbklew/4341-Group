/**
 * Combinational Logic - Part 2
 * Group Memebers: Anon Laosirilurchakai, Peter Glass, Brianne Mclemore, Grayson Ayres, Marco Myers, Alex Ni
 * 
 * Description: Our project for this semester is to create an arithmetic logic unit (ALU) using a virtual 
 * hardware design language. The ALU will be capable of doing math functions (add, subtract, multiply, divide, 
 * modulus), logic functions (and, or, xor, not, nand, nor, xnor), support functions (no operation, shift left, 
 * shift right, reset, clear) and be able to catch errors (divide by zero, overflow). The ALU will also have 
 * the additional ability to store the first and second inputs, store the result of an operation and use the 
 * result of an operation as an input. The ALU will accept up to a 16-bit integer as input and the output will 
 * support 32-bits.
 *
 * Module List: Half Adder, Full Adder, Adder/Subtractor, Multiplier, Multiplexor, Left Arbiter, RightArbiter, 
 * Encoder, Decoder
 *
 * The software used to compile this program is Icarus Verilog for Windows v11
 * Source: http://bleyer.org/icarus/
**/

//=============================================
// and16: 16 bit to 16 bit AND gate
//=============================================
module and16 (a, b, f);
	input [15:0] a, b;
	output [15:0] f;
	assign f = a & b;
endmodule

//=============================================
// or16: 16 bit to 16 bit OR gate
//=============================================
module or16 (a, b, f);
	input [15:0] a, b;
	output [15:0] f;
	assign f = a | b;
endmodule

//=============================================
// xor16: 16 bit to 16 bit XOR gate
//=============================================
module xor16 (a, b, f);
	input [15:0] a, b;
	output [15:0] f;
	assign f = a ^ b;
endmodule

//=============================================
// xnor16: 16 bit to 16 bit XNOR gate
//=============================================
module xnor16 (a, b, f);
	input [15:0] a, b;
	output [15:0] f;
	assign f = ~(a ^ b);
endmodule

//=============================================
// nand16: 16 bit to 16 bit NAND gate
//=============================================
module nand16 (a, b, f);
	input [15:0] a, b;
	output [15:0] f;
	assign f = ~(a & b);
endmodule

//=============================================
// not16: 16 bit to 16 bit NOT gate
//=============================================
module not16 (a, f);
	input [15:0] a;
	output [15:0] f;
	assign f = ~a;
endmodule

//=============================================
// nor16: 16 bit to 16 bit NOR gate
//=============================================
module nor16 (a, b, f);
	input [15:0] a, b;
	output [15:0] f;
	assign f = ~(a | b);
endmodule

//=============================================
// Mux8: 8 channel, 16 bit multiplexer
//=============================================
module Mux8(a7, a6, a5, a4, a3, a2, a1, a0, s, b) ;
  parameter k = 16; //channel bit size
  input [k-1:0] a7, a6, a5, a4, a3, a2, a1, a0;
  input [7:0] s; //one-hot select
  output[k-1:0] b;
  assign b = 	({k{s[7]}} & a7) |
		({k{s[6]}} & a6) |
		({k{s[5]}} & a5) |
		({k{s[4]}} & a4) |
		({k{s[3]}} & a3) |
		({k{s[2]}} & a2) | 
                ({k{s[1]}} & a1) |
                ({k{s[0]}} & a0);
endmodule

//=============================================
// Dec16: 4 bit to 16 hot bit decoder
//=============================================
module Dec16(a,b);
   input  [3:0] a;
   output [15:0] b;
   assign b = 1<<a;
endmodule
 
//=============================================
// Enc16: 16 hot bit to 4 bit encoder
//=============================================
module Enc16(a, b);
	input [15:0] a;
	output [3:0] b;
	assign b = {a[8] | a[9] | a[10] | a[11] | a[12] | a[13] | a[14] | a[15],
		    a[4] | a[5] | a[6]  | a[7]  | a[12] | a[13] | a[14] | a[15],
		    a[2] | a[3] | a[6]  | a[7]  | a[10] | a[11] | a[14] | a[15],
		    a[1] | a[3] | a[5]  | a[7]  | a[9]  | a[11] | a[13] | a[15]}; 
endmodule

//=============================================
// RArb16: 16 bit to 16 hot bit right arbiter
//=============================================
module RArb16(r, g);
  input  [15:0] r ;
  output [15:0] g ;
  wire   [15:0] c = {(~r[14:0] & c[14:0]),1'b1} ;
  assign g = r & c ;
endmodule

//=============================================
// LArb16: 16 bit to 16 hot bit left arbiter
//=============================================
module LArb16(r, g);
  input  [15:0] r ;
  output [15:0] g ;
  wire   [15:0] c = {1'b1,(~r[15:1] & c[15:1])} ;
  assign g = r & c ;
endmodule

//======================================================================
//HAdder: 1 bit half adder
//======================================================================
module HAdder (S, C, x, y);
	input x,y;
	output S,C;//Sum, Carry
	xor (S, x, y);
	and (C, x, y);
endmodule

//======================================================================
//FAdder: 1 bit Full adder
//======================================================================
module FAdder(S, C, x, y, z);
	input x, y, z;
	output S, C;
	wire S1, C1, C2;
	// instantiate half adders
	HAdder HA1 (S1, C1, x, y);
	HAdder HA2 (S, C2, S1, z);
	//Combine half adders
	or (C, C2, C1); 
endmodule

//======================================================================
//AddSub16: 16 bit to 32 bit adder and subtractor
//======================================================================
module AddSub16(S,C,V,A,B,M);
	output [31: 0] S;
	output C;
	output V;
	input [15: 0] A, B;
	input M;
	wire [15: 0] Sum;
	wire [15: 0] B_xor_M;
	wire C1, C2, C3, C4, C5, C6, C7, C8, C9, C10, C11, C12, C13, C14, C15, C16;

	assign C = C16; //output carry

	//Flip the Bit
	xor (B_xor_M[0], B[0], M);
	xor (B_xor_M[1], B[1], M);
	xor (B_xor_M[2], B[2], M);
	xor (B_xor_M[3], B[3], M);
	xor (B_xor_M[4], B[4], M);
	xor (B_xor_M[5], B[5], M);
	xor (B_xor_M[6], B[6], M);
	xor (B_xor_M[7], B[7], M);
	xor (B_xor_M[8], B[8], M);
	xor (B_xor_M[9], B[9], M);
	xor (B_xor_M[10], B[10], M);
	xor (B_xor_M[11], B[11], M);
	xor (B_xor_M[12], B[12], M);
	xor (B_xor_M[13], B[13], M);
	xor (B_xor_M[14], B[14], M);
	xor (B_xor_M[15], B[15], M);

	FAdder FA0 (S[0], C1, A[0], B_xor_M[0], M);
	FAdder FA1 (S[1], C2, A[1], B_xor_M[1], C1);
	FAdder FA2 (S[2], C3, A[2], B_xor_M[2], C2);
	FAdder FA3 (S[3], C4, A[3], B_xor_M[3], C3);
	FAdder FA4 (S[4], C5, A[4], B_xor_M[4], C4);
	FAdder FA5 (S[5], C6, A[5], B_xor_M[5], C5);
	FAdder FA6 (S[6], C7, A[6], B_xor_M[6], C6);
	FAdder FA7 (S[7], C8, A[7], B_xor_M[7], C7);
	FAdder FA8 (S[8], C9, A[8], B_xor_M[8], C8);
	FAdder FA9 (S[9], C10, A[9], B_xor_M[9], C9);
	FAdder F10 (S[10], C11, A[10], B_xor_M[10], C10);
	FAdder FA11 (S[11], C12, A[11], B_xor_M[11], C11);
	FAdder FA12 (S[12], C13, A[12], B_xor_M[12], C12);
	FAdder FA13 (S[13], C14, A[13], B_xor_M[13], C13);
	FAdder FA14 (S[14], C15, A[14], B_xor_M[14], C14);
	FAdder FA15 (S[15], C16, A[15], B_xor_M[15], C15);

	xor(V, C16, C15); //overflow detector

	//sign extension
	and(S[16], S[15], 1);
	and(S[17], S[15], 1);
	and(S[18], S[15], 1);
	and(S[19], S[15], 1);
	and(S[20], S[15], 1);
	and(S[21], S[15], 1);
	and(S[22], S[15], 1);
	and(S[23], S[15], 1);
	and(S[24], S[15], 1);
	and(S[25], S[15], 1);
	and(S[26], S[15], 1);
	and(S[27], S[15], 1);
	and(S[28], S[15], 1);
	and(S[29], S[15], 1);
	and(S[30], S[15], 1);
	and(S[31], S[15], 1);
endmodule


//======================================================================
//Add16: 16 bit to 16 bit adder
//======================================================================
module Add16(a,b,cin,cout,s);
	parameter n = 16; 
	input [n-1:0] a, b; 
	input cin ;
	output [n-1:0] s; 
	output cout ;
	wire [n-1:0] p = a ^b; //propagate
	wire [n-1:0] g = a & b ; //generate
	wire [n:0] c = {g | (p & c[n-1:0]), cin} ; //carry = g | p & c
	assign s = p ^ c[n-1:0]; //sum
	assign cout = c[n]; 
endmodule

//======================================================================
//Multi16: 16 bit to 32 bit multiplier
//======================================================================
module Multi16(a,b,p); 
	input [15:0] a,b; 
	output [31:0] p;

	//form partial products
	wire [15:0] pp0 = a & {16{b[0]}} ; //x1 
	wire [15:0] pp1 = a & {16{b[1]}} ; //x2 
	wire [15:0] pp2 = a & {16{b[2]}} ; //x4
	wire [15:0] pp3 = a & {16{b[3]}} ; //x8
	wire [15:0] pp4 = a & {16{b[4]}} ;
	wire [15:0] pp5 = a & {16{b[5]}} ;
	wire [15:0] pp6 = a & {16{b[6]}} ;
	wire [15:0] pp7 = a & {16{b[7]}} ;
	wire [15:0] pp8 = a & {16{b[8]}} ;
	wire [15:0] pp9 = a & {16{b[9]}} ;
	wire [15:0] pp10 = a & {16{b[10]}} ;
	wire [15:0] pp11 = a & {16{b[11]}} ;
	wire [15:0] pp12 = a & {16{b[12]}} ;
	wire [15:0] pp13 = a & {16{b[13]}} ;
	wire [15:0] pp14 = a & {16{b[14]}} ;
	wire [15:0] pp15 = a & {16{b[15]}} ;

	//sum up partial products
	wire cout1, cout2, cout3, cout4, cout5, cout6, cout7, cout8, cout9, cout10, cout11, cout12, cout13, cout14;
	wire [15:0] s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15;

	Add16 a1(pp1, {1'b0,pp0[15:1]}, 1'b0, cout1, s1); 
	Add16 a2(pp1, {cout1, s1[15:1]}, 1'b0, cout2, s2);
	Add16 a3(pp2, {cout2, s2[15:1]}, 1'b0, cout3, s3);
	Add16 a4(pp3, {cout3, s3[15:1]}, 1'b0, cout4, s4);
	Add16 a5(pp4, {cout4, s4[15:1]}, 1'b0, cout5, s5);
	Add16 a6(pp5, {cout5, s5[15:1]}, 1'b0, cout6, s6);
	Add16 a7(pp6, {cout6, s6[15:1]}, 1'b0, cout7, s7);
	Add16 a8(pp7, {cout7, s7[15:1]}, 1'b0, cout8, s8);
	Add16 a9(pp8, {cout8, s8[15:1]}, 1'b0, cout9, s9);
	Add16 a10(pp9, {cout9, s9[15:1]}, 1'b0, cout10, s10);
	Add16 a11(pp10, {cout10, s10[15:1]}, 1'b0, cout11, s11);
	Add16 a12(pp11, {cout11, s11[15:1]}, 1'b0, cout12, s12);
	Add16 a13(pp12, {cout12, s12[15:1]}, 1'b0, cout13, s13);
	Add16 a14(pp13, {cout13, s13[15:1]}, 1'b0, cout14, s14);
	Add16 a15(pp14, {cout14, s14[15:1]}, 1'b0, cout15, s15);
	
	//collect the result
	assign p = {cout15, s15, s14[0], s13[0], s12[0], s11[0], s10[0], s9[0], s8[0], s7[0], s6[0], s5[0], s4[0], s3[0], s2[0], s1[0], pp0[0]}; 
endmodule

module testbench();

	reg [3:0] decIn;
	reg [7:0] selcIn;
	reg [15:0] encIn, rarbIn, larbIn, bool1In, bool2In;
	wire [3:0] encOut;
	wire [15:0] decOut, rarbOut, larbOut, andOut, orOut, notOut, xorOut, xnorOut, nandOut, norOut, muxOut;
	
	reg [15: 0] A, B, A1, B1;
	reg [15:0] A2, B2;
	reg M; // mode for add or subtract
	wire [31: 0] S, P, Q;
	wire C; // carry for subtractor
	wire V; // overflow detection

	AddSub16 k1(S, C, V, A, B, M);
	Multi16 m2(A2, B2, Q);
	
	and16 and16(bool1In, bool2In, andOut);
	or16 or16(bool1In, bool2In, orOut);
	not16 not16(bool1In, notOut);
	xor16 xor16(bool1In, bool2In, xorOut);
	xnor16 xnor16(bool1In, bool2In, xnorOut);
	nand16 nand16(bool1In, bool2In, nandOut);
	nor16 nor16(bool1In, bool2In, norOut);
	Dec16 decoder(decIn, decOut);
	Enc16 encoder(encIn, encOut);
	RArb16 rarb(rarbIn, rarbOut);
	LArb16 larb(larbIn, larbOut);
	Mux8 mux8(encIn, larbIn, rarbIn, bool1In, bool2In, encIn, larbIn, rarbIn, selcIn, muxOut);
	
	initial begin
		decIn = 4'b0011;
		encIn = 16'b0010000000000000;
		larbIn = 16'b0001010101010101;
		rarbIn = 16'b1001100100111100;
		bool1In = 16'b1101010010100010;
		bool2In = 16'b0100101001010111;
		selcIn = 8'b00001000;
		#10;
		$display("And:\nInput 1: %b\nInput 2: %b\nOutput:  %b\n", bool1In, bool2In, andOut);
		$display("Or:\nInput 1: %b\nInput 2: %b\nOutput:  %b\n", bool1In, bool2In, orOut);
		$display("Not:\nInput:  %b\nOutput: %b\n", bool1In, notOut);
		$display("Xor:\nInput 1: %b\nInput 2: %b\nOutput:  %b\n", bool1In, bool2In, xorOut);
		$display("Xnor:\nInput 1: %b\nInput 2: %b\nOutput:  %b\n", bool1In, bool2In, xnorOut);
		$display("Nand:\nInput 1: %b\nInput 2: %b\nOutput:  %b\n", bool1In, bool2In, nandOut);
		$display("Nor:\nInput 1: %b\nInput 2: %b\nOutput:  %b\n", bool1In, bool2In, norOut);
		$display("Decoder:\nInput:  %b\nOutput: %b\n", decIn, decOut);
		$display("Encoder:\nInput:  %b\nOutput: %b\n", encIn, encOut);
		$display("Right Arbiter:\nInput:  %b\nOutput: %b\n", rarbIn, rarbOut);
		$display("Left Arbiter:\nInput:  %b\nOutput: %b\n", larbIn, larbOut);
		$display("Multiplexor:\nChannel 8: %b\nChannel 7: %b\nChannel 6: %b\nChannel 5: %b\nChannel 4: %b\nChannel 3: %b\nChannel 2: %b\nChannel 1: %b\nSelection: %b\nOutput: %b\n", 
				encIn, larbIn, rarbIn, bool1In, bool2In, encIn, larbIn, rarbIn, selcIn, muxOut);
		
		$display("=============================================================================");
		#10 A2 = 16'hA;
		#10 B2 = 16'hA;
		#10
		$display("Multiply Test: ");
		$display("A                B                  Product");
		$display("%b %b   %b", A2, B2, Q);
		$display("=============================================================================");
		$display("Addition Test: ");
		$display("A                B                M Sum                           overflow");
		#10 M = 0;
		#10 A = 16'h20;
		#10 B = 16'h20;
		#10
		$display("%b %b %b %b %b",A,B,M,S,V);
		$display("=============================================================================");
		#10
		$display("Subtraction: ");
		$display("A                B                M difference");
		#10 M = 1;
		#10 A = 16'h20;
		#10 B = 16'hAA;
		#10
		$display("%b %b %b %b",A,B,M,S);
		$display("=============================================================================");
	end
endmodule


// Base Code Source: Dally, WIlliam J., Harting, Curtis, R. DIgital Design, A Systems Approach, 
// Cambridge, Cambridge University Press, 2012
