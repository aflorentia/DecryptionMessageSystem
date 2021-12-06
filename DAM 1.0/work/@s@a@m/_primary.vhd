library verilog;
use verilog.vl_types.all;
entity sam is
    port(
        str             : in     vl_logic;
        mode            : in     vl_logic;
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        msg             : out    vl_logic;
        frame           : out    vl_logic
    );
end sam;
