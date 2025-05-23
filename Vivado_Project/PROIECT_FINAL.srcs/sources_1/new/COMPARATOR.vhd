library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity COMPARATOR is
    Port ( A0 : in STD_LOGIC_VECTOR (3 downto 0);
           A1 : in STD_LOGIC_VECTOR (3 downto 0);
           A2 : in STD_LOGIC_VECTOR (3 downto 0);
           A3 : in STD_LOGIC_VECTOR (3 downto 0);
           B0 : in STD_LOGIC_VECTOR (3 downto 0);
           B1 : in STD_LOGIC_VECTOR (3 downto 0);
           B2 : in STD_LOGIC_VECTOR (3 downto 0);
           B3 : in STD_LOGIC_VECTOR (3 downto 0);
           EGAL : out STD_LOGIC);
end COMPARATOR;

architecture Behavioral of COMPARATOR is

begin

    EGAL <= '1' when (A0 = B0) and 
                     (A1 = B1) and 
                     (A2 = B2) and 
                     (B3 = "1111") and 
                     (A3 = "1111") 
            else '0';


end Behavioral;
