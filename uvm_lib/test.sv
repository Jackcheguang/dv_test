class adder_base_test extends uvm_test;
  `uvm_component_utils(adder_base_test)
  
  adder_env env;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_build_phase phase);
    super.build_phase(phase);
    env = adder_env::type_id::create("env", this);
  endfunction
endclass

class adder_random_test extends adder_base_test;
  `uvm_component_utils(adder_random_test)
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  task run_phase(uvm_run_phase phase);
    adder_sequence seq;
    phase.raise_objection(this);
    `uvm_info("TEST", "Starting adder_random_test", UVM_LOW)
    seq = adder_sequence::type_id::create("seq");
    seq.start(env.sequencer);
    #100;
    phase.drop_objection(this);
  endtask
endclass

class adder_directed_test extends adder_base_test;
  `uvm_component_utils(adder_directed_test)
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  task run_phase(uvm_run_phase phase);
    adder_directed_sequence seq;
    phase.raise_objection(this);
    `uvm_info("TEST", "Starting adder_directed_test", UVM_LOW)
    seq = adder_directed_sequence::type_id::create("seq");
    seq.start(env.sequencer);
    #100;
    phase.drop_objection(this);
  endtask
endclass