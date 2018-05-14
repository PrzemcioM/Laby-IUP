--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   23:42:35 04/02/2013
-- Design Name:   
-- Module Name:   C:/Users/Adi/cw8/test_main.vhd
-- Project Name:  cw8
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: main
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;
 
ENTITY test_main IS
END test_main;
 
ARCHITECTURE behavior OF test_main IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT main
    PORT(
         clk_i : IN  std_logic;
         rst_i : IN  std_logic;
         led7_an_o : OUT  std_logic_vector(3 downto 0);
         led7_seg_o : OUT  std_logic_vector(7 downto 0);
         ps2_clk_i : IN  std_logic;
         ps2_data_i : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk_i : std_logic := '0';
   signal rst_i : std_logic := '0';
   signal ps2_clk_i : std_logic := '0';
   signal ps2_data_i : std_logic := '0';

 	--Outputs
   signal led7_an_o : std_logic_vector(3 downto 0);
   signal led7_seg_o : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_i_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: main PORT MAP (
          clk_i => clk_i,
          rst_i => rst_i,
          led7_an_o => led7_an_o,
          led7_seg_o => led7_seg_o,
          ps2_clk_i => ps2_clk_i,
          ps2_data_i => ps2_data_i
        );

   -- Clock process definitions
   clk_i_process :process is
   begin
		clk_i <= '0';
		wait for clk_i_period/2;
		clk_i <= '1';
		wait for clk_i_period/2;
   end process;
   ps2_clk_i_process :process
   begin
		ps2_clk_i <= '0';
		wait for clk_i_period*1500/2;
		ps2_clk_i <= '1';
		wait for clk_i_period*1500/2;
   end process;
   
   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100ms.
		ps2_data_i <= '1';
		wait for clk_i_period*15000;
		ps2_data_i <= '0';			-- bit startu
		wait for clk_i_period*1500;
		ps2_data_i <= '1';         -- bit nr 0
		wait for clk_i_period*1500;
		ps2_data_i <= '0';			-- bit nr 1
		wait for clk_i_period*1500;
		ps2_data_i <= '1';			-- bit nr 2
		wait for clk_i_period*1500;
		ps2_data_i <= '0';			-- bit nr 3
		wait for clk_i_period*1500;
		ps2_data_i <= '0';			-- bit nr 4
		wait for clk_i_period*1500;
		ps2_data_i <= '1';			-- bit nr 5
		wait for clk_i_period*1500;
		ps2_data_i <= '0';			-- bit nr 6
		wait for clk_i_period*1500;
		ps2_data_i <= '0';			-- bit nr 7
		wait for clk_i_period*1500;
		ps2_data_i <= '1';			-- bit parzystosci
		wait for clk_i_period*1500;
		ps2_data_i <= '1';			-- bit konca
      wait for 100ms;	

      wait for clk_i_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
