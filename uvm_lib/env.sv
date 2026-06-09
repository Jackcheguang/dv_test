class adder_env extends uvm_env;
  `uvm_component_utils(adder_env)
  
  adder_sequencer sequencer;
  adder_driver driver;
  adder_monitor monitor;
  adder_scoreboard scoreboard;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_build_phase phase);
    super.build_phase(phase);
    sequencer = adder_sequencer::type_id::create("sequencer", this);
    driver = adder_driver::type_id::create("driver", this);
    monitor = adder_monitor::type_id::create("monitor", this);
    scoreboard = adder_scoreboard::type_id::create("scoreboard", this);
  endfunction
  
  function void connect_phase(uvm_connect_phase phase);
    super.connect_phase(phase);
    driver.seq_item_port.connect(sequencer.seq_item_export);
    monitor.ap.connect(scoreboard.imp);
  endfunction
endclass