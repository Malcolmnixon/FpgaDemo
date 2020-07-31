-------------------------------------------------------------------------------
--! @file
--! @brief FPGA Demo top-level module
-------------------------------------------------------------------------------

--! Using IEEE library
LIBRARY ieee;

--! Using IEEE standard logic components
USE ieee.std_logic_1164.ALL;

--! Using IEE standard numeric components
USE ieee.numeric_std.ALL;

--! @brief FPGA Demo top-level entity
ENTITY fpga_demo IS
    PORT (
        led_out : OUT   std_logic_vector(7 DOWNTO 0) --! LED outputs
    );
END ENTITY fpga_demo;

--! Architecture rtl of fpga_demo entity
ARCHITECTURE rtl OF fpga_demo IS

    SIGNAL osc       : std_logic;            --! Internal oscillator (11.08MHz)
    SIGNAL lock      : std_logic;            --! PLL Lock 
    SIGNAL clk       : std_logic;            --! Main clock (99.72MHz)
    SIGNAL rst       : std_logic;            --! Reset
    SIGNAL clk_10khz : std_logic;            --! Divided clock (10KHz)
    SIGNAL clk_2hz   : std_logic;            --! Divided clock (2Hz)
    SIGNAL blink     : unsigned(7 DOWNTO 0); --! Blink barrel-shift register

    --! Component declaration for the MachX02 internal oscillator
    COMPONENT osch IS
        GENERIC (
            nom_freq : string := "11.08"
        );
        PORT ( 
            stdby    : IN    std_logic;
            osc      : OUT   std_logic;
            sedstdby : OUT   std_logic
        );
    END COMPONENT osch;

    --! Component delcaration for the PLL
    COMPONENT pll IS
        PORT (
            clki  : IN    std_logic;
            clkop : OUT   std_logic;
            lock  : OUT   std_logic
        );
    END COMPONENT pll;

BEGIN

    --! Instantiate the internal oscillator for 11.08MHz 
    i_osch : osch
        GENERIC MAP (
            nom_freq => "11.08"
        )
        PORT MAP (
            stdby    => '0',
            osc      => osc,
            sedstdby => OPEN
        );

    --! Instantiate the PLL (9.85MHz -> 98.5MHz)
    i_pll : pll
        PORT MAP (
            clki  => osc,
            clkop => clk,
            lock  => lock
        );
        
    --! Create a 2Hz clock
    i_clk_2hz : ENTITY work.clk_div_n
        GENERIC MAP (
            divide => 50_000_000
        )
        PORT MAP (
            mod_clk_in => clk,
            mod_rst_in => rst,
            cnt_en_in  => '1',
            cnt_out    => clk_2hz
        );

    --! @brief Reset process
    --!
    --! This process provides a synchronous reset signal where possible.
    pr_reset : PROCESS (clk, lock) IS
    BEGIN
    
        IF (lock = '0') THEN
            rst <= '1';
        ELSIF (rising_edge(clk)) THEN
            rst <= '0';
        END IF;
         
    END PROCESS pr_reset;
    
    pr_blink : PROCESS (clk, rst) IS
    BEGIN
    
        IF (rst = '1') THEN
            blink <= "11111110";
        ELSIF (rising_edge(clk) AND clk_2hz = '1') THEN
            blink <= blink(6 DOWNTO 0) & blink(7);
        END IF;
        
    END PROCESS pr_blink;

    led_out <= std_logic_vector(blink);
    
END ARCHITECTURE rtl;
