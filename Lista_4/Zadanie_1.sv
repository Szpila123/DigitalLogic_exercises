
module shift( input r, l, input [3:0] i,
             output [3:0] o);
  logic nrnl;
  assign nrnl = r ~^ l;
  assign o[0] = r && i[1] || l && 1'b0 || nrnl && i[0];
  assign o[1] = r && i[2] || l && i[0] || nrnl && i[1];
  assign o[2] = r && i[3] || l && i[1] || nrnl && i[2];
  assign o[3] = r && 1'b0 || l && i[2] || nrnl && i[3];
endmodule

