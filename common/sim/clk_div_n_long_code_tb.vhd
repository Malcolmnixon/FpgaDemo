-------------------------------------------------------------------------------
--! @file
--! @brief Clock divider test bench using 'long-code' pattern
-------------------------------------------------------------------------------

--! Using IEEE library
LIBRARY ieee;

--! Using IEEE standard logic components
USE ieee.std_logic_1164.ALL;

--! Using IEE standard numeric components
USE ieee.numeric_std.ALL;

--! @brief clk_div_n test bench
ENTITY clk_div_n_long_code_tb IS
END ENTITY clk_div_n_long_code_tb;

--! Architecture tb of clk_div_n_long_code_tb entity
ARCHITECTURE tb OF clk_div_n_long_code_tb IS

    --! Test bench clock period
    CONSTANT c_clk_period : time := 10 ns;
    
    -- Signals to unit under test
    SIGNAL clk     : std_logic; --! Clock input to unit under test
    SIGNAL rst     : std_logic; --! Reset input to unit under test
    SIGNAL cnt_en  : std_logic; --! Count enable input to unit under test
    SIGNAL cnt_out : std_logic; --! Count output from unit under test
    
BEGIN

    --! Instantiate clk_div_n as unit under test
    i_uut : ENTITY work.clk_div_n(rtl)
        GENERIC MAP (
            divide => 4
        )
        PORT MAP (
            mod_clk_in => clk,
            mod_rst_in => rst,
            cnt_en_in  => cnt_en,
            cnt_out    => cnt_out
        );

    --! @brief Clock generation process
    pr_clock : PROCESS IS
    BEGIN
    
        -- Low for 1/2 clock period
        clk <= '0';
        WAIT FOR c_clk_period / 2;
        
        -- High for 1/2 clock period
        clk <= '1';
        WAIT FOR c_clk_period / 2;
        
    END PROCESS pr_clock;

    --! @brief Stimulus process to drive PWM unit under test
    pr_stimulus : PROCESS IS
    BEGIN
    
        -- Initialize entity inputs
        rst    <= '1';
        cnt_en <= '0';
        WAIT FOR c_clk_period;

        -- Reset for 8 clock periods
        REPORT "Starting: Hold in reset" SEVERITY note;
        rst    <= '1';
        cnt_en <= '0';
        WAIT FOR c_clk_period;
        ASSERT (cnt_out = '0') REPORT "Expected 0 but got " & std_logic'image(cnt_out) SEVERITY error;
        WAIT FOR c_clk_period;
        ASSERT (cnt_out = '0') REPORT "Expected 0 but got " & std_logic'image(cnt_out) SEVERITY error;
        WAIT FOR c_clk_period;
        ASSERT (cnt_out = '0') REPORT "Expected 0 but got " & std_logic'image(cnt_out) SEVERITY error;
        WAIT FOR c_clk_period;
        ASSERT (cnt_out = '0') REPORT "Expected 0 but got " & std_logic'image(cnt_out) SEVERITY error;
        WAIT FOR c_clk_period;
        ASSERT (cnt_out = '0') REPORT "Expected 0 but got " & std_logic'image(cnt_out) SEVERITY error;
        WAIT FOR c_clk_period;
        ASSERT (cnt_out = '0') REPORT "Expected 0 but got " & std_logic'image(cnt_out) SEVERITY error;
        WAIT FOR c_clk_period;
        ASSERT (cnt_out = '0') REPORT "Expected 0 but got " & std_logic'image(cnt_out) SEVERITY error;
        WAIT FOR c_clk_period;
        ASSERT (cnt_out = '0') REPORT "Expected 0 but got " & std_logic'image(cnt_out) SEVERITY error;
        
        -- Take out of reset, but keep counting disabled for 8 clock periods
        REPORT "Starting: Not enabled" SEVERITY note;
        rst <= '0';
        WAIT FOR c_clk_period;
        ASSERT (cnt_out = '0') REPORT "Expected 0 but got " & std_logic'image(cnt_out) SEVERITY error;
        WAIT FOR c_clk_period;
        ASSERT (cnt_out = '0') REPORT "Expected 0 but got " & std_logic'image(cnt_out) SEVERITY error;
        WAIT FOR c_clk_period;
        ASSERT (cnt_out = '0') REPORT "Expected 0 but got " & std_logic'image(cnt_out) SEVERITY error;
        WAIT FOR c_clk_period;
        ASSERT (cnt_out = '0') REPORT "Expected 0 but got " & std_logic'image(cnt_out) SEVERITY error;
        WAIT FOR c_clk_period;
        ASSERT (cnt_out = '0') REPORT "Expected 0 but got " & std_logic'image(cnt_out) SEVERITY error;
        WAIT FOR c_clk_period;
        ASSERT (cnt_out = '0') REPORT "Expected 0 but got " & std_logic'image(cnt_out) SEVERITY error;
        WAIT FOR c_clk_period;
        ASSERT (cnt_out = '0') REPORT "Expected 0 but got " & std_logic'image(cnt_out) SEVERITY error;
        WAIT FOR c_clk_period;
        ASSERT (cnt_out = '0') REPORT "Expected 0 but got " & std_logic'image(cnt_out) SEVERITY error;
        
        -- Enable counting and verify output every fourth clock period
        REPORT "Starting: Normal counting 1" SEVERITY note;
        cnt_en <= '1';
        WAIT FOR c_clk_period;
        ASSERT (cnt_out = '0') REPORT "Expected 0 but got " & std_logic'image(cnt_out) SEVERITY error;
        WAIT FOR c_clk_period;
        ASSERT (cnt_out = '0') REPORT "Expected 0 but got " & std_logic'image(cnt_out) SEVERITY error;
        WAIT FOR c_clk_period;
        ASSERT (cnt_out = '0') REPORT "Expected 0 but got " & std_logic'image(cnt_out) SEVERITY error;
        WAIT FOR c_clk_period;
        ASSERT (cnt_out = '1') REPORT "Expected 1 but got " & std_logic'image(cnt_out) SEVERITY error;
        WAIT FOR c_clk_period;
        ASSERT (cnt_out = '0') REPORT "Expected 0 but got " & std_logic'image(cnt_out) SEVERITY error;
        WAIT FOR c_clk_period;
        ASSERT (cnt_out = '0') REPORT "Expected 0 but got " & std_logic'image(cnt_out) SEVERITY error;
        WAIT FOR c_clk_period;
        ASSERT (cnt_out = '0') REPORT "Expected 0 but got " & std_logic'image(cnt_out) SEVERITY error;
        WAIT FOR c_clk_period;
        ASSERT (cnt_out = '1') REPORT "Expected 1 but got " & std_logic'image(cnt_out) SEVERITY error;
        
        -- Enable counting and verify output every fourth clock period
        REPORT "Starting: Normal counting 2" SEVERITY note;
        WAIT FOR c_clk_period;
        ASSERT (cnt_out = '0') REPORT "Expected 0 but got " & std_logic'image(cnt_out) SEVERITY error;
        WAIT FOR c_clk_period;
        ASSERT (cnt_out = '0') REPORT "Expected 0 but got " & std_logic'image(cnt_out) SEVERITY error;
        WAIT FOR c_clk_period;
        ASSERT (cnt_out = '0') REPORT "Expected 0 but got " & std_logic'image(cnt_out) SEVERITY error;
        WAIT FOR c_clk_period;
        ASSERT (cnt_out = '1') REPORT "Expected 1 but got " & std_logic'image(cnt_out) SEVERITY error;
        WAIT FOR c_clk_period;
        ASSERT (cnt_out = '0') REPORT "Expected 0 but got " & std_logic'image(cnt_out) SEVERITY error;
        WAIT FOR c_clk_period;
        ASSERT (cnt_out = '0') REPORT "Expected 0 but got " & std_logic'image(cnt_out) SEVERITY error;
        WAIT FOR c_clk_period;
        ASSERT (cnt_out = '0') REPORT "Expected 0 but got " & std_logic'image(cnt_out) SEVERITY error;
        WAIT FOR c_clk_period;
        ASSERT (cnt_out = '1') REPORT "Expected 1 but got " & std_logic'image(cnt_out) SEVERITY error;
        
        -- Enable counting and verify output every fourth clock period
        REPORT "Starting: Freezing count" SEVERITY note;
        cnt_en <= '0';
        WAIT FOR c_clk_period;
        ASSERT (cnt_out = '1') REPORT "Expected 1 but got " & std_logic'image(cnt_out) SEVERITY error;
        WAIT FOR c_clk_period;
        ASSERT (cnt_out = '1') REPORT "Expected 1 but got " & std_logic'image(cnt_out) SEVERITY error;
        WAIT FOR c_clk_period;
        ASSERT (cnt_out = '1') REPORT "Expected 1 but got " & std_logic'image(cnt_out) SEVERITY error;
        WAIT FOR c_clk_period;
        ASSERT (cnt_out = '1') REPORT "Expected 1 but got " & std_logic'image(cnt_out) SEVERITY error;
        cnt_en <= '1';
        WAIT FOR c_clk_period;
        ASSERT (cnt_out = '0') REPORT "Expected 0 but got " & std_logic'image(cnt_out) SEVERITY error;
        WAIT FOR c_clk_period;
        ASSERT (cnt_out = '0') REPORT "Expected 0 but got " & std_logic'image(cnt_out) SEVERITY error;
        WAIT FOR c_clk_period;
        ASSERT (cnt_out = '0') REPORT "Expected 0 but got " & std_logic'image(cnt_out) SEVERITY error;
        WAIT FOR c_clk_period;
        ASSERT (cnt_out = '1') REPORT "Expected 1 but got " & std_logic'image(cnt_out) SEVERITY error;
        
        -- Log end of test
        REPORT "Finished" SEVERITY note;
        
        -- Finish the simulation
        std.env.finish;
		
    END PROCESS pr_stimulus;
    
END ARCHITECTURE tb;
