// valid/ready Protocol Transaction
// Based on interface specification with 527-bit payload

class valid_ready_transaction extends uvm_sequence_item;
  `uvm_object_utils(valid_ready_transaction)

  // Protocol Fields
  rand bit [7:0]    space_id;      // [526:519] The application space ID of current kernel, sent by TD
  rand bit [1:0]    ctxt_id;       // [518:517] The context_id maintained by TFC, TFC support 4 context run in parallel
  rand bit [2:0]    gsm_id;        // [516:514] The shared-memory index for current block
  rand bit [3:0]    seq_id;        // [513:510] Warp sequence ID
  rand bit [2:0]    warp_id;       // [509:507] Warp ID
  rand bit [1:0]    ie_id;         // [506:505] IE ID
  rand bit [7:0]    req_id;        // [504:497] LSU request ID
  rand bit [5:0]    opcode;        // [496:491] The operation opcode
  rand bit [3:0]    atom_op;       // [490:487] opcode for atomic, reserved for others
  rand bit [2:0]    ele_cnt;       // [486:484] element count
  rand bit [3:0]    datatype;      // [483:480] data type
  rand bit [31:0]   thread_mask;   // [479:448] thread mask indicates which thread in the warp is active
  rand bit [447:0]  address;       // [447:0]   14-bit per thread addresses (32 threads * 14-bit)

  // Control signals
  rand bit valid;
  bit ready;

  // Constraints
  constraint opcode_valid {
    opcode inside {[0:7]};  // ld=0, st=1, sld=2, sst=3, bld=4, bst=5, bred=6, atomic=7
  }

  constraint atom_op_valid {
    atom_op inside {[0:8]};  // ATADD=0 to ATCAS=8
  }

  constraint ele_cnt_valid {
    ele_cnt inside {[0:7]};
  }

  constraint datatype_valid {
    datatype inside {[0:15]};
  }

  constraint thread_mask_valid {
    thread_mask != 32'h0;  // At least one thread must be active
  }

  function new(string name = "valid_ready_transaction");
    super.new(name);
  endfunction

  function void do_copy(uvm_object rhs);
    valid_ready_transaction rhs_;
    if(!$cast(rhs_, rhs)) begin
      `uvm_fatal("COPY", "Cast failed during copy operation")
    end
    super.do_copy(rhs);
    space_id   = rhs_.space_id;
    ctxt_id    = rhs_.ctxt_id;
    gsm_id     = rhs_.gsm_id;
    seq_id     = rhs_.seq_id;
    warp_id    = rhs_.warp_id;
    ie_id      = rhs_.ie_id;
    req_id     = rhs_.req_id;
    opcode     = rhs_.opcode;
    atom_op    = rhs_.atom_op;
    ele_cnt    = rhs_.ele_cnt;
    datatype   = rhs_.datatype;
    thread_mask = rhs_.thread_mask;
    address    = rhs_.address;
    valid      = rhs_.valid;
    ready      = rhs_.ready;
  endfunction

  function bit do_compare(uvm_object rhs, uvm_comparer comparer);
    valid_ready_transaction rhs_;
    if(!$cast(rhs_, rhs)) begin
      `uvm_error("COMPARE", "Cast failed during compare operation")
      return 0;
    end
    return super.do_compare(rhs_, comparer) &&
           (space_id == rhs_.space_id) &&
           (ctxt_id == rhs_.ctxt_id) &&
           (gsm_id == rhs_.gsm_id) &&
           (seq_id == rhs_.seq_id) &&
           (warp_id == rhs_.warp_id) &&
           (ie_id == rhs_.ie_id) &&
           (req_id == rhs_.req_id) &&
           (opcode == rhs_.opcode) &&
           (atom_op == rhs_.atom_op) &&
           (ele_cnt == rhs_.ele_cnt) &&
           (datatype == rhs_.datatype) &&
           (thread_mask == rhs_.thread_mask) &&
           (address == rhs_.address);
  endfunction

  function string convert2string();
    string s;
    s = $sformatf("valid_ready_transaction:\n");
    s = {s, $sformatf("  space_id=%0h, ctxt_id=%0h, gsm_id=%0h\n", space_id, ctxt_id, gsm_id)};
    s = {s, $sformatf("  seq_id=%0h, warp_id=%0h, ie_id=%0h\n", seq_id, warp_id, ie_id)};
    s = {s, $sformatf("  req_id=%0h, opcode=%0h, atom_op=%0h\n", req_id, opcode, atom_op)};
    s = {s, $sformatf("  ele_cnt=%0h, datatype=%0h\n", ele_cnt, datatype)};
    s = {s, $sformatf("  thread_mask=%032b\n", thread_mask)};
    s = {s, $sformatf("  address=0x%0h\n", address)};
    s = {s, $sformatf("  valid=%0b, ready=%0b", valid, ready)};
    return s;
  endfunction

endclass
