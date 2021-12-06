library verilog;
use verilog.vl_types.all;
entity sam_configuration is
    port(
        str             : in     vl_logic;
        clk             : in     vl_logic;
        enable          : in     vl_logic;
        n               : out    vl_logic_vector(3 downto 0);
        d               : out    vl_logic_vector(31 downto 0);
        capsn           : out    vl_logic_vector(31 downto 0)
    );
end sam_configuration;
