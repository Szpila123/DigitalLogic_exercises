module circuit(input [3:0] i, output o);
  logic a, b, c, d;
  assign a = i[0];
  assign b = i[1];
  assign c = i[2];
  assign d = i[3];
  assign o = ( !a  && c && d) ||
    (!b && c && d) ||
    (!a && b && d) ||
    (!a && b && c) ||
    (a && b && !d) ||
    (a && b && !c) ||
    (a && !b && d) ||
    (a && !b && c) ||
    (b && !c && d) ||
    (a && !c && d) ||
    (a && c && !d) ||
    (b && c && !d);
endmodule
