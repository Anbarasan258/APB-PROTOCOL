class APB_sequence extends uvm_sequence#(APB_sequence_item);
  `uvm_object_utils(APB_sequence)
  function new(string name = "APB_sequence");
    super.new(name);
  endfunction
  task reset();
    APB_sequence_item item;
    item = APB_sequence_item::type_id::create("reset_item");
    start_item(item);
    item.PRST_N = 1'b0;
    finish_item(item);
  endtask
endclass

// TC 16 write and read in all location
class APB_read_write_all_sequence extends APB_sequence;
  `uvm_object_utils(APB_read_write_all_sequence)
  
  function new(string name = "APB_read_write_all_sequence");
    super.new(name);
  endfunction
  
  task body();
    reset();
    write();
    read();
  endtask
  
  task write();
    for(int i = 0;i< 255; i++)
      begin
        APB_sequence_item seq_item;
        seq_item = APB_sequence_item::type_id::create("seq_item");
        start_item(seq_item);
        seq_item.randomize() with {APB_READ_WRITE == 1'b1; APB_TRANSFER == 1'b1; APB_ADDR == i; APB_STROBE == 4'b1111; PRST_N == 1'b1;};
        finish_item(seq_item);
      end
  endtask
  
  task read();
    for(int i = 0;i< 255; i++)
      begin
        APB_sequence_item seq_item;
        seq_item = APB_sequence_item::type_id::create("seq_item");
        start_item(seq_item);
        seq_item.strobe.constraint_mode(0);
        seq_item.randomize() with {APB_READ_WRITE == 1'b0; APB_TRANSFER == 1'b1; APB_ADDR == i; PRST_N == 1'b1;};
         finish_item(seq_item);
      end
    endtask
  
endclass


// TC 1 & 2 [write and read directed] 

class APB_read_write_sequence extends APB_sequence;
  `uvm_object_utils(APB_read_write_sequence)
  
  function new(string name = "APB_read_write_sequence");
    super.new(name);
  endfunction
  
  task body();
    reset();
    write();
    read();
  endtask
  
  task write();
      begin
        APB_sequence_item item;
        item = APB_sequence_item::type_id::create("seq_item");
        start_item(item);
        item.randomize() with {APB_READ_WRITE == 1'b1; APB_TRANSFER == 1'b1; APB_ADDR == 32'd7; APB_STROBE == 4'b1111 ; APB_PROTECT == 3'b001; PRST_N == 1'b1;};
        finish_item(item);
        start_item(item);
        item.randomize() with {APB_READ_WRITE == 1'b1; APB_TRANSFER == 1'b1; APB_ADDR == 32'd140; APB_STROBE == 4'b0101 ; APB_PROTECT == 3'b001; PRST_N == 1'b1;};
        finish_item(item);
        start_item(item);
        item.randomize() with {APB_READ_WRITE == 1'b1; APB_TRANSFER == 1'b1; APB_ADDR == 32'd240; APB_STROBE == 4'b0001 ; APB_PROTECT == 3'b001; PRST_N == 1'b1;};
        finish_item(item);
      end
  endtask
  
  task read();
      begin
        APB_sequence_item item;
        item = APB_sequence_item::type_id::create("item");
        start_item(item);
        item.strobe.constraint_mode(0);
        item.randomize() with {APB_READ_WRITE == 1'b0; APB_TRANSFER == 1'b1; APB_ADDR == 32'd7;  APB_PROTECT == 3'b001;PRST_N == 1'b1;};
         finish_item(item);
        
        start_item(item);
        item.strobe.constraint_mode(0);
        item.randomize() with {APB_READ_WRITE == 1'b0; APB_TRANSFER == 1'b1; APB_ADDR == 32'd140;  APB_PROTECT == 3'b001; PRST_N == 1'b1;};
        finish_item(item);
        
        start_item(item);
        item.strobe.constraint_mode(0);
        item.randomize() with {APB_READ_WRITE == 1'b0; APB_TRANSFER == 1'b1; APB_ADDR == 32'd240; APB_PROTECT == 3'b001; PRST_N == 1'b1;};
        finish_item(item);
      end
    endtask
  
endclass

// TC 9 RESET 

class reset_sequence extends APB_sequence;
  `uvm_object_utils(reset_sequence)
  function new(string name = "reset_sequence");
    super.new(name);
  endfunction
  
  task body();
    reset();
    read_after_reset();
  endtask
  
  task read_after_reset();
   begin
     APB_sequence_item item;
     item = APB_sequence_item :: type_id :: create("item");
     start_item(item);
     item.strobe.constraint_mode(0);
     item.randomize() with {APB_READ_WRITE == 1'b0; APB_TRANSFER == 1'b1; APB_ADDR == 32'd7; APB_STROBE == 4'b0000 ; APB_PROTECT == 3'b001;PRST_N == 1'b1;};
     finish_item(item);
   end
  endtask
endclass


// TC 5 , 15  ERROR[basic]

class error_sequence extends APB_sequence;
  `uvm_object_utils(error_sequence)
  
  function new(string name = "error_sequence");
    super.new(name);
  endfunction
  
  task body();
    reset();
    error();
  endtask
  
  task error();
    APB_sequence_item item;
    item = APB_sequence_item :: type_id :: create("item");
    start_item(item);
    item.strobe.constraint_mode(0);
    item.addr.constraint_mode(0);
    item.randomize() with {APB_READ_WRITE == 1'b0; APB_TRANSFER == 1'b1; APB_ADDR == 32'd300; APB_STROBE == 4'b0000 ; APB_PROTECT == 3'b001;PRST_N == 1'b1;};
    finish_item(item);
    start_item(item);
    item.prot.constraint_mode(0);
    item.strobe.constraint_mode(0);
    item.randomize() with {APB_READ_WRITE == 1'b0; APB_TRANSFER == 1'b1; APB_ADDR == 32'd7; APB_STROBE == 4'b0000 ; APB_PROTECT == 3'b000;PRST_N == 1'b1;};
    finish_item(item);
    start_item(item);
    item.strobe_write.constraint_mode(0);
    item.strobe.constraint_mode(0);
    item.randomize() with {APB_READ_WRITE == 1'b1; APB_TRANSFER == 1'b1; APB_ADDR == 32'd7; APB_STROBE == 4'b0000 ; APB_PROTECT == 3'b001;PRST_N == 1'b1;};
    finish_item(item);
  endtask
endclass

// TC 14 PROTECT SIGNAL ALL COMBINATION


class protect_sequence extends APB_sequence;
  `uvm_object_utils(protect_sequence)
  
  function new(string name = "protect_sequence");
    super.new(name);
  endfunction
  
  task body();
    reset();
    prot();
  endtask
  
  task prot();
    for(int i = 0 ;i < 8 ;i++)
      begin 
        APB_sequence_item item;
        item = APB_sequence_item ::type_id :: create("item");
        start_item(item);
        item.prot.constraint_mode(0);
        item.randomize() with {APB_READ_WRITE == 1'b1; APB_TRANSFER == 1'b1; APB_ADDR == i; APB_STROBE == 4'b1111 ; APB_PROTECT == i; PRST_N == 1'b1;};
        finish_item(item);
      end
        
        // for read protect checking
    for(int i = 0 ;i < 8 ;i++)
      begin
        APB_sequence_item item;
        item = APB_sequence_item ::type_id :: create("item");
        start_item(item);
        item.prot.constraint_mode(0);
        item.strobe.constraint_mode(0);
        item.randomize() with {APB_READ_WRITE == 1'b0; APB_TRANSFER == 1'b1; APB_ADDR == i; APB_PROTECT == i; PRST_N == 1'b1;};
        finish_item(item);
      end
        // to ensure the data is not writen in the protected area 0,2,3,5,6,7
    for(int i = 0 ;i < 8 ;i++)
      begin
        APB_sequence_item item;
        item = APB_sequence_item ::type_id :: create("item");
        start_item(item);
        //item.prot.constraint_mode(1);
        item.strobe.constraint_mode(0);
        item.randomize() with {APB_READ_WRITE == 1'b0; APB_TRANSFER == 1'b1; APB_ADDR == i;PRST_N == 1'b1;};
         finish_item(item);
      end
  endtask
endclass


// TC 7 back-to-back-transfer

class b2b_transfer extends APB_sequence; 
  `uvm_object_utils(b2b_transfer)
  
  function new(string name = "b2b_transfer");
    super.new(name);
  endfunction
  
  task body();
    reset();
    b2b_read_write();
  endtask
  
  task b2b_read_write();
    // b2b write in 15 location
    for(int i = 0; i < 4; i++)
      begin
        APB_sequence_item item;
        item = APB_sequence_item :: type_id :: create("item");
        start_item(item);
        item.randomize () with {APB_READ_WRITE == 1'b1; APB_TRANSFER == 1'b1; APB_STROBE == 4'b1111; APB_ADDR == i; PRST_N == 1'b1;};
        finish_item(item);
      end
    for(int i = 85; i < 90; i++)
      begin
        APB_sequence_item item;
        item = APB_sequence_item :: type_id :: create("item");
        start_item(item);
        item.randomize () with {APB_READ_WRITE == 1'b1; APB_TRANSFER == 1'b1;  APB_ADDR == i; PRST_N == 1'b1;};
        finish_item(item);
      end
    for(int i = 165; i < 170; i++)
      begin
        APB_sequence_item item;
        item = APB_sequence_item :: type_id :: create("item");
        start_item(item);
        item.randomize () with {APB_READ_WRITE == 1'b1; APB_TRANSFER == 1'b1;  APB_ADDR == i; PRST_N == 1'b1;};
        finish_item(item);
      end
    // b2b read in 15 location
    for(int i = 0; i < 5; i++)
      begin
         APB_sequence_item item;
        item = APB_sequence_item :: type_id :: create("item");
        start_item(item);
        item.strobe.constraint_mode(0);
        item.randomize () with {APB_READ_WRITE == 1'b0; APB_TRANSFER == 1'b1; APB_ADDR == i; PRST_N == 1'b1;};
        finish_item(item);
      end
    
    for(int i = 85; i < 90; i++)
      begin
         APB_sequence_item item;
        item = APB_sequence_item :: type_id :: create("item");
        start_item(item);
        item.strobe.constraint_mode(0);
        item.randomize () with {APB_READ_WRITE == 1'b0; APB_TRANSFER == 1'b1; APB_ADDR == i; PRST_N == 1'b1;};
        finish_item(item);
      end
    
    for(int i = 165; i < 170; i++)
      begin
         APB_sequence_item item;
        item = APB_sequence_item :: type_id :: create("item");
        start_item(item);
        item.strobe.constraint_mode(0);
        item.randomize () with {APB_READ_WRITE == 1'b0; APB_TRANSFER == 1'b1; APB_ADDR == i; PRST_N == 1'b1;};
        finish_item(item);
      end
  endtask
endclass


// TC 6 PSTROBE CHECKING FOR ALL 16 COMBINATION

class pstrobe_comb_sequence extends APB_sequence;
  `uvm_object_utils(pstrobe_comb_sequence)
    
  function new(string name = "pstrobe_comb_sequence");
    super.new(name);
  endfunction
  
  task body();
    reset();
    pstrobe();
  endtask
  
  task pstrobe();
    //using all combination of strobe signal write in tne location 0-15
    for(int i = 0 ; i < 5 ;i++)
      begin
        APB_sequence_item item;
        item = APB_sequence_item::type_id::create("item");
        start_item(item);
        item.wdata.constraint_mode(0);
        item.strobe_write.constraint_mode(0);
        item.strobe.constraint_mode(0);
        item.randomize() with {APB_READ_WRITE == 1'b1; APB_TRANSFER == 1'b1; APB_ADDR == i; APB_WDATA == 32'd1515870810; PRST_N == 1'b1; APB_STROBE == i;};
        finish_item(item);
      end
    
    for(int i = 85 ; i < 90 ;i++)
      begin
        APB_sequence_item item;
        item = APB_sequence_item::type_id::create("item");
        start_item(item);
        item.wdata.constraint_mode(0);
        item.strobe_write.constraint_mode(0);
        item.strobe.constraint_mode(0);
        item.randomize() with {APB_READ_WRITE == 1'b1; APB_TRANSFER == 1'b1; APB_ADDR == i; APB_WDATA == 32'd1515870810; PRST_N == 1'b1; };
        finish_item(item);
      end
    
    for(int i = 165 ; i < 170 ;i++)
      begin
        APB_sequence_item item;
        item = APB_sequence_item::type_id::create("item");
        start_item(item);
        item.wdata.constraint_mode(0);
        item.strobe_write.constraint_mode(0);
        item.strobe.constraint_mode(0);
        item.randomize() with {APB_READ_WRITE == 1'b1; APB_TRANSFER == 1'b1; APB_ADDR == i; APB_WDATA == 32'd1515870810; PRST_N == 1'b1; };
        finish_item(item);
      end
    
    //reading them and checking the correctness of data
    for(int i = 0 ; i < 5 ;i++)
      begin
        APB_sequence_item item;
        item = APB_sequence_item::type_id::create("item");
        start_item(item);
        item.strobe.constraint_mode(0);
        item.randomize() with {APB_READ_WRITE == 1'b0; APB_TRANSFER == 1'b1; APB_ADDR == i; APB_WDATA == 32'd0; PRST_N == 1'b1;};
        finish_item(item);
      end
   
    for(int i = 85 ; i < 90 ;i++)
      begin
        APB_sequence_item item;
        item = APB_sequence_item::type_id::create("item");
        start_item(item);
        item.strobe.constraint_mode(0);
        item.randomize() with {APB_READ_WRITE == 1'b0; APB_TRANSFER == 1'b1; APB_ADDR == i; APB_WDATA == 32'd0; PRST_N == 1'b1;};
        finish_item(item);
      end
    
    for(int i = 165 ; i < 170 ;i++)
      begin
        APB_sequence_item item;
        item = APB_sequence_item::type_id::create("item");
        start_item(item);
        item.strobe.constraint_mode(0);
        item.randomize() with {APB_READ_WRITE == 1'b0; APB_TRANSFER == 1'b1; APB_ADDR == i; APB_WDATA == 32'd0; PRST_N == 1'b1;};
        finish_item(item);
      end
  endtask
endclass


// TC 10 & 13 TC_RANDOM_PSTRB and TC_CONSTR_PSTRB

 
class random_strobe extends APB_sequence;
  `uvm_object_utils(random_strobe)
  
  function new(string name = "random_strobe");
    super.new(name);
  endfunction
  
   task body();
    reset();
    pstrobe();
  endtask
   
  task pstrobe();
    //randomizing the strobe signal in the location from 1-16
    for(int i = 0 ; i < 16 ;i++)
      begin
        APB_sequence_item item;
        item = APB_sequence_item::type_id::create("item");
        start_item(item);
        item.wdata.constraint_mode(0);
        item.randomize() with {APB_READ_WRITE == 1'b1; APB_TRANSFER == 1'b1; APB_ADDR == i; APB_WDATA == 32'd1515870810; PRST_N == 1'b1;};
        finish_item(item);
      end
    
    //reading them and checking the correctness of data
    for(int i = 0 ; i < 16 ;i++)
      begin
        APB_sequence_item item;
        item = APB_sequence_item::type_id::create("item");
        start_item(item);
        item.strobe.constraint_mode(0);
        item.randomize() with {APB_READ_WRITE == 1'b0; APB_TRANSFER == 1'b1; APB_ADDR == i; APB_WDATA == 32'd0; PRST_N == 1'b1;};
        finish_item(item);
      end
  endtask
endclass


// TC 11,12 , 8   ,CONSTRAINT RANDOM READ AND WRITE ,RANDOM ADDRESSS AND BOUNDARY COVERAGE

class random_addr_rw_sequence extends APB_sequence;
  `uvm_object_utils(random_addr_rw_sequence)
  
  function new(string name = "random_addr_rw_sequence");
    super.new(name);
  endfunction
  
  task body();
    reset();
    random_addr();
  endtask
  
  task random_addr();
    repeat(20)
      begin
        APB_sequence_item item;
        item = APB_sequence_item :: type_id :: create("item");
        start_item(item);
        item.randomize() with {PRST_N == 1'b1; APB_TRANSFER == 1'b1;};
        finish_item(item);
      end
  endtask
endclass
    

// TC 3,4 state transition check from idle to access state and checking the state when transfer is zero


class state_sequence extends APB_sequence;
  `uvm_object_utils(state_sequence)
  
  function new(string name = "state_sequence");
    super.new(name);
  endfunction
  
  
  task body();
    reset();
    state_trans();
  endtask
  
  task state_trans();
     APB_sequence_item item;
    repeat(10)
      begin
       
        item = APB_sequence_item :: type_id :: create("item");
        start_item(item);
        item.randomize() with {PRST_N == 1'b1; APB_TRANSFER == 1'b0;};
        finish_item(item);
        #20;
        start_item(item);
        item.randomize() with {PRST_N == 1'b1; APB_TRANSFER == 1'b0;};
        finish_item(item);
      end
  endtask
endclass
