module hex2seg(input wire [3:0]hex, 
				   output reg [6:0]seg); // seg = {A, B, C, .. G}

always @(*)
begin				
	case (hex)
	4'h0: seg = 7'b1111110;
	4'h1: seg = 7'b0110000;
	4'h2: seg = 7'b1101101;
	4'h3: seg = 7'b1111001;
	4'h4: seg = 7'b0110011;
	4'h5: seg = 7'b1011011;

	default: seg = 7'b1111111;
	endcase
end


endmodule