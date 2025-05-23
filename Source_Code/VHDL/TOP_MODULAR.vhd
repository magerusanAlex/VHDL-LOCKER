library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TOP_MODULAR is
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
end TOP_MODULAR;

architecture Behavioral of TOP_MODULAR is

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

    component MAGIC is --aici butoanele trec ptrintr-un DEBOUNCER
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
    end component;

    signal numar : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    
    signal btn_up_debounced, btn_down_debounced : STD_LOGIC := '0';
    signal btn_add_debounced : STD_LOGIC := '0';
    
    
    signal d0, d1, d2 : STD_LOGIC_VECTOR(3 downto 0) := "0000";
   

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

   coder: MAGIC port map(
    CLK=>CLK,
    RST=>RST,
    
    BTN_ADD_DIGIT=>btn_add_debounced,
    SWITCH_ADD_CYPHER=>SWITCH_ADD_CYPHER,
    
    DISPLAYED_NUMBER0=>d0,
    DISPLAYED_NUMBER1=>d1,
    DISPLAYED_NUMBER2=>d2,
    NUMBER_FROM_COUNTER=>numar,
    
    LED_OCCUPIED=>LED_OCCUPIED,
    LED_ADD_DIGIT=>LED_ADD_DIGIT
    
    
   );

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