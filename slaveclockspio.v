`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:29:56 11/27/2013 
// Design Name: 
// Module Name:    slavebusint 
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
module slavebusint(opb_dbus,reset,opb_abus,clk,opb_select,opb_rnw,o_sl_dbus,o_sl_xferack,o_sl_fullack,rd,wr,cs,opb_clk,opb_addrs,data_in,data_out);
    input [31:0] opb_dbus;
    input [15:0]opb_abus;
	 input [31:0]data_out;
	 input opb_clk,reset;
	 input opb_select;
    input opb_rnw;
    output [31:0] o_sl_dbus,data_in;
    output o_sl_xferack;
    output o_sl_fullack;
    output rd;
    output wr;
    output cs;
    output clk;
    output[15:0]  opb_addrs;
    reg o_sl_xferack,o_sl_fullack,rd,wr,cs,clk;
	 reg[15:0] opb_addrs;
	 reg [31:0] o_sl_dbus,data_in;
    reg[2:0] nst;
	 integer readcount;
	 parameter idle=3'b000,write=3'b001,read=3'b010,readwait=3'b011,done=3'b100;
	 always @(posedge opb_clk or posedge reset )
	  begin 
	  if (reset==1)
				 begin
				  rd<=0;
				  wr<=0;
				  o_sl_xferack<=1'b0;
				  o_sl_fullack<=1'b0;
				  //clk<=opb_clk;
				  end
			else
			//begin
			//clk<=opb_clk;
		case(nst)
		idle:begin				 
				 begin
				 if(opb_select==1)// && opb_abus >16'b0000000000000000 && opb_abus <15'b1111111111111111

              begin
               cs<=1;
               opb_addrs<=opb_abus;	
               if(opb_rnw==0)
                 begin
					  wr<=1;
					  nst<=write;
					  end 


					else
                 nst<=read;
               end 					  
	          else
              begin
				  wr<=0;
				  rd<=0;
				  o_sl_xferack<=1'b0;
              o_sl_fullack<=1'b0;
				  nst<=idle;
              end                
	          end				 
				end 				  
       write:begin
		       wr<=1;
				 data_in<=opb_dbus;
				 o_sl_xferack<=1;
				 o_sl_fullack<=1;
				 nst<=done;
				 end
		 readwait:begin
		           if (readcount<2)
		            begin
                   readcount<=readcount+1;
                   nst<=readwait;
                  end
                 else
                  begin 					  
                   readcount<=0;
					   nst<=idle;
                  end					 
                end   
		 read:begin
		       rd<=1;
				 o_sl_dbus<=data_out;
				 o_sl_xferack<=1;
				 o_sl_fullack<=1;
				 nst<=readwait;
				end 
		 done:begin
		       cs<=0;
				 wr<=0;
				 rd<=0;
				 o_sl_xferack<=1;
				 nst<=idle;
				end
       default:
		         nst<=idle;
               		 
	endcase
  //end
 end	
endmodule
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:29:56 11/27/2013 
// Design Name: 
// Module Name:    slavebusint 
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
module slavebusint(opb_dbus,reset,opb_abus,clk,opb_select,opb_rnw,o_sl_dbus,o_sl_xferack,o_sl_fullack,rd,wr,cs,opb_clk,opb_addrs,data_in,data_out);
    input [31:0] opb_dbus;
    input [15:0]opb_abus;
	 input [31:0]data_out;
	 input opb_clk,reset;
	 input opb_select;
    input opb_rnw;
    output [31:0] o_sl_dbus,data_in;
    output o_sl_xferack;
    output o_sl_fullack;
    output rd;
    output wr;
    output cs;
    output clk;
    output[15:0]  opb_addrs;
    reg o_sl_xferack,o_sl_fullack,rd,wr,cs,clk;
	 reg[15:0] opb_addrs;
	 reg [31:0] o_sl_dbus,data_in;
    reg[2:0] nst;
	 integer readcount;
	 parameter idle=3'b000,write=3'b001,read=3'b010,readwait=3'b011,done=3'b100;
	 always @(posedge opb_clk or posedge reset )
	  begin 
	  if (reset==1)
				 begin
				  rd<=0;
				  wr<=0;
				  o_sl_xferack<=1'b0;
				  o_sl_fullack<=1'b0;
				  //clk<=opb_clk;
				  end
			else
			//begin
			//clk<=opb_clk;
		case(nst)
		idle:begin				 
				 begin
				 if(opb_select==1)// && opb_abus >16'b0000000000000000 && opb_abus <15'b1111111111111111

              begin
               cs<=1;
               opb_addrs<=opb_abus;	
               if(opb_rnw==0)
                 begin
					  wr<=1;
					  nst<=write;
					  end 


					else
                 nst<=read;
               end 					  
	          else
              begin
				  wr<=0;
				  rd<=0;
				  o_sl_xferack<=1'b0;
              o_sl_fullack<=1'b0;
				  nst<=idle;
              end                
	          end				 
				end 				  
       write:begin
		       wr<=1;
				 data_in<=opb_dbus;
				 o_sl_xferack<=1;
				 o_sl_fullack<=1;
				 nst<=done;
				 end
		 readwait:begin
		           if (readcount<2)
		            begin
                   readcount<=readcount+1;
                   nst<=readwait;
                  end
                 else
                  begin 					  
                   readcount<=0;
					   nst<=idle;
                  end					 
                end   
		 read:begin
		       rd<=1;
				 o_sl_dbus<=data_out;
				 o_sl_xferack<=1;
				 o_sl_fullack<=1;
				 nst<=readwait;
				end 
		 done:begin
		       cs<=0;
				 wr<=0;
				 rd<=0;
				 o_sl_xferack<=1;
				 nst<=idle;
				end
       default:
		         nst<=idle;
               		 
	endcase
  //end
 end	
endmodule
