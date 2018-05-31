--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:14:25 05/22/2018
-- Design Name:   
-- Module Name:   C:/Designs/MikoWoj9/cw9/tb9.vhd
-- Project Name:  cw9
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
 
ENTITY tb9 IS
END tb9;
 
ARCHITECTURE behavior OF tb9 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT main
    PORT(
         clk_i : IN  std_logic;
         rst_i : IN  std_logic;
         TXD_o : OUT  std_logic;
			RXD_i : IN std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk_i : std_logic := '0';
   signal rst_i : std_logic := '0';
   signal RXD_i : std_logic := '0';

 	--Outputs
   signal TXD_o : std_logic;

   -- Clock period definitions
   constant clk_i_period : time := 1us;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: main PORT MAP (
          clk_i => clk_i,
          rst_i => rst_i,
          TXD_o => TXD_o,
          RXD_i => RXD_i
        );

   -- Clock process definitions
   clk_i_process :process
   begin
		clk_i <= '0';
		wait for clk_i_period/2;
		clk_i <= '1';
		wait for clk_i_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100ms.
	  
	  RXD_i <= '1';						--1
	  wait for clk_i_period*10;
	  RXD_i <= '0';						--0
	  wait for clk_i_period*10;
	  RXD_i <= '1';						--1
	  wait for clk_i_period*10;
	  RXD_i <= '1';						--0
	  wait for clk_i_period*10;
	  RXD_i <= '0';						--0
	  wait for clk_i_period*10;
	  RXD_i <= '1';						--1
	  wait for clk_i_period*10;
	  RXD_i <= '0';						--0
	  wait for clk_i_period*10;
	  RXD_i <= '0';						--0
	  wait for clk_i_period*10;
	  RXD_i <= '0';						--0
	  wait for clk_i_period*10;
	  RXD_i <= '0';						--0
	  wait for clk_i_period*10;
	  RXD_i <= '1';						--1
      -- insert stimulus here 

      wait;
   end process;

END;




