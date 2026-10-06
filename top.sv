import uvm_pkg::*;
`include "APB_master.sv"
`include "APB_slave.sv"
`include "APB_package.sv"
`include "APB_interface.sv"
`include "uvm_macros.svh"
import APB_package::*;

module test_APB;
  bit clk;
  always #5 clk = ~clk;
  
  APB_interface vif(clk);
  
  top dut(.PCLK(vif.PCLK),.PRST_N(vif.PRST_N),.APB_ADDR(vif.APB_ADDR),.APB_WDATA(vif.APB_WDATA),.APB_RDATA(vif.APB_RDATA),.APB_READ_WRITE(vif.APB_READ_WRITE),.APB_ENABLE(vif.APB_ENABLE),.APB_PSEL(vif.APB_SEL),.APB_TRANSFER(vif.APB_TRANSFER),.APB_STROBE(vif.APB_STROBE),.APB_PROTECT(vif.APB_PROTECT),.APB_DONE(vif.APB_DONE),.APB_ERROR(vif.APB_ERROR));
  
 initial
  begin
    clk = 1'b0;
    $dumpfile("dump.vcd");
    $dumpvars(0,test_APB);
    uvm_config_db#(virtual APB_interface)::set(null, "*", "vif", vif);
// run_test("write_read_sequence"); // TC 1 & 2 [write and read directed] 
// run_test("state_trans_sequence"); // TC 3,4 state transition from idle to access state and checking the state when transfer is zero
// run_test("error_signal_sequence"); // TC 5 , 15  ERROR[basic]
//run_test("pstrobe_sequence"); // TC 6 PSTROBE CHECKING FOR ALL 16 COMBINATION
run_test("b2b_sequence"); //TC 7 b2b read and write
//  run_test("rand_addr_wd_sequence"); // TC 11,12 , 8   ,CONSTRAINT RANDOM READ AND WRITE ,RANDOM ADDRESSS AND BOUNDARY COVERAGE
// run_test("reset_signal_sequence"); // TC 9 [RESET]
//run_test("rand_strobe_sequence"); // TC 10 & 13 TC_RANDOM_PSTRB and TC_CONSTR_PSTRB
// run_test("protect_signal_sequence"); // TC 14
// run_test("read_write_all_location"); //TC 16 [write and read in all location]
    
    
// run_test("APB_regression_test"); //regression test
 $finish;
//       #1000 $finish;
  end
endmodule
