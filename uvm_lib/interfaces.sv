interface adder_if(input clk);
  logic rst_n;
  logic [7:0] a, b;
  logic [8:0] sum;
  logic valid;
  
  clocking cb @(posedge clk);
    output a, b, rst_n;
    input sum, valid;
  endclocking
  
  modport tb(clocking cb);
  modport dut(input a, b, rst_n, clk, output sum, valid);
endinterface