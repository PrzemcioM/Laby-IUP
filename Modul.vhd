<<<<<<< HEAD
=======

--------------------------- dzielnik -------------------------

>>>>>>> master
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
<<<<<<< HEAD

entity modul is
    Port ( clk_i : in std_logic;
           start_stop_button_i : in std_logic;
           rst_i : in std_logic;
           led7_an_o : out std_logic_vector (3 downto 0);
           led7_seg_o : out std_logic_vector (7 downto 0));
end modul;

architecture Behavioral of modul is
signal clk_div : std_logic;
signal timer_start : std_logic := '0';
signal timer_stop : std_logic := '0';
signal key_stable_i : std_logic := '0';
signal key_stable_down_1 : std_logic := '0';
signal key_stable_down_2 : std_logic := '0';

signal digit : std_logic_vector (31 downto 0) := "00000011000000100000001100000011";
type time_array is array (0 to 4) of integer range 0 to 9;
signal cur_time : time_array := (others => 0);

component dzielnik
    Port ( clk_i : in std_logic;
           rst_i : in std_logic;
           clk_dz : out std_logic);
end component;

component wyswietlacz
    Port (
            clk_wys : in std_logic := '0' ;
            rst_i : in std_logic := '0';
            led7_seg_wysw : out std_logic_vector (7 downto 0 ) := "00000000" ;
            led7_an_wysw  : out std_logic_vector (3 downto 0) := "0000" ;
            digit_i_wysw : in std_logic_vector( 31 downto 0 ) := ( others => '0' )
end component;

component debouncer
    Port ( btn_i : in STD_LOGIC;
              clk_i : in STD_LOGIC;
           btn_stable_port : out STD_LOGIC);
end component;

function convert_digit_to_7seg(data_i: integer range 0 to 9) return std_logic_vector is
begin
    case data_i is
        when 0 => return ("0000001"); -- 0
        when 1 => return ("1001111"); -- 1
        when 2 => return ("0010010"); -- 2
        when 3 => return ("0000110"); -- 3
        when 4 => return ("1001100"); -- 4
        when 5 => return ("0100100"); -- 5
        when 6 => return ("0100000"); -- 6
        when 7 => return ("0001111"); -- 7
        when 8 => return ("0000000"); -- 8
        when 9 => return ("0000100"); -- 9
    end case;
end function convert_digit_to_7seg;

function convert_time_array_to_7seg(data_i: time_array) return std_logic_vector is
variable tmp : std_logic_vector(31 downto 0);
begin
    tmp(0) := '1';
    tmp(8) := '1';
    tmp(16) := '0';
    tmp(24) := '1';
    if (data_i(4) = 6) then
        tmp := "11111101111111001111110111111101";
    else
        tmp(7 downto 1) := convert_digit_to_7seg(data_i(1));
        tmp(15 downto 9) := convert_digit_to_7seg(data_i(2));
        tmp(23 downto 17) := convert_digit_to_7seg(data_i(3));
        tmp(31 downto 25) := convert_digit_to_7seg(data_i(4));
    end if;
    return tmp;
end function convert_time_array_to_7seg;

begin
    div:divider
    Port Map ( clk_i => clk_i,
                rst_i => rst_i,
                clk_o => clk_div);
    dis:display
    Port Map ( clk_i => clk_div,
                rst_i => rst_i,
                digit_i => digit,
                led7_an_o => led7_an_o,
                led7_seg_o => led7_seg_o);
    deb:debouncer
    Port Map ( clk_i => clk_i,
                key_i => start_stop_button_i,
                key_stable_o => key_stable_i);

    process (clk_div, rst_i, key_stable_i)
    begin
        if (rst_i = '1') then
                cur_time(0) <= 0;
                cur_time(1) <= 0;
                cur_time(2) <= 0;
                cur_time(3) <= 0;
                cur_time(4) <= 0;
                timer_start <= '0';
                timer_stop <= '0';
        elsif (rising_edge(clk_div)) then
            key_stable_down_1 <=  key_stable_i;
            key_stable_down_2 <=  key_stable_down_1;

            if (timer_start = '0' and timer_stop = '0' and key_stable_down_1 = '0' and key_stable_i = '1') then
                  timer_start <= '1';
            end if;

            if (timer_start = '1' and timer_stop = '0' and key_stable_down_1 = '0' and key_stable_i = '1') then
                  timer_stop <= '1';
            end if;

            if (timer_start = '1' and timer_stop = '1' and key_stable_down_1 = '0' and key_stable_i = '1') then
                  timer_start <= '0';
                  timer_stop <= '0';
            end if;

            if (timer_start = '0' and timer_stop = '0') then
                  cur_time(0) <= 0;
                   cur_time(1) <= 0;
                   cur_time(2) <= 0;
                   cur_time(3) <= 0;
                   cur_time(4) <= 0;
            end if;

            if (timer_start = '1' and timer_stop = '0') then
                if (cur_time(0) < 9) then
                    cur_time(0) <= cur_time(0) + 1;
                end if;
                if (cur_time(1) < 9 and cur_time(0) = 9) then
                    cur_time(0) <= 0;
                    cur_time(1) <= cur_time(1) + 1;
                end if;
                if (cur_time(2) < 9 and cur_time(1) = 9) then
                    cur_time(1) <= 0;
                    cur_time(2) <= cur_time(2) + 1;
                end if;
                if (cur_time(3) < 9 and cur_time(2) = 9) then
                    cur_time(2) <= 0;
                    cur_time(3) <= cur_time(3) + 1;
                end if;
                if (cur_time(4) < 6 and cur_time(3) = 9) then
                    cur_time(3) <= 0;
                    cur_time(4) <= cur_time(4) + 1;
                elsif (cur_time(4) = 6) then
                    timer_stop <= '1';
                end if;
            end if;
         end if;
    end process;
    digit <= convert_time_array_to_7seg(cur_time);
end Behavioral;
=======

entity dzielnik is generic ( constant CntSize : integer := 50000); -- aby 1kHz - 50000
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
shared variable poczatek_multi : integer := 0 ;

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
			
		--end if;
		
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
	  
		btn_i : in std_logic_vector( 3 downto 0 ) := "0000" ;
		sw_i  : in std_logic_vector( 7 downto 0 ) := "00000000" ;
	   rst_i : in std_logic := '0' ;
		clk_i : in std_logic;
	
		led7_seg_o : out std_logic_vector (7 downto 0 ) := "11111111" ;
		led7_an_o  : out std_logic_vector (3 downto 0)	:= "1111" 	
		
		);
	
