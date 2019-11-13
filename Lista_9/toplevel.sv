module kuchenka( input clk, nrst, door, start, finish,
                output heat, light, bell );
  logic closedstate, openstate, bellstate, cookstate, pausestate;
  
  always_ff @(posedge clk, negedge nrst) begin
      if( !nrst ) begin
        closedstate <= 1;
        openstate <= 0;
        cookstate <= 0;
        lightstate <= 0;
        bellstate <= 0;
      end
    else begin
      closedstate <= (!door && openstate) || (closedstate && (!start || door));
      cookstate <= (closedstate && start && !door) || (pausestate && !door) || (cookstate && (!finish && !door));
      pausestate <= (cookstate && door) || (pausestate && door);
      bellstate <= (cookstate && finish && !door ) || (bellstate && !door);
      openstate <= (bellstate && door ) || (closedstate && door) || (openstate && door);
    end
  end
  
  assign light = cookstate || openstate || pausestate;
  assign bell = bellstate;
  assign heat = cookstate;
     
endmodule 
