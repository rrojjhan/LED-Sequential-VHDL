library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

--******************************************************************************
--*
--* Name:     LedSequential_TB
--* Designer: Luis Mercado & Rachnicha Rojjhanarittikorn
--*
--* Testbench for the LedSequential design. Simulates various left/right button
--* presses, holding a button, and resetting mid-operation. Includes clock and
--* reset generation and applies stimuli to 'leftButton' and 'rightButton'.
--*
--******************************************************************************

entity LedSequential_TB is
end LedSequential_TB;

architecture LedSequential_TB_ARCH of LedSequential_TB is

    -- Unit Under Test
    component LedSequential is
        Port (
            leftButton  : in  STD_LOGIC;
            rightButton : in  STD_LOGIC;
            reset       : in  STD_LOGIC;
            clock       : in  STD_LOGIC;
            leds        : out STD_LOGIC_VECTOR (15 downto 0);
            sevenSegs   : out STD_LOGIC_VECTOR (6 downto 0);
            anodes      : out STD_LOGIC_VECTOR (3 downto 0)
        );
    end component;

    -- Signals
    signal leftButton  : std_logic := '0';
    signal rightButton : std_logic := '0';
    signal reset       : std_logic := '0';
    signal clock       : std_logic := '0';
    signal leds        : std_logic_vector (15 downto 0);
    signal sevenSegs   : std_logic_vector (6 downto 0);
    signal anodes      : std_logic_vector (3 downto 0);

    constant clock_period : time := 10 ns;  -- 100 MHz clock

begin

    UUT : LedSequential
        Port Map (
            leftButton  => leftButton,
            rightButton => rightButton,
            reset       => reset,
            clock       => clock,
            leds        => leds,
            sevenSegs   => sevenSegs,
            anodes      => anodes
        );

    -- Clock generation
    clock_process : process
    begin
        clock <= '0';
        wait for clock_period / 2;
        clock <= '1';
        wait for clock_period / 2;
    end process;

    -- Stimulus process
    stimulus_process : process
    begin
        -- Hold reset for a few clock cycles
        wait for 50 ns;
        reset <= '0';           -- Release reset
        wait for 50 ns;

        -- Test Case 1: Press left button once
        leftButton <= '1';
        wait for clock_period;
        leftButton <= '0';
        wait for 100 ns;

        -- Test Case 2: Press right button twice
        rightButton <= '1';
        wait for clock_period;
        rightButton <= '0';
        wait for 20 ns;
        rightButton <= '1';
        wait for clock_period;
        rightButton <= '0';
        wait for 100 ns;

        -- Test Case 3: Press left button five times
        for i in 1 to 5 loop
            leftButton <= '1';
            wait for clock_period;
            leftButton <= '0';
            wait for 20 ns;
        end loop;
        wait for 100 ns;

        -- Test Case 4: Press both buttons simultaneously (no movement expected)
        leftButton  <= '1';
        rightButton <= '1';
        wait for clock_period;
        leftButton  <= '0';
        rightButton <= '0';
        wait for 100 ns;

        -- Test Case 5: Hold down left button (only one move expected)
        leftButton <= '1';
        wait for 50 ns;
        leftButton <= '0';
        wait for 100 ns;

        -- Test Case 6: Reset during operation
        reset <= '1';
        wait for 20 ns;
        reset <= '0';
        wait for 100 ns;

        -- End simulation
        wait;
    end process;

end LedSequential_TB_ARCH;
