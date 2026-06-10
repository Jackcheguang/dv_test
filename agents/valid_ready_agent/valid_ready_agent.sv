// valid/ready Protocol Agent
// Top-level agent that combines driver, sequencer, and monitor

class valid_ready_agent extends uvm_agent;
  `uvm_component_utils(valid_ready_agent)

  // Agent components
  valid_ready_driver     driver;
  valid_ready_sequencer  sequencer;
  valid_ready_monitor    monitor;

  // Configuration
  uvm_active_passive_enum is_active = UVM_ACTIVE;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_build_phase phase);
    super.build_phase(phase);
    
    monitor = valid_ready_monitor::type_id::create("monitor", this);
    
    if(is_active == UVM_ACTIVE) begin
      driver = valid_ready_driver::type_id::create("driver", this);
      sequencer = valid_ready_sequencer::type_id::create("sequencer", this);
    end
  endfunction

  function void connect_phase(uvm_connect_phase phase);
    super.connect_phase(phase);
    
    if(is_active == UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction

endclass
