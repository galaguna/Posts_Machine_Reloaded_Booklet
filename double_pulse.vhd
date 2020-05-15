--=============================================================================
-- Entity to generate from a two-pulse sequence
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
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity doublepulse_generator is
   port(
      clk, reset  : in std_logic;
      trigger     : in std_logic;
      p           : out std_logic
   );
end doublepulse_generator;

architecture moore_arch of doublepulse_generator is

   type state_type is (idle, High1, Low, High2);
   signal state_reg, state_next: state_type;

begin
   -- state register
   process(clk,reset)
   begin
      if (reset='1') then
         state_reg <= idle;
      elsif (clk'event and clk='1') then
         state_reg <= state_next;
      end if;
   end process;
   -- next-state and output logic
   process(state_reg,trigger)
   begin
      p <= '0'; --By default
      case state_reg is
         when idle=>
            if trigger= '1' then
               state_next <= High1;
            else
               state_next <= idle;
            end if;
         when High1 =>
            state_next <= Low;
            p <= '1'; --Moore Output
         when Low =>
            state_next <= High2;
         when High2 =>
            state_next <= Idle;
            p <= '1'; --Moore Output
      end case;
   end process;
   
end moore_arch;

