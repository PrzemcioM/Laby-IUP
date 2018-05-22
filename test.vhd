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
         RXD_i : IN  std_logic;
         led_o : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk_i : std_logic := '0';
   signal rst_i : std_logic := '0';
   signal RXD_i : std_logic := '0';

 	--Outputs
   signal TXD_o : std_logic;
   signal led_o : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_i_period : time := 20ns;
   constant period : time := 0.10416666ms;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: main PORT MAP (
          clk_i => clk_i,
          rst_i => rst_i,
          TXD_o => TXD_o,
          RXD_i => RXD_i,
          led_o => led_o
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
	  wait for period*1000;
	  RXD_i <= '0';
	  wait for period;
	  RXD_i <= '1';
	  wait for period;
	  RXD_i <= '1';
	  wait for period;
	  RXD_i <= '0';
	  wait for period;
	  RXD_i <= '1';
	  wait for period;
	  RXD_i <= '0';
	  wait for period;
	  RXD_i <= '0';
	  wait for period;
	  RXD_i <= '0';
	  wait for period;
	  RXD_i <= '0';
      -- insert stimulus here 

      wait;
   end process;

END;
