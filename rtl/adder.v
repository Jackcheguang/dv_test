module adder(
  input [7:0] a, b,
  input rst_n, clk,
  output [8:0] sum,
  output valid
);
  reg [8:0] sum_r;
  reg valid_r;
  
  always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      sum_r <= 0;
      valid_r <= 0;
    end else begin
      sum_r <= a + b;
      valid_r <= 1;
    end
  end
  
  assign sum = sum_r;
  assign valid = valid_r;
endmodule