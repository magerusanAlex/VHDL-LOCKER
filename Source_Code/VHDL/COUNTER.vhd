library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
 
entity COUNTER is
    Port ( CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           BTN_UP : in STD_LOGIC;
           BTN_DOWN : in STD_LOGIC;
           NUMAR : out STD_LOGIC_VECTOR (3 downto 0));
end COUNTER;
 
architecture Behavioral of COUNTER is
 
signal counter      : STD_LOGIC_VECTOR(3 downto 0) := "0000";  
signal btn_inc_prev : STD_LOGIC := '0';
signal btn_dec_prev : STD_LOGIC := '0';
 
begin
 
process(CLK, BTN_DOWN, BTN_UP, RST)
    begin           
        if RST = '1' then 
            counter <= "0000";
        else
            if rising_edge(CLK) then
                --btn_inc_prev <= BTN_UP;
                --btn_dec_prev <= BTN_DOWN;        
                
                    if BTN_UP = '1' then--and btn_inc_prev = '0' then
                        if counter = 15 then
                            counter <= "0000";
                        else
                            counter <= counter + 1;
                        end if;
                    end if;
 
                    if BTN_DOWN = '1' then  --and btn_dec_prev = '0' then
                        if counter = 0 then
                            counter <= "1111";
                        else
                            counter <= counter - 1;
                        end if;
                    end if;
 
 
                end if;
 
        end if;
end process;
 
NUMAR <= counter;
 
end Behavioral;