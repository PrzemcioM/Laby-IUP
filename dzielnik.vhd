library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity dzielnik is generic ( constant CntSize : integer := 100); -- aby 1kHz - 50000
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