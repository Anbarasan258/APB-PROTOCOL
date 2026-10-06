

class apb_env_config extends uvm_object;
  `uvm_object_utils(apb_env_config)
  
  function new(string name="apb_env_config");
    super.new(name);
  endfunction
  
  APB_agent_config agent_cfg;
  bit is_scoreboard=1;
  bit is_coverage=1;
  
endclass
