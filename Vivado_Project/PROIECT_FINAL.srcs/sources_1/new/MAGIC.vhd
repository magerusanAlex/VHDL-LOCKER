library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity MAGIC is --aici butoanele trec ptrintr-un DEBOUNCER
    port(
        CLK : in STD_LOGIC;
        RST : in STD_LOGIC;
        
        BTN_ADD_DIGIT: in STD_LOGIC := '0';
        SWITCH_ADD_CYPHER: in STD_LOGIC;
        NUMBER_FROM_COUNTER: in STD_LOGIC_VECTOR(3 downto 0);
        
        DISPLAYED_NUMBER0: out STD_LOGIC_VECTOR(3 downto 0); 
        DISPLAYED_NUMBER1: out STD_LOGIC_VECTOR(3 downto 0); 
        DISPLAYED_NUMBER2: out STD_LOGIC_VECTOR(3 downto 0);   
        
        CURRENT_NUMBER: out STD_LOGIC_VECTOR(3 downto 0);
    
        LED_OCCUPIED: out STD_LOGIC := '0';
        LED_ADD_DIGIT: out STD_LOGIC := '1'
    );
end MAGIC;

architecture Behavioral of MAGIC is

component COMPARATOR is
    Port ( A0 : in STD_LOGIC_VECTOR (3 downto 0);
           A1 : in STD_LOGIC_VECTOR (3 downto 0);
           A2 : in STD_LOGIC_VECTOR (3 downto 0);
           A3 : in STD_LOGIC_VECTOR (3 downto 0);
           B0 : in STD_LOGIC_VECTOR (3 downto 0);
           B1 : in STD_LOGIC_VECTOR (3 downto 0);
           B2 : in STD_LOGIC_VECTOR (3 downto 0);
           B3 : in STD_LOGIC_VECTOR (3 downto 0);
           EGAL : out STD_LOGIC);
end component;


signal s_PASSWORD0, s_PASSWORD1, s_PASSWORD2, s_PASSWORD3: STD_LOGIC_VECTOR(3 downto 0);
signal s_VERIF_PASSWORD0, s_VERIF_PASSWORD1, s_VERIF_PASSWORD2, s_VERIF_PASSWORD3: STD_LOGIC_VECTOR(3 downto 0);
signal s_DISPLAYED_NUMBER0, s_DISPLAYED_NUMBER1, s_DISPLAYED_NUMBER2 : STD_LOGIC_VECTOR(3 downto 0);
signal s_CURRENT_NUMBER: STD_LOGIC_VECTOR(3 downto 0);

signal is_password_set, equal : STD_LOGIC;

   type state_type is (
        IDLE,
        ENTER_PASSWORD,
        ENTER_VERIF_PASSWORD,
        LOCKED,
        UNLOCKED,
        CHECK_PASSWORD,
        CHECK_UNLOCKING
        );

signal current_state : state_type;

signal number_of_clicks : integer := 0;

signal btn_add_prev : STD_LOGIC := '0';
signal btn_add_pulse : STD_LOGIC;

begin

comparator1: COMPARATOR port map(A0=>s_PASSWORD0, A1=>s_PASSWORD1, A2=>s_PASSWORD2, A3=>s_PASSWORD3,
                                 B0=>s_VERIF_PASSWORD0, B1=>s_VERIF_PASSWORD1, B2=>s_VERIF_PASSWORD2, B3=>s_VERIF_PASSWORD3,
                                 EGAL=>EQUAL
);