end Modul;

architecture Behavioral of Modul is
	
	component dzielnik is 
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

	signal clk : std_logic ;
	signal digit : std_logic_vector ( 31 downto 0 ) := "11111111111111111111111111111111";
	signal wektor_zdekodowany : std_logic_vector  ( 6 downto 0 ) := "0000000" ;
	signal ready: std_logic := '1' ;

begin

	--------- PORT MAP ---------
	
		dziel : dzielnik port map ( 
			rst_i => '0' ,
			clk_i => clk_i,
			clk_dz => clk 
	
				);	
		
		wysw: wyswietlacz port map (
		
			rst_i => '0' ,
			led7_seg_wysw => led7_seg_o ,
			led7_an_wysw => led7_an_o ,
			
			clk_wys => clk ,
			
			digit_i_wysw => digit			
		);
		
		--deb : debouncer port map (
		
			
		--);
				
	
	----------------------------

	enkoder : process ( sw_i  )
		begin
		
				if sw_i ( 3 downto 0 ) = "0000" then  				-- 4 mlodsze to 4 bitowa liczba 		
					wektor_zdekodowany ( 6 downto 0 ) <= "0100000" ;     --( 6 => '1' , others => '0' )		-- 0 
				
				elsif sw_i( 3 downto 0 ) = "0001" then			-- 1  
					wektor_zdekodowany ( 6 downto 0 ) <= "1111001" ; 							--( 1,2 => '0' , others => '1' );
				
				elsif sw_i ( 3 downto 0 ) = "0010" then			-- 2 
					wektor_zdekodowany ( 6 downto 0 ) <= "0100100" ; 							--( 5,2 => '1' , others => '0' );
					
				elsif sw_i ( 3 downto 0 ) = "0011" then			-- 3 
					wektor_zdekodowany ( 6 downto 0 ) <= "0110000" ; 							--( 5,4 => '1' , others => '0' );

				elsif sw_i( 3 downto 0 ) = "0100" then			-- 4 
					wektor_zdekodowany ( 6 downto 0 ) <= "0011001" ; 							--( 0,3,4 => '1' , others => '0' );

				elsif sw_i( 3 downto 0 ) = "0101" then			-- 5 
					wektor_zdekodowany ( 6 downto 0 ) <= "0010010"; 							--( 1,4 => '1' , others => '0' );

				elsif sw_i( 3 downto 0 ) = "0110" then			-- 6 
					wektor_zdekodowany ( 6 downto 0 ) <= "0000010" ;  						--( 1 => '1' , others => '0' );

				elsif sw_i ( 3 downto 0 ) = "0111" then			-- 7 
					wektor_zdekodowany ( 6 downto 0 ) <= "1111000" ; 							--( 0,1,2 => '0' , others => '1' );

				elsif sw_i ( 3 downto 0 ) = "1000" then			-- 8 
					wektor_zdekodowany ( 6 downto 0 ) <= "0000000" ; 							--(  others => '0' );

				elsif sw_i ( 3 downto 0 ) = "1001" then			-- 9 
					wektor_zdekodowany ( 6 downto 0 ) <= "0010000" ;  						--( 4 => '1' , others => '0' );

				elsif sw_i( 3 downto 0 ) = "1010" then			-- A
					wektor_zdekodowany ( 6 downto 0 ) <= "0001000" ; 							--( 3 => '1' , others => '0' );

				elsif sw_i( 3 downto 0 ) = "1011" then			-- B
					wektor_zdekodowany ( 6 downto 0 ) <= "0000011" ;							-- ( 0,1 => '1' , others => '0' );

				elsif sw_i ( 3 downto 0 ) = "1100" then			-- C
					wektor_zdekodowany( 6 downto 0 ) <= "0111001" ; 							--( 1,2,6 => '0' , others => '1' );

				elsif sw_i ( 3 downto 0 ) = "1101" then			-- D
					wektor_zdekodowany( 6 downto 0 ) <= "0100001" ; 							--( 0,5 => '1' , others => '0' );

				elsif sw_i ( 3 downto 0 ) = "1110" then			-- E
					wektor_zdekodowany ( 6 downto 0 ) <= "0000110" ; 							--( 1,2 => '1' , others => '0' );

				elsif sw_i ( 3 downto 0 ) = "1111" then			-- F
					wektor_zdekodowany ( 6 downto 0 ) <= "0001110" ; 							--( 1,2,3 => '1' , others => '0' );				
						
				end if;
				
	end process enkoder ;	

	pamiec : process ( clk ) 
		begin
			if rising_edge ( clk ) then
					if   btn_i(0) = '1' and ready = '1' then		
						digit ( 6 downto 0 ) <= wektor_zdekodowany ( 6 downto 0 );
							ready <= '0' ;
					elsif  btn_i(1) = '1'  and ready = '1' then
						digit ( 14 downto 8 ) <= wektor_zdekodowany ( 6 downto 0 );
								ready <= '0' ;
					elsif  btn_i(2) = '1' and ready = '1' then
						digit( 22 downto 16 ) <= wektor_zdekodowany ( 6 downto 0 );
								ready <= '0' ;
					elsif btn_i(3) = '1'  and ready = '1' then
						digit ( 30 downto 24 ) <= wektor_zdekodowany ( 6 downto 0 );
								ready <= '0' ;
					end if;
					
			if btn_i = "0000" then
				ready <= '1';
			end if;
		end if;
	end process pamiec;
	
		digit(7) <= not sw_i(4); 
		digit(15) <= not sw_i(5); 
		digit(23) <= not sw_i(6); 
		digit(31) <= not sw_i(7);
	
end Behavioral;


>>>>>>> master
