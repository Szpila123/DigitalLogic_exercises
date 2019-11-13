module compare(input [3:0] a, b, output [3:0] bigger, smaller);
  always_comb begin
    if( a > b )
      begin
        bigger = a;
   	    smaller = b;
      end
    else
      begin
        bigger = b;
  	    smaller = a;
      end
  end
endmodule

module sort_4(input [15:0] i, output [15:0] o);
  logic [3:0] bigger1, bigger2, smaller1, smaller2, middle1, middle2;
  
  compare comp1( i[15:12], i[11:8], bigger1, smaller1 );
  compare comp2( i[7:4], i[3:0], bigger2, smaller2 );
  compare comp3( bigger1, bigger2, o[15:12], middle1 );
  compare comp4( smaller1, smaller2, middle2, o[3:0] );
  compare comp5( middle1, middle2, o[11:8], o[7:4] );

endmodule

