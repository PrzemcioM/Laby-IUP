----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:23:11 03/23/2018 
-- Design Name: 
-- Module Name:    dzielnik - Behavioral 
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

entity dzielnik is
port(
	signal rst, clk : in std_logic;
	signal clk_p : out std_logic
);


end dzielnik;

architecture Behavioral of dzielnik is
begin
	
	dzielnik: process(clk, rst) is
		constant N: integer :=50000;
		variable lic: integer :=0;
	begin
		if rst = '1' then
			lic:=0;
			clk_p <= '0';
		elsif rising_edge(clk) then
			lic:=lic+1;
			
			if lic = N then
				lic :=0;
			end if;
			
			if lic < N/2 then
				clk_p <= '0';
			end if;	
			
			if lic >= N/2 then
				clk_p <= '1';
			end if;
		end if;
	end process dzielnik;
end Behavioral;


architecture Behavioral of dzielnik2 is
begin
	
	dzielnik: process(clk, rst) is
		constant N: integer :=250;
		variable lic: integer :=0;
	begin
		if rst = '1' then
			lic:=0;
			clk_p <= '0';
		elsif rising_edge(clk) then
			lic:=lic+1;
			
			if lic = N then
				lic :=0;
			end if;
			
			if lic < N/2 then
				clk_p <= '0';
			end if;	
			
			if lic >= N/2 then
				clk_p <= '1';
			end if;
		end if;
	end process dzielnik;
end Behavioral;

