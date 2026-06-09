class adder_monitor extends uvm_monitor;
  `uvm_component_utils(adder_monitor)
  
  virtual adder_if vif;
  uvm_analysis_port #(adder_transaction) ap;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_build_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual adder_if)::get(this, "", "vif", vif))
      `uvm_fatal("NOVIF", "Virtual interface not set")
    ap = new("ap", this);
  endfunction
  
  task run_phase(uvm_run_phase phase);
    adder_transaction tr;
    forever begin
      @(vif.cb);
      tr = adder_transaction::type_id::create("tr");
      tr.a = vif.cb.a;
      tr.b = vif.cb.b;
      tr.sum = vif.cb.sum;
      tr.valid = vif.cb.valid;
      ap.write(tr);
    end
  endtask
endclass