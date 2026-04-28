library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

--******************************************************************************
--*
--* Name:     POSITION_DETECTOR
--* Designer: Luis Mercado & Rachnicha Rojjhanarittikorn
--*
--* Keeps track of the current position of the lit LED on the LED bar. Updates
--* the position based on 'leftEn' and 'rightEn' enable signals while ensuring
--* the position stays within the valid range (0 to 15).
--*   - Increments when 'leftEn' is active and position < 15 (moves left).
--*   - Decrements when 'rightEn' is active and position > 0  (moves right).
--* Outputs ledPosition as a 4-bit binary value.
--*
--******************************************************************************

entity POSITION_DETECTOR is
    Port (
        leftEn      : in  STD_LOGIC;
        rightEn     : in  STD_LOGIC;
        reset       : in  STD_LOGIC;
        clock       : in  STD_LOGIC;
        ledPosition : out STD_LOGIC_VECTOR (3 downto 0)
    );
end POSITION_DETECTOR;

architecture POSITION_DETECTOR_ARCH of POSITION_DETECTOR is

    constant ACTIVE  : std_logic := '1';
    signal   position : unsigned (3 downto 0) := (others => '0');

begin

    DUEL_SHIFT : process (reset, clock)
    begin
        if (reset = ACTIVE) then
            position <= (others => '0');
        elsif (rising_edge(clock)) then
            if (leftEn = '1' and rightEn = '0') then
                if position < 15 then
                    position <= position + 1;
                end if;
            elsif (rightEn = '1' and leftEn = '0') then
                if position > 0 then
                    position <= position - 1;
                end if;
            end if;
        end if;
    end process;

    ledPosition <= std_logic_vector(position);

end POSITION_DETECTOR_ARCH;
