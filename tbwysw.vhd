--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:13:22 04/15/2018
-- Design Name:   
-- Module Name:   C:/Documents and Settings/Pawel/Desktop/iup/Zadanie 6/OdNowa6/Zad6_2/Zad6/tbwysw.vhd
-- Project Name:  Zad6
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: wyswietlacz
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
 
ENTITY tbwysw IS
END tbwysw;
 
ARCHITECTURE behavior OF tbwysw IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT wyswietlacz
    PORT(
         clk_wys : IN  std_logic;
         rst_i : IN  std_logic;
         led7_seg_wysw : OUT  std_logic_vector(7 downto 0);
         led7_an_wysw : OUT  std_logic_vector(3 downto 0);
         digit_i_wysw : IN  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk_wys : std_logic := '0';
   signal rst_i : std_logic := '0';
   signal digit_i_wysw : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal led7_seg_wysw : std_logic_vector(7 downto 0);
   signal led7_an_wysw : std_logic_vector(3 downto 0);

   -- Clock period definitions
   constant clk_wys_period : time := 1us;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: wyswietlacz PORT MAP (
          clk_wys => clk_wys,
          rst_i => rst_i,
          led7_seg_wysw => led7_seg_wysw,
          led7_an_wysw => led7_an_wysw,
          digit_i_wysw => digit_i_wysw
        );

   -- Clock process definitions
   clk_wys_process :process
   begin
		clk_wys <= '0';
		wait for clk_wys_period/2;
		clk_wys <= '1';
		wait for clk_wys_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100ms.
      wait for 1ms;
			digit_i_wysw(31 downto 0 ) <= "10001000011110011010010000100000" ; -- A. 1 2. 0
      wait for 5ms;
			rst_i <= '1';
		wait for 2ms;
			rst_i <= '0';
		wait for 1ms;

      -- insert stimulus here 

      wait;
   end process;

END;
