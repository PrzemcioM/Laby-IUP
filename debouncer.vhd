library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity debouncer is

Port (
	btn_i : in STD_LOGIC;
	clk_i : in STD_LOGIC;
    btn_stable_port : out STD_LOGIC);
end debouncer;

architecture Behavioral of debouncer is

signal tmp : std_logic := '0';
signal btn_synch : std_logic := '0';			--current btn state
signal btn_stable_signal : std_logic := '0';	--lsat state

begin
	process (clk_i) is
	variable delay_cntr : integer range 0 to 63 := 0;
	begin
	  if rising_edge(clk_i) then
		 tmp <= btn_i;
		 btn_synch <= tmp;

		 if (btn_synch = btn_stable_signal) then	--no go if input = '0' and not stable
			delay_cntr := 0;
		 else										--go if input 1 and unstable
			delay_cntr := delay_cntr + 1;
		 end if;

		 if (delay_cntr = 63) then					--if waited for stabilization
			btn_stable_signal <= btn_synch;
			delay_cntr := 0;

		 end if;

	  end if;
	end process;
	btn_stable_port <= btn_stable_signal; 	--signal of stabilizaton is outputted
end Behavioral;

