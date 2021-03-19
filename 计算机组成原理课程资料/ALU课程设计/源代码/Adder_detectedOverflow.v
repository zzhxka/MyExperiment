`timescale 1ns / 1ps

// ???????????32��???????????
module Adder_detectedOverflow(sub, inA, inB, overflow, cout, zero, add_result);
    input sub; //?????????
    input [31:0]inA;
    input [31:0]inB;

    output overflow; //??????????????��????????????
    output zero;     //???????0
    output [31:0]add_result; //??????
    output reg cout; // ????��?��??????????????????��????????????
    wire [31:0]inB_r; //B???
    wire C2;  //??��???
    wire C_r;  //??��??????
    reg [31:0]inB_final; //?????B

    assign inB_r = ~inB;
    assign C_r = ~C2;
    always@(*)
    begin
    if(sub==1)
        begin
            inB_final = inB_r;
            cout = C_r; //????????????????????��??????��??????
        end
    else
        begin
            inB_final = inB;
            cout = C2;
       end
   end
   aheadAdder_32 adder(add_result, C2, inA, inB_final, sub); // ????????????????B????????sub

   assign zero = ~(add_result[0]|add_result[1]|add_result[2]|add_result[3]|add_result[4]|add_result[5]|add_result[6]|add_result[7]|add_result[8]|add_result[9]|add_result[10]|add_result[11]|add_result[12]|add_result[13]|add_result[14]|add_result[15]|add_result[16]|add_result[17]|add_result[18]|add_result[19]|add_result[20]|add_result[21]|add_result[22]|add_result[23]|add_result[24]|add_result[25]|add_result[26]|add_result[27]|add_result[28]|add_result[29]|add_result[30]|add_result[31]);
   assign overflow = inA[31]&inB_final[31]&~add_result[31]|~inA[31]&~inB_final[31]&add_result[31];

endmodule

module aheadAdder_32(f32,c2,x32,y32,cin32);//32��????????��?��?????
input [32:1]x32;
input [32:1]y32;
input cin32;//??��????
output [32:1]f32;
output c2;   //??��???
wire c1;
wire [2:1]p;
wire [2:1]g;

// ????????16��?????????��
assign c1=g[1]|p[1]&cin32;  // C16 = G0+P0*C0
assign c2=g[2]|p[2]&g[1]|p[2]&p[1]&cin32; // C32 = G1 + P1*G0 + P1*P0*C0

aheadAdder_16 ah1(g[1],p[1],f32[16:1],x32[16:1],y32[16:1],cin32);
aheadAdder_16 ah2(g[2],p[2],f32[32:17],x32[32:17],y32[32:17],c1);

endmodule


module aheadAdder_16(gmm,pmm,f16,x16,y16,cin);//16��????????��?��?????
input [16:1]x16;
input [16:1]y16;
input cin;
output [16:1]f16;
output gmm,pmm;
wire [4:1]c;
wire [4:1]p;
wire [4:1]g;

aheadAdder_4 ah_1(g[1],p[1],f16[4:1],x16[4:1],y16[4:1],cin);
aheadAdder_4 ah_2(g[2],p[2],f16[8:5],x16[8:5],y16[8:5],c[1]);
aheadAdder_4 ah_3(g[3],p[3],f16[12:9],x16[12:9],y16[12:9],c[2]);
aheadAdder_4 ah_4(g[4],p[4],f16[16:13],x16[16:13],y16[16:13],c[3]);

parrallel_carry cl4(c,p,g,cin);

assign pmm=p[4]&p[3]&p[2]&p[1];
assign gmm=g[4]|p[4]&g[3]|p[4]&p[3]&g[2]|p[4]&p[3]&p[2]&g[1];
endmodule



module aheadAdder_4(gm,pm,f,x,y,c0);   //4��?????��?????
input [4:1]x;                    //??��x?
input [4:1]y;                    //??��y?
input c0;                        //????????��
output [4:1]f;                  //??��???f
output gm,pm;

wire [3:1]c;                     //?????��
wire [4:1]p;
wire [4:1]g;
assign p=x|y;  // P????��????????��???????(A3+B3), (A2+B2), (A1+B1), (A0+B0)
assign g=x&y;  //G?? ??��?????????��???? A3B3,A2B2,A1B1,A0B0

assign pm=p[4]&p[3]&p[2]&p[1];  //??????????????G??P
assign gm=g[4]|p[4]&g[3]|p[4]&p[3]&g[2]|p[4]&p[3]&p[2]&g[1];

// ??????��???��
assign c[1]=g[1]|p[1]&c0;
assign c[2]=g[2]|p[2]&g[1]|p[2]&p[1]&c0;
assign c[3]=g[3]|p[3]&g[2]|p[2]&p[3]&g[1]|p[3]&p[2]&p[1]&c0;
//?????????
half_adder H1(x[1],y[1],c0,f[1]);
half_adder H2(x[2],y[2],c[1],f[2]);
half_adder H3(x[3],y[3],c[2],f[3]);
half_adder H4(x[4],y[4],c[3],f[4]);
endmodule



module half_adder(x,y,c0,f);  //???????????????????��??��
input x;
input y;
input c0;
output f;
assign f=(x^y)^c0;
endmodule


module parrallel_carry(c,p,g,c0);//???��?��???????????4??4��?????��?????->16��?????��???????????G??P??C0????????��???��??
input [4:1]p;
input [4:1]g;
input c0;
output [4:1]c;
assign c[1]=g[1]|p[1]&c0;  // C4??��
assign c[2]=g[2]|p[2]&g[1]|p[2]&p[1]&c0; //C8??��
assign c[3]=g[3]|p[3]&g[2]|p[2]&p[3]&g[1]|p[3]&p[2]&p[1]&c0; // C12??��
assign c[4]=g[4]|p[4]&g[3]|p[4]&p[3]&g[2]|p[4]&p[3]&p[2]&g[1]|p[4]&p[3]&p[2]&p[1]&c0; // C16??��
endmodule
