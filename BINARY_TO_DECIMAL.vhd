library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

--******************************************************************************
--*
--* Name:     BINARY_TO_DECIMAL
--* Designer: Luis Mercado & Rachnicha Rojjhanarittikorn
--*
--* Converts the 4-bit binary 'ledPosition' value into two BCD digits suitable
--* for display on seven-segment displays. Calculates the tens ('highDigit') and
--* ones ('lowDigit') digits from 'ledPosition'. Supports values 0–15.
--*
--******************************************************************************

entity BINARY_TO_DECIMAL is
    Port (
        ledPosition : in  STD_LOGIC_VECTOR (3 downto 0);
        lowDigit    : out STD_LOGIC_VECTOR (3 downto 0);
        highDigit   : out STD_LOGIC_VECTOR (3 downto 0);
        reset       : in  STD_LOGIC;
        clock       : in  std_logic
    );
end BINARY_TO_DECIMAL;

architecture BINARY_TO_DECIMAL_ARCH of BINARY_TO_DECIMAL is

    signal binaryValue : unsigned (3 downto 0);
    signal tens        : unsigned (3 downto 0);
    signal ones        : unsigned (3 downto 0);
    constant ACTIVE    : std_logic := '1';

begin

    TENS_AND_ONES : process (reset, clock)
    begin
        if reset = ACTIVE then
            tens <= (others => '0');
            ones <= (others => '0');
        elsif rising_edge(clock) then
            binaryValue <= unsigned(ledPosition);
            tens <= (others => '0');
            ones <= (others => '0');

            if binaryValue >= 10 then
                tens <= "0001";
                ones <= binaryValue - 10;
            else
                tens <= "0000";
                ones <= binaryValue;
            end if;
        end if;
    end process;

    highDigit <= std_logic_vector(tens);
    lowDigit  <= std_logic_vector(ones);

end BINARY_TO_DECIMAL_ARCH;
