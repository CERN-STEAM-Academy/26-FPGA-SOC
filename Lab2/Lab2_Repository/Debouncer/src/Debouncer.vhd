-------------------------------------------------------------
-- FPGA SoCs: Unleashing the Next Generation
-- of Embedded Systems
-------------------------------------------------------------
-- Debouncer : push-button debouncer with stretched output pulse
-------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Debouncer is
   generic(
      NR_OF_CLKS : integer := 1250000 -- Number of System Clock periods while the incoming signal
   );                                 -- has to be stable until a one-shot output pulse is generated
                                      -- (default: 10 ms at 125 MHz - realistic push-button debounce)
   port(
      clk_i : in std_logic;
      sig_i : in std_logic;
      pls_o : out std_logic
   );
end Debouncer;

architecture Behavioral of Debouncer is

-- Output pulse width in clock periods. The pulse must be wide enough to be
-- reliably sampled by a SLOWER clock domain (e.g. the AXI clock of an AXI
-- GPIO input): a single-cycle pulse (8 ns at 125 MHz) can fall entirely
-- between two samples of a 100 MHz clock and be lost.
constant PULSE_CLKS : integer := 16;   -- 16 x 8 ns = 128 ns

signal cnt      : integer range 0 to NR_OF_CLKS-1;
signal pulseCnt : integer range 0 to PULSE_CLKS := 0;
signal sigTmp   : std_logic;
signal stble    : std_logic;
signal stbleTmp : std_logic;

begin

   DEB: process(clk_i)
   begin
      if rising_edge(clk_i) then
         if sig_i = sigTmp then -- Count the number of clock periods if the signal is stable
            if cnt = NR_OF_CLKS-1 then
               stble <= sig_i;
            else
               cnt <= cnt + 1;
            end if;
         else -- Reset counter and sample the new signal value
            cnt <= 0;
            sigTmp <= sig_i;
         end if;
      end if;
   end process DEB;

   PLS: process(clk_i)
   begin
      if rising_edge(clk_i) then
         stbleTmp <= stble;
         -- Stretch the one-shot pulse to PULSE_CLKS clock periods
         if stbleTmp = '0' and stble = '1' then
            pulseCnt <= PULSE_CLKS;
         elsif pulseCnt > 0 then
            pulseCnt <= pulseCnt - 1;
         end if;
      end if;
   end process PLS;

   pls_o <= '1' when pulseCnt > 0 else '0';

end Behavioral;
