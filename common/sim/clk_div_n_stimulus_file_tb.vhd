-------------------------------------------------------------------------------
--! @file
--! @brief Clock divider test bench
-------------------------------------------------------------------------------

--! Using IEEE library
LIBRARY ieee;

--! Using standard text-io components
USE std.textio.ALL;

--! Using IEEE standard logic components
USE ieee.std_logic_1164.ALL;

--! Using IEEE standard numeric components
USE ieee.numeric_std.ALL;

--! Using IEEE standard logic text-io components
USE ieee.std_logic_textio.all;

--! @brief clk_div_n test bench
ENTITY clk_div_n_stimulus_file_tb IS
END ENTITY clk_div_n_stimulus_file_tb;

--! Architecture tb of clk_div_n_stimulus_file_tb entity
ARCHITECTURE tb OF clk_div_n_stimulus_file_tb IS

    --! Test bench clock period
    CONSTANT c_clk_period : time := 10 ns;
    
    --! Stimulus text file
    FILE file_stimulus : text;
    
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
    
        VARIABLE v_stimulus_line : line;
        VARIABLE v_name          : string(1 TO 20);
        VARIABLE v_clk_in        : std_logic_vector(0 TO 15);
        VARIABLE v_rst_in        : std_logic_vector(0 TO 15);
        VARIABLE v_cnt_en_in     : std_logic_vector(0 TO 15);
        VARIABLE v_cnt_out       : std_logic_vector(0 TO 15);
        VARIABLE v_space         : character;
        
    BEGIN
    
        -- Open the stimulus file (and skip comment line)
        file_open(file_stimulus, "common/sim/clk_div_n_stimulus_file.txt", read_mode);
        readline(file_stimulus, v_stimulus_line);

        -- Loop over the file
        WHILE NOT endfile(file_stimulus) LOOP
        
            -- Read the next line
            readline(file_stimulus, v_stimulus_line);
            read(v_stimulus_line, v_name);
            read(v_stimulus_line, v_space);
            read(v_stimulus_line, v_clk_in);
            read(v_stimulus_line, v_space);
            read(v_stimulus_line, v_rst_in);
            read(v_stimulus_line, v_space);
            read(v_stimulus_line, v_cnt_en_in);
            read(v_stimulus_line, v_space);
            read(v_stimulus_line, v_cnt_out);

            -- Log start of stimulus
            REPORT "Starting: " & v_name SEVERITY note;
            
            -- Loop for test stimulus
            FOR t IN 0 TO 15 LOOP
                -- Drive inputs
                clk    <= v_clk_in(t);
                rst    <= v_rst_in(t);
                cnt_en <= v_cnt_en_in(t);
                WAIT FOR c_clk_period;
                
                -- Assert outputs
                ASSERT cnt_out = v_cnt_out(t)
                    REPORT "At time " & integer'image(t) 
                    & " expected " & std_logic'image(v_cnt_out(t)) 
                    & " but got " & std_logic'image(cnt_out)
                    SEVERITY error;
            END LOOP;
        
        END LOOP;
        
        -- Close the stimulus file
        file_close(file_stimulus);
        
        -- Log end of test
        REPORT "Finished" SEVERITY note;
        
        -- Finish the simulation
        std.env.finish;
		
    END PROCESS pr_stimulus;
    
END ARCHITECTURE tb;
