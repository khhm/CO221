module ALU4_tb;

  reg [3:0] a, b;
  reg cin;
  reg [2:0] op;
  reg cout;
  wire [7:0] out; 
  wire [3:0] compA;
  wire [3:0] compB;
  wire [3:0] bwor;
  wire [3:0] bwand;
  wire [3:0] bwxor;
  wire [3:0] bitadd;
  wire [3:0] bitsub;
  wire [7:0] mul;
   initial
     begin
        $dumpfile("ALU.vcd");
        $dumpvars(0, ALU01);
               $display("___________________________________");
		$display("| Op  |  A   |  B     |   output  |");
               $display("___________________________________");
        $monitor("| %b | %b | %b   |  %b |", op,a, b, out);
		
        #0 	op= 3'b000; a = 4'b0000; b = 4'b0000;cin = 1'b0;
		#50 op= 3'b000; a = 4'b0001; b = 4'b0001;cin = 1'b0;
		#50 op= 3'b000; a = 4'b0010; b = 4'b0010;cin = 1'b0;
		#50 op= 3'b000; a = 4'b0011; b = 4'b0011;cin = 1'b0;
		#50 op= 3'b001; a = 4'b0100; b = 4'b0010;cin = 1'b0;
		#50 op= 3'b001; a = 4'b0101; b = 4'b1001;cin = 1'b0;
		#50 op= 3'b001; a = 4'b0110; b = 4'b0110;cin = 1'b0;
		#50 op= 3'b010; a = 4'b0101; b = 4'b0111;cin = 1'b0;
		#50 op= 3'b010; a = 4'b1010; b = 4'b1001;cin = 1'b0;
		#50 op= 3'b011; a = 4'b1110; b = 4'b0011;cin = 1'b0;
		#50 op= 3'b011; a = 4'b1010; b = 4'b0111;cin = 1'b0;
		#50 op= 3'b100; a = 4'b1000; b = 4'b0010;cin = 1'b0;
		#50 op= 3'b100; a = 4'b0011; b = 4'b0011;cin = 1'b0;
		#50 op= 3'b101; a = 4'b0110; b = 4'b0010;cin = 1'b0;
		#50 op= 3'b101; a = 4'b0011; b = 4'b0111;cin = 1'b0;
		#50 op= 3'b101; a = 4'b0010; b = 4'b1000;cin = 1'b0;
                #50 op= 3'b110; a = 4'b0011; b = 4'b0111;cin = 1'b0;
		#50 op= 3'b110; a = 4'b1010; b = 4'b0111;cin = 1'b0;
                #50 op= 3'b111; a = 4'b0011; b = 4'b0111;cin = 1'b0;
		#50 op= 3'b111; a = 4'b1010; b = 4'b0111;cin = 1'b0;
        #50 $display("___________________________________");
            $finish;
     end

   ALU_4bit ALU01(a,b,cin,op,cout,out);

endmodule

module ALU_4bit(a,b,cin,op,cout,out);

	input [3:0] a,b;
	input cin;
	input cout;
	input [2:0] op;
	
	output [7:0] out;
        input [3:0] compA;
        input [3:0] compB;
        input [3:0] bwand;
        input [3:0] bwor;
        input [3:0] bwxor;
        input [3:0] bitadd;
        input [3:0] bitsub;
        input [7:0] mul;

        comp2sA cA(a,compA);
        comp2sB cB(b,compB);
        BitAdder badd(a,b,cin,bitadd,cout);
        BitSubtracter bsub(a,b,cin,bitsub,cout);
	bwOR bo(a,b,bwor);
        bwAND ba(a,b,bwand);
        bwXOR bx(a,b,bwxor);
        mult  mu(a,b,mul);

        wire op0n,op1n,op2n;
        wire [7:0] y0,y1,y2,y3,y4,y5,y6,y7;
        not(op0n,op[0]);
        not(op1n,op[1]);
        not(op2n,op[2]);

        and (y0[0],compA[0] , op2n  ,op1n  ,op0n);
	and (y1[0],compB[0] , op2n  ,op1n  ,op[0]);
	and (y2[0],bitadd[0], op2n  ,op[1] ,op0n);
	and (y3[0],bitsub[0] , op2n  ,op[1] ,op[0]);
	and (y4[0],bwand[0] , op[2] ,op1n  ,op0n);
	and (y5[0],bwor[0] , op[2] ,op1n  ,op[0]);
	and (y6[0],bwxor[0] , op[2] ,op[1] ,op0n);
	and (y7[0],mul[0] , op[2] ,op[1] ,op[0]);
	or (out[0], y0[0], y1[0], y2[0], y3[0], y4[0], y5[0], y6[0], y7[0]);
        
        and (y0[1],compA[1] , op2n  ,op1n  ,op0n);
	and (y1[1],compB[1] , op2n  ,op1n  ,op[0]);
	and (y2[1],bitadd[1], op2n  ,op[1] ,op0n);
	and (y3[1],bitsub[1] , op2n  ,op[1] ,op[0]);
	and (y4[1],bwand[1] , op[2] ,op1n  ,op0n);
	and (y5[1],bwor[1] , op[2] ,op1n  ,op[0]);
	and (y6[1],bwxor[1] , op[2] ,op[1] ,op0n);
	and (y7[1],mul[1] , op[2] ,op[1] ,op[0]);
	or (out[1], y0[1], y1[1], y2[1], y3[1], y4[1], y5[1], y6[1], y7[1]);

        and (y0[2],compA[2] , op2n  ,op1n  ,op0n);
	and (y1[2],compB[2] , op2n  ,op1n  ,op[0]);
	and (y2[2],bitadd[2], op2n  ,op[1] ,op0n);
	and (y3[2],bitsub[2] , op2n  ,op[1] ,op[0]);
	and (y4[2],bwand[2] , op[2] ,op1n  ,op0n);
	and (y5[2],bwor[2] , op[2] ,op1n  ,op[0]);
	and (y6[2],bwxor[2] , op[2] ,op[1] ,op0n);
	and (y7[2],mul[2] , op[2] ,op[1] ,op[0]);
	or (out[2], y0[2], y1[2], y2[2], y3[2], y4[2], y5[2], y6[2], y7[2]);
      
        and (y0[3],compA[3] , op2n  ,op1n  ,op0n);
	and (y1[3],compB[3] , op2n  ,op1n  ,op[0]);
	and (y2[3],bitadd[3], op2n  ,op[1] ,op0n);
	and (y3[3],bitsub[3] , op2n  ,op[1] ,op[0]);
	and (y4[3],bwand[3] , op[2] ,op1n  ,op0n);
	and (y5[3],bwor[3] , op[2] ,op1n  ,op[0]);
	and (y6[3],bwxor[3] , op[2] ,op[1] ,op0n);
	and (y7[3],mul[3] , op[2] ,op[1] ,op[0]);
	or (out[3], y0[3], y1[3], y2[3], y3[3], y4[3], y5[3], y6[3], y7[3]);

        and (y0[4],1'b0 , op2n  ,op1n  ,op0n);
	and (y1[4],1'b0, op2n  ,op1n  ,op[0]);
	and (y2[4],1'b0, op2n  ,op[1] ,op0n);
	and (y3[4],1'b0 , op2n  ,op[1] ,op[0]);
	and (y4[4],1'b0 , op[2] ,op1n  ,op0n);
	and (y5[4],1'b0 , op[2] ,op1n  ,op[0]);
	and (y6[4],1'b0 , op[2] ,op[1] ,op0n);
	and (y7[4],mul[4] , op[2] ,op[1] ,op[0]);
	or (out[4], y0[4], y1[4], y2[4], y3[4], y4[4], y5[4], y6[4], y7[4]);

        and (y0[5],1'b0 , op2n  ,op1n  ,op0n);
	and (y1[5],1'b0, op2n  ,op1n  ,op[0]);
	and (y2[5],1'b0, op2n  ,op[1] ,op0n);
	and (y3[5],1'b0 , op2n  ,op[1] ,op[0]);
	and (y4[5],1'b0 , op[2] ,op1n  ,op0n);
	and (y5[5],1'b0 , op[2] ,op1n  ,op[0]);
	and (y6[5],1'b0 , op[2] ,op[1] ,op0n);
	and (y7[5],mul[5] , op[2] ,op[1] ,op[0]);
	or (out[5], y0[5], y1[5], y2[5], y3[5], y4[5], y5[5], y6[5], y7[5]);

        and (y0[6],1'b0 , op2n  ,op1n  ,op0n);
	and (y1[6],1'b0, op2n  ,op1n  ,op[0]);
	and (y2[6],1'b0, op2n  ,op[1] ,op0n);
	and (y3[6],1'b0 , op2n  ,op[1] ,op[0]);
	and (y4[6],1'b0 , op[2] ,op1n  ,op0n);
	and (y5[6],1'b0 , op[2] ,op1n  ,op[0]);
	and (y6[6],1'b0 , op[2] ,op[1] ,op0n);
	and (y7[6],mul[6] , op[2] ,op[1] ,op[0]);
	or (out[6], y0[6], y1[6], y2[6], y3[6], y4[6], y5[6], y6[6], y7[6]);

        and (y0[7],1'b0 , op2n  ,op1n  ,op0n);
	and (y1[7],1'b0, op2n  ,op1n  ,op[0]);
	and (y2[7],1'b0, op2n  ,op[1] ,op0n);
	and (y3[7],1'b0 , op2n  ,op[1] ,op[0]);
	and (y4[7],1'b0 , op[2] ,op1n  ,op0n);
	and (y5[7],1'b0 , op[2] ,op1n  ,op[0]);
	and (y6[7],1'b0 , op[2] ,op[1] ,op0n);
	and (y7[7],mul[7] , op[2] ,op[1] ,op[0]);
	or (out[7], y0[7], y1[7], y2[7], y3[7], y4[7], y5[7], y6[7], y7[7]);

endmodule

module comp2sA(a,s);
      input [3:0] a;
      output [3:0] s;
      wire [3:0] not_a;
      not(not_a[0],a[0]);
      not(not_a[1],a[1]);
      not(not_a[2],a[2]);
      not(not_a[3],a[3]);
      BitAdder add4(not_a,1'b1,1'b0,s,cout);
endmodule

module comp2sB(b,s);
      input [3:0] b;
      output [3:0] s;
      wire [3:0] not_b;
      not(not_b[0],b[0]);
      not(not_b[1],b[1]);
      not(not_b[2],b[2]);
      not(not_b[3],b[3]);
      BitAdder add4(not_b,1'b1,1'b0,s,cout);
endmodule

module BitAdder(a,b,cin,s,cout);
    input [3:0] a, b;
    output [3:0] s;
    input cin; 
    output cout;
    wire cout01, cout02, cout03,cout04,cout11, cout12, cout13, cout14;
    wire cout21, cout22, cout23,cout24, cout31, cout32,cout33;

    xor(cout01,a[0],b[0]);
    xor(s[0],cout01,cin);
    and(cout02,a[0],b[0]);
    and(cout03,cout01,cin);
    xor(cout04,cout02,cout03);

    xor(cout11,a[1],b[1]);
    xor(s[1],cout11,cout04);
    and(cout12,a[1],b[1]);
    and(cout13,cout11,cout04);
    xor(cout14,cout12,cout13);

    xor(cout21,a[2],b[2]);
    xor(s[2],cout21,cout14);
    and(cout22,a[2],b[2]);
    and(cout23,cout21,cout14);
    xor(cout24,cout22,cout23);

    xor(cout31,a[3],b[3]);
    xor(s[3],cout31,cout24);
    and(cout32,a[3],b[3]);
    and(cout33,cout31,cout24);
    xor(cout,cout32,cout33);
endmodule

module BitSubtracter(a,b,cin,s,cout);
    input [3:0] a, b;
    output [3:0] s;
    input cin; 
    output cout;
    wire [3:0] minus_b;
    comp2sB cB(b,minus_b);
    BitAdder add4(a,minus_b,1'b0,s,cout);
endmodule

module bwAND(a,b,s);  
    input [3:0] a,b;
    output [3:0] s;
    
    and(s[0],a[0],b[0]);
    and(s[1],a[1],b[1]);
    and(s[2],a[2],b[2]);
    and(s[3],a[3],b[3]);
endmodule

module bwOR(a,b,s); 
    input [3:0] a,b;
    output [3:0] s;
    
    or(s[0],a[0],b[0]);
    or(s[1],a[1],b[1]);
    or(s[2],a[2],b[2]);
    or(s[3],a[3],b[3]);
endmodule

module bwXOR(a,b,s);
    input [3:0] a,b;
    output [3:0] s;

    xor(s[0],a[0],b[0]);
    xor(s[1],a[1],b[1]);
    xor(s[2],a[2],b[2]);
    xor(s[3],a[3],b[3]);
endmodule

module mult(a,b,s);
	
    input [3:0] a, b; 
    output [7:0] s; 
    wire p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15,p16,p17,p18,p19,p20,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11;
    wire r1,r2,r3,r4,r5,r6,r7,r8,q1,q2,q3,q4,q5,q6,q7,q8,q9,q10,q11,q12,q13,q14,q15,q16;

    and(s[0],a[0],b[0]);
    
    and(p0,a[1],b[0]);
    and(p1,a[0],b[1]);
    xor(s[1],p0,p1);
    and(c1,p0,p1);
    
    and(p2,a[0],b[2]);
    and(p3,a[1],b[1]);
    and(p4,a[2],b[0]);
    xor(p5,p2,p3);
    and(c2,p2,p3);
    xor(r1,p4,p5);
    and(q1,p4,p5);
    xor(s[2],r1,c1);
    and(q2,r1,c1);
    or(c3,q1,q2);

    and(p6,a[0],b[3]);
    and(p7,a[1],b[2]);
    xor(p8,p6,p7);
    and(c4,p6,p7);
    and(p9,a[2],b[1]);
    xor(r2,p8,p9);
    and(q3,p8,p9);
    xor(p10,r2,c2);
    and(q4,r2,c2);
    or(c5,q3,q4);
    and(p11,a[3],b[0]);
    xor(r3,p10,p11);
    and(q5,p10,p11);
    xor(s[3],r3,c3);
    and(q6,r3,c3);
    or(c6,q5,q6);
    
    and(p12,a[1],b[3]);
    and(p13,a[2],b[2]);
    xor(r4,p12,p13);
    and(q7,p12,p13);
    xor(p15,r4,c4);
    and(q8,r4,c4);
    or(c7,q7,q8);
    and(p14,a[3],b[1]);
    xor(r5,p14,p15);
    and(q9,p14,p15);
    xor(p16,r5,c5);
    and(q10,r5,c5);
    or(c8,q9,q10);
    xor(s[4],p16,c6);
    and(c9,p16,c6);
    
    and(p17,a[2],b[3]);
    and(p18,a[3],b[2]);
    xor(r6,p17,p18);
    and(q11,p17,p18);
    xor(p19,r6,c7);
    and(q12,r6,c7);
    or(c10,q11,q12);
    xor(r7,p19,c9);
    and(q13,p19,c9);
    xor(s[5],r7,c8);
    and(q14,r7,c8);
    or(c11,q13,q14);
     
    and(p20,a[3],b[3]);
    xor(r8,p20,c10);
    and(q15,p20,c10);
    xor(s[6],r8,c11);
    and(q16,r8,c11);
    or(s[7],q15,q16);
endmodule

