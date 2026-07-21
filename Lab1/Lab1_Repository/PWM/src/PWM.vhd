-------------------------------------------------------------
-- FPGA SoCs: Unleashing the Next Generation
-- of Embedded Systems
-------------------------------------------------------------
-- PWM : 8-bit PWM generator
-- IP core developed for this course module
-------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

entity PWM is
    Port ( clk_i       : in  STD_LOGIC;
           data_i      : in  STD_LOGIC_VECTOR (7 downto 0);
           PWM_o : out STD_LOGIC);
end PWM;

architecture RTL of PWM is

signal cnt : unsigned(7 downto 0) := (others=>'0');

begin

   COUNT: process(clk_i)
   begin
      if rising_edge(clk_i) then
         cnt <= cnt + 1;
      end if;
   end process COUNT;
   
   COMPARE: process(data_i, cnt)
   begin
      if cnt < unsigned(data_i) then
         PWM_o <= '1';
      else
         PWM_o <= '0';
      end if;
   end process COMPARE;

end RTL;
