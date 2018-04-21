----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:50:05 03/19/2018 
-- Design Name: 
-- Module Name:    divider - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity divider is
    Port ( clk_i : in STD_LOGIC;
           rst_i : in STD_LOGIC;
           clk_o : out STD_LOGIC);
end divider;

architecture Behavioral of divider is
-- constant N : Integer := 2; -- for simulation == 4
constant N : Integer := 50000; -- for 1kHz == 50000
signal cnt_n : Integer range 0 to N - 1 := 0;
signal clk : std_logic := '0';
begin
process (clk_i, rst_i)
	begin
	if (rst_i = '1') then
		 cnt_n <= 0;
		 clk <= '0';
	elsif (rising_edge(clk_i)) then
			  cnt_n <= cnt_n + 1;
			  if (cnt_n = (N / 2) - (1 - (N mod 2))) then
					clk <= '1';
			  end if;
			  if cnt_n = N - 1 then
					clk <= '0';
					cnt_n <= 0;
			  end if;
	end if;
end process;
clk_o <= clk;
end Behavioral;