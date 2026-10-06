class APB_coverage extends uvm_component;
  `uvm_component_utils(APB_coverage)
  uvm_analysis_imp#(APB_sequence_item,APB_coverage)cov_imp;
  APB_sequence_item item;
  
  covergroup covg1;
   ADDRESS : coverpoint item.APB_ADDR {
      bins low = {[0:82]};
      bins mid = {[83:162]};
      bins high = {[163:255]};
    }
   READ_WRITE : coverpoint item.APB_READ_WRITE;
   RESET : coverpoint item.PRST_N;
   STROBE : coverpoint  item.APB_STROBE {
      bins low = {[1:4]};
      bins mid = {[5:8]};
      bins high = {[9:15]};
     ignore_bins error = {0};
    }
    
  endgroup
  
  
  function new(string name = "APB_coverage",uvm_component parent);
    super.new(name,parent);
    cov_imp = new("cov_imp",this);
    covg1 = new();
  endfunction
  
  function void write(APB_sequence_item item1);
    item = item1;
    covg1.sample();
//    `uvm_info("COVERAGE",$sformatf("APB Coverage = %0.2f %%", covg1.get_coverage()),UVM_NONE)
  endfunction


// function void report_phase(uvm_phase phase);
//   super.report_phase(phase);
//   `uvm_info("COVERAGE",$sformatf("APB Coverage = %0.2f %%", covg1.get_coverage()),UVM_NONE)
// endfunction
  endclass
