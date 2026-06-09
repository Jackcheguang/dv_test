class adder_transaction extends uvm_sequence_item;
  rand logic [7:0] a, b;
  logic [8:0] sum;
  logic valid;
  
  `uvm_object_utils(adder_transaction)
  
  function new(string name = "adder_transaction");
    super.new(name);
  endfunction
  
  function string convert2string();
    return $sformatf("a=0x%02h, b=0x%02h, sum=0x%03h, valid=%b", a, b, sum, valid);
  endfunction
endclass