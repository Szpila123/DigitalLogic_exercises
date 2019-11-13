module mlplex8to1( input [8:0] a, input [3:0] n, 
                          output o);
  logic [3:0] layer_1;
  logic [1:0] layer_2;
  logic layer_3;
  //Last gate (4) goes straight to output
  genvar i;
  for( i = 0 ; i < 4 ; i = i + 1)
    assign layer_1[i] = n[0] ? a[i*2+1] : a[i*2];
  
  for( i = 0 ; i < 2 ; i = i + 1)
    assign layer_2[i] = n[1] ? layer_1[i*2+1] : layer_1[i*2];
  
  assign layer_3 = n[2] ? layer_2[1] : layer_2[0];
  assign o = n[3] ? a[8] : layer_3;
    
endmodule

module funnel_shifter( input [7:0] a, b, input [3:0] n,
                      output [7:0] o);
  logic [15:0] t;
  assign t = {a,b};
  genvar i;
  for( i = 0 ; i < 8 ; i = i + 1)
    mlplex8to1 mlplex( t[8+i:0+i], n[3:0], o[i]);
endmodule

module dop_do_8( input [3:0] n, output [3:0] o);
  assign o[0] = n[0];
  assign o[1] = n[0] ^ n[1];
  assign o[2] = n[2] ^ ( o[1] || n[1] );
  assign o[3] = n[3] ^ ( o[2] ~| n[2] );
endmodule

module shift_rot( input [7:0] i, input [3:0] n,
                 input ar, lr, rot,
                 output [7:0] o );
  logic [3:0] dop, shift; //when shifting left, n=8-n 
  dop_do_8 dop8( n, dop); 
  assign shift = lr ? dop : n ;
  
  logic [7:0] signs;//creating the 'signs' half of base;
  genvar x;         //(only needed if shifting right)
  assign sign = ar && i[7];  
  for( x = 0 ; x < 8 ; x = x + 1 )
    assign signs[x] = sign;
  
  logic [15:0] base;  //creating the base, which part will be cut out
  assign base[7:0] = rot ? i : ( lr ? 0 : i );    //depending of rotating or direction of shifting,
  assign base[15:8] = rot ? i : (lr ? i : signs); //the input will be placed on left, right or both sides of the base
  
  funnel_shifter fn_sh( base[15:8], base[7:0], shift, o);
endmodule

