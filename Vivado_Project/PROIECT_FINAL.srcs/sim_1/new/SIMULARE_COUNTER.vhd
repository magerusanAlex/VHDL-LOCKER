library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TB_COUNTER is
end TB_COUNTER;

architecture Behavioral of TB_COUNTER is
    component COUNTER is
        Port ( CLK : in STD_LOGIC;
               RST : in STD_LOGIC;
               BTN_UP : in STD_LOGIC;
               BTN_DOWN : in STD_LOGIC;
               NUMAR : out STD_LOGIC_VECTOR (3 downto 0));
    end component;

    signal CLK, RST, BTN_UP, BTN_DOWN : STD_LOGIC := '0';
    signal NUMAR : STD_LOGIC_VECTOR(3 downto 0);
    
    constant CLK_PERIOD : time := 10 ns;  -- 100 MHz clock

begin
    uut: COUNTER port map (
        CLK => CLK,
        RST => RST,
        BTN_UP => BTN_UP,
        BTN_DOWN => BTN_DOWN,
        NUMAR => NUMAR
    );

    -- Clock generation process
    clk_process: process
    begin
        CLK <= '0';
        wait for CLK_PERIOD/2;
        CLK <= '1';
        wait for CLK_PERIOD/2;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- Initialize inputs
        RST <= '1';
        BTN_UP <= '0';
        BTN_DOWN <= '0';
        wait for 20 ns;
        
        -- Test 1: Release reset
        RST <= '0';
        wait for 20 ns;
        
        -- Test 2: Single increment
        BTN_UP <= '1';
        wait for CLK_PERIOD;
        BTN_UP <= '0';
        wait for 20 ns;
        
        -- Test 3: Multiple increments
        for i in 1 to 3 loop
            BTN_UP <= '1';
            wait for CLK_PERIOD;
            BTN_UP <= '0';
            wait for 20 ns;
        end loop;
        
        -- Test 4: Single decrement
        BTN_DOWN <= '1';
        wait for CLK_PERIOD;
        BTN_DOWN <= '0';
        wait for 20 ns;
        
        -- Test 5: Multiple decrements
        for i in 1 to 2 loop
            BTN_DOWN <= '1';
            wait for CLK_PERIOD;
            BTN_DOWN <= '0';
            wait for 20 ns;
        end loop;
        
        -- Test 6: Reset while counting
        RST <= '1';
        wait for CLK_PERIOD;
        RST <= '0';
        wait for 20 ns;
        
        -- Test 7: Increment to overflow (15->0)
        for i in 1 to 16 loop
            BTN_UP <= '1';
            wait for CLK_PERIOD;
            BTN_UP <= '0';
            wait for 20 ns;
        end loop;
        
        -- Test 8: Decrement to underflow (0->15)
        for i in 1 to 2 loop
            BTN_DOWN <= '1';
            wait for CLK_PERIOD;
            BTN_DOWN <= '0';
            wait for 20 ns;
        end loop;
        
        -- Test 9: Simultaneous buttons (should have no effect)
        BTN_UP <= '1';
        BTN_DOWN <= '1';
        wait for CLK_PERIOD;
        BTN_UP <= '0';
        BTN_DOWN <= '0';
        wait for 20 ns;
        
        -- End simulation
        wait;
    end process;

end Behavioral;