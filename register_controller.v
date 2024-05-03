module register_controller #(parameter 
    DATA_WIDTH = 16
) (
    input [DATA_WIDTH-1:0] din,
    input [4:0] wad1,
    input [4:0] rad1, rad2,
    input wen1, ren1, ren2,
    input clk,
    input resetn,
    output [DATA_WIDTH-1:0] dout1, dout2,
    output reg collision
);
reg [DATA_WIDTH-1:0] reg_file[0:31];
reg access_bit [0:31];
reg [DATA_WIDTH-1:0] dout1_temp, dout2_temp;
wire collision_condition;

assign collision_condition = ((rad1 == rad2) & ren1 & ren2) | ((rad2 == wad1) & wen1 & ren2) | ((rad1 == wad1) & wen1 & ren2);

always @(posedge clk) begin
    if (!resetn)
        dout1_temp <= 0;
    else begin
        if (ren1)begin
            if (access_bit[rad1])
                dout1_temp <= reg_file[rad1];
            else
                dout1_temp <= 0;
        end
    end
end

always @(posedge clk) begin
    if (!resetn)
        dout2_temp <= 0;
    else begin
        if (ren2) begin
            if (access_bit[rad2]) 
                dout2_temp <= reg_file[rad2];
            else
                dout2_temp <= 0;
        end
    end
end

always @(posedge clk) begin
    if (!resetn)
        collision <= 0;
    else if (collision_condition)
            collision <= 1'b 1;
end

always @(posedge clk) begin
    if (wen1) begin
        reg_file[wad1] <= din;
        access_bit[wad1] <= 1'b 1;
    end
end
assign dout1 = (collision) ? 0 : dout1_temp;
assign dout2 = (collision) ? 0 : dout2_temp; 
endmodule
