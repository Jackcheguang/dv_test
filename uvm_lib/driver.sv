class adder_driver extends uvm_driver #(adder_transaction);
  `uvm_component_utils(adder_driver)
  
  virtual adder_if vif;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_build_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual adder_if)::get(this, "", "vif", vif))
      `uvm_fatal("NOVIF", "Virtual interface not set")
  endfunction
  
  task run_phase(uvm_run_phase phase);
    adder_transaction tr;
    forever begin
      seq_item_port.get_next_item(tr);
      vif.cb.a <= tr.a;
      vif.cb.b <= tr.b;
      @(vif.cb);
      seq_item_port.item_done();
    end
  endtask
endclass