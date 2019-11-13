module Control( input clk, nrst, start, equal, less,
               output ready_next, sub, swap, load, upload); 
  logic ready;
  
  always_ff @(posedge clk or negedge nrst)
    begin
      if( !nrst ) ready <= 1;
      else ready <= ready_next;
    end
  
  assign ready_next = !nrst || ready && !start || !ready && equal;
  assign load = start && ready;
  assign sub = !equal && !ready;
  assign swap = less && !ready && !equal;
  assign upload = equal && !ready;
endmodule
      
module Data( input clk, sub, swap, load, upload, input [7:0] ina, inb,
            output logic [7:0] out, output equal, less);
  logic [7:0] a, b;
  always_ff @(posedge clk)
    begin
      out <= out;
      if ( upload ) begin
        out <= a;
      end
      else if ( load ) begin
      a <= ina;
      b <= inb;
      end 
      else if ( swap ) begin   	
        a <= b;   
        b <= a;         
      end
      else if ( sub ) begin
        a <= a - b;
        b <= b;
      end
      else begin
        a <= a;
        b <= b;
      end
    end

  assign equal = (a == b);
  assign less = (a < b);
endmodule
  
  
module NWD(input clk, nrst, start, input [7:0] ina, inb,
           output ready, output [7:0] out);
  
  logic ready_next, equal, less, sub, swap, load, upload;
    
  Control cltr( clk, nrst, start, equal, less, ready_next, sub, swap, load, upload );
  Data data( clk, sub, swap, load, upload, ina, inb, out, equal, less);
  
  assign ready = ready_next;
endmodule
