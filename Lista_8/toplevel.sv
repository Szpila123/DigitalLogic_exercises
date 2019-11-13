module memory( input wr, clk,
              input [9:0] rdaddr, wraddr,
              input [15:0] in,
              output [15:0] out );
  logic [15:0] mem [0:1023];
  always_ff @(posedge clk)
    if(wr) mem[wraddr] <= in;
  assign out = mem[rdaddr];
endmodule

module clkout( input [15:0] top, input nrst, clk, output [15:0] out );
  always_ff @(posedge clk, negedge nrst)
    if(!nrst) out <= 0;
  	else out <= top;
endmodule

module clkcnt(input [9:0] tcnt, input nrst, clk, output [9:0] cnt);
  always_ff @(posedge clk, negedge nrst)
    if(!nrst) cnt <= 0;
  	else cnt <= tcnt;
endmodule

module operation( input [15:0] first, second, input [9:0] cnt,  input [1:0] op,
                 output [15:0] result, output [9:0] tcnt );
  always_comb
    case( op )
          2'b00:
            begin
              result <= first;
              tcnt <= cnt;
            end
          2'b01:
            begin
              result <= 16'b0 - first;
              tcnt <= cnt;
            end
          2'b10:
            begin
              result <= first + second;
              tcnt <= cnt < 10'b10 ? cnt : cnt - 10'b1;
            end
          2'b11:
            begin
              result <= first * second;
              tcnt <= cnt < 10'b10 ? cnt : cnt - 10'b1;
            end
    endcase
      endmodule

module Calc_ONP(input nrst, step, push, input [1:0] op, input [15:0] d,
                output [15:0] out, output [9:0] cnt);
  logic [15:0] top, second;
  logic [9:0] tcnt, opcnt;
  logic [15:0] result;
  memory mem( push, step, cnt-10'b10, cnt-10'b1, out, second);
  operation oper( out, second, cnt, op, result, opcnt );
  always_comb
      if(push)
        begin
          top <= d;
          tcnt <= cnt + 10'b1;
        end
      else begin
        top <= result;
        tcnt <= opcnt;   	
      end
    
  clkcnt display_cnt( tcnt, nrst, step, cnt);
  clkout display_out( top, nrst, step, out);
endmodule

