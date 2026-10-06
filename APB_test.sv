class APB_test extends uvm_test;
  `uvm_component_utils(APB_test)
  APB_environment env;
  apb_env_config env_config;
  
  function new(string name = "APB_test",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    env = APB_environment::type_id::create("env",this);
    env_config = apb_env_config::type_id::create("env_config",this);
    env_config.agent_cfg = APB_agent_config::type_id::create("agent_cfg");
    if(!uvm_config_db#(virtual APB_interface)::get(this,"","vif",env_config.agent_cfg.vif))
      `uvm_fatal("TEST","vif not  get in test")
      
      //uvm_config_db#(APB_agent_config)::set(this, "*", "cfg", env_config.agent_cfg);
    uvm_config_db#(apb_env_config)::set(this,"*","cfg",env_config);
  endfunction
  
  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
  endfunction 
endclass

//TC 16 [write and read in all location]

class read_write_all_location extends APB_test;
  `uvm_component_utils(read_write_all_location)
  
  function new(string name = "read_write_all_location",uvm_component parent);
    super.new(name,parent);
  endfunction
  
   task run_phase(uvm_phase phase);
    APB_read_write_all_sequence seq;
    phase.raise_objection(this);
    seq = APB_read_write_all_sequence :: type_id::create("seq");
    seq.start(env.agnth.seqr);
//      #1000;
    phase.drop_objection(this);
  endtask
  
endclass

// TC 1 & 2 [write and read directed] 

class write_read_sequence extends APB_test;
  `uvm_component_utils(write_read_sequence)

  function new(string name = "write_read_sequence",uvm_component parent);
    super.new(name,parent);
  endfunction

  task run_phase(uvm_phase phase);
    APB_read_write_sequence seq1;
    phase.raise_objection(this);
    seq1 = APB_read_write_sequence::type_id::create("seq1");
    seq1.start(env.agnth.seqr);
    phase.drop_objection(this);
  endtask
endclass


// TC 9 RESET

class reset_signal_sequence extends APB_test;
  `uvm_component_utils(reset_signal_sequence)
  
  function new(string name = "reset_signal_sequence",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  task run_phase(uvm_phase phase);
    reset_sequence seq;
    phase.raise_objection(this);
    seq = reset_sequence :: type_id :: create("seq");
    seq.start(env.agnth.seqr);
    phase.drop_objection(this);
  endtask
  
endclass


// TC 5 ,15 ERROR

class error_signal_sequence extends APB_test;
  `uvm_component_utils(error_signal_sequence)
  
  function new(string name = "error_signal_sequence",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  task run_phase(uvm_phase phase);
    error_sequence seq;
    phase.raise_objection(this);
    seq = error_sequence :: type_id :: create("seq");
    seq.start(env.agnth.seqr);
    phase.drop_objection(this);
  endtask
endclass


// TC 14 PROTECT SIGNAL ALL COMBINATION

class protect_signal_sequence extends APB_test;
  `uvm_component_utils(protect_signal_sequence)
  
  function new(string name = "protect_signal_sequence",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  task run_phase(uvm_phase phase);
    protect_sequence seq;
    phase.raise_objection(this);
    seq = protect_sequence :: type_id :: create("seq");
    seq.start(env.agnth.seqr);
    phase.drop_objection(this);
  endtask
  
endclass

//TC 7 b2b read and write

class b2b_sequence extends APB_test;
  `uvm_component_utils(b2b_sequence)
  
  function new(string name = "b2b_sequence",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  task run_phase(uvm_phase phase);
    b2b_transfer seq;
    phase.raise_objection(this);
    seq = b2b_transfer :: type_id :: create("seq");
    seq.start(env.agnth.seqr);
    phase.drop_objection(this);
  endtask
  
endclass


// TC 6 PSTROBE CHECKING FOR ALL 16 COMBINATION

class pstrobe_sequence extends APB_test;
  `uvm_component_utils(pstrobe_sequence)
  
  function new(string name = "pstrobe_sequence",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  task run_phase(uvm_phase phase);
    pstrobe_comb_sequence seq;
    phase.raise_objection(this);
    seq = pstrobe_comb_sequence :: type_id :: create("seq");
    seq.start(env.agnth.seqr);
   // #1000;
    phase.drop_objection(this);
  endtask
  
endclass


// TC 10 & 13 TC_RANDOM_PSTRB and TC_CONSTR_PSTRB

class rand_strobe_sequence extends APB_test;
  `uvm_component_utils(rand_strobe_sequence)
  
  function new(string name = "rand_strobe_sequence",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  task run_phase(uvm_phase phase);
    random_strobe seq;
    phase.raise_objection(this);
    seq = random_strobe :: type_id :: create("seq");
    seq.start(env.agnth.seqr);
   // #1000;
    phase.drop_objection(this);
  endtask
  
endclass


// TC 11,12 , 8   ,CONSTRAINT RANDOM READ AND WRITE ,RANDOM ADDRESSS AND BOUNDARY COVERAGE

class rand_addr_wd_sequence extends APB_test;
  `uvm_component_utils(rand_addr_wd_sequence)
  
  function new(string name = "rand_addr_wd_sequence",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  task run_phase(uvm_phase phase);
    random_addr_rw_sequence seq;
    phase.raise_objection(this);
    seq = random_addr_rw_sequence :: type_id :: create("seq");
    seq.start(env.agnth.seqr);
  //  #1000;
    phase.drop_objection(this);
  endtask
  
endclass


// TC 3,4 state transition check from idle to access state and checking the state when transfer is zero

class state_trans_sequence extends APB_test;
  `uvm_component_utils(state_trans_sequence)
  
  function new(string name = "state_trans_sequence",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  task run_phase(uvm_phase phase);
    state_sequence seq;
    phase.raise_objection(this);
    seq = state_sequence :: type_id :: create("seq");
    seq.start(env.agnth.seqr);
  //  #1000;
    phase.drop_objection(this);
  endtask
  
endclass



class APB_regression_test extends APB_test;
  `uvm_component_utils(APB_regression_test)
  
  function new(string name = "APB_regression_test",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  task run_phase(uvm_phase phase);
    APB_read_write_all_sequence seq1;
    APB_read_write_sequence seq2;
    reset_sequence seq3;
    error_sequence seq4;
    protect_sequence seq5;
    b2b_transfer seq6;
    pstrobe_comb_sequence seq7;
    random_strobe seq8;
    random_addr_rw_sequence seq9;
    state_sequence seq10;
    
    phase.raise_objection(this);
    
    seq1 = APB_read_write_all_sequence :: type_id :: create("seq1");
    seq2 = APB_read_write_sequence :: type_id :: create("seq2");
    seq3 = reset_sequence :: type_id :: create("seq3");
    seq4 = error_sequence :: type_id :: create("seq4");
    seq5 = protect_sequence :: type_id :: create("seq5");
    seq6 = b2b_transfer :: type_id :: create("seq6");
    seq7 = pstrobe_comb_sequence :: type_id :: create("seq7");
    seq8 = random_strobe :: type_id :: create("seq8");
    seq9 = random_addr_rw_sequence :: type_id :: create("seq9");
    seq10 = state_sequence :: type_id :: create("seq10");
    
    
    seq1.start(env.agnth.seqr);
    `uvm_info("TEST","SEQ1 DONE",UVM_LOW)
    seq2.start(env.agnth.seqr);
    `uvm_info("TEST","SEQ2 DONE",UVM_LOW)
    seq3.start(env.agnth.seqr);
    `uvm_info("TEST","SEQ3 DONE",UVM_LOW)
    seq4.start(env.agnth.seqr);
    `uvm_info("TEST","SEQ4 DONE",UVM_LOW)
    seq5.start(env.agnth.seqr);
    `uvm_info("TEST","SEQ5 DONE",UVM_LOW)
    seq6.start(env.agnth.seqr);
    `uvm_info("TEST","SEQ6 DONE",UVM_LOW)
    seq7.start(env.agnth.seqr);
    `uvm_info("TEST","SEQ7 DONE",UVM_LOW)
    seq8.start(env.agnth.seqr);
    `uvm_info("TEST","SEQ8 DONE",UVM_LOW)
    seq9.start(env.agnth.seqr);
    `uvm_info("TEST","SEQ9 DONE",UVM_LOW)
    seq10.start(env.agnth.seqr);
    `uvm_info("TEST","SEQ10 DONE",UVM_LOW)
    #20375;
    phase.drop_objection(this);
  endtask
  
endclass
