----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:20:26 04/02/2013 
-- Design Name: 
-- Module Name:    clkTest - Behavioral 
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

entity clkTest is
    Port ( clk_i : in  STD_LOGIC;
           ps2_clk_i : in  STD_LOGIC;
           clk_o : out  STD_LOGIC);
end clkTest;

architecture Behavioral of clkTest is
signal stan : STD_LOGIC:='0';
signal licz : integer range 0 to 250 :=0;
begin
process(clk_i)
begin
if rising_edge(clk_i) then
		if licz = 250 then
			if stan/='0' and ps2_clk_i='0' then
			clk_o <= '1';
			licz <= 0;
			else
			clk_o <= '0';
			licz <= 0;
			end if;
		stan <= ps2_clk_i;
		else
		licz <= licz + 1;
		end if;
end if;
end process;

end Behavioral;

