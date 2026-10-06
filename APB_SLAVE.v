module APB_slave(PCLK,PRST_N,PSELX,PADDR,PWDATA,PRDATA,PWRITE,
                 PENABLE,PREADY,PSTRB,PPROT,PSLVRR);
  parameter ADDR_WIDTH   = 32;
  parameter DATA_WIDTH   = 32;
  parameter memory_depth = 256;

  input PCLK, PRST_N, PWRITE, PENABLE, PSELX;
  input [ADDR_WIDTH-1:0] PADDR;
  input [DATA_WIDTH-1:0] PWDATA;
  input [3:0] PSTRB;
  input [2:0] PPROT;

  output wire [DATA_WIDTH-1:0] PRDATA;
  output wire PREADY,PSLVRR;

  reg [DATA_WIDTH-1:0] memory [memory_depth-1:0];
  wire [1:0] wait_count, wait_cycle;
  reg  [1:0] count;
  wire valid_access;
  integer i;

  wire prot_error   = (PPROT[0] == 1'b0 || PPROT[1] == 1'b1);
  wire addr_error   = (PADDR >= memory_depth);
  wire strobe_error = (PWRITE && PSTRB == 4'b0000);

  assign valid_access = (PSELX && PENABLE && (wait_count >= wait_cycle));
  assign PREADY       = valid_access ? 1'b1 : 1'b0;
  assign wait_cycle   = PADDR[0] ? 2'd2 : 2'd0;
  assign wait_count   = (PSELX && !PENABLE) ? 2'b00 : count;

 
  assign PSLVRR = valid_access && (prot_error || addr_error || strobe_error);

  assign PRDATA = (!PWRITE && PSELX && PENABLE && valid_access
                  && !addr_error && !prot_error)
                  ? memory[PADDR[7:0]] : 32'd0;

  always@(posedge PCLK) begin
    if(!PRST_N) begin
      for(i = 0; i < memory_depth; i = i+1)
        memory[i] <= 0;
      count <= 2'b00;
    end
    else begin
      if(PSELX && PENABLE) begin
        if(wait_count < wait_cycle) begin
          count <= wait_count + 1'b1;
        end
        else begin
          count <= 2'b00;
          if(PWRITE && !prot_error && !addr_error && !strobe_error) begin
            if(PSTRB[0]) memory[PADDR[7:0]][7:0]   <= PWDATA[7:0];
            if(PSTRB[1]) memory[PADDR[7:0]][15:8]  <= PWDATA[15:8];
            if(PSTRB[2]) memory[PADDR[7:0]][23:16] <= PWDATA[23:16];
            if(PSTRB[3]) memory[PADDR[7:0]][31:24] <= PWDATA[31:24];
          end
        end
      end
    end
  end

endmodule
