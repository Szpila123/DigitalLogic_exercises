module dff(output q, nq,           
           input clk,d);
  logic r, s, nr, ns;
  nand gq(q, nr, nq), gnq(nq, ns, q),
       gr(nr, clk, r), gs(ns, nr, clk, s), 
       gr1(r, nr, s), gs1(s, ns, d);
endmodule

module CreateTempReg( input [7:0] d, q, input i, l, r,
                       output [7:0] load);
  genvar x;
  
  assign load[0] = l ? ( r ? d[0] : q[1] ) : ( r ? i : q[0] );
  
  for( x = 1 ; x < 7 ; x = x + 1 )
    assign load[x] = l ? ( r ? d[x] : q[x+1] ) : ( r ? q[x-1] : q[x] );
  
  assign load[7] = l ? ( r ? d[7] : i ) : ( r ? q[6] : q[7] );
endmodule


module uniregister(input [7:0] d, input i, c, l, r,
                  output [7:0] q);
  logic [7:0] load, nq;
  genvar x;
  
  CreateTempReg ctr( d, q, i, l, r, load );
  
  for( x = 0 ; x < 8 ; x = x + 1 )
    dff dffs( q[x], nq[x],c,load[x] );
endmodule

