library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

--******************************************************************************
--*
--* Name:     RIGHT_PRESS_DETECT
--* Designer: Luis Mercado & Rachnicha Rojjhanarittikorn
--*
--* Detects rising edges on the synchronized right button signal. Generates a
--* single clock-cycle enable pulse 'rightEn' whenever the right button is pressed.
--* This ensures that each press results in exactly one movement command,
--* preventing unintended multiple movements due to button bounce or holding.
--*
--******************************************************************************

entity RIGHT_PRESS_DETECT is
    Port (
        safeRightSignal : in  STD_LOGIC;
        reset           : in  STD_LOGIC;
        clock           : in  STD_LOGIC;
        rightEn         : out STD_LOGIC
    );
end RIGHT_PRESS_DETECT;

architecture RIGHT_PRESS_DETECT_ARCH of RIGHT_PRESS_DETECT is

    constant ACTIVE : std_logic := '1';
    signal lastState : std_logic := '0';

begin

    process(clock, reset)
    begin
        if reset = ACTIVE then
            rightEn   <= '0';
            lastState <= '0';
        elsif rising_edge(clock) then
            if safeRightSignal = ACTIVE and lastState = not ACTIVE then
                rightEn <= '1';  -- Rising edge detected
            else
                rightEn <= '0';
            end if;
            lastState <= safeRightSignal;
        end if;
    end process;

end RIGHT_PRESS_DETECT_ARCH;
