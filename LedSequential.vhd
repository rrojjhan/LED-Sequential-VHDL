library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

--******************************************************************************
--*
--* Name:     LedSequential (Top-Level)
--* Designer: Luis Mercado & Rachnicha Rojjhanarittikorn
--*
--* This is the top-level module. It integrates all the components to create
--* a system where a single lit LED moves left or right across a 16-LED bar
--* in response to button presses. The current position is displayed both in
--* hexadecimal and decimal formats on a four-digit seven-segment display.
--* A reset button is used to reset the system to its starting position.
--*
--******************************************************************************

entity LedSequential is
    Port (
        leftButton  : in  STD_LOGIC;
        rightButton : in  STD_LOGIC;
        reset       : in  STD_LOGIC;
        clock       : in  STD_LOGIC;
        leds        : out STD_LOGIC_VECTOR (15 downto 0);
        sevenSegs   : out STD_LOGIC_VECTOR (6 downto 0);
        anodes      : out STD_LOGIC_VECTOR (3 downto 0)
    );
end LedSequential;

architecture LedSequential_ARCH of LedSequential is

    signal safeLeftSignal  : std_logic;
    signal safeRightSignal : std_logic;
    signal leftEn          : std_logic;
    signal rightEn         : std_logic;
    signal ledPosition     : std_logic_vector (3 downto 0);
    signal lowDigit        : std_logic_vector (3 downto 0);
    signal highDigit       : std_logic_vector (3 downto 0);
    signal digit2          : std_logic_vector (3 downto 0);
    signal digit3          : std_logic_vector (3 downto 0);
    signal blank0          : std_logic;
    signal blank1          : std_logic;
    signal blank2          : std_logic;
    signal blank3          : std_logic;

    -- Component declarations
    component SIGNAL_SYNC
        port (
            leftButton      : in  std_logic;
            rightButton     : in  std_logic;
            safeLeftSignal  : out std_logic;
            safeRightSignal : out std_logic;
            reset           : in  std_logic;
            clock           : in  std_logic
        );
    end component;

    component LEFT_PRESS_DETECT
        port (
            safeLeftSignal : in  std_logic;
            leftEn         : out std_logic;
            reset          : in  std_logic;
            clock          : in  std_logic
        );
    end component;

    component RIGHT_PRESS_DETECT
        port (
            safeRightSignal : in  std_logic;
            rightEn         : out std_logic;
            reset           : in  std_logic;
            clock           : in  std_logic
        );
    end component;

    component POSITION_DETECTOR
        port (
            leftEn      : in  STD_LOGIC;
            rightEn     : in  STD_LOGIC;
            reset       : in  STD_LOGIC;
            clock       : in  STD_LOGIC;
            ledPosition : out STD_LOGIC_VECTOR (3 downto 0)
        );
    end component;

    component LED_MUX
        port (
            ledPosition : in  std_logic_vector (3 downto 0);
            leds        : out std_logic_vector (15 downto 0);
            reset       : in  std_logic;
            clock       : in  std_logic
        );
    end component;

    component BINARY_TO_DECIMAL
        port (
            ledPosition : in  std_logic_vector (3 downto 0);
            lowDigit    : out std_logic_vector (3 downto 0);
            highDigit   : out std_logic_vector (3 downto 0);
            reset       : in  std_logic;
            clock       : in  std_logic
        );
    end component;

    component SevenSegmentDriver
        port (
            lowDigit  : in  std_logic_vector (3 downto 0);
            highDigit : in  std_logic_vector (3 downto 0);
            digit2    : in  std_logic_vector (3 downto 0);
            digit3    : in  std_logic_vector (3 downto 0);
            blank0    : in  std_logic;
            blank1    : in  std_logic;
            blank2    : in  std_logic;
            blank3    : in  std_logic;
            sevenSegs : out STD_LOGIC_VECTOR (6 downto 0);
            anodes    : out STD_LOGIC_VECTOR (3 downto 0);
            reset     : in  std_logic;
            clock     : in  std_logic
        );
    end component;

begin

    digit2 <= "1111";
    blank0 <= '0';
    blank1 <= '0';
    blank2 <= '1';
    blank3 <= '0';

    SIGNAL_SYNC_INCLUDE : SIGNAL_SYNC
        port map (
            leftButton      => leftButton,
            rightButton     => rightButton,
            safeLeftSignal  => safeLeftSignal,
            safeRightSignal => safeRightSignal,
            reset           => reset,
            clock           => clock
        );

    LEFT_PRESS_DETECT_INCLUDE : LEFT_PRESS_DETECT
        port map (
            safeLeftSignal => safeLeftSignal,
            leftEn         => leftEn,
            reset          => reset,
            clock          => clock
        );

    RIGHT_PRESS_DETECT_INCLUDE : RIGHT_PRESS_DETECT
        port map (
            safeRightSignal => safeRightSignal,
            rightEn         => rightEn,
            reset           => reset,
            clock           => clock
        );

    POSITION_DETECTOR_INCLUDE : POSITION_DETECTOR
        port map (
            leftEn      => leftEn,
            rightEn     => rightEn,
            ledPosition => ledPosition,
            reset       => reset,
            clock       => clock
        );

    LED_MUX_INCLUDE : LED_MUX
        port map (
            ledPosition => ledPosition,
            leds        => leds,
            reset       => reset,
            clock       => clock
        );

    BINARY_TO_DECIMAL_INCLUDE : BINARY_TO_DECIMAL
        port map (
            ledPosition => ledPosition,
            lowDigit    => lowDigit,
            highDigit   => highDigit,
            reset       => reset,
            clock       => clock
        );

    SevenSegmentDriver_INCLUDE : SevenSegmentDriver
        port map (
            lowDigit  => lowDigit,
            highDigit => highDigit,
            digit2    => digit2,
            digit3    => digit3,
            blank0    => blank0,
            blank1    => blank1,
            blank2    => blank2,
            blank3    => blank3,
            sevenSegs => sevenSegs,
            anodes    => anodes,
            reset     => reset,
            clock     => clock
        );

end LedSequential_ARCH;
