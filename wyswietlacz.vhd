library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity wyswietlacz is
    port (
                clk_wys : in std_logic := '0' ;
               rst_i : in std_logic := '0';

                led7_seg_wysw : out std_logic_vector (7 downto 0 ) := "00000000" ;
                led7_an_wysw  : out std_logic_vector (3 downto 0) := "0000" ;

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