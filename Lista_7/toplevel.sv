module mux4reg16( output [15:0] q, input [15:0] d0, d1, d2, d3, input clk, input [1:0] sel );
  always_ff @(posedge clk)
    begin
     casez(sel)
       2'b00: q <= d0;
       2'b01: q <= d1;
       2'b10: q <= d2;
       2'b11: q <= d3;
       2'bxx: q <= 0;
     endcase
    end
endmodule

module mux2reg16( output [15:0] q, input [15:0] d0, d1, input clk, input sel );
  always_ff @(posedge clk)
    case(sel)
      1'b0: q <= d0;
      1'b1: q <= d1;
    endcase
endmodule



module PWM(input clk, input [1:0] sel, input [15:0] d,           
           output [15:0] cnt, cmp, top, output out );
  logic [1:0] sel_cnt;
  logic sel_top, sel_cmp;
  always_comb
    begin
      
      if( sel == 2'b11 ) sel_cnt = 2'b01;
      else if( cnt >= top ) sel_cnt = 2'b10;
      else sel_cnt = 2'b00;
      
      if( sel == 2'b10 ) sel_top = 1;
      else sel_top = 0;
      
      if( sel == 2'b01 ) sel_cmp = 1;
      else sel_cmp = 0;
    end
  mux4reg16 reg_cnt( cnt, cnt + 16'b1, d, 16'b0, 16'b0, clk, sel_cnt );
  mux2reg16 reg_top( top, top, d, clk, sel_top );
  mux2reg16 reg_cmp( cmp, cmp, d, clk, sel_cmp );
  
  assign out = cmp > cnt;
  
   
endmodule



