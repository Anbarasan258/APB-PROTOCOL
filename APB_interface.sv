interface APB_interface(input bit PCLK);
  logic PRST_N,APB_READ_WRITE,APB_TRANSFER,APB_DONE,APB_ERROR,APB_ENABLE,APB_SEL;
  logic [3:0] APB_STROBE;
  logic [2:0] APB_PROTECT;
  logic [31:0]APB_ADDR;
  logic [31:0]APB_WDATA;
  logic [31:0]APB_RDATA;
  

// reset checking

property reset;
  @(posedge PCLK)
  !PRST_N |-> !(APB_ENABLE && APB_SEL);
endproperty

// Setup Phase to access phase Validation  
property setup_phase_check;
  @(posedge PCLK)
  disable iff(!PRST_N)
  (APB_SEL && !APB_ENABLE) |=> (APB_ENABLE);
endproperty
  
// data stabiltiy Validation
 property data_stability;
  @(posedge PCLK)
  disable iff(!PRST_N)
   (APB_SEL && $rose(APB_ENABLE)) |-> $stable({APB_STROBE,APB_PROTECT,APB_ADDR,APB_WDATA});
endproperty
  
// PREADY SIGNAL CHECK AND WAIT STATE CHECK
property pready_check;
  @(posedge PCLK)
  disable iff(!PRST_N)
  (APB_SEL && $rose(APB_ENABLE)) |-> ##[0:$] APB_DONE;
endproperty
  
// Transfer Completion  check
  property transfer_check;
     @(posedge PCLK) disable iff(!PRST_N)
    APB_DONE |=> !APB_ENABLE;
  endproperty

//Error Handling 
  property error_check;
    @(posedge PCLK) disable iff(!PRST_N)
    APB_ERROR |-> APB_DONE;
  endproperty
  
// // Strobe check
//   property strobe_check;
//     @(posedge PCLK) disable iff(!PRST_N)
//     (APB_SEL && (APB_ENABLE)) |-> if(APB_READ_WRITE)
//                                    (APB_STROBE !=4'd0 )
//                                   else
//                                     (APB_STROBE == 4'd0);
//   endproperty

// write check
  property write_check;
    @(posedge PCLK) disable iff(!PRST_N)
    (APB_SEL && APB_ENABLE && APB_READ_WRITE) |-> !$isunknown(APB_WDATA);
  endproperty
  
// read check
  property read_check;
    @(posedge PCLK) disable iff(!PRST_N)
    (APB_SEL && APB_ENABLE && !APB_READ_WRITE && APB_DONE) |-> !$isunknown(APB_RDATA);
  endproperty
  
// reset checking
assert property(reset)
// `uvm_info("ASSERTION","ASSERTION IS PASSED FOR RESET",UVM_LOW)
  else
    `uvm_error("ASSERTION","ASSERTION IS FAILED FOR RESET")

// Setup Phase to access phase Validation
 assert property(setup_phase_check)
// `uvm_info("ASSERTION","ASSERTION IS PASSED FOR  SETUP TO ACCESS PHASE CHECK",UVM_LOW)
  else
    `uvm_error("ASSERTION","ASSERTION IS FAILED FOR SETUP TO ACCESS PHASE CHECK")

// data stabiltiy Validation
    assert property(data_stability)
// `uvm_info("ASSERTION","ASSERTION IS PASSED FOR DATA STABILITY CHECK",UVM_LOW)
  else
    `uvm_error("ASSERTION","ASSERTION IS FAILED FOR DATA STABILITY CHECK")
    
// write check    
 assert property(write_check)
//    `uvm_info("ASSERTION","ASSERTION IS PASSED FOR WRITE CHECK",UVM_LOW)
  else
    `uvm_error("ASSERTION","ASSERTION IS FAILED FOR WRITE CHECK")
    
//read check
    assert property(read_check)
//       `uvm_info("ASSERTION","ASSERTION IS PASSED FOR READ CHECK",UVM_LOW)
  else
    `uvm_error("ASSERTION","ASSERTION IS FAILED FOR READ CHECK")
 
// PREADY SIGNAL CHECK AND WAIT STATE CHECK
assert property(pready_check)
// `uvm_info("ASSERTION","ASSERTION IS PASSED FOR PREADY SIGNAL CHECK",UVM_LOW)
  else
    `uvm_error("ASSERTION","ASSERTION IS FAILED FOR PREADY SIGNAL CHECK")
    
// Transfer Completion  check
 assert property(transfer_check)
//  `uvm_info("ASSERTION","ASSERTION IS PASSED FOR TRANSFER COMPLETION CHECK",UVM_LOW)
  else
    `uvm_error("ASSERTION","ASSERTION IS FAILED FOR TRANSFER COMPLETION CHECK CHECK")
    
//Error Handling 
  assert property(error_check)
//   `uvm_info("ASSERTION","ASSERTION IS PASSED FOR ERROR CHECK",UVM_LOW)
  else
    `uvm_error("ASSERTION","ASSERTION IS FAILED FOR ERROR CHECK")
    
// // Strobe check
// assert property(strobe_check)
//  // `uvm_info("ASSERTION","ASSERTION IS PASSED FOR STROBE CHECK",UVM_LOW)
//   else
//     `uvm_error("ASSERTION","ASSERTION IS FAILED FOR STROBE CHECK")
endinterface
