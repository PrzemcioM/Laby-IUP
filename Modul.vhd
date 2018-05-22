
--------------------------- dzielnik -------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity dzielnik is generic ( constant CntSize : integer := 50000000);
						port ( 			
							rst_i : in std_logic := '0';
							clk_i : in std_logic := '0' ;
							clk_dz : out std_logic := '0'
							);
end dzielnik;

architecture Behavioral of dzielnik is

shared variable licznik :  integer  := 0 ; 
signal stan : std_logic := '0';

begin

dzielnik : process ( clk_i , rst_i )
	begin
		
		if rst_i = '1' then
			stan <= '0' ;
			clk_dz <= '0' ;
			licznik := 0; 	
		
		elsif rising_edge(clk_i) then 
							
			licznik := licznik + 1;
			
			if licznik = CntSize   or licznik = (CntSize/2) then
				stan <= not stan;
			end if;
			if licznik = CntSize then licznik := 0;
			end if;
			clk_dz <= stan;
		end if;

end process dzielnik;

end Behavioral;

-------------------------- koniec dzielnika ------------------------- 

-------------------------- wyswietlacz ------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity wyswietlacz is
	port (
				clk_wys : in std_logic := '0' ;
			   rst_i : in std_logic := '0';
	
				led7_seg_wysw : out std_logic_vector (7 downto 0 ) := "11111111" ;
				led7_an_wysw  : out std_logic_vector (3 downto 0) := "1111" ;
				
				digit_i_wysw : in std_logic_vector( 31 downto 0 ) := ( others => '0' ) 
				
	);
	
end wyswietlacz;

architecture Behavioral of wyswietlacz is

shared variable licznik_multi : integer  := 0 ;

	begin
				
	wyswietl : process ( rst_i , clk_wys )
		begin  
		
			if rst_i = '1' then
				led7_an_wysw <= "1111" ;
				licznik_multi := 0 ;
				
			elsif rising_edge( clk_wys ) then

			if licznik_multi = 0 then
				led7_seg_wysw <= digit_i_wysw ( 7 downto 0 );
				led7_an_wysw <= ( 0 => '0' , others => '1' );
				
			elsif licznik_multi  = 1 then
				led7_seg_wysw <= digit_i_wysw ( 15 downto 8 );
			   led7_an_wysw <= ( 1 => '0' , others => '1' );
				
			elsif licznik_multi  = 2 then
				led7_seg_wysw <= digit_i_wysw ( 23 downto 16 );
				led7_an_wysw <= ( 2 => '0' , others => '1' );
				
			elsif licznik_multi = 3 then
				led7_seg_wysw <= digit_i_wysw ( 31 downto 24 );
				led7_an_wysw <= ( 3 => '0' , others => '1' );
								
			end if;
			
				licznik_multi  := licznik_multi  + 1 ;
				 
				if licznik_multi = 4 then
					licznik_multi := 0 ;
				end if;
		end if;
			
	end process wyswietl ;
	
end Behavioral;

------------------------- koniec wyswietlacza -----------------------

------------------------- Program glowny ----------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Modul is
	    Port ( 
			  clk_i : in  STD_LOGIC;
           rst_i : in  STD_LOGIC;
           led7_an_o : out  STD_LOGIC_VECTOR (3 downto 0);
           led7_seg_o : out  STD_LOGIC_VECTOR (7 downto 0);
           ps2_clk_i : in  STD_LOGIC;
           ps2_data_i : in  STD_LOGIC
			  );

end Modul;

architecture Behavioral of Modul is

	component dzielnik is 
		generic ( CntSize : integer := 50000 );
		port (
				rst_i : in std_logic;
				clk_i : in std_logic;
				clk_dz : out std_logic 
				
				);
	end component dzielnik;
	
	component wyswietlacz is 
		port (
				rst_i : in std_logic;
				led7_seg_wysw : out std_logic_vector (7 downto 0 ) := "11111111" ;
				led7_an_wysw  : out std_logic_vector (3 downto 0) := "1111" ;
				
				clk_wys : in std_logic ;
				digit_i_wysw : in std_logic_vector(31 downto 0 )
				);
				
	end component wyswietlacz;

	-- sygnaly programu glownego ( signal )
	
	signal clk : std_logic := '0' ;
	signal digit : std_logic_vector( 31 downto 0 ) := "11111111111111111111111111111111" ;                                                  
	signal data : std_logic_vector ( 10 downto 0 ) := "00000000000" ;
	signal stan : integer := 0 ; 
	signal break : std_logic := '1' ;
	signal data_old : std_logic_vector( 8 downto 1 ) := "00000000" ;
	signal data_old2 : std_logic_vector( 8 downto 1 ) := "00000000" ;
	signal data_pamietaj : std_logic_vector( 8 downto 1 ) := "00000000" ;
	---

begin

	--------- PORT MAP ---------

	dzielnik_1k : dzielnik 
		generic map ( 50000 )				
		port map ( 				-- dzielnik 1kHz , domyslny do wyswietlacza
			rst_i => rst_i  ,
			clk_i => clk_i,
			clk_dz => clk 
	);	

	wysw: wyswietlacz port map (
		
			rst_i => rst_i ,
			led7_seg_wysw => led7_seg_o ,
			led7_an_wysw => led7_an_o ,
			
			clk_wys => clk,
			
			digit_i_wysw => digit			
	);

	----------------------------
	
	glowny : process ( ps2_clk_i , rst_i )
	
	variable n : integer range 1 to 8 := 1 ;
	
	begin
		if rst_i = '1' then 
			stan <= 0 ;
			data( 10 downto 0 ) <= "00000000000" ;
			break <= '0' ;
		
		elsif falling_edge( ps2_clk_i ) then
			
			if stan = 0 then							-- stan opisujacy poczatek czytania z klawiatury
			
				data( 10 downto 0 ) <= "00000000000" ;
			
					if ps2_data_i = '0' then
						data(0) <= ps2_data_i;			-- zapisuje bit startu do data
						stan <= 1 ;
					end if;
			
			elsif stan = 1 then						-- zczytuje data(8-1)
			
				data(n) <= ps2_data_i ;
				
				if n = 8 then
					stan <= 2;
					n := 1;
				else
					n := n + 1;
				end if;
			
			elsif stan = 2 then						-- kontrola bitu parzystosci
				
				data(9)	<= ps2_data_i;
				
				if ps2_data_i = ( data(1) xnor data(2) xnor data(3) xnor data(4) xnor data(5) xnor data(6) xnor data(7) xnor data(8)) then  
					stan <= 3 ;
				else 
					stan <= 0 ;
				end if;

			elsif stan = 3 then						-- stan przypisan
			
				data(10) <= ps2_data_i ;		-- zapisujemy bit stopu czyli '1'
				
				if data_old(8 downto 1 ) = "11110000" and break = '0' then				-- break -> F0
					break <= '1' ;
				
				elsif ( break = '1' and data_pamietaj(8 downto 1) = data_old(8 downto 1) ) or data_pamietaj = "0000000"  then 
					case  data(8 downto 1)  is						-- od 1 do 8 bitu - bity danych 
				
						when "01000101" => 	digit(6 downto 0 ) <= "1000000"; -- 0 45				-- sprawdzic te "" po lewej 
						when "00010110" => 	digit(6 downto 0 ) <= "1111001"; -- 1 16
						when "00011110" => 	digit(6 downto 0 ) <= "0100100"; -- 2 1E
						when "00100110" =>	digit(6 downto 0 ) <= "0110000"; --3 26	
						when "00100101" =>	digit(6 downto 0 ) <= "0011001"; --4 25
						when "00101110" =>	digit(6 downto 0 ) <= "0010010"; --5 2E
						when "00110110" =>	digit(6 downto 0 ) <= "0000010"; --6 36
						when "00111101" =>	digit(6 downto 0 ) <= "1111000"; --7 3D
						when "00111110" =>	digit(6 downto 0 ) <= "0000000"; --8 3E
						when "01000110" =>	digit(6 downto 0 ) <= "0010000"; --9 46
						when "00011100" =>	digit(6 downto 0 ) <= "0001000"; --A 1C
						when "00110010" =>	digit(6 downto 0 ) <= "0000011"; --B 32
						when "00100001" =>	digit(6 downto 0 ) <= "1000110"; --C 21
						when "00100011" => 	digit(6 downto 0 ) <= "0100001"; --D 23
						when "00100100" =>	digit(6 downto 0 ) <= "0000110"; --E 24
						when "00101011" =>	digit(6 downto 0 ) <= "0001110"; --F 2B
						when others  	 =>	digit(6 downto 0 ) <= "1111111";
					end case;
					break <= '0' ;
					data_pamietaj(8 downto 1) <= data(8 downto 1);
			  end if;
			  
			data_old( 8 downto 1 ) <= data(8 downto 1 ) ; 
			data_old2(8 downto 1 ) <= data_old(8 downto 1);
			stan <= 0 ;
			
			end if;
		end if;

			digit( 31 downto 7 )<= "1111111111111111111111111" ;

	end process;
end Behavioral;

