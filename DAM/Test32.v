// This is the very same example as the previous one. The only change is that n=5.

module SAMtest ();
  reg  str;
  reg  mode;
  reg  clk;
  reg  reset;
  wire msg;
  wire frame;
  integer seed;
  integer idle_cycles;
  integer key_length; 
  reg  [2:0] counter;
  reg  [9:0] counter2;
  reg  [9:0] counter3;
  reg  [3:0]  n;
  reg  [31:0] d;
  reg  [31:0] capsN;
  reg  [4:0]  counterones;
  reg  [4:0]  counterzeros;
  reg  [31:0] sent;
  reg         state;
  integer i;

SAM CUT (str, mode, clk, reset, msg, frame); 

initial
  begin
    clk        = 1'b0;
    str        = 1'b1;
    reset      = 1'b1;
    n          = 4'h5;
    counter    = 3'h4;
    counter2   = 10'h020;
    counter3   = 10'h020;
    key_length = 32;
 #5 mode       = 1'b0;
    i          = 0;
    reset      = 1'b0;
#2  reset      = 1'b1;
  end

always #20 clk = !clk; 

initial
  begin
    seed         = $random(32434);
    idle_cycles  = $random % 16;
    d[14:0]      = $random;
    d[29:15]     = $random;
    d[31:30]     = $random; 
    capsN[14:0]  = $random;
    capsN[29:15] = $random;
    capsN[31:30] = $random;
  end

initial
  begin
    # (40*idle_cycles +21)        mode = 1'b1;
                                  state = 1'b1;
    # (40*(n+(2*key_length)+1)+5) mode = 1'b0;
    # (10*key_length) i = 33;
       counterones = 5'h0;
       counterzeros = 5'h0;
  end

always @(negedge clk)
  if (mode)
    begin
      if (counter)
        begin
          str     <= n[counter-1];
          counter <= counter - 1;
        end
       else if (counter2)
              begin
                str      <= d[counter2-1];
                counter2 <= counter2 - 1;
              end
             else if (counter3)
                    begin
                      str      <= capsN[counter3-1];
                      counter3 <= counter3 - 1;
                    end
    end
   else if (state)
          begin
            state <= 1'b0;
            str <= 1'b0;
          end
         else
          begin
            if (i)
              begin 
                if ( (!counterones) && (!counterzeros) )
                  begin
                    counterones = 5'b00101 + $random%25;
                    counterzeros = 5'b00101 + $random%24;
                     if (counterones > counterzeros)sent[i-2] <= 1'b1;    
                      else sent[i-2] <= 1'b0;
                     i <= i-1;
                  end
              end
          end


always @(posedge clk)
  begin
    if (counterones)
      begin
        str <= 1'b1;
        counterones <= counterones - 1;
      end
     else if (counterzeros)
            begin
              str <= 1'b0;
              counterzeros <= counterzeros - 1;
            end
  end

endmodule