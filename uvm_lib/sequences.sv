class adder_sequence extends uvm_sequence #(adder_transaction);
  `uvm_object_utils(adder_sequence)
  
  function new(string name = "adder_sequence");
    super.new(name);
  endfunction
  
  task body();
    adder_transaction tr;
    `uvm_info("SEQ", "Starting adder_sequence", UVM_LOW)
    repeat(10) begin
      tr = adder_transaction::type_id::create("tr");
      start_item(tr);
      assert(tr.randomize());
      `uvm_info("SEQ", $sformatf("Sending transaction: a=0x%02h, b=0x%02h", tr.a, tr.b), UVM_HIGH)
      finish_item(tr);
    end
  endtask
endclass

class adder_directed_sequence extends uvm_sequence #(adder_transaction);
  `uvm_object_utils(adder_directed_sequence)
  
  function new(string name = "adder_directed_sequence");
    super.new(name);
  endfunction
  
  task body();
    adder_transaction tr;
    logic [7:0] test_vectors_a[] = {8'h00, 8'h01, 8'hFF, 8'h7F, 8'h80};
    logic [7:0] test_vectors_b[] = {8'h00, 8'h01, 8'hFF, 8'h7F, 8'h80};
    
    `uvm_info("SEQ", "Starting adder_directed_sequence", UVM_LOW)
    foreach(test_vectors_a[i]) begin
      tr = adder_transaction::type_id::create("tr");
      start_item(tr);
      tr.a = test_vectors_a[i];
      tr.b = test_vectors_b[i];
      `uvm_info("SEQ", $sformatf("Sending directed test: a=0x%02h, b=0x%02h", tr.a, tr.b), UVM_HIGH)
      finish_item(tr);
    end
  endtask
endclass