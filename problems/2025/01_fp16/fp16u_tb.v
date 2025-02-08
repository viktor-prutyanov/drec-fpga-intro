module fp16u_tb;

reg clk = 1'b0;

always begin
    #1 clk <= ~clk;
end

wire [15:0] a, b, c, z;

wire       z_sign = z[15];
wire [4:0] z_bexp = z[14:10];
wire [9:0] z_mant = z[9:0];

wire       c_sign = c[15];
wire [4:0] c_bexp = c[14:10];
wire [9:0] c_mant = c[9:0];

fp16`TEST_OP fp16`TEST_OP (
    .i_a      (a),
    .i_b      (b),
    .o_res    (c)
);

reg [3*16-1:0] test[`TEST_SIZE];
reg [$clog2(`TEST_SIZE)-1:0] idx = 0;

reg ok, pass = 1;

assign {a, b, z} = test[idx];

initial begin
    $readmemh("test.txt", test);
end

wire signed [14:0] diff = $signed(c[14:0]) - $signed(z[14:0]);

always @(*) begin
    if (z_bexp == 5'h0) // Zero/denormal
        ok = (c_bexp == 5'h00) && (c_mant == 10'h0) && (c_sign == z_sign);
    else if (z_bexp == 5'h1F) // Inf/NaN
        ok = (c_bexp == 5'h1F) && (c_mant == 10'h0) && (c_sign == z_sign);
    else
        ok = ($abs(diff) < 2) && (c_sign == z_sign);
end

always @(posedge clk) begin
    idx <= idx + 1;
    if (`DEBUG || !ok) begin
        $display("[%d] %h %h -> %h z=%h ok=%d", idx, a, b, c, z, ok);
    end
    pass <= ok ? pass : 0;
    if (idx == `TEST_SIZE-1) begin
        $display("Result: %s", pass ? "PASS" : "FAIL");
        $finish;
    end
end

initial begin
    $dumpvars;
    $display("Test size: %d", `TEST_SIZE);
end

endmodule