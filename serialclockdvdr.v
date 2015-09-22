`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:01:03 12/11/2013 
// Design Name: 
// Module Name:    serialclockdvdr 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module serialclockdvdr(write,m_ss_bar,reset,clock,m_sclk,address,opb_datain,opb_dataout,read,cs,MOSI_2);
input reset,clock,write,read,cs;
input [15:0] address;
input [31:0]opb_datain;
output [31:0] opb_dataout;
reg[0:7] spcr;
reg[0:7] temp;
reg[0:7] temp1;
reg [31:0]opb_dataout;
output m_sclk,m_ss_bar,MOSI_2;
reg m_sclk,m_ss_bar,MOSI_2;
integer count1,count2,count3,count4;
reg[31:0] n_clk_cycles,clk_hightime,clk_lowtime;
parameter idle=3'b000,delay=3'b001,sclk1=3'b010,sclk0=3'b011,sclkhigh=3'b100;
reg [2:0]nst;
integer cntr_tx ;

always @(posedge clock or posedge reset)
  begin 
	if (reset ==1)
	 begin
	  n_clk_cycles<=32'b00000000000000000000000000000000;
	  clk_hightime<=32'b00000000000000000000000000000000;
	  clk_lowtime<=32'b00000000000000000000000000000000;
	  spcr<=8'b00000000;
	 end
	 else if(write==1 && cs ==1)
     begin
	   if(address == 16'b0000000000000000)
	      begin
			n_clk_cycles<=opb_datain;
		   end
		else if(address ==16'b0000000000010000)
		temp1<=opb_datain[7:0];
		else if(address ==16'b0000000000000100)
         clk_hightime<=opb_datain;
      else if(address ==16'b0000000000001000)
	       clk_lowtime<=opb_datain;
		else if(address ==16'b0000000000001100)
	       begin
			 spcr<=opb_datain[7:0];

			 end
	  end
  end

always @(posedge clock or posedge reset)
 begin
 if (reset ==1)
	 begin
	  opb_dataout<=32'h00000000;
	 end
  else if(read==1 && cs==1)
   begin
    if(address==16'b0000000000000000)
	  opb_dataout<=n_clk_cycles;
    else if(address==16'b0000000000000100)
	  opb_dataout<=clk_hightime;
    else if(address==16'b0000000000001000)
	  opb_dataout<=clk_lowtime;
    else if (address==16'b000000000001100)
	  opb_dataout<=spcr;
	end
end

always @( posedge m_sclk )
 begin
	//temp<=temp1;
	//temp<=temp <<1 ;//{1'b0,temp[0:6]};
	if (cntr_tx<7)
	begin
   MOSI_2<=temp1[cntr_tx];  
	cntr_tx <= cntr_tx +1;
	end
	else 
	begin
	MOSI_2<=temp1[cntr_tx];  
	cntr_tx <= 0;
	end
end  
always @(posedge clock or posedge reset)
 begin
 if(reset==1 )
                 begin 
	               m_ss_bar<=1;count1<=0;count2<=0;count3<=0;count4<=0;
	                nst<=idle;
					    m_sclk<=0;
					  end
  else 
  case(nst)
         idle:begin
			       if (write==1 &&  spcr==8'b01001010)
                 begin
                  m_ss_bar<=0;
                  nst<=delay;
                 end	
					  end
			delay:begin 
			       if(count1<=1)
                 begin
					   count1<=count1+1;
						nst<=delay;
					  end
					 else
                 begin 
						count1<=0;
                  nst<=sclk1;
                 end
               end
 			sclk1: begin
			          if(count2<=n_clk_cycles)
                    begin
                     if(count3<=clk_hightime)
                      begin
                       m_sclk<=1;
							  count3<=count3+1;
							  nst<=sclk1;
                      end
                     else
                      begin
                       count2<=count2+1;
							  count3<=0;
                       nst<=sclk0;
                      end
							end
						 else
						  begin
                     //count2<=0;
                     nst<=sclkhigh;
                    end
                  end
       sclk0:begin
                if(count2<=n_clk_cycles)
                 begin
                  if(count4<=clk_lowtime)
                   begin
                    count4<=count4+1;						 
						  m_sclk<=0;
                    nst<=sclk0;
                   end
                  else
                   begin 
						 count2<=count2+1;
						  count4<=0;						
                    nst<=sclk1;
                   end
                 	end
						else
                   begin
                    //count2<=0;
                    nst<=sclkhigh;
						 end
					end
						  
     sclkhigh:begin
	          count2<=0;
				 m_sclk<=1;
				 m_ss_bar<=1;
				 nst<=idle;
				 end
	 default:begin
				nst<=idle;
            end	
	endcase
	end

endmodule
