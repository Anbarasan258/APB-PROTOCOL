class APB_agent_config extends uvm_object;
  `uvm_object_utils(APB_agent_config)

  uvm_active_passive_enum is_active = UVM_ACTIVE;

  bit has_driver  = 1;
  bit has_monitor = 1;

  virtual interface APB_interface vif;

  function new(string name="my_agent_config");
    super.new(name);
  endfunction

endclass
