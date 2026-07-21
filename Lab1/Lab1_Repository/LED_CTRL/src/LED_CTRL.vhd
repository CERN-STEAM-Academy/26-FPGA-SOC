-------------------------------------------------------------
-- FPGA SoCs: Unleashing the Next Generation
-- of Embedded Systems
-------------------------------------------------------------
-- LED_CTRL : RGB LED controller FSM
-------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity LED_CTRL is
   port(
      clk_i : in std_logic;
      -- Command button signals
      btn_red   : in std_logic;
      btn_green : in std_logic;
      btn_blue  : in std_logic;
      btn_ctrl  : in std_logic;
      -- LD PWM output signals
      red   : out std_logic_vector(7 downto 0);
      green : out std_logic_vector(7 downto 0);
      blue  : out std_logic_vector(7 downto 0);
      -- LedOFF signals
      fLed4Off : out std_logic;
      fLed5Off : out std_logic
   );
end LED_CTRL;

architecture RTL of LED_CTRL is
-- Clock divider, will determine the frequency at which
-- the color components will increase/decrease
-- 125MHz/12500000 = 10Hz
constant CLK_DIV : integer := 12500000;
--Clock divider counter and signal
signal clkCnt : integer := 0;
signal slowClk : std_logic;

-- colorCnt will determine the PWM values to be sent to the RGB Led color components
-- colorCnt(9 downto 5) will be increasing and colorCnt(4 downto 0) will be decreasing
signal colorCnt : unsigned(9 downto 0) := "0000011111";
-- specCnt determines which color components are swept
-- 0: decrease Red, increase Green
-- 1: decrease Green, increase Blue
-- 2: decrease Blue, increase Red
signal specCnt : integer range 0 to 2 := 0;
-- State machine states definition
type state_type is (stIdle,   -- Both Leds are on, show sweeping color
                     stRed,   -- Show Red color only
                     stGreen, -- Show Green color only
                     stBlue,  -- Show Blue color only
                     stLed2Off, -- Turn off Ld17
                     stLed1Off, -- Turn off Ld16
                     stLed12Off -- Turn off both Leds
                     ); 
-- State machine signal definitions
signal state, nState : state_type;
signal btn_red_d, btn_green_d, btn_blue_d, btn_ctrl_d : std_logic;
signal btn_red_X, btn_green_X, btn_blue_X, btn_ctrl_X : std_logic;

begin
   -- State machine registerred process
   SYNC_PROC: process(clk_i)
   begin
      if rising_edge(clk_i) then
            state <= nState;
            
            --Create delayed version of input btns
            btn_red_d <= btn_red;
            btn_green_d <= btn_green;
            btn_blue_d <= btn_blue;
            btn_ctrl_d <= btn_ctrl;
            
            --Assing '1' to X version of btn only when rising edge occurs on btn. Assign '0' otherwise
            if btn_red_d = '0' and btn_red = '1' then 
                btn_red_X <= '1';
            else
                btn_red_X <= '0';
            end if;
            
            if btn_green_d = '0' and btn_green = '1' then 
                btn_green_X <= '1';
            else
                btn_green_X <= '0';
            end if;
            
            if btn_blue_d = '0' and btn_blue = '1' then 
                btn_blue_X <= '1';
            else
                btn_blue_X <= '0';
            end if;
            
            if btn_ctrl_d = '0' and btn_ctrl = '1' then 
                btn_ctrl_X <= '1';
            else
                btn_ctrl_X <= '0';
            end if;        
            
      end if;
   end process;
   
   -- Next State decode process
   NEXT_STATE_DECODE: process(state, btn_ctrl_X, btn_blue_X, btn_green_X, btn_red_X)
   begin
      nState <= state;  -- Default: Stay in the current state
      case state is
         when stIdle => -- show sweeping color
            if btn_red_X = '1' then
               nState <= stRed;
            elsif btn_green_X = '1' then
               nState <= stGreen;
            elsif btn_blue_X = '1' then
               nState <= stBlue;
            elsif btn_ctrl_X = '1' then
               nState <= stLed2Off;
            end if;
         when stRed => -- show red only
            if btn_green_X = '1' then
               nState <= stGreen;
            elsif btn_blue_X = '1' then
               nState <= stBlue;
            elsif btn_ctrl_X = '1' then
               nState <= stIdle;
            end if;
         when stGreen => -- show green only
            if btn_red_X = '1' then
               nState <= stRed;
            elsif btn_blue_X = '1' then
               nState <= stBlue;
            elsif btn_ctrl_X = '1' then
               nState <= stIdle;
            end if;
         when stBlue => -- show blue only
            if btn_red_X = '1' then
               nState <= stRed;
            elsif btn_green_X = '1' then
               nState <= stGreen;
            elsif btn_ctrl_X = '1' then
               nState <= stIdle;
            end if;
         when stLed2Off => -- turn off Ld5
            if btn_ctrl_X = '1' then
               nState <= stLed1Off;
            end if;
         when stLed1Off => -- turn off Ld4
            if btn_ctrl_X = '1' then
               nState <= stLed12Off;
            end if;
         when stLed12Off => -- turn off both Ld5 and Ld5
            if btn_ctrl_X = '1' then
               nState <= stIdle;
            end if;
         when others => nState <= stIdle;
      end case;      
   end process;
   
