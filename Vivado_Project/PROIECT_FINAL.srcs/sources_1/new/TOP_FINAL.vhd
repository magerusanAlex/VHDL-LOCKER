library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TOP_FINAL is
    port (
        ANOD : out STD_LOGIC_VECTOR(3 downto 0);
        CATOD : out STD_LOGIC_VECTOR(6 downto 0);
        LED_OCCUPIED : out STD_LOGIC := '0';
        LED_ADD_DIGIT : out STD_LOGIC := '1';
        
        CLK : in STD_LOGIC;
        RST : in STD_LOGIC;
        BTN_UP : in STD_LOGIC;
        BTN_DOWN : in STD_LOGIC;
        BTN_ADD_DIGIT: in STD_LOGIC;
        SWITCH_ADD_CYPHER: in STD_LOGIC
    );
end TOP_FINAL;

architecture Behavioral of TOP_FINAL is

    component COMPARATOR is
        Port ( A0 : in STD_LOGIC_VECTOR(3 downto 0);
               A1 : in STD_LOGIC_VECTOR(3 downto 0);
               A2 : in STD_LOGIC_VECTOR(3 downto 0);
               A3 : in STD_LOGIC_VECTOR(3 downto 0);
               B0 : in STD_LOGIC_VECTOR(3 downto 0);
               B1 : in STD_LOGIC_VECTOR(3 downto 0);
               B2 : in STD_LOGIC_VECTOR(3 downto 0);
               B3 : in STD_LOGIC_VECTOR(3 downto 0);
               EGAL : out STD_LOGIC);
    end component;

    component COUNTER is
        Port ( CLK : in STD_LOGIC;
               RST : in STD_LOGIC;
               BTN_UP : in STD_LOGIC;
               BTN_DOWN : in STD_LOGIC;
               NUMAR : out STD_LOGIC_VECTOR(3 downto 0));
    end component;

    component MPG is
        Port ( CLK : in STD_LOGIC;
               BTN : in STD_LOGIC;
               ENABLE : out STD_LOGIC);
    end component;

    component SSD is
        Port ( CLK : in STD_LOGIC;
               digit0 : in STD_LOGIC_VECTOR(3 downto 0) := "0000";
               digit1 : in STD_LOGIC_VECTOR(3 downto 0) := "0000";
               digit2 : in STD_LOGIC_VECTOR(3 downto 0) := "0000";
               digit3 : in STD_LOGIC_VECTOR(3 downto 0) := "0000";
               ANOD : out STD_LOGIC_VECTOR(3 downto 0);
               CATOD : out STD_LOGIC_VECTOR(6 downto 0));
    end component;


    signal numar : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    
    signal btn_up_debounced, btn_down_debounced : STD_LOGIC := '0';
    signal btn_add_debounced : STD_LOGIC := '0';
    
    
    signal password0, password1, password2 : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal verif0, verif1, verif2 : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    
    
    signal d0, d1, d2 : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    
    
    signal number_of_clicks : integer := 0;
    signal egal : STD_LOGIC := '0';
    signal is_password_set : STD_LOGIC := '0';

begin

    deb_up: MPG port map(CLK => CLK, BTN => BTN_UP, ENABLE => btn_up_debounced);
    deb_down: MPG port map(CLK => CLK, BTN => BTN_DOWN, ENABLE => btn_down_debounced);
    deb_add: MPG port map(CLK => CLK, BTN => BTN_ADD_DIGIT, ENABLE => btn_add_debounced);

    counter_inst: COUNTER port map(
        CLK => CLK,
        RST => RST,
        BTN_UP => btn_up_debounced,
        BTN_DOWN => btn_down_debounced,
        NUMAR => numar
    );

    comparator_inst: COMPARATOR port map(
        A0 => password0, A1 => password1, A2 => password2, A3 => "1111",
        B0 => verif0, B1 => verif1, B2 => verif2, B3 => "1111",
        EGAL => egal
    );

    -- Main process for password handling
    process(CLK, RST)
    begin
        if RST = '1' then
            -- Reset all signals
            password0 <= "0000";
            password1 <= "0000";
            password2 <= "0000";
            
            verif0 <= "0000";
            verif1 <= "0000";
            verif2 <= "0000";
            
            d0 <= "0000";
            d1 <= "0000";
            d2 <= "0000";
            
            number_of_clicks <= 0;
            is_password_set <= '0';
            
            -- Aici nu avem parola si putem adauga cifre
            LED_OCCUPIED <= '0'; 
            LED_ADD_DIGIT <= '1';
            
        elsif rising_edge(CLK) then
            
            if btn_add_debounced = '1' then
                if SWITCH_ADD_CYPHER = '1' then
                    -- Aici verificam parola
                    case number_of_clicks is
                        when 0 => 
                            verif0 <= numar;
                            d0 <= numar;
                        when 1 => 
                            verif1 <= numar;
                            d1 <= numar;
                        when 2 => 
                            verif2 <= numar;
                            d2 <= numar;                       
                        when others => 
                            if egal = '1' and is_password_set = '1' then
                                LED_OCCUPIED <= '0'; 
                                LED_ADD_DIGIT <= '0';
                                
                                d0 <= "0000";
                                d1 <= "0000";
                                d2 <= "0000";
                                
                            else
                                verif0 <= "0000";
                                verif1 <= "0000";
                                verif2 <= "0000";
                                
                                d0 <= "0000";
                                d1 <= "0000";
                                d2 <= "0000";
                            end if;
                    end case;
                else
                    case number_of_clicks is
                        when 0 => 
                            password0 <= numar;
                            d0 <= numar;
                        when 1 => 
                            password1 <= numar;
                            d1 <= numar;
                        when 2 => 
                            password2 <= numar;
                            d2 <= numar;
                        when 3 => 
                            is_password_set <= '1'; 
                            LED_OCCUPIED <= '1';
                            LED_ADD_DIGIT <= '0';
                            
                            d0 <= "0000";
                            d1 <= "0000";
                            d2 <= "0000";
                        when others => null;
                    end case;
                end if;
                
                if number_of_clicks = 3 then
                    number_of_clicks <= 0;
                else
                    number_of_clicks <= number_of_clicks + 1;
                end if;
            end if;
        end if;
    end process;

    -- Seven-segment display
    ssd_inst: SSD port map(
        CLK => CLK,
        digit0 => numar,    -- Current counter value
        digit1 => d0,
        digit2 => d1,
        digit3 => d2,
        ANOD => ANOD,
        CATOD => CATOD
    );

end Behavioral;