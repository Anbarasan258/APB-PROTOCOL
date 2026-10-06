class APB_active_monitor extends uvm_monitor;
  `uvm_component_utils(APB_active_monitor)
  virtual APB_interface vif;
  APB_agent_config cfg;
  uvm_analysis_port#(APB_sequence_item) aport;

  function new(string name="APB_active_monitor", uvm_component parent);
    super.new(name,parent);
    aport = new("aport",this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(APB_agent_config)::get(this,"","cfg",cfg))
      `uvm_fatal("MONITOR","cfg not found")
    vif = cfg.vif;
  endfunction

  task run_phase(uvm_phase phase);
    APB_sequence_item item;
    forever begin
      @(posedge vif.PCLK);
      if(!vif.PRST_N)
        begin
          wait(!vif.APB_ENABLE && !vif.APB_SEL);
        item = APB_sequence_item::type_id::create("item", this);
        item.PRST_N        = vif.PRST_N;
        item.APB_TRANSFER   = vif.APB_TRANSFER;
        item.APB_READ_WRITE = vif.APB_READ_WRITE;
        item.APB_STROBE     = vif.APB_STROBE;
        item.APB_ENABLE     = vif.APB_ENABLE;
        item.APB_SEL        = vif.APB_SEL;
        item.APB_PROTECT    = vif.APB_PROTECT;
        item.APB_ADDR       = vif.APB_ADDR;
        item.APB_WDATA      = vif.APB_WDATA;
        item.APB_DONE       = vif.APB_DONE;
        item.APB_ERROR      = vif.APB_ERROR;
        item.APB_RDATA = vif.APB_RDATA;
        aport.write(item); 
        end
      else if(vif.PRST_N && vif.APB_SEL && vif.APB_ENABLE && vif.APB_DONE)    
        begin
        item = APB_sequence_item::type_id::create("item", this);
        item.PRST_N        = vif.PRST_N;
        item.APB_TRANSFER   = vif.APB_TRANSFER;
        item.APB_READ_WRITE = vif.APB_READ_WRITE;
        item.APB_STROBE     = vif.APB_STROBE;
        item.APB_PROTECT    = vif.APB_PROTECT;
        item.APB_ENABLE     = vif.APB_ENABLE;
        item.APB_SEL        = vif.APB_SEL;
        item.APB_ADDR       = vif.APB_ADDR;
        item.APB_WDATA      = vif.APB_WDATA;
        item.APB_DONE       = vif.APB_DONE;
        item.APB_ERROR      = vif.APB_ERROR;
        if(!item.APB_READ_WRITE)
          item.APB_RDATA = vif.APB_RDATA;

        aport.write(item);
      end
    end
  endtask
endclass
