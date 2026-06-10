// valid/ready Protocol Interface
// SystemVerilog interface for valid/ready protocol signals

interface valid_ready_interface(
  input logic clk,
  input logic rst_n
);

  // Protocol Signals (527-bit payload)
  logic [7:0]    space_id;      // [526:519] Application space ID
  logic [1:0]    ctxt_id;       // [518:517] Context ID
  logic [2:0]    gsm_id;        // [516:514] Shared-memory index
  logic [3:0]    seq_id;        // [513:510] Warp sequence ID
  logic [2:0]    warp_id;       // [509:507] Warp ID
  logic [1:0]    ie_id;         // [506:505] IE ID
  logic [7:0]    req_id;        // [504:497] LSU request ID
  logic [5:0]    opcode;        // [496:491] Operation opcode
  logic [3:0]    atom_op;       // [490:487] Atomic opcode
  logic [2:0]    ele_cnt;       // [486:484] Element count
  logic [3:0]    datatype;      // [483:480] Data type
  logic [31:0]   thread_mask;   // [479:448] Thread mask
  logic [447:0]  address;       // [447:0]   14-bit per thread addresses

  // Handshake signals
  logic valid;                  // Valid signal from master
  logic ready;                  // Ready signal from slave

  // Clocking block for testbench
  clocking cb @(posedge clk);
    default input #1 output #1;
    output space_id, ctxt_id, gsm_id, seq_id, warp_id, ie_id, req_id;
    output opcode, atom_op, ele_cnt, datatype, thread_mask, address, valid;
    input ready;
  endclocking

  // Modport for driver
  modport driver_mp (
    clocking cb,
    input clk, rst_n
  );

  // Modport for monitor
  modport monitor_mp (
    input space_id, ctxt_id, gsm_id, seq_id, warp_id, ie_id, req_id,
    input opcode, atom_op, ele_cnt, datatype, thread_mask, address,
    input valid, ready, clk, rst_n
  );

  // Modport for DUT
  modport dut_mp (
    input space_id, ctxt_id, gsm_id, seq_id, warp_id, ie_id, req_id,
    input opcode, atom_op, ele_cnt, datatype, thread_mask, address,
    input valid, clk, rst_n,
    output ready
  );

endinterface
