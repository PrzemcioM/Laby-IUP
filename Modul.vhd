library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

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
