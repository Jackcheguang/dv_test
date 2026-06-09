module top;
  logic clk, rst_n;
  
  adder_if intf(clk);
  
  adder dut(
    .a(intf.a),
    .b(intf.b),
    .clk(clk),
    .rst_n(intf.rst_n),
    .sum(intf.sum),
    .valid(intf.valid)
  );
  
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end
  
  initial begin
    rst_n = 0;
    #20 rst_n = 1;
  end
  
  initial begin
    uvm_config_db#(virtual adder_if)::set(null, "*", "vif", intf);
    run_test();
  end
  
  initial begin
    #10000 $finish();
  end
endmodule