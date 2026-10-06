class APB_environment extends uvm_env;
  `uvm_component_utils(APB_environment)
  APB_active_agnt agnth;
  APB_scoreboard score_h;
  apb_env_config env_config;
  APB_coverage cov_h;
  
  function new(string name = "APB_environment",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(apb_env_config)::get(this,"","cfg",env_config))
      `uvm_fatal("Env","cfg not getting")
      
      agnth = APB_active_agnt::type_id::create("agnth",this);
    
    if(env_config.is_scoreboard)
      score_h = APB_scoreboard::type_id::create("score_h",this);
    if(env_config.is_coverage)
      cov_h = APB_coverage::type_id::create("cov_h",this);
    uvm_config_db#(APB_agent_config)::set(this,"agnth*","cfg",env_config.agent_cfg);
    uvm_config_db#(APB_agent_config)::set(this,"score_h","cfg",env_config.agent_cfg);
  endfunction
  
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    
    agnth.mon.aport.connect(score_h.imp_port);
    
    agnth.mon.aport.connect(cov_h.cov_imp);
   
  endfunction
  
endclass