-- clock prescaler
   Prescaller: process(clk_i)
   begin
      if rising_edge(clk_i) then
         if clkCnt = CLK_DIV-1 then
            clkCnt <= 0;
         else
            clkCnt <= clkCnt + 1;
         end if;
      end if;
   end process Prescaller;
   
   slowClk <= '1' when clkCnt = CLK_DIV-1 else '0';
      
   process(clk_i)
   begin
      if rising_edge(clk_i) then
         if slowClk = '1' then
            if colorCnt = b"1111000001" then -- at the end of the color sweeping, 
               colorCnt <= b"0000011111";    -- start over and change the colors which are swept
               if specCnt = 2 then 
                  specCnt <= 0;
               else
                  specCnt <= specCnt + 1;
               end if;
            else -- colorCnt (9 downto 5) will be increasing 
                 -- and colorCnt(4 downto 0) will be decreasing
               colorCnt <= colorCnt + b"0000011111";
            end if;
         end if;
      end if;
   end process;
   
   process(state, colorCnt, specCnt, btn_red, btn_green, btn_blue)
   begin
      if state = stRed then
         red   <= b"000" & b"11111";
         green <= b"0000" & b"0000";
         blue  <= b"0000" & b"0000";
      elsif state = stGreen then
         red   <= b"0000" & b"0000";
         green <= b"000" & b"11111";
         blue  <= b"0000" & b"0000";
      elsif state = stBlue then
         red   <= b"0000" & b"0000";
         green <= b"0000" & b"0000";
         blue  <= b"000" & b"11111";
      else
         case specCnt is 
            when 0 =>
               red   <= b"000" & std_logic_vector(colorCnt(4 downto 0)); -- Decrease Red, increase Green
               green <= b"000" & std_logic_vector(colorCnt(9 downto 5));
               blue  <= b"0000" & b"0000";
            when 1 => 
               red   <= b"0000" & b"0000"; 
               green <= b"000" & std_logic_vector(colorCnt(4 downto 0)); -- Decrease Green, increase Blue
               blue  <= b"000" & std_logic_vector(colorCnt(9 downto 5));
            when 2 => 
               red   <= b"000" & std_logic_vector(colorCnt(9 downto 5)); -- Decrease Blue, increase Red
               green <= b"0000" & b"0000"; 
               blue  <= b"000" & std_logic_vector(colorCnt(4 downto 0));
            when others => 
               red   <= b"0000" & b"0000"; 
               green <= b"0000" & b"0000"; 
               blue  <= b"0000" & b"0000"; 
         end case;
      end if;
	  
      if state = stLed2Off then
         fLed5Off <= '1';
         fLed4Off <= '0';
      elsif state = stLed1Off then
         fLed5Off <= '0';
         fLed4Off <= '1';
      elsif state = stLed12Off then
         fLed5Off <= '1';
         fLed4Off <= '1';
      else
         fLed5Off <= '0';
         fLed4Off <= '0';
      end if;

	  
   end process;

end RTL;
