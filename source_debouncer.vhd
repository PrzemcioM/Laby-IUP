----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:57:08 03/21/2018 
-- Design Name: 
-- Module Name:    debouncer - Behavioral 
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

entity debouncer is
    Port ( key_i : in STD_LOGIC;
			  clk_i : in STD_LOGIC;
           key_stable_o : out STD_LOGIC);
end debouncer;

architecture Behavioral of debouncer is
signal q : std_logic := '0';
signal key_synch : std_logic := '0';
signal key_stable_out : std_logic := '0';
begin
	process (clk_i) is
	variable delay_cntr : integer range 0 to 63 := 0;
	begin
	  if rising_edge(clk_i) then
		 q <= key_i;
		 key_synch <= q;
		 if (key_synch = key_stable_out) then
			delay_cntr := 0;
		 else
			delay_cntr := delay_cntr + 1;
		 end if;
		 if (delay_cntr = 63) then
			key_stable_out <= key_synch;
			delay_cntr := 0;
		 end if;
	  end if;
	end process;
	key_stable_o <= key_stable_out;
end Behavioral;

