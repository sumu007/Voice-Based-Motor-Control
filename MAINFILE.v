
//=======================================================
//  This code is generated by Terasic System Builder
//=======================================================

module MAINFILE(



	//////////// CLOCK //////////
	input 		          		FPGA_CLK1_50,
	input 		          		FPGA_CLK2_50,
	input 		          		FPGA_CLK3_50,


	//////////// KEY //////////
	input 		     [1:0]		KEY,
//	input				  [1:0]     KEYMOTOR,

	//////////// LED //////////
	output		[7:0]		LED,

	//////////// SW //////////
	input 		     [3:0]		SW,

	//////////// GPIO_0, GPIO connect to RFS //////////
	inout 		          		BT_KEY,
	input 		          		BT_UART_RX,
	output		          		BT_UART_TX,
	
		//////////// Motor Control //////////
	inout		[5:0]		GPIO_1
	
);



//=======================================================
//  REG/WIRE declarations
//=======================================================

wire 				rts; // request to send		  
wire 				cts; // clear to send
wire 				rxd;
wire 				txd;
wire	 [7:0]   uart_data;
wire	         rdempty;
wire	         write;
reg	     	   read;
reg	         cnt;
wire    [7:0]   LEDFake;
wire    [7:0]   command; // output from bluetooth to input to motor module
//=======================================================
//  Structural coding
//=======================================================

// UART Controller
uart_control UART0(

	.clk(FPGA_CLK1_50),
	.reset_n(KEY[0]),

	// rx
	.read(read),
	.readdata(uart_data),
	.rdempty(rdempty),
	//
	.uart_clk_25m(cnt),
	.uart_rx(BT_UART_RX)
	
);	

//read
always@(posedge FPGA_CLK1_50)
begin
  if (~rdempty)
		read <= 1;
  else
		read <= 0;
end
assign  write = ( read & (~rdempty) );


commandSelector c0 (FPGA_CLK1_50,
					KEY[0],
					write,
					uart_data,
					LED,
					command
					);

ServoControl S0(FPGA_CLK1_50,
						  FPGA_CLK2_50,
	                 FPGA_CLK3_50,
						  command,
						  LEDFake,
						  SW,
						  GPIO_1
						  );

always@(posedge FPGA_CLK1_50)
	cnt <= cnt + 1;


endmodule