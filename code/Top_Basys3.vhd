--=============================================================================
-- Integrating entity for the EPM CPU with a Basys3 card
--=============================================================================
-- Code for the manuscript:
-- The Post’s Machine Reloaded
-- Design, Implementation and Programming of 
-- a Small and Functional CPU Prototype
--=============================================================================
-- Author: Gerardo A. Laguna-Sanchez
-- Universidad Autonoma Metropolitana
-- Unidad Lerma
-- may.08.2020
-------------------------------------------------------------------------------
-- Library declarations
-------------------------------------------------------------------------------
library ieee;
  use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------
-- Entity declaration
-------------------------------------------------------------------------------
entity Basys3_system is
port (

  --Basys3 Resources
  btnC          : in std_logic; -- sys_rst 
  btnU          : in std_logic; -- manm_clk 
  btnR          : in std_logic; -- run_sig 
  sysclk        : in std_logic;
  led           : out std_logic_vector(15 downto 0);
  sw            : in std_logic_vector(15 downto 0);
  seg           : out std_logic_vector(6 downto 0);
  an            : out std_logic_vector(3 downto 0)

);
end Basys3_system;

architecture my_arch of Basys3_system is

-------------------------------------------------------------------------------
-- Components declaration
-------------------------------------------------------------------------------

component doublepulse_generator
   port(
      clk       : in std_logic; 
      reset     : in std_logic;
      trigger   : in std_logic;
      p         : out std_logic
   );
end component;

component deboucing_3tics
   port(
      clk   : in std_logic;
      rst   : in std_logic;
      x     : in std_logic;
      y     : out std_logic
   );
end component;

component Bin_Counter
  port (
    clk     : in std_logic;
    q       : out std_logic_vector(23 DOWNTO 0)
  );
end component;

component hex2led
    Port ( 
      hex   : in std_logic_vector(3 downto 0);
      led   : out std_logic_vector(6 downto 0 )
  );
end component;

component RAM_256x1 
  Port (
    clka    : in std_logic;
    ena     : in std_logic;
    wea     : in std_logic_vector(0 downto 0);
    addra   : in std_logic_vector(7 downto 0);
    dina    : in std_logic_vector(0 downto 0);
    douta   : out std_logic_vector(0 downto 0)
  );
end component;

component ROM_256x4 
  Port (
    clka    : in std_logic;
    ena     : in std_logic;
    addra   : in std_logic_vector(7 downto 0);
    douta   : out std_logic_vector(3 downto 0)
  );
end component;

component Post_cpu
   port(
      clk, reset : in std_logic;
      run        : in std_logic;
      state      : out std_logic_vector(7 downto 0);
      code_add   : out std_logic_vector(7 downto 0);
      code       : in std_logic_vector(3 downto 0);
      code_mem   : out std_logic;
      data_add   : out std_logic_vector(7 downto 0);
      din        : in std_logic;
      dout       : out std_logic;
      data_mem   : out std_logic;
      data_we    : out std_logic
  );
end component;

-------------------------------------------------------------------------------
-- Signal declaration
-------------------------------------------------------------------------------
signal sys_rst       : std_logic;
signal refresh       : std_logic;
signal exec_mode     : std_logic;
signal one_pulse     : std_logic;
signal run_sig       : std_logic;
signal usrclk        : std_logic_vector(23 downto 0); -- Divided clock signals  
signal disp_driver   : std_logic_vector(6 downto 0); -- 7 segments LED Disp.   
signal ram2cpu_data  : std_logic;
signal cpu2ram_data  : std_logic;
signal manm_din      : std_logic;
signal muxed_din     : std_logic;
signal data_add_bus  : std_logic_vector(7 downto 0);
signal manm_add      : std_logic_vector(7 downto 0);
signal muxed_add     : std_logic_vector(7 downto 0);
signal code_add_bus  : std_logic_vector(7 downto 0);
signal code_bus      : std_logic_vector(3 downto 0);
signal RAM_en        : std_logic;
signal manm_en       : std_logic;
signal muxed_en      : std_logic;
signal RAM_we        : std_logic;
signal manm_we       : std_logic;
signal muxed_we      : std_logic;
signal ROM_en        : std_logic;
signal mem_clk       : std_logic;
signal manm_clk      : std_logic;
signal muxed_clk     : std_logic;
signal cpu_clk       : std_logic;
signal disp_ref_clk  : std_logic;
signal disp_bus      : std_logic_vector(3 downto 0);
signal state_byte    : std_logic_vector(7 downto 0);
signal state_nible   : std_logic_vector(3 downto 0);
signal data_byte     : std_logic_vector(7 downto 0);
signal data_nible    : std_logic_vector(3 downto 0);

-------------------------------------------------------------------------------
-- Begin
-------------------------------------------------------------------------------
begin

   my_Post_Machine : Post_cpu
   port map(
      clk => cpu_clk, 
      reset => sys_rst,
      run  => run_sig,
      state => state_byte,
      code_add => code_add_bus,
      code => code_bus,
      code_mem => ROM_en,
      data_add => data_add_bus,
      din => ram2cpu_data,
      dout => cpu2ram_data,
      data_mem => RAM_en,
      data_we => RAM_we
  );

    my_Pulse_gen : doublepulse_generator
    port map (
        clk => disp_ref_clk,
        reset => sys_rst,
        trigger => one_pulse,
        p => manm_clk   
    );

    my_Deboucing : deboucing_3tics
    port map (
        clk => disp_ref_clk,
        rst => sys_rst,
        x => refresh,
        y => one_pulse   
    );

    my_Counter : Bin_Counter
    port map (
        clk => sysclk,
        q => usrclk
    );

    my_RAM  : RAM_256x1
    port map(
        clka => muxed_clk,
        ena => muxed_en,
        wea(0) => muxed_we,
        addra => muxed_add,
        dina(0) => muxed_din,
        douta(0) => ram2cpu_data  
    );
  
    my_ROM  : ROM_256x4
    port map(
      clka => mem_clk,
      ena => ROM_en,
      addra => code_add_bus,
      douta => code_bus  
    );

 -- Binary coded Hexa to 7 segments display:

    my_Display7seg : hex2led 
    port map (
          hex => disp_bus,
          led => disp_driver 
      );
             
    state_nible <= state_byte(7 downto 4) when (disp_ref_clk = '1') else
                    state_byte(3 downto 0);

    data_nible <= data_byte(7 downto 4) when (disp_ref_clk = '1') else
                    data_byte(3 downto 0);

    an <=  "0111" when (disp_ref_clk = '1') else
            "1011";         

    seg <= disp_driver;

    data_byte <= "00000001" when (ram2cpu_data = '1') else
                "00000000";

    disp_bus <= state_nible when (exec_mode = '1') else
                data_nible;

-- RAM's multiplexed control:
    muxed_add <= data_add_bus when (exec_mode = '1') else
                  manm_add;

    muxed_din <= cpu2ram_data when (exec_mode = '1') else
                  manm_din;

    muxed_en <= RAM_en when (exec_mode = '1') else
                  manm_en;

    muxed_we <= RAM_we when (exec_mode = '1') else 
                  manm_we;

    muxed_clk <= mem_clk when (exec_mode = '1') else 
                  manm_clk;

-- Conections:
    disp_ref_clk <= usrclk(20); 
    mem_clk <= usrclk(22);
    cpu_clk <= usrclk(23);
    
    sys_rst <= btnC;
    refresh <= btnU;
    run_sig <= btnR;
    exec_mode <= sw(15);
    manm_en <= sw(14);
    manm_we <= sw(13);
    manm_din <= sw(12);
    manm_add <= sw(7 downto 0);
    
    led(0)<= sw(0);   -- manm_add0 & LED
    led(1)<= sw(1);   -- manm_add1 & LED
    led(2)<= sw(2);   -- manm_add2 & LED
    led(3)<= sw(3);   -- manm_add3 & LED
    led(4)<= sw(4);   -- manm_add4 & LED
    led(5)<= sw(5);   -- manm_add5 & LED
    led(6)<= sw(6);   -- manm_add6 & LED
    led(7)<= sw(7);   -- manm_add7 & LED

    led(8)<= sw(8);     -- Guard & LED
    led(9)<= sw(9);     -- Guard & LED
    led(10)<= sw(10);   -- Guard & LED
    led(11)<= sw(11);   -- Guard & LED
    
    led(12)<= sw(12);   -- manm_din & LED
    led(13)<= sw(13);   -- manm_we & LED
    led(14)<= sw(14);   -- manm_en & LED
    led(15)<= sw(15);   -- exec_mode & LED

end my_arch;
