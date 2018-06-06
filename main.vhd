library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity main is
    Port ( clk_i : in  STD_LOGIC;
           rst_i : in  STD_LOGIC;
           TXD_o : out  STD_LOGIC := '1';
			  bit_start : in STD_LOGIC;
			  bit_stop : in STD_LOGIC;
			  data : in STD_LOGIC;
           RXD_i : in  STD_LOGIC
			  );
end main;

architecture Behavioral of main is
signal A: STD_LOGIC:='0';
signal B: STD_LOGIC:='0';
signal C: STD_LOGIC:='0';
signal zmianaRS: STD_LOGIC:='1';
signal stan: integer range 0 to 6:=0;
signal licznik: integer range 0 to 50000000:=0;
constant N: integer:=5208;
signal dane :  STD_LOGIC_VECTOR (7 downto 0):="00000000";
signal licznik_dane: integer range 0 to 7:=0;
begin

RS: process (licznik)
begin
	if licznik = 0  then
		if zmianaRS= '0' then
			zmianaRS <= '1';
		elsif zmianaRS = '1' then 
			zmianaRS <= '0';
		end if;
	end if;
end process;


Glowny: process (clk_i,rst_i)

begin
	if rst_i='1' then
		stan <= 0;
		licznik <= 0;
		dane <= "00000000";
		licznik_dane <= 0;
	elsif rising_edge(clk_i) then
		A<=RXD_i;
		B<=A;
		C<=B;
		case stan is
          when 0 => 
			 TXD_o<='1';
			 if C='1' and B='0' then
				stan<=1;
				licznik<=0;
			 end if;
			 when 1 => 
			 if licznik=N/2 then
				stan<=2; -- Początek odczytu
				licznik <= 0;
				else
				licznik <= licznik + 1;
				end if;
			 when 2 =>
			   if licznik=N then
						licznik<=0;
						dane(licznik_dane) <= C;
					if licznik_dane=7 then
						stan <= 3;
						licznik_dane <=0;
					else
					licznik_dane <= licznik_dane + 1;
					end if;
				else
					licznik <= licznik + 1;
				end if;
			 when 3 =>
				if licznik=N then
					stan <= 4;
					dane <= dane;
					TXD_o<='1';
					licznik<=0;
				else
					licznik <= licznik + 1;
				end if;
			 when 4 =>
				if licznik=N then
					stan <= 5;
					TXD_o<='0';
					licznik<=0;
				else
					licznik <= licznik + 1;
				end if;
			 when 5 =>
				if licznik=N then
					licznik<=0;
						TXD_o <= dane(licznik_dane);
						if licznik_dane=7 then
							stan <= 6;
							licznik_dane <=0;
						else
						licznik_dane <= licznik_dane + 1;
						end if;
				else
					licznik <= licznik + 1;
				end if;
				when 6 =>
				if licznik=N then
					stan <= 0;
					TXD_o<='1';
					licznik<=0;
				else
					licznik <= licznik + 1;
				end if;
          when others =>
				stan <= 0;
				licznik <=0;
       end case;		
			
		end if;
		
end process;
end Behavioral;