process(CLK, RST)
begin

    if BTN_ADD_DIGIT = '1' and btn_add_prev = '0' then btn_add_pulse <= '1';
    else btn_add_pulse <= '0';
    end if;

    if RST = '1' then
        s_PASSWORD0 <= "0000";
        s_PASSWORD1 <= "0000";
        s_PASSWORD2 <= "0000";
        
        s_VERIF_PASSWORD0 <= "0000";
        s_VERIF_PASSWORD1 <= "0000";
        s_VERIF_PASSWORD2 <= "0000";
        
        s_DISPLAYED_NUMBER0 <= "0000";
        s_DISPLAYED_NUMBER1 <= "0000";
        s_DISPLAYED_NUMBER2 <= "0000";
        
        s_CURRENT_NUMBER <= "0000";
        
        is_password_set <= '0';
        equal <= '0';
        
        LED_OCCUPIED <= '0';
        LED_ADD_DIGIT <= '1';
        
        number_of_clicks <= 0;
        
        current_state <= IDLE;
        
    elsif rising_edge(CLK) then
        btn_add_prev <= BTN_ADD_DIGIT;
    
        case current_state is
        
            when IDLE =>
                if (is_password_set = '0') then
                    current_state <= ENTER_PASSWORD;
                end if;
             
            when ENTER_PASSWORD =>
                if (btn_add_pulse  = '1') then
                    s_CURRENT_NUMBER <= NUMBER_FROM_COUNTER;
                    
                    case number_of_clicks is
                        when 0 =>
                            s_PASSWORD0 <= s_CURRENT_NUMBER;
                            s_DISPLAYED_NUMBER0 <= s_CURRENT_NUMBER;
                            number_of_clicks <= 1;
                            
                        when 1 =>
                            s_PASSWORD1 <= s_CURRENT_NUMBER;
                            s_DISPLAYED_NUMBER1 <= s_CURRENT_NUMBER;
                            number_of_clicks <= 2;
                            
                        when 2 =>
                            s_PASSWORD2 <= s_CURRENT_NUMBER;
                            s_DISPLAYED_NUMBER2 <= s_CURRENT_NUMBER;
                            number_of_clicks <= 3;
                        
                        when 3 => --- Cum ar veni aici dam confirm (la a 4-a apasare)
                            s_DISPLAYED_NUMBER0 <= "0000";
                            s_DISPLAYED_NUMBER1 <= "0000";
                            s_DISPLAYED_NUMBER2 <= "0000";
                            
                            s_PASSWORD3 <= "1111";
                            
                            is_password_set <= '1';
                            LED_OCCUPIED <= '1';
                            LED_ADD_DIGIT <= '0';
                            current_state <= LOCKED;
                            number_of_clicks <= 0;
                        
                        when others => null;
                        
                        
                    end case;
                end if;
        
            when LOCKED =>
                if (SWITCH_ADD_CYPHER = '1') then
                    current_state <= ENTER_VERIF_PASSWORD;
                end if;
           
            when ENTER_VERIF_PASSWORD =>
                if (btn_add_pulse  = '1') then
                    s_CURRENT_NUMBER <= NUMBER_FROM_COUNTER;
                    
                    case number_of_clicks is
                        when 0 =>
                            s_VERIF_PASSWORD0 <= s_CURRENT_NUMBER;
                            s_DISPLAYED_NUMBER0 <= s_CURRENT_NUMBER;
                            number_of_clicks <= 1;
                                                
                       when 1 =>
                            s_VERIF_PASSWORD1 <= s_CURRENT_NUMBER;
                            s_DISPLAYED_NUMBER1 <= s_CURRENT_NUMBER;
                            number_of_clicks <= 2;
                                                
                        when 2 =>
                            s_VERIF_PASSWORD2 <= s_CURRENT_NUMBER;
                            s_DISPLAYED_NUMBER2 <= s_CURRENT_NUMBER;
                            number_of_clicks <= 3;
                                            
                        when 3 => --- Cum ar veni aici dam confirm (la a 4-a apasare)
                            s_DISPLAYED_NUMBER0 <= "0000";
                            s_DISPLAYED_NUMBER1 <= "0000";
                            s_DISPLAYED_NUMBER2 <= "0000";
                                                
                            s_VERIF_PASSWORD3 <= "1111";
                    
                            current_state <= CHECK_UNLOCKING;
                            number_of_clicks <= 0;
                                            
                       when others => null;
                                                                             
                    end case;
                    
                end if;
                 
            when CHECK_UNLOCKING =>
                if (is_password_set = '1' and equal = '1') then
                    current_state <= UNLOCKED;
                end if;
                
            when UNLOCKED =>
                LED_OCCUPIED <= '0';
                
            when others => null;
   
        end case;
    
    end if;

end process;

DISPLAYED_NUMBER0 <= s_DISPLAYED_NUMBER0;
DISPLAYED_NUMBER1 <= s_DISPLAYED_NUMBER1;
DISPLAYED_NUMBER2 <= s_DISPLAYED_NUMBER2;
CURRENT_NUMBER <= s_CURRENT_NUMBER;


end Behavioral;
