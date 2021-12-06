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
	
	reg[2:0] counter0 = 3'b100;		//log2(n) = log2(4) = 2 bits +1 reverse
	reg[15:0] counter1 = 16'b0;		//log2( 2^max(n) )=log2( 2^ 1111)=log2(2^15) = 15 bits +1 reverse
	reg[15:0] counter2 = 16'b0;

	reg[15:0] countZeros = 16'b0;		//log2(n) = log2(4) = 2 bits
	reg[15:0] countOnes = 16'b0;		//log2( 2^max(n) )=log2( 2^ 1111)=log2(2^15) = 15 bits
	reg[5:0] bitPeriod = 6'b0;
	
	reg prevBit = 1'b0;
	reg[15:0] msgSize = 16'b0;
	reg status = 1'b1;
	
	reg configured = 1'b0;

	
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
			configured <= 1'b1;
		end		
		else if (!mode&configured) begin 
		//#1	status = (!prevBit)&str;
			if(prevBit==1'b0 && str == 1'b1) begin
				if(countZeros<countOnes) begin
				//	msg <= (crypto[]^d)|capsN;
					msg <= (!d)|capsN;				// 1^d = !d
				end
				else if(countZeros>=countOnes) begin
					msg <= (d)|capsN;				// 0^d = d
				end
			countZeros <= 15'b0;
			countOnes <= 15'b0;
			bitPeriod <= 1'b0;
			end
			
			else  begin						// 01	=>	a'b 
				if(str==1'b1) begin
					countOnes <= countOnes+1;
				end
				else if(str==1'b0) begin
					countZeros <= countZeros+1;				
				end
				bitPeriod <= bitPeriod+1;
				prevBit <= str;

			end
			
	
		end
   
	
	end

endmodule