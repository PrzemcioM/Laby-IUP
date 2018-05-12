
--------------------------- dzielnik -------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity dzielnik is generic ( constant CntSize : integer := 50000); -- aby 1kHz - 50000 , zas do licznika 500000 bo chcemy impuls co setna czesc sekundy
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

-------------------------- debouncer --------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity debouncer is

Port (
		btn_i : in std_logic ;
		clk_i : in std_logic ;
		
		btn_stable_port : out std_logic 
		);
end debouncer ;

architecture Behavioral of debouncer is 

signal tmp : std_logic := '0' ;
signal btn_synch : std_logic := '0' ;
signal btn_stable_signal : std_logic := '0' ;

begin 
	process (clk_i) is
	
	variable delay_cntr : integer range 0 to 63 := 0;
	
	begin 
		if rising_edge(clk_i) then
		tmp <= btn_i ;
		btn_synch <= tmp;
		
		if ( btn_synch = btn_stable_signal ) then
			delay_cntr := 0;
		else 
			delay_cntr := delay_cntr + 1;
		end if;
		
		if ( delay_cntr = 63 ) then
			btn_stable_signal <= btn_synch ;
			delay_cntr := 0;
			
		end if;
	end if;
	end process;
	
	btn_stable_port <= btn_stable_signal ;
	
	end Behavioral;
	
	
-------------------------- koniec debouncer -------------------------

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


------------------------ PROGRAM GLOWNY -----------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity Modul is
	port (
	  
		start_stop_button_i : in std_logic := '0' ;
	   rst_i : in std_logic := '0' ;
		clk_i : in std_logic := '0' ;
	
		led7_seg_o : out std_logic_vector (7 downto 0 ) := "11111111" ;
		led7_an_o  : out std_logic_vector (3 downto 0)	:= "1111" 	
		
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
	
	component debouncer is
		port (
		btn_i : in std_logic ;
		clk_i : in std_logic ;
		
		btn_stable_port : out std_logic 
		
		);
		
end component debouncer ;
	
	signal clk_100hz : std_logic ;
	signal clk : std_logic ;
	signal digit : std_logic_vector ( 31 downto 0 ) := "11000000010000001100000011000000";	-- 00.00
																		
	signal licznik1 : integer := 0 ;
	signal licznik2 : integer := 0 ;
	signal licznik3 : integer := 0 ;
	signal licznik4 : integer := 0 ;
	
	signal btn_mod : std_logic := '0' ;
	signal stan : integer := 0 ;
	signal wcisnieto : std_logic := '0' ;
	
begin

	--------- PORT MAP ---------
	
		dzielnik_1k : dzielnik 
		generic map ( 50 )				-- POD TESTBENCH 50 w nawias | do symulacji 50000
		port map ( 				-- dzielnik 1kHz , domyslny do wyswietlacza
			rst_i => rst_i  ,
			clk_i => clk_i,
			clk_dz => clk 
	
				);	
		
		wysw: wyswietlacz port map (
		
			rst_i => rst_i ,
			led7_seg_wysw => led7_seg_o ,
			led7_an_wysw => led7_an_o ,
			
			clk_wys => clk ,
			
			digit_i_wysw => digit			
		);
		
		deb : debouncer port map (
		
			btn_i => start_stop_button_i ,
			clk_i => clk_i ,
		
			btn_stable_port => btn_mod  
			
		);
		
		dzielnik_100hz : dzielnik 
			generic map ( 500 )				-- POD TESTBENCH 500 w nawias | do symulacji 500000
		port map (
			rst_i => rst_i  ,
			clk_i => clk_i,
			clk_dz => clk_100hz 			-- moj drugi dzielnik 100hz
	
			);
			
	----------------------------

	licznik : process ( clk_100hz , rst_i )
		begin
			
			if stan = 3 then
				stan <= 0 ;	
			end if;
			
			if  btn_mod = '1' and wcisnieto = '0' then
				stan <= stan + 1;
				wcisnieto <= '1' ;
			elsif btn_mod = '0' and wcisnieto = '1' then
				wcisnieto <= '0';
			end if;
			
			if rst_i = '1' or stan = 0 or stan = 3 then 
				licznik1 <= 0;
				licznik2 <= 0;
				licznik3 <= 0;
				licznik4 <= 0;
				digit <= "11000000010000001100000011000000";			-- 00.00
			
			elsif rising_edge ( clk_100hz ) then				-- uzupelnic o przycisk btn_mod
		
					if stan = 1 then
						case licznik1 is														-- zapalamy stanem niskim !
							when 0 => digit ( 6 downto 0 ) <= "1000000" ;
								licznik1 <= licznik1 + 1 ; 				-- 0 -> ( 6 => '1' , others =>'0' )
							when 1 => digit ( 6 downto 0 ) <= "1111001" ;		-- 1 -> ( 1,2 => '1' , oth 0
								licznik1 <= licznik1 + 1 ;
							when 2 => digit ( 6 downto 0 ) <= "0100100" ;		-- 2 -> ( 5,2 => '1' , oth 0
								licznik1 <= licznik1 + 1 ; 
							when 3 => digit ( 6 downto 0 ) <= "0110000" ;		-- 3 -> ( 4,5 => '1', oth 0 
								licznik1 <= licznik1 + 1 ; 
							when 4 => digit ( 6 downto 0 ) <= "0011001" ;		-- 4 -> ( 0,3,4 => '1' , oth 0
								licznik1 <= licznik1 + 1 ; 
							when 5 => digit ( 6 downto 0 ) <= "0010010" ;		-- 5 -> ( 1,4 
								licznik1 <= licznik1 + 1 ; 
							when 6 => digit ( 6 downto 0 ) <= "0000010" ;		-- 6 -> ( 1 
								licznik1 <= licznik1 + 1 ; 
							when 7 => digit ( 6 downto 0 ) <= "1111000" ;		-- 7 -> ( 0,1,2
								licznik1 <= licznik1 + 1 ; 
							when 8 => digit ( 6 downto 0 ) <= "0000000" ;		-- 8 -> ( oth 0
								licznik1 <= licznik1 + 1 ; 
							when 9 => digit ( 6 downto 0 ) <= "0010000" ;		-- 9 -> ( 4
								licznik1 <= licznik1 + 1 ; 
							when others => licznik1 <= 0;
											licznik2 <= licznik2 + 1;
							end case ;	
								
						case licznik2 is
							when 0 => digit ( 14 downto 8 ) <= "1000000" ;						-- do digita
							when 1 => digit ( 14 downto 8 ) <= "1111001" ;
							when 2 => digit ( 14 downto 8 ) <= "0100100" ;
							when 3 => digit ( 14 downto 8 ) <= "0110000" ;
							when 4 => digit ( 14 downto 8 ) <= "0011001" ;
							when 5 => digit ( 14 downto 8 ) <= "0010010" ;
							when 6 => digit ( 14 downto 8 ) <= "0000010" ;
							when 7 => digit ( 14 downto 8 ) <= "1111000" ;
							when 8 => digit ( 14 downto 8 ) <= "0000000" ;
							when 9 => digit ( 14 downto 8 ) <= "0010000" ;
							when others => licznik2 <= 0 ;
												licznik3 <= licznik3 + 1;
						end case ;	
						
						case licznik3 is
							when 0 => digit ( 22 downto 16 ) <= "1000000" ;						-- do digita
							when 1 => digit ( 22 downto 16 ) <= "1111001" ;
							when 2 => digit ( 22 downto 16 ) <= "0100100" ;
							when 3 => digit ( 22 downto 16 ) <= "0110000" ;
							when 4 => digit ( 22 downto 16 ) <= "0011001" ;
							when 5 => digit ( 22 downto 16 ) <= "0010010" ;
							when 6 => digit ( 22 downto 16 ) <= "0000010" ;
							when 7 => digit ( 22 downto 16 ) <= "1111000" ;
							when 8 => digit ( 22 downto 16 ) <= "0000000" ;
							when 9 => digit ( 22 downto 16 ) <= "0010000" ;
							when others => licznik3 <= 0 ;
												licznik4 <= licznik4 + 1;	
						end case;
							
						case licznik4 is
							when 0 => digit ( 30 downto 24  ) <= "1000000" ;						-- do digita
							when 1 => digit ( 30 downto 24  ) <= "1111001" ;
							when 2 => digit ( 30 downto 24  ) <= "0100100" ;
							when 3 => digit ( 30 downto 24  ) <= "0110000" ;
							when 4 => digit ( 30 downto 24  ) <= "0011001" ;
							when 5 => digit ( 30 downto 24  ) <= "0010010" ;
							when others => digit(31 downto 0) <= "10111111001111111011111110111111";	-- --.-- 					

						end case;		 
						end if;
				
			end if;
					
					digit(23) <= '0' ; 							-- staly przecinek przy 2 liczbie od lewej, bo jest zawsze
		
		end process licznik ;

end Behavioral;


