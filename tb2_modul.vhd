--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:33:49 04/17/2018
-- Design Name:   
-- Module Name:   C:/Documents and Settings/Pawel/Desktop/iup/Zadanie 6/OdNowa6/Zad6_3/Zad6/tb_modul.vhd
-- Project Name:  Zad6
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Modul
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
 
ENTITY tb2_modul IS
END tb2_modul;
 
ARCHITECTURE behavior OF tb2_modul IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Modul
    PORT(
         btn_i : IN  std_logic_vector(3 downto 0);
         sw_i : IN  std_logic_vector(7 downto 0);
         rst_i : IN  std_logic;
         clk_i : IN  std_logic;
         led7_seg_o : OUT  std_logic_vector(7 downto 0);
         led7_an_o : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal btn_i : std_logic_vector(3 downto 0) := (others => '0');
   signal sw_i : std_logic_vector(7 downto 0) := (others => '0');
   signal rst_i : std_logic := '0';
   signal clk_i : std_logic := '0';

 	--Outputs
   signal led7_seg_o : std_logic_vector(7 downto 0);
   signal led7_an_o : std_logic_vector(3 downto 0);

   -- Clock period definitions
   constant clk_i_period : time := 1us;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Modul PORT MAP (
          btn_i => btn_i,
          sw_i => sw_i,
          rst_i => rst_i,
          clk_i => clk_i,
          led7_seg_o => led7_seg_o,
          led7_an_o => led7_an_o
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
	  		wait for 100us;
			sw_i <= "00001111" ;		-- F
	   wait for 100us;
			btn_i <= "0001" ;
	   wait for 100us;
			btn_i <= "0000" ;

			wait for 100us;
			sw_i <= "00100010" ;		-- 2.
	   wait for 100us;
			btn_i <= "0010" ;
	   wait for 100us;
			btn_i <= "0000" ;

			wait for 100us;
			sw_i <= "00000001" ;		-- 1
	   wait for 100us;
			btn_i <= "0100" ;
	   wait for 100us;
			btn_i <= "0000" ;

	  wait for 100us;
			sw_i <= "10001010" ;		-- A.
	   wait for 100us;
			btn_i <= "1000" ;
	   wait for 100us;
			btn_i <= "0000" ;
			

      wait for clk_i_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
