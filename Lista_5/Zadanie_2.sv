module Grays_code( input [31:0] i, output [31:0] o );
  genvar a;
  assign o[31] = i[31];
  for( a = 30 ; a >= 0 ; a = a - 1 )
    assign o[a] = i[a] ? !o[a+1] : o[a+1];
endmodule
