// valid/ready Protocol Sequencer
// Sequencer for generating test sequences

class valid_ready_sequencer extends uvm_sequencer #(valid_ready_transaction);
  `uvm_component_utils(valid_ready_sequencer)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

endclass

// Base Sequence
class valid_ready_base_seq extends uvm_sequence #(valid_ready_transaction);
  `uvm_object_utils(valid_ready_base_seq)

  function new(string name = "valid_ready_base_seq");
    super.new(name);
  endfunction

  task body();
    `uvm_info("BASE_SEQ", "Base sequence started", UVM_MEDIUM)
  endtask

endclass

// Single Transaction Sequence
class valid_ready_single_seq extends valid_ready_base_seq;
  `uvm_object_utils(valid_ready_single_seq)

  rand bit [5:0] opcode_type;  // 0-7
  rand bit [7:0] num_transactions;

  function new(string name = "valid_ready_single_seq");
    super.new(name);
    num_transactions = 1;
  endfunction

  task body();
    valid_ready_transaction tr;
    
    repeat(num_transactions) begin
      tr = valid_ready_transaction::type_id::create("tr");
      start_item(tr);
      
      if(!tr.randomize() with {
        opcode == opcode_type;
        valid == 1'b1;
      }) begin
        `uvm_fatal("SEQ", "Randomization failed")
      end
      
      `uvm_info("SEQ", $sformatf("Sending transaction:\n%s", tr.convert2string()), UVM_HIGH)
      finish_item(tr);
    end
  endtask

endclass

// Load Operation Sequence
class valid_ready_load_seq extends valid_ready_base_seq;
  `uvm_object_utils(valid_ready_load_seq)

  rand bit [7:0] num_loads;

  function new(string name = "valid_ready_load_seq");
    super.new(name);
    num_loads = 10;
  endfunction

  task body();
    valid_ready_transaction tr;
    
    repeat(num_loads) begin
      tr = valid_ready_transaction::type_id::create("tr");
      start_item(tr);
      
      if(!tr.randomize() with {
        opcode == 6'h0;  // ld = 0
        valid == 1'b1;
      }) begin
        `uvm_fatal("SEQ", "Randomization failed")
      end
      
      finish_item(tr);
    end
  endtask

endclass

// Store Operation Sequence
class valid_ready_store_seq extends valid_ready_base_seq;
  `uvm_object_utils(valid_ready_store_seq)

  rand bit [7:0] num_stores;

  function new(string name = "valid_ready_store_seq");
    super.new(name);
    num_stores = 10;
  endfunction

  task body();
    valid_ready_transaction tr;
    
    repeat(num_stores) begin
      tr = valid_ready_transaction::type_id::create("tr");
      start_item(tr);
      
      if(!tr.randomize() with {
        opcode == 6'h1;  // st = 1
        valid == 1'b1;
      }) begin
        `uvm_fatal("SEQ", "Randomization failed")
      end
      
      finish_item(tr);
    end
  endtask

endclass

// Atomic Operation Sequence
class valid_ready_atomic_seq extends valid_ready_base_seq;
  `uvm_object_utils(valid_ready_atomic_seq)

  rand bit [7:0] num_atomics;
  rand bit [3:0] atomic_op_type;  // 0-8

  function new(string name = "valid_ready_atomic_seq");
    super.new(name);
    num_atomics = 5;
  endfunction

  task body();
    valid_ready_transaction tr;
    
    repeat(num_atomics) begin
      tr = valid_ready_transaction::type_id::create("tr");
      start_item(tr);
      
      if(!tr.randomize() with {
        opcode == 6'h7;  // atomic = 7
        atom_op == atomic_op_type;
        valid == 1'b1;
      }) begin
        `uvm_fatal("SEQ", "Randomization failed")
      end
      
      finish_item(tr);
    end
  endtask

endclass

// Stress Sequence - Mixed Operations
class valid_ready_stress_seq extends valid_ready_base_seq;
  `uvm_object_utils(valid_ready_stress_seq)

  rand bit [15:0] num_transactions;

  function new(string name = "valid_ready_stress_seq");
    super.new(name);
    num_transactions = 100;
  endfunction

  task body();
    valid_ready_transaction tr;
    
    repeat(num_transactions) begin
      tr = valid_ready_transaction::type_id::create("tr");
      start_item(tr);
      
      if(!tr.randomize() with {
        valid == 1'b1;
        thread_mask != 32'h0;
      }) begin
        `uvm_fatal("SEQ", "Randomization failed")
      end
      
      finish_item(tr);
    end
  endtask

endclass