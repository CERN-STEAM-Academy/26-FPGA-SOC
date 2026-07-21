-------------------------------------------------------------
-- FPGA SoCs: Unleashing the Next Generation
-- of Embedded Systems
-------------------------------------------------------------
-- VideoProcessing : real-time RGB video processing
-------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity VideoProcessing is
    Port (
        vid_data : in STD_LOGIC_VECTOR (23 downto 0);
        pHSync : in STD_LOGIC;
        pVSync : in STD_LOGIC;
        pVDE : in STD_LOGIC;
        clk_pix: in STD_LOGIC;
        SELECTION: in STD_LOGIC_VECTOR(1 downto 0);
        RED_COEFF: in STD_LOGIC_VECTOR(7 downto 0);
        GREEN_COEFF: in STD_LOGIC_VECTOR(7 downto 0);
        BLUE_COEFF: in STD_LOGIC_VECTOR(7 downto 0);
        OUT_vid_data : out STD_LOGIC_VECTOR (23 downto 0);
        OUT_pHSync : out STD_LOGIC;
        OUT_pVSync : out STD_LOGIC;
        OUT_pVDE : out STD_LOGIC
    );
    end VideoProcessing;
 
architecture RTL of VideoProcessing is

signal redSignal, greenSignal, blueSignal : unsigned(7 downto 0);
signal redCoeff, greenCoeff, blueCoeff : unsigned(7 downto 0);
signal redMod, greenMod, blueMod : unsigned(7 downto 0);
signal redMult, greenMult, blueMult : unsigned(15 downto 0);
signal grayPixel : unsigned(15 downto 0);

begin
--video signals
-- RBG packaging
redSignal   <= unsigned(vid_data(23 downto 16));
greenSignal <= unsigned(vid_data(7 downto 0));
blueSignal  <= unsigned(vid_data(15 downto 8));
-- Coefficients
redCoeff    <= unsigned(RED_COEFF); --red coeff
greenCoeff  <= unsigned(GREEN_COEFF); --green coeff
blueCoeff   <= unsigned(BLUE_COEFF); --blue coeff
  
-- Grayscale function
grayPixel <= (x"4c"*redSignal + x"97"*greenSignal +	x"1C"*blueSignal); --weighted color

-- Multiplication
redMult <= redCoeff*redSignal;
greenMult <= greenCoeff*greenSignal;
blueMult <= blueCoeff*blueSignal;

process(SELECTION)
begin
case SELECTION is
    when "00" =>
        redMod   <= redCoeff+redSignal;
        greenMod <= greenCoeff+greenSignal;
        blueMod  <= blueCoeff+blueSignal;
    when "01" =>
        redMod   <= redMult(15 downto 8);
        greenMod <= greenMult(15 downto 8);
        blueMod  <= blueMult(15 downto 8);
    when "10" =>
        redMod   <= redSignal   rol to_integer(redCoeff);
        greenMod <= greenSignal rol to_integer(greenCoeff);
        blueMod  <= blueSignal  rol to_integer(blueCoeff);
    when "11" =>
        redMod   <= grayPixel(15 downto 8);
        greenMod <= grayPixel(15 downto 8);
        blueMod  <= grayPixel(15 downto 8);
        
    when others =>
        redMod   <= redSignal;
        greenMod <= greenSignal;
        blueMod  <= blueSignal;
end case;
end process;

process(clk_pix)
begin
	if rising_edge(clk_pix) then
        OUT_pHSync <=  pHSync;
        OUT_pVSync <= pVSync;
        OUT_pVDE <= pVDE;
        OUT_vid_data(23 downto 16) <= Std_Logic_Vector(redMod); --red channel
        OUT_vid_data(15 downto  8) <= Std_Logic_Vector(blueMod); --blue channel
        OUT_vid_data( 7 downto  0) <= Std_Logic_Vector(greenMod); --green channel
    end if;
end process VideoEdition;
    
end RTL;
