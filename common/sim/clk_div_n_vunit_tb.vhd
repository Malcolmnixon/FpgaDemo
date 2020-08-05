-------------------------------------------------------------------------------
--! @file
--! @brief Clock divider test bench
-------------------------------------------------------------------------------

--! Using IEEE library
LIBRARY ieee;

--! Using IEEE standard logic components
USE ieee.std_logic_1164.ALL;

--! Using IEE standard numeric components
USE ieee.numeric_std.ALL;

--! Using VUnit library
LIBRARY vunit_lib;

--! Using VUnit context
CONTEXT vunit_lib.vunit_context;

--! @brief clk_div_n test bench
ENTITY clk_div_n_vunit_tb IS
    GENERIC (
        runner_cfg : string  
    );
END ENTITY clk_div_n_vunit_tb;

--! Architecture tb of clk_div_n_vunit_tb entity
ARCHITECTURE tb OF clk_div_n_vunit_tb IS

    --! Stimulus record type
    TYPE t_stimulus IS RECORD
        name      : string(1 TO 20);
        clk_in    : std_logic_vector(0 TO 15);
        rst_in    : std_logic_vector(0 TO 15);
        cnt_en_in : std_logic_vector(0 TO 15);
        cnt_out   : std_logic_vector(0 TO 15);
    END RECORD t_stimulus;
    
    --! Stimulus array type
    TYPE t_stimulus_array IS ARRAY(natural RANGE <>) OF t_stimulus;
    
    --! Test bench clock period
    CONSTANT c_clk_period : time := 10 ns;
    
    --! Test stimulus
    CONSTANT c_stimulus : t_stimulus_array := 
    (
        ( 
            name      => "Hold in reset       ",
            clk_in    => "0101010101010101",
            rst_in    => "1111111111111111",
            cnt_en_in => "0000000000000000",
            cnt_out   => "0000000000000000"
        ),
        ( 
            name      => "Not enabled         ",
            clk_in    => "0101010101010101",
            rst_in    => "0000000000000000",
            cnt_en_in => "0000000000000000",
            cnt_out   => "0000000000000000"
        ),
        ( 
            name      => "Normal counting 1   ",
            clk_in    => "0101010101010101",
            rst_in    => "0000000000000000",
            cnt_en_in => "1111111111111111",
            cnt_out   => "0000000110000001"
        ),
        ( 
            name      => "Normal counting 2   ",
            clk_in    => "0101010101010101",
            rst_in    => "0000000000000000",
            cnt_en_in => "1111111111111111",
            cnt_out   => "1000000110000001"
        ),
        ( 
            name      => "Freezing count      ",
            clk_in    => "0101010101010101",
            rst_in    => "0000000000000000",
            cnt_en_in => "0000000011111111",
            cnt_out   => "1111111110000001"
        )
    );
    
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

    --! @brief Stimulus process to drive PWM unit under test
    pr_stimulus : PROCESS IS
    BEGIN

        -- Setup test
        test_runner_setup(runner, runner_cfg);
        
        -- Loop over stimulus
        FOR s IN c_stimulus'range LOOP
            -- Log start of stimulus
            REPORT "Starting: " & c_stimulus(s).name SEVERITY note;
            
            -- Loop for test stimulus
            FOR t IN 0 TO 15 LOOP
                -- Drive inputs
                clk    <= c_stimulus(s).clk_in(t);
                rst    <= c_stimulus(s).rst_in(t);
                cnt_en <= c_stimulus(s).cnt_en_in(t);
                WAIT FOR c_clk_period;
                
                -- Assert outputs
                ASSERT cnt_out = c_stimulus(s).cnt_out(t)
                    REPORT "At time " & integer'image(t) 
                    & " expected " & std_logic'image(c_stimulus(s).cnt_out(t)) 
                    & " but got " & std_logic'image(cnt_out)
                    SEVERITY error;
            END LOOP;
        END LOOP;
		
        -- Log end of test
        REPORT "Finished" SEVERITY note;
        
        -- Finish the test
        test_runner_cleanup(runner);
		
    END PROCESS pr_stimulus;
    
END ARCHITECTURE tb;
