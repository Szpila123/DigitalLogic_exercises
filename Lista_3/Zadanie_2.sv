module four_bit_sum( input [3:0] a, b, input c_0,
                    output [3:0] o, output G, P );
  logic [4:0] c;
  logic [3:0] g, p;
  assign c[0] = c_0;
  genvar i,j;
  for( i = 0 ; i < 4 ; i = i + 1)
    begin
      assign g[i] = a[i] && b[i];
      assign p[i] = a[i] || b[i];
    end
  assign c[1] = g[0] || p[0] && c[0];
  assign c[2] = g[1] || p[1] && g[0] || p[1] && p[0] && c[0];
  assign c[3] = g[2] || p[2] && g[1] || p[2] && p[1] && g[0] || p[2] && p[1] && p[0] && c[0];
  for( i = 0 ; i < 4 ; i = i + 1)
    assign o[i] =  a[i] ^ b[i] ^ c[i];
  assign G = g[3] || p[3] && g[2] || p[3] && p[2] && g[1] || p[3] && p[2] && p[1] && g[0];
  assign P = p[3] && p[2] && p[1] && p[0];
endmodule

module sixteen_bit_sum( input [15:0] a, b,
                       output [15:0] o );
  logic [4:0] C;
  logic [3:0] G, P;
  assign C[0] = 0;
  four_bit_sum sum1(a[3:0], b[3:0], C[0], o[3:0], G[0], P[0] );
  assign C[1] = G[0] || P[0] && C[0];
  four_bit_sum sum2(a[7:4], b[7:4], C[1], o[7:4], G[1], P[1] );
  assign C[2] = G[1] || P[1] && G[0] || P[1] && P[0] && C[0];
  four_bit_sum sum3(a[11:8], b[11:8], C[2], o[11:8], G[2], P[2] );
  assign C[3] = G[2] || P[2] && G[1] || P[2] && P[1] && G[0] || P[2] && P[1] && P[0] && C[0];
  four_bit_sum sum4(a[15:12], b[15:12], C[3], o[15:12], G[3], P[3] );
  
endmodule
                   
