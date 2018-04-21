----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:49:44 03/19/2018 
-- Design Name: 
-- Module Name:    display - Behavioral 
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

entity display is
    Port ( clk_i : in std_logic;
           rst_i : in std_logic;
           digit_i : in std_logic_vector (31 downto 0) := (others => '1');
           led7_an_o : out std_logic_vector (3 downto 0) := "0000";
           led7_seg_o : out std_logic_vector (7 downto 0) := "00000000");
end display;

architecture Behavioral of display is
signal active_an : std_logic_vector(3 downto 0) := "1110";
signal reset_an : std_logic_vector(3 downto 0) := "1111";
begin
	process(clk_i, rst_i, active_an, digit_i)
      begin
      if (rst_i = '1') then
         reset_an(3 downto 0) <= "0000";
         led7_seg_o(7 downto 0) <= "00000000";
      else
         reset_an(3 downto 0) <= "1111";
         if (rising_edge(clk_i)) then
            active_an <= to_stdlogicvector(to_bitvector(active_an) rol 1);
         end if;
      end if;
      case active_an is
         when "0111" => led7_seg_o <= digit_i(31 downto 24);
         when "1011" => led7_seg_o <= digit_i(23 downto 16);
         when "1101" => led7_seg_o <= digit_i(15 downto 8);
         when "1110" => led7_seg_o <= digit_i(7 downto 0);
         when others => led7_seg_o <= "00000000";
      end case;
	end process;
	led7_an_o <= active_an and reset_an;
end Behavioral;

