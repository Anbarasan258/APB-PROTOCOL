class APB_sequence_item extends uvm_sequence_item;
  `uvm_object_utils(APB_sequence_item)

  rand logic APB_READ_WRITE,APB_TRANSFER,PRST_N;
  rand logic [3:0] APB_STROBE;
  rand logic [2:0] APB_PROTECT;
  rand logic [31:0]APB_ADDR;
  rand logic [31:0]APB_WDATA;
  logic [31:0] APB_RDATA;
  logic APB_DONE,APB_ERROR,APB_ENABLE,APB_SEL;
    constraint wdata{APB_WDATA inside {[0:200]};}
    constraint addr {APB_ADDR inside {[0:255]};}
  constraint wr_rd {APB_READ_WRITE dist {0 := 3 ,1 := 3};}
  constraint strobe {APB_STROBE dist {0:=1,[1:4] := 5, [5:8] := 2 , [9:15]:=5};}
    constraint prot {APB_PROTECT[0]!=1'b0 ; APB_PROTECT[1]!= 1'b1;}
  constraint strobe_write {(APB_READ_WRITE) -> (APB_STROBE != 4'b0000);}
constraint strobe_read  {
    (APB_READ_WRITE == 1'b0) -> (APB_STROBE == 4'b0000);
  }
    function new(string name = "APB_sequence_item");
      super.new(name);
    endfunction
 
    function void display(string name);
      `uvm_info(name,$sformatf("APB_TRANSFER=%0d | APB_READ_WRITE=%0d | APB_ADDR=%0h |APB_WDATA=%0h | APB_PROTECT=%b | APB_STROBE=%b | APB_RDATA=%0h ",APB_TRANSFER,APB_READ_WRITE,APB_ADDR,APB_WDATA,APB_PROTECT,APB_STROBE,APB_RDATA),UVM_LOW);
    endfunction
 endclass
