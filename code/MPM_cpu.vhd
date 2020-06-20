--=============================================================================
-- My Post Machine Entity (EPM CPU) 
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
use ieee.numeric_std.all;

-------------------------------------------------------------------------------
-- Entity declaration
-------------------------------------------------------------------------------
entity Post_cpu is
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
end Post_cpu;

architecture my_arch of Post_cpu is
-------------------------------------------------------------------------------
-- Constant declaration
-------------------------------------------------------------------------------
   constant stop             :  std_logic_vector(7 downto 0):= "00000000";
   constant start            :  std_logic_vector(7 downto 0):= "00000001";
   constant fetch            :  std_logic_vector(7 downto 0):= "00000010";
   constant decode           :  std_logic_vector(7 downto 0):= "00000011";
   constant point_ha_jmp     :  std_logic_vector(7 downto 0):= "00000100";
   constant load_ha_jmp      :  std_logic_vector(7 downto 0):= "00000101";
   constant point_la_jmp     :  std_logic_vector(7 downto 0):= "00000110";
   constant load_la_jmp      :  std_logic_vector(7 downto 0):= "00000111";
   constant jmp              :  std_logic_vector(7 downto 0):= "00001000";
   constant point_ha_jz      :  std_logic_vector(7 downto 0):= "00001001";
   constant load_ha_jz       :  std_logic_vector(7 downto 0):= "00001010";
   constant point_la_jz      :  std_logic_vector(7 downto 0):= "00001011";
   constant load_la_jz       :  std_logic_vector(7 downto 0):= "00001100";
   constant point_data_jz    :  std_logic_vector(7 downto 0):= "00001101";
   constant loadntst_data_jz :  std_logic_vector(7 downto 0):= "00001110";
   constant jz               :  std_logic_vector(7 downto 0):= "00001111";
   constant incdp            :  std_logic_vector(7 downto 0):= "00010000";
   constant decdp            :  std_logic_vector(7 downto 0):= "00010001";
   constant set              :  std_logic_vector(7 downto 0):= "00010010";
   constant clr              :  std_logic_vector(7 downto 0):= "00010011";
   constant nop_code         :  std_logic_vector(3 downto 0):= "0000";
   constant incdp_code       :  std_logic_vector(3 downto 0):= "0001";
   constant decdp_code       :  std_logic_vector(3 downto 0):= "0010";
   constant set_code         :  std_logic_vector(3 downto 0):= "0011";
   constant clr_code         :  std_logic_vector(3 downto 0):= "0100";
   constant jmp_code         :  std_logic_vector(3 downto 0):= "0101";
   constant jz_code          :  std_logic_vector(3 downto 0):= "0110";
   constant stoop_code       :  std_logic_vector(3 downto 0):= "0111";

-------------------------------------------------------------------------------
-- Signal declaration
-------------------------------------------------------------------------------
   signal state_reg, state_next            : std_logic_vector(7 downto 0);
   signal IP_reg, IP_next                  : unsigned(7 downto 0);
   signal DP_reg, DP_next                  : unsigned(7 downto 0);
   signal instruction_reg, instruction_next: std_logic_vector(3 downto 0);
   signal hadd_reg, hadd_next              : unsigned(3 downto 0);
   signal ladd_reg, ladd_next              : unsigned(3 downto 0);
   signal bit_reg, bit_next                : std_logic;
   signal rome_next, rame_next, we_next    : std_logic;
   signal rome_reg, rame_reg, we_reg       : std_logic;

-------------------------------------------------------------------------------
-- Begin
-------------------------------------------------------------------------------
begin
   -- state & data registers
   process(clk,reset)
   begin
      if (reset='1') then
         state_reg <= stop;
         IP_reg <= (others=>'0');
         DP_reg <= (others=>'0');
         instruction_reg <= (others=>'0');
         hadd_reg <= (others=>'0');
         ladd_reg <= (others=>'0');
         bit_reg <= '0';
         rome_reg <= '0';
         rame_reg <= '0';
         we_reg <= '0';
      elsif (clk'event and clk='1') then
         state_reg <= state_next;
         IP_reg <= IP_next;
         DP_reg <= DP_next;
         instruction_reg <= instruction_next;
         hadd_reg <= hadd_next;
         ladd_reg <= ladd_next;
         bit_reg <= bit_next;
         rome_reg <= rome_next;
         rame_reg <= rame_next;
         we_reg <= we_next;
      end if;
   end process;

   -- next-state logic & data path functional units/routing
   process(state_reg,run,code,din, 
           IP_reg,DP_reg,instruction_reg,hadd_reg,ladd_reg)
   begin
      IP_next <= IP_reg;
      DP_next <= DP_reg;
      instruction_next <= instruction_reg;
      hadd_next <= hadd_reg;
      ladd_next <= ladd_reg;

      case state_reg is
         when stop =>
            if run='1' then
               state_next <= start;
            else
               state_next <= stop;
            end if;
         when start =>
            IP_next <= (others=>'0');
            DP_next <= (others=>'0');
            state_next <= fetch;
         when fetch =>
            state_next <= decode;
         when decode =>
            instruction_next <= code;
            IP_next <= IP_reg + 1;

            if code = nop_code then --If nop
               state_next <= fetch;
            else
               if code = incdp_code then --If incdp
                  state_next <= incdp;
               else
                  if code = decdp_code then --If decdp
                     state_next <= decdp;
                  else
                     if code = set_code then --If set
                        state_next <= set;
                     else
                        if code = clr_code then --If clr
                           state_next <= clr;
                        else
                           if code = jmp_code then --If jmp
                              state_next <= point_ha_jmp;
                           else
                              if code = jz_code then --If jz
                                 state_next <= point_ha_jz;
                              else
                                 --If stop
                                 state_next <= stop;
                              end if; 
                           end if; 
                        end if; 
                     end if; 
                  end if; 
               end if; 
            end if;
         when point_ha_jmp =>
            state_next <= load_ha_jmp;
         when load_ha_jmp => 
            IP_next <= IP_reg + 1;
            hadd_next <= unsigned(code);
            state_next <= point_la_jmp;
         when point_la_jmp =>
            state_next <= load_la_jmp;
         when load_la_jmp =>
            ladd_next <= unsigned(code);
            state_next <= jmp;
         when jmp =>
            IP_next <= hadd_reg & ladd_reg;
            state_next <= fetch;
         when point_ha_jz =>
            state_next <= load_ha_jz;
         when load_ha_jz =>
            IP_next <= IP_reg + 1;
            hadd_next <= unsigned(code);
            state_next <= point_la_jz;
         when point_la_jz =>
            state_next <= load_la_jz;
         when load_la_jz =>
            IP_next <= IP_reg + 1;
            ladd_next <= unsigned(code);
            state_next <= point_data_jz;
         when point_data_jz =>
            state_next <= loadntst_data_jz;
         when loadntst_data_jz =>
            if din='0' then
               state_next <= jz;
            else
               state_next <= fetch;
            end if;
         when jz =>
            IP_next <= hadd_reg & ladd_reg;
            state_next <= fetch;
         when incdp =>
            DP_next <= DP_reg + 1;
            state_next <=fetch;
         when decdp =>
            DP_next <= DP_reg - 1;
            state_next <=fetch;
         when set =>
            state_next <=fetch;
         when clr =>
            state_next <=fetch;
         when others =>
            state_next <=stop;
      end case;
   end process;

   -- look-ahead output logic
   process(state_next)
   begin
      rome_next <= '0';
      rame_next <= '0';
      we_next <= '0';
      bit_next <= '0';
      
      case state_next is
         when stop =>
         when start =>
         when fetch =>
            rome_next <= '1';
         when decode =>
            rome_next <= '1';
         when point_ha_jmp =>
            rome_next <= '1';
         when load_ha_jmp =>
            rome_next <= '1';
         when point_la_jmp =>
            rome_next <= '1';
         when load_la_jmp =>
            rome_next <= '1';
         when jmp =>
         when point_ha_jz =>
            rome_next <= '1';
         when load_ha_jz =>
            rome_next <= '1';
         when point_la_jz =>
            rome_next <= '1';
         when load_la_jz =>
            rome_next <= '1';
         when point_data_jz =>
            rame_next <= '1';
         when loadntst_data_jz =>
            rame_next <= '1';
         when jz =>
         when incdp=>
         when decdp=>
         when set =>
            bit_next <= '1';
            rame_next <= '1';
            we_next <= '1';
         when clr =>
            bit_next <= '0';
            rame_next <= '1';
            we_next <= '1';
         when others =>
         
      end case;
   end process;

   --  outputs
   state <= state_reg;
   code_add <= std_logic_vector(IP_reg);
   code_mem <= rome_reg;
   data_add <= std_logic_vector(DP_reg);
   dout <= bit_reg;
   data_mem <= rame_reg;
   data_we <= we_reg;

end my_arch;
