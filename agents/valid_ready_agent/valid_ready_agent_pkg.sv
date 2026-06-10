// valid/ready Agent Package
// Includes all agent-related classes

`ifndef VALID_READY_AGENT_SV
`define VALID_READY_AGENT_SV

package valid_ready_agent_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  // Include transaction class
  `include "valid_ready_transaction.sv"
  
  // Include driver
  `include "valid_ready_driver.sv"
  
  // Include sequencer and sequences
  `include "valid_ready_sequence.sv"
  
  // Include monitor
  `include "valid_ready_monitor.sv"
  
  // Include agent
  `include "valid_ready_agent.sv"

endpackage: valid_ready_agent_pkg

`endif // VALID_READY_AGENT_SV
