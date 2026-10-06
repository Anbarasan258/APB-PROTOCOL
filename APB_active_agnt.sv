class APB_active_agnt extends uvm_agent;
  `uvm_component_utils(APB_active_agnt)
  APB_sequencer seqr;
  APB_driver drvh;
  APB_active_monitor mon;
  APB_agent_config cfg;
  
  function new(string name = "APB_active_agnt",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(APB_agent_config)::get(this,"","cfg",cfg))
    `uvm_fatal("AGENT", "CFG not found")
      mon = APB_active_monitor::type_id::create("mon",this);
    
    if(cfg.is_active==UVM_ACTIVE)
      begin
        drvh=APB_driver::type_id::create("drv",this);
        seqr=APB_sequencer::type_id::create("seqr",this);
      end
    endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if(cfg.is_active==UVM_ACTIVE)begin
      drvh.seq_item_port.connect(seqr.seq_item_export);
      end
    endfunction
  
endclass
  
