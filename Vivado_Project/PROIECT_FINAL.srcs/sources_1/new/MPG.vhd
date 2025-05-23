library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MPG is
    Port ( CLK : in STD_LOGIC;
           BTN : in STD_LOGIC;
           ENABLE : out STD_LOGIC);
end MPG;

architecture Behavioral of MPG is

signal count: std_logic_vector (15 downto 0);
signal q1,q2,q3: std_logic;

begin

    process(CLK)
    begin
     
        if rising_edge(clk) 
            then count <= count+1;
        end if;
     
    end process;
     
    process(CLK)
    begin
     
        if rising_edge(CLK) then 
            if count=X"FFFF" then
                 q1 <= BTN;
            end if;
    end if;
     
    end process;
     
    process(CLK)
    begin
        if rising_edge(CLK) then 
            q2 <= q1; 
            q3 <= q2;
        end if;
     
    end process;
     
    ENABLE <= q2 and (not q3);

end Behavioral;
