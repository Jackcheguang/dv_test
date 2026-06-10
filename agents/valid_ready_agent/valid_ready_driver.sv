// valid/ready Protocol Driver
// Drives protocol signals on the interface based on transactions

class valid_ready_driver extends uvm_driver #(valid_ready_transaction);
  `uvm_component_utils(valid_ready_driver)

  virtual valid_ready_interface vif;
  valid_ready_transaction tr;

  // Configuration
  int ready_delay = 0;  // Delay before asserting ready signal
  bit allow_backpressure = 1'b1;  // Allow ready to deassert

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_build_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual valid_ready_interface)::get(this, "", "vif", vif))
      `uvm_fatal("NOVIF", "Virtual interface not found")
  endfunction

  task run_phase(uvm_run_phase phase);
    super.run_phase(phase);
    forever begin
      seq_item_port.get_next_item(tr);
      drive_transaction(tr);
      seq_item_port.item_done();
    end
  endtask

  task drive_transaction(valid_ready_transaction transaction);
    // Pack transaction data onto interface
    vif.space_id    <= transaction.space_id;
    vif.ctxt_id     <= transaction.ctxt_id;
    vif.gsm_id      <= transaction.gsm_id;
    vif.seq_id      <= transaction.seq_id;
    vif.warp_id     <= transaction.warp_id;
    vif.ie_id       <= transaction.ie_id;
    vif.req_id      <= transaction.req_id;
    vif.opcode      <= transaction.opcode;
    vif.atom_op     <= transaction.atom_op;
    vif.ele_cnt     <= transaction.ele_cnt;
    vif.datatype    <= transaction.datatype;
    vif.thread_mask <= transaction.thread_mask;
    vif.address     <= transaction.address;
    vif.valid       <= transaction.valid;

    // Wait for ready signal with timeout
    if(transaction.valid) begin
      repeat(ready_delay) @(posedge vif.clk);
      
      fork
        begin
          repeat(1000) @(posedge vif.clk);  // Timeout after 1000 cycles
          `uvm_error("TIMEOUT", $sformatf("Ready signal not received for transaction:\n%s", transaction.convert2string()))
        end
        begin
          wait(vif.ready == 1'b1);
          `uvm_info("DRIVER", $sformatf("Transaction accepted:\n%s", transaction.convert2string()), UVM_HIGH)
        end
      join_any
      disable fork;

      @(posedge vif.clk);
      vif.valid <= 1'b0;
    end else begin
      @(posedge vif.clk);
    end
  endtask

  function void connect_phase(uvm_connect_phase phase);
    super.connect_phase(phase);
  endfunction

endclass
