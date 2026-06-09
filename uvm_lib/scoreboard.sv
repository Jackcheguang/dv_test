class adder_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(adder_scoreboard)
  
  uvm_analysis_imp #(adder_transaction, adder_scoreboard) imp;
  
  int pass_count = 0;
  int fail_count = 0;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_build_phase phase);
    super.build_phase(phase);
    imp = new("imp", this);
  endfunction
  
  function void write(adder_transaction tr);
    logic [8:0] expected_sum;
    expected_sum = tr.a + tr.b;
    
    if(tr.valid) begin
      if(tr.sum == expected_sum) begin
        `uvm_info("SCOREBOARD", $sformatf("PASS: %s", tr.convert2string()), UVM_LOW)
        pass_count++;
      end else begin
        `uvm_error("SCOREBOARD", $sformatf("FAIL: Expected sum=0x%03h, got 0x%03h | %s", expected_sum, tr.sum, tr.convert2string()))
        fail_count++;
      end
    end
  endfunction
  
  function void report_phase(uvm_report_phase phase);
    super.report_phase(phase);
    `uvm_info("SCOREBOARD", $sformatf("Test Results: PASS=%0d, FAIL=%0d", pass_count, fail_count), UVM_LOW)
  endfunction
endclass