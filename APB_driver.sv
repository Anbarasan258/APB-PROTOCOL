class APB_driver extends uvm_driver#(APB_sequence_item);
  `uvm_component_utils(APB_driver)
  virtual APB_interface vif;
  APB_agent_config cfg;

  function new(string name="APB_driver", uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(APB_agent_config)::get(this,"","cfg",cfg))
      `uvm_fatal("DRIVER","cfg not set")
    vif = cfg.vif;
  endfunction

  task run_phase(uvm_phase phase);
    APB_sequence_item item;

    forever begin
      seq_item_port.get_next_item(item);
      if(!item.PRST_N )
      begin
        vif.PRST_N <= 1'b0 ; 
        vif.APB_TRANSFER <= 1'b0;
        vif.APB_READ_WRITE <= 1'b0;
        vif.APB_STROBE <= 4'b0000;
        vif.APB_PROTECT <= 3'b000;
        vif.APB_ADDR <= 32'd0;
        vif.APB_WDATA <= 32'd0;
        
        repeat(2) @(posedge vif.PCLK);
         seq_item_port.item_done();
      end
      else
        begin
          if(!item.APB_TRANSFER)
           begin
              vif.PRST_N <= item.PRST_N ; 
              vif.APB_TRANSFER <= item.APB_TRANSFER;
              vif.APB_READ_WRITE <= item.APB_READ_WRITE;
              vif.APB_STROBE <= item.APB_STROBE;
              vif.APB_PROTECT <= item.APB_PROTECT;
              vif.APB_ADDR <= item.APB_ADDR;
             vif.APB_WDATA <= (item.APB_READ_WRITE) ? item.APB_WDATA : 32'd0;
             seq_item_port.item_done();
           end
          else
            begin
              vif.PRST_N <= 1'b1;
              vif.APB_READ_WRITE <= item.APB_READ_WRITE;
              vif.APB_TRANSFER   <= item.APB_TRANSFER;
              vif.APB_STROBE     <= item.APB_STROBE;
              vif.APB_PROTECT    <= item.APB_PROTECT;
              vif.APB_ADDR       <= item.APB_ADDR;
              vif.APB_WDATA      <= (item.APB_READ_WRITE) ? item.APB_WDATA : 32'd0;
          
          @(posedge vif.PCLK);
            while(!vif.APB_DONE) @(posedge vif.PCLK);
            
            seq_item_port.item_done();
            end
        end
    end
  endtask
endclass
