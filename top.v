`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:35:24 02/17/2014 
// Design Name: 
// Module Name:    top 
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
module top(m_ss_bar,reset,m_sclk,data_out,MOSI_2,s_ss_bar,s_sclk,MOSI_1,opb_abus,opb_dbus,opb_select,opb_rnw,opb_clk,opb_dataout);//,o_sl_dbus,o_sl_xferack,o_sl_fullack);
	 input [31:0] opb_dbus;
    input [15:0]opb_abus;
	 input [31:0]data_out;
	 input opb_clk,reset;
	 input opb_select;
    input opb_rnw;
	 wire read,cs,clk,rd,wr;
	 wire [31:0]data_in;
	 wire [15:0]opb_addrs;
	 input s_ss_bar,s_sclk,MOSI_1;
	 output [31:0] opb_dataout;
	 output m_sclk,m_ss_bar,MOSI_2;
	 reg [31:0] opb_dataout;
	 wire m_sclk,m_ss_bar,MOSI_2;
	 wire [0:7] MISO;
	 wire [15:0]address;
	 wire [31:0] opb_datain;
	 wire [31:0] data_in_opb,data_out_m,data_out_s;
    wire [31:0] o_sl_dbus;
    wire o_sl_xferack;
    wire o_sl_fullack;
	 

serialclockdvdr m1 (
    .write(wr), 
    .m_ss_bar(m_ss_bar), 
    .reset(reset), 
    .clock(opb_clk), 
    .m_sclk(m_sclk), 
    .address(address), 
    .opb_datain(data_in), 
    .opb_dataout(data_out_m), 
    .read(rd), 
    .cs(cs), 
    .MOSI_2(MOSI_2)
    );


// Instantiate the module
slaveclocksipo m2(
    .s_ss_bar(s_ss_bar), 
    .s_sclk(s_sclk), 
    .MOSI_1(MOSI_1), 
    .reset(reset), 
    .cs(cs), 
    .address(address), //y
    .clock(opb_clk), 
    .read(rd), 
    .opb_dataout(data_out_s),
	 .MISO(MISO)
    );

slavebusint m3(
    .opb_dbus(opb_dbus), 
    .reset(reset), 
    .opb_abus(opb_abus), 
    //.clk(clk), 
    .opb_select(opb_select), 
    .opb_rnw(opb_rnw), 
    .rd(rd),
    .wr(wr), 
    .cs(cs), 
    .opb_clk(opb_clk), 
    .opb_addrs(address), //x
    .data_in(data_in), 
    .data_out(data_in_opb),
	 .o_sl_dbus (o_sl_dbus),
    .o_sl_xferack (o_sl_xferack),
    .o_sl_fullack (o_sl_fullack)
	 );

assign data_in_opb = (data_out_m || data_out_s);

endmodule
