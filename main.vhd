----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:55:43 04/20/2018 
-- Design Name: 
-- Module Name:    main - Behavioral 
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

entity main is
    Port ( rst,clk_i : in  STD_LOGIC;
           ps2_clk_i : in  STD_LOGIC;
           ps2_data_i : in  STD_LOGIC;
			  wys : out STD_LOGIC_Vector (0 to 6);
			  signal dp: out std_logic;
			  signal an_d : out std_logic_vector (3 downto 0)
 			  );
	signal clk_p: std_logic;
	signal sw_d : std_logic_vector (3 downto 0);
	signal wys0,wys1,wys2,wys3: std_logic_vector (0 to 6);
	signal czytaj: std_logic;
	signal data: std_logic_vector (10 downto 0);
end main;

architecture Behavioral of main is

COMPONENT dzielnik
    PORT(
			rst : IN  std_logic;
			clk : IN  std_logic;
			clk_p : OUT  std_logic
        );
END COMPONENT;

COMPONENT leddis
    PORT(
			signal sw_d : in std_logic_vector (3 downto 0);
			signal wys: out std_logic_vector (0 to 6);
			signal an_d : out std_logic_vector (3 downto 0); 
			signal clk_i,rst: in std_logic;
			signal wys0,wys1,wys2,wys3: in std_logic_vector (0 to 6);
			signal dp: out std_logic
        );
END COMPONENT;

begin

	dzl: dzielnik2 PORT MAP 
	(
		rst => rst,
		clk => clk_i,
		clk_p => clk_p
    );
	 
	 led: leddis PORT MAP
	 (
		clk_i => clk_i,
		rst => rst,
		dp => dp,
		an_d => an_d,
		wys => wys,
		wys0 => wys0,
		wys1 => wys1,
		wys2 => wys2,
		wys3 => wys3,
		sw_d => sw_d
	);
	
	wys1 <= "1111111";
	wys2 <= "1111111";
	wys3 <= "1111111";
	
	wykryj_zbocze: process(clk_p) is
		variable old_kla_clk std_logic := '1';
		begin
			if rising_edge(clk_p) then
				if old_kla_clk = '1' and ps2_clk_i = '0' then
					czytaj <= '1';
				else 
					czytaj <= '0';
				end if;
			end if;
			if rising_edge(clk_p) then
				old_kla_clk := ps2_clk_i;
			end if;
		end process wykryj_zbocze;
		
	czytanie_znakow: process(clk_p) is
		variable n : integer range 0 to 10 :=0;
		begin
			if czytaj = '1' and rising_edge(clk_p) then
				data(n) <= ps2_data_i;
				n:= n+1;
			end if;
			if n=10 then
				n:= 0;
			end if;
		end process czytanie_znakow;
	
	display:  process(data) is
		begin
			case  data(8 downto 1) is
				when "01000101" => wys0 <= "0000001"; --0 45
				when "00010110" => wys0 <= "1001111"; --1 16
				when "00011110" => wys0 <= "0010010"; --2 1E
				when "0011" => wys0 <= "0000110"; --3
				when "0100" => wys0 <= "1001100"; --4
				when "0101" => wys0 <= "0100100"; --5
				when "0110" => wys0 <= "0100000"; --6
				when "0111" => wys0 <= "0001111"; --7
				when "1000" => wys0 <= "0000000"; --8
				when "1001" => wys0 <= "0000100"; --9 
				when "1010" => wys0 <= "0001000"; --A
				when "1011" => wys0 <= "1100000"; --B
				when "1100" => wys0 <= "0110001"; --C
				when "1101" => wys0 <= "1000010"; --D
				when "1110" => wys0 <= "0110000"; --E
				when "1111"=> wys0 <= "0111000"; --F
				when others => wys0 <= "1111111" -- wygaszenie
			end case;
		end process display;
		
end Behavioral;

