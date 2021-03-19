module SHIFTER(X,Sa,Arith,Right,Sh);
/*移位模块可对输入的数据X,左移或右移任意位数
*X被位移的数
*Sa位移的位数
*Arith 是否为算术移位 0逻辑 1算术
*Right 移位方向 0左 1右
*Sh 结果
*/

    input [31:0]X;//被位移数据
    input [4:0]Sa;//位移位数2^5 
    input Arith,Right;// Arith 是否为算术移位 , Right 移位方向 
    output reg [31:0]Sh;//结果
    wire a=X[31]&Arith;     //补位子 即根据移位类型，补0还是补1
    always @(*) begin
    // 右移
    if(Right)begin
        case(Sa)
            0: Sh =X;
            1: Sh ={{a}, X[31:1]};
            2: Sh ={{2{a}}, X[31:2]};
            3: Sh ={{3{a}}, X[31:3]};
            4: Sh ={{4{a}}, X[31:4]};
            5: Sh ={{5{a}}, X[31:5]};
            6: Sh ={{6{a}}, X[31:6]};
            7: Sh ={{7{a}}, X[31:7]};
            8: Sh ={{8{a}}, X[31:8]};
            9: Sh ={{9{a}}, X[31:9]};
            10: Sh ={{10{a}}, X[31:10]};
            11: Sh ={{11{a}}, X[31:11]};
            12: Sh ={{12{a}}, X[31:12]};
            13: Sh ={{13{a}}, X[31:13]};
            14: Sh ={{14{a}}, X[31:14]};
            15: Sh ={{15{a}}, X[31:15]};
            16: Sh ={{16{a}}, X[31:16]};
            17: Sh ={{17{a}}, X[31:17]};
            18: Sh ={{18{a}}, X[31:18]};
            19: Sh ={{19{a}}, X[31:19]};
            20: Sh ={{20{a}}, X[31:20]};
            21: Sh ={{21{a}}, X[31:21]};
            22: Sh ={{22{a}}, X[31:22]};
            23: Sh ={{23{a}}, X[31:23]};
            24: Sh ={{24{a}}, X[31:24]};
            25: Sh ={{25{a}}, X[31:25]};
            26: Sh ={{26{a}}, X[31:26]};
            27: Sh ={{27{a}}, X[31:27]};
            28: Sh ={{28{a}}, X[31:28]};
            29: Sh ={{29{a}}, X[31:29]};
            30: Sh ={{30{a}}, X[31:30]};
            31: Sh ={{31{a}}, X[31]};
            default: Sh ={32{a}};
        endcase
    end
    else begin
    // 左移
        case(Sa)
            0: Sh =X;
            1: Sh =X << 1;
            2: Sh =X << 2;
            3: Sh =X << 3;
            4: Sh =X << 4;
            5: Sh =X << 5;
            6: Sh =X << 6;
            7: Sh =X << 7;
            8: Sh =X << 8;
            9: Sh =X << 9;
            10: Sh =X << 10;
            11: Sh =X << 11;
            12: Sh =X << 12;
            13: Sh =X << 13;
            14: Sh =X << 14;
            15: Sh =X << 15;
            16: Sh =X << 16;
            17: Sh =X << 17;
            18: Sh =X << 18;
            19: Sh =X << 19;
            20: Sh =X << 20;
            21: Sh =X << 21;
            22: Sh =X << 22;
            23: Sh =X << 23;
            24: Sh =X << 24;
            25: Sh =X << 25;
            26: Sh =X << 26;
            27: Sh =X << 27;
            28: Sh =X << 28;
            29: Sh =X << 29;
            30: Sh =X << 30;
            31: Sh =X << 31;
            default:Sh=0;
        endcase
    end
    end
endmodule