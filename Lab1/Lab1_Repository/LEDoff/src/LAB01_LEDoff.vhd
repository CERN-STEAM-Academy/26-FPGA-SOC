-------------------------------------------------------------
-- FPGA SoCs: Unleashing the Next Generation
-- of Embedded Systems
-------------------------------------------------------------
-- LAB01_LEDoff : RGB LED off-gating
-------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity LAB01_LEDoff is
    Port ( LedOFF  : in  STD_LOGIC;
           red_i   : in  STD_LOGIC;
           green_i : in  STD_LOGIC;
           blue_i  : in  STD_LOGIC;
           red_o   : out STD_LOGIC;
           green_o : out STD_LOGIC;
           blue_o  : out STD_LOGIC);
end LAB01_LEDoff;

architecture Behavioral of LAB01_LEDoff is

begin
   red_o   <= red_i   when LedOFF = '0' else '0';
   green_o <= green_i when LedOFF = '0' else '0';
   blue_o  <= blue_i  when LedOFF = '0' else '0';
end Behavioral;
