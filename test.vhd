LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;
 
ENTITY test IS
END test;
 
ARCHITECTURE behavior OF test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT main
    PORT(
         clk_i : IN  std_logic;
         rst_i : IN  std_logic;
         TXD_o : OUT  std_logic;
			bit_start : IN std_logic;
			bit_stop : IN std_logic;
			data : IN std_logic;
         RXD_i : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk_i : std_logic := '0';
   signal rst_i : std_logic := '0';
   signal RXD_i : std_logic := '0';
	signal bit_start : std_logic := '0';
	signal bit_stop : std_logic := '0';
	signal data : std_logic := '0';

 	--Outputs
   signal TXD_o : std_logic;

   -- Clock period definitions
   constant clk_i_period : time := 20ns;
   constant period : time := 0.10416666ms;		-- == 1/9600 baud rate
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: main PORT MAP (
          clk_i => clk_i,
          rst_i => rst_i,
          TXD_o => TXD_o,
			 bit_start => bit_start,
			 bit_stop => bit_stop,
			 data => data,
          RXD_i => RXD_i
        );

   -- Clock process definitions
   clk_i_process :process
   begin
		clk_i <= '0';
		wait for clk_i_period/2;
		clk_i <= '1';
		wait for clk_i_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100ms.
     RXD_i <= '1';
	  wait for period*5;
	  RXD_i <= '0';
	  bit_start <='1';
	  wait for period;
	  RXD_i <= '1';
	  bit_start <='0';
	  data <='1';
	  wait for period;
	  RXD_i <= '1';
	  data <='0';
	  wait for period;
	  RXD_i <= '0';
	  data <='1';
	  wait for period;
	  RXD_i <= '1';
	  data <='0';
	  wait for period;
	  RXD_i <= '0';
	  data <='1';
	  wait for period;
	  RXD_i <= '0';
	  data <='0';
	  wait for period;
	  RXD_i <= '0';
	  data <='1';
	  wait for period;
	  RXD_i <= '0';
	  data <='0';
	  wait for period;
	  RXD_i <= '1';
	  bit_stop <='1';
	  wait for period;
	  bit_stop <='0';
	  
	  wait for period/2;
	  bit_start <='1';
	  wait for period;
	  bit_start <='0';
	  data <='1';
	  wait for period;
	  data <='0';
	  wait for period;
	  data <='1';
	  wait for period;
	  data <='0';
	  wait for period;
	  data <='1';
	  wait for period;
	  data <='0';
	  wait for period;
	  data <='1';
	  wait for period;
	  data <='0';
	  wait for period;
	  bit_stop <='1';
	  wait for period;
	  bit_stop <='0';
	  
      -- insert stimulus here 

      wait;
   end process;

END;
