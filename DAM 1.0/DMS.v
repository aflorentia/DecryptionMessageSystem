// Created by F. Afentaki
// Revision 1.1

module SAM (str, mode, clk, reset, msg, frame);
	
	//input
	input str;
	input mode;
	input clk;
	input reset;
	
	//output
	output reg msg;
	output reg frame;
	
	reg [3:0] n = 4'b0000;
	reg [31:0] d = 32'b00;
	reg [31:0] capsN = 32'b0;
	
	reg[2:0] counter0 = 3'b100;		//log2(n) = log2(4) = 2 bits
	reg[15:0] counter1 = 16'b0;				//log2( 2^max(n) )=log2( 2^ 1111)=log2(2^15) = 15 bits
	reg[15:0] counter2 = 16'b0;


	always @(posedge clk, negedge reset) begin
     
		if (!reset) begin msg <= 0; frame <=0; end
		else if (mode) begin 				
				if(counter0) 
					begin  
						n[counter0-1] <= str; 
						counter0 <= counter0-1; 
						if(counter0==3'b001) begin
							#1 counter1 <= 2**n; 		//logw paralilias 
							#1 counter2 <= 2**n;
						end
					end
				else if(counter1) 
					begin  
						d[counter1-1]<= str; 
						counter1<= counter1-1; 
					end
				else if(counter2) 
					begin  
						capsN[counter2-1]<= str; 
						counter2<= counter2-1; 
					end
					
				
				
			//else if (!mode) begin 
			
			//end
		end
		
   
	
	end

endmodule