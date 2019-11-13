module bit_sum( input a, b, c,
               output o, s);
  assign o = a^b^c;
  assign s = (a && b) || c & (a||b);
endmodule

module convert( input [3:0] b, input sign,
               output [4:0] o);
  logic [4:0] w, carry;
  
  genvar i;
  for( i = 0 ; i < 4 ; i = i + 1 )
      assign w[i] = sign ^ b[i];
  assign w[4] = sign;
  
  bit_sum add_sign( w[0], sign, 0, o[0], carry[0] );
  for( i = 1 ; i < 5 ; i = i + 1 )
    bit_sum add_carry( w[i], 0, carry[i-1], o[i], carry[i] );
endmodule
  
module get_dec( input [4:0] w, input sub,
              output [3:0] o, output s ); 
  logic [4:0] cc, minus;
  assign s =  !sub && ( w[4] || w[3] && (w[2] || w[1])) || sub && w[4];
  assign minus[4] = s && !sub;
  assign minus[3] = s && sub;
  assign minus[2] = s && !sub;
  assign minus[1] = s;
  assign minus[0] = 0;
  assign cc[0] = 0;
  genvar i;
  for( i = 0 ; i < 4 ; i = i + 1 )
    bit_sum sum( w[i], minus[i], cc[i], o[i], cc[i+1] );

endmodule

module half_byte_count( input sub, input [3:0] a, input [4:0] b,
                       output [3:0] o, output s);
  logic [4:0] carry, res;
  assign carry[0] = 0;
  genvar i;
  for( i = 0 ; i < 4 ; i = i + 1 )
    bit_sum sum( a[i], b[i], carry[i], res[i], carry[i+1] ); 
  bit_sum sign( carry[4], b[4], 0, res[4],);
  
  get_dec dec( res[4:0], sub, o[3:0], s );
endmodule

module circuit( input [7:0] a, b, input sub,
               output [7:0] o);
  
  logic [9:0] signb;
  logic [4:0] incb;
  logic [2:0] high_carry;
  logic carry;
  
  convert low( b[3:0], sub, signb[4:0] );
  half_byte_count hbc1( sub, a[3:0], signb[4:0], o[3:0], carry );
  
  bit_sum bsum1( b[4], carry, 0, incb[0], high_carry[0] );
  bit_sum bsum2( b[5], 0, high_carry[0], incb[1], high_carry[1] );
  bit_sum bsum3( b[6], 0, high_carry[1], incb[2], high_carry[2] );
  bit_sum bsum4( b[7], 0, high_carry[2], incb[3], );
  
  convert high( incb[3:0], sub, signb[9:5] );
  half_byte_count hbc2( sub, a[7:4], signb[9:5], o[7:4],  );
endmodule

