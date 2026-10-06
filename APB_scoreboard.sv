class APB_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(APB_scoreboard)
  uvm_analysis_imp#(APB_sequence_item, APB_scoreboard) imp_port;
  logic [31:0] memory [0:255];
  logic [31:0] expected_data;
  virtual APB_interface vif;
  APB_agent_config cfg;
  int pass_count,fail_count,no_of_write_transaction;
  
  function new(string name="APB_scoreboard", uvm_component parent);
    super.new(name,parent);
    imp_port = new("imp_port", this);
  endfunction
  
  function void build_phase(uvm_phase phase);
    begin
	 super.build_phase(phase);
  		if(!uvm_config_db#(APB_agent_config)::get(this,"","cfg",cfg)) begin
		  `uvm_fatal("SCOREBOARD","cfg cannot found")
	      end
      foreach(memory[i])
                memory[i] = 32'd0;
      vif = cfg.vif;
 	end
  endfunction

  function void write(APB_sequence_item item);
    if(!item.PRST_N)
        begin
          foreach(memory[i])
                memory[i] = 32'd0;
          if(!item.APB_ENABLE && !item.APB_SEL)
            `uvm_info(get_type_name(),$sformatf("THE RESET IS HAPPENED PROPERLY"),UVM_LOW)
            else
              `uvm_error(get_type_name(),$sformatf("THE RESET IS NOT HAPPENED PROPERLY"))
        end
              
      else if(item.APB_ERROR)
         begin
           if(item.APB_PROTECT[0] == 1'b0 || item.APB_PROTECT[1] == 1'b1 )
             `uvm_error(get_type_name(),$sformatf("NORMAL OR NON-SECURE ACCESS REQUEST FROM THE MASTER for the address = %0d",item.APB_ADDR))
           if (item.APB_ADDR > 255)
             `uvm_error(get_type_name(),$sformatf("ADDRESS OUT-OF-BOUND ERROR OCCURS FOR THE ADDRESS = %0d",item.APB_ADDR)) 
             if(item.APB_STROBE == 4'b0000 && vif.APB_READ_WRITE ) 
               `uvm_error(get_type_name(),$sformatf("STROBE ERROR OCCURS FOR THE ADDRESS = %0d",item.APB_ADDR))  
         end

     else if(item.APB_READ_WRITE && !item.APB_ERROR && item.APB_DONE && (item.APB_ADDR < 256)) 
       begin
      no_of_write_transaction++;
      if(item.APB_STROBE[0]) memory[item.APB_ADDR[7:0]][7:0]   = item.APB_WDATA[7:0];
      if(item.APB_STROBE[1]) memory[item.APB_ADDR[7:0]][15:8]  = item.APB_WDATA[15:8];
      if(item.APB_STROBE[2]) memory[item.APB_ADDR[7:0]][23:16] = item.APB_WDATA[23:16];
      if(item.APB_STROBE[3]) memory[item.APB_ADDR[7:0]][31:24] = item.APB_WDATA[31:24];
         `uvm_info(get_type_name(),$sformatf("PWRITE=%0b | PADDR=%0d | PWDATA=%0d | PSTRB=%0b | PPROT=%0b ",item.APB_READ_WRITE,item.APB_ADDR,item.APB_WDATA,item.APB_STROBE,item.APB_PROTECT),UVM_LOW)

    end
    else begin
      expected_data = memory[item.APB_ADDR[7:0]];
      if(item.APB_RDATA !== expected_data)
        begin
          fail_count++;
          `uvm_error(get_type_name(),$sformatf("MISMATCH PADDR=%0d PRDATA=%0d EXPECTED=%0d", item.APB_ADDR, item.APB_RDATA, expected_data))
        end
      else
        begin
          pass_count++;
        `uvm_info(get_type_name(),$sformatf("MATCH PADDR=%0d PRDATA=%0d EXPECTED=%0d", item.APB_ADDR, item.APB_RDATA, expected_data),UVM_LOW)
        end
    end
  endfunction
  
//   function void report_phase(uvm_phase phase);
//     super.report_phase(phase);
//     if(pass_count == no_of_write_transaction)
//       begin
//         `uvm_info(get_type_name(),$sformatf("PASS_COUNT IS EQUAL TO THE NO_OF_WRITE_TRANSACTION : %0d == %0d",no_of_write_transaction,pass_count),UVM_LOW)
//       end
//     else
//       begin
//         `uvm_info(get_type_name(),$sformatf("PASS_COUNT IS NOT EQUAL TO THE NO_OF_WRITE_TRANSACTION : %0d != %0d",no_of_write_transaction,pass_count),UVM_LOW)
//         `uvm_info(get_type_name(),$sformatf("FAIL_COUNT IS : %0d",fail_count),UVM_LOW)
//       end
//   endfunction
   
endclass
