// valid/ready Protocol Monitor
// Monitors protocol signals and samples transactions from the interface

class valid_ready_monitor extends uvm_monitor;
  `uvm_component_utils(valid_ready_monitor)

  virtual valid_ready_interface vif;
  uvm_analysis_port #(valid_ready_transaction) ap;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_build_phase phase);
    super.build_phase(phase);
    ap = new("ap", this);
    if(!uvm_config_db#(virtual valid_ready_interface)::get(this, "", "vif", vif))
      `uvm_fatal("NOVIF", "Virtual interface not found")
  endfunction

  task run_phase(uvm_run_phase phase);
    super.run_phase(phase);
    forever begin
      monitor_transaction();
    end
  endtask

  task monitor_transaction();
    valid_ready_transaction tr;
    
    // Wait for valid signal
    @(posedge vif.clk);
    while(vif.valid !== 1'b1) begin
      @(posedge vif.clk);
    end

    // Capture transaction data when valid and ready
    tr = valid_ready_transaction::type_id::create("tr");
    
    tr.space_id    = vif.space_id;
    tr.ctxt_id     = vif.ctxt_id;
    tr.gsm_id      = vif.gsm_id;
    tr.seq_id      = vif.seq_id;
    tr.warp_id     = vif.warp_id;
    tr.ie_id       = vif.ie_id;
    tr.req_id      = vif.req_id;
    tr.opcode      = vif.opcode;
    tr.atom_op     = vif.atom_op;
    tr.ele_cnt     = vif.ele_cnt;
    tr.datatype    = vif.datatype;
    tr.thread_mask = vif.thread_mask;
    tr.address     = vif.address;
    tr.valid       = vif.valid;

    // Wait for handshake
    fork
      begin
        repeat(1000) @(posedge vif.clk);  // Timeout
        `uvm_warning("MONITOR", "Timeout waiting for ready signal")
      end
      begin
        wait(vif.ready == 1'b1);
      end
    join_any
    disable fork;

    tr.ready = vif.ready;

    // Write to analysis port
    ap.write(tr);
    `uvm_info("MONITOR", $sformatf("Transaction captured:\n%s", tr.convert2string()), UVM_HIGH)

    @(posedge vif.clk);
  endtask

endclass