----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:33:20 03/16/2018 
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

entity leddis is
	port(
		signal sw_d : in std_logic_vector (3 downto 0);
		signal wys: out std_logic_vector (0 to 6);
		signal an_d : out std_logic_vector (3 downto 0); 
		signal clk_i,rst: in std_logic;
		signal wys0,wys1,wys2,wys3:in std_logic_vector (0 to 6);
		signal dp: out std_logic
	);
	signal clk_p: std_logic;
	signal seg: std_logic_vector (1 downto 0);
end leddis;



architecture Behavioral of leddis is

COMPONENT dzielnik
    PORT(
        rst : IN  std_logic;
        clk : IN  std_logic;
        clk_p : OUT  std_logic
        );
END COMPONENT;




begin
	dzl: dzielnik PORT MAP 
	(
		rst => rst,
		clk => clk_i,
		clk_p => clk_p
    );
	 
	
	mux: process(seg,rst) is
		begin
			if rst='1' then
				an_d <= "0000";
			else
				case seg is
					when "00" => an_d <="1110";
					when "01" => an_d <="1101";
					when "10" => an_d <="1011";
					when others => an_d <="0111";
				end case;
			end if;
			
			if rst='1' then
				wys <= "0000000";
			else
				case seg is
					when "00" => wys <= wys0;
					when "01" => wys <= wys1;
					when "10" => wys <= wys2;
					when others => wys <= wys3;
				end case;
			end if;
			
			
		end process mux;
	
	mux_dp: process(seg,rst) is
		begin
			if rst='1' then
				dp <= '0';
			else
				case seg is
					when "00" => dp <= not sw_d(0);
					when "01" => dp <= not sw_d(1);
					when "10" => dp <= not sw_d(2);
					when others => dp <= not sw_d(3);
				end case;
			end if;
		end process mux_dp;
	
	licz: process(clk_p) is
		variable n: std_logic_vector(1 downto 0) := "00";
		begin
				if rising_edge(clk_p) then
				 n:= n+1;
				 seg <= n;
				end if;
				
		end process licz;
	
	--trs0: process(lc0) is
	--	begin
		
	--		case  lc0 is
	--			when 0 => wys0 <= "0000001"; --0
	--			when 1 => wys0 <= "1001111"; --1
	--			when 2 => wys0 <= "0010010"; --2
	--			when 3 => wys0 <= "0000110"; --3
	--			when 4 => wys0 <= "1001100"; --4
	--			when 5 => wys0 <= "0100100"; --5
	--			when 6 => wys0 <= "0100000"; --6
	--			when 7 => wys0 <= "0001111"; --7
	--			when 8 => wys0 <= "0000000"; --8
	--			when 9 => wys0 <= "0000100"; --9 
	--		end case;
			
	--	end process trs0;
		
		

end Behavioral;


