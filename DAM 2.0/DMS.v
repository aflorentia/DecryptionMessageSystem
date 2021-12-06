// Created by F. Afentaki
// Revision 1.2

module SAM (str, mode, clk, reset, msg, frame);
	
	//input
	input str;
	input mode;
	input clk;
	input reset;
	
	//output
	output reg [31:0] msg;
	output reg frame;
	
	reg [3:0] n = 4'b0000;
	reg [31:0] d = 32'b00;
	reg [31:0] capsN = 32'b0;
	
	reg[2:0] counter0 = 3'b100;		//log2(n) = log2(4) = 2 bits +1 reverse
	reg[15:0] counter1 = 16'b0;		//log2( 2^max(n) )=log2( 2^ 1111)=log2(2^15) = 15 bits +1 reverse
	reg[15:0] counter2 = 16'b0;

	reg[15:0] countZeros = 16'b0;	//log2(n) = log2(4) = 2 bits
	reg[15:0] countOnes = 16'b0;	//log2( 2^max(n) )=log2( 2^ 1111)=log2(2^15) = 15 bits
	reg[5:0] bitPeriod = 6'b0;
	reg[5:0] prevBitPeriod = 6'b0;

	reg prevBit = 1'b0;
	reg[15:0] msgSize = 16'b0;

	reg status = 1'b1;
	
	reg configured = 1'b0;
	//reg valid = 1'b0;
	reg [15:0] sent = 16'b0;
	reg stop_count = 1'b0;
	//reg [31:0] tmp;
	//reg [31:0] tmp2;
	
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
		
			if(prevBit&str) begin
				//countOnes <= countOnes+1;
				if(countZeros<countOnes & msgSize>1'b0) begin
				//	msg <= (crypto[]^d)|capsN;
					sent[msgSize-1] <= 1'b1;
					//tmp <= 32'b1^d;
					//tmp2 <= ~d;
					msg <= (~d)|capsN;				// 1^d = !d = ~b
				end
				else if(countZeros>=countOnes & msgSize>1'b0) begin
					sent[msgSize-1] <= 1'b0;
					msg <= d|capsN;				// 0^d = d
				end

			prevBit <= 1'b0;
			countZeros <= 15'b0;
			countOnes <= 15'b1;
			bitPeriod <= 1'b0;
			prevBitPeriod <= bitPeriod;
			#1 msgSize = msgSize+1; // an den einai valid to str sent[-1]=str;
			stop_count <= 1'b0;
			//valid <= 1'b1;
			end
			if (!stop_count) begin
				#10 if(str==1'b1) begin
					countOnes <= countOnes+1;
				end
				else if(str==1'b0) begin
					countZeros <= countZeros+1;
					prevBit <= 1'b1;				
				end
				#5 bitPeriod <= bitPeriod+1;
				//#5 prevBit <= str;
			end
		end
	end


	always @(negedge clk) begin
		if(bitPeriod>6'b111100) begin
			frame <= 0;
			stop_count <= 1'b1;
		end
		else if(prevBit&str & bitPeriod<4'b1010) begin
			frame <= 0;
		end
		else begin
			frame <=1;
		end

	end


endmodule