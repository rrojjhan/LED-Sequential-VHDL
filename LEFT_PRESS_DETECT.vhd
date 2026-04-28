library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

--******************************************************************************
--*
--* Name:     LEFT_PRESS_DETECT
--* Designer: Luis Mercado & Rachnicha Rojjhanarittikorn
--*
--* Detects rising edges on the synchronized left button signal. Generates a
--* single clock-cycle enable pulse 'leftEn' whenever the left button is pressed.
--* This ensures that each press results in exactly one movement command,
--* preventing unintended multiple movements due to button bounce or holding.
--*
--******************************************************************************

entity LEFT_PRESS_DETECT is
    Port (
        safeLeftSignal : in  STD_LOGIC;
        reset          : in  STD_LOGIC;
        clock          : in  STD_LOGIC;
        leftEn         : out STD_LOGIC
    );
end LEFT_PRESS_DETECT;

architecture LEFT_PRESS_DETECT_ARCH of LEFT_PRESS_DETECT is

    constant ACTIVE : std_logic := '1';
    signal lastState : std_logic := '0';

begin

    process(clock, reset)
    begin
        if reset = ACTIVE then
            leftEn    <= '0';
            lastState <= '0';
        elsif rising_edge(clock) then
            if safeLeftSignal = ACTIVE and lastState = not ACTIVE then
                leftEn <= '1';  -- Rising edge detected
            else
                leftEn <= '0';
            end if;
            lastState <= safeLeftSignal;
        end if;
    end process;

end LEFT_PRESS_DETECT_ARCH;
