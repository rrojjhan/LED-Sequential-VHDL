library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

--******************************************************************************
--*
--* Name:     SIGNAL_SYNC
--* Designer: Luis Mercado & Rachnicha Rojjhanarittikorn
--*
--* A synchronization chain is an effective technique for handling asynchronous
--* inputs in synchronous systems. By passing the asynchronous signal through a
--* series of flip-flops, the chain provides additional time for the signal to
--* stabilize, reducing the risk of metastability and improving system reliability.
--*
--******************************************************************************

entity SIGNAL_SYNC is
    Port (
        leftButton      : in  STD_LOGIC;
        rightButton     : in  STD_LOGIC;
        safeLeftSignal  : out STD_LOGIC;
        safeRightSignal : out STD_LOGIC;
        reset           : in  STD_LOGIC;
        clock           : in  STD_LOGIC
    );
end SIGNAL_SYNC;

architecture SIGNAL_SYNC_ARCH of SIGNAL_SYNC is

    constant ACTIVE : std_logic := '1';
    signal left_sync1,  left_sync2  : std_logic;
    signal right_sync1, right_sync2 : std_logic;

begin

    -- Synchronize leftButton
    process(clock, reset)
    begin
        if (reset = ACTIVE) then
            left_sync1 <= '0';
            left_sync2 <= '0';
        elsif (rising_edge(clock)) then
            left_sync1 <= leftButton;
            left_sync2 <= left_sync1;
        end if;
    end process;

    -- Synchronize rightButton
    process(clock, reset)
    begin
        if (reset = ACTIVE) then
            right_sync1 <= '0';
            right_sync2 <= '0';
        elsif (rising_edge(clock)) then
            right_sync1 <= rightButton;
            right_sync2 <= right_sync1;
        end if;
    end process;

    safeLeftSignal  <= left_sync2;
    safeRightSignal <= right_sync2;

end SIGNAL_SYNC_ARCH;
