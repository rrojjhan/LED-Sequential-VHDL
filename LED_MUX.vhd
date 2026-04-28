library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

--******************************************************************************
--*
--* Name:     LED_MUX
--* Designer: Luis Mercado & Rachnicha Rojjhanarittikorn
--*
--* Controls which of the 16 LEDs is lit based on the 'ledPosition' input.
--* Outputs a 16-bit vector where only the bit corresponding to the current
--* position is set, ensuring only one LED is illuminated at any time.
--*
--******************************************************************************

entity LED_MUX is
    Port (
        ledPosition : in  STD_LOGIC_VECTOR (3 downto 0);
        reset       : in  STD_LOGIC;
        clock       : in  STD_LOGIC;
        leds        : out STD_LOGIC_VECTOR (15 downto 0)
    );
end LED_MUX;

architecture LED_MUX_ARCH of LED_MUX is

    constant ACTIVE : std_logic := '1';

begin

    process(reset, clock)
    begin
        if (reset = ACTIVE) then
            leds    <= (others => '0');
            leds(0) <= '1';
        elsif (rising_edge(clock)) then
            leds <= (others => '0');
            leds(TO_INTEGER(unsigned(ledPosition))) <= '1';
        end if;
    end process;

end LED_MUX_ARCH;
