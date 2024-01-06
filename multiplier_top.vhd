--Electronica Digital 2º curso EITE/ULPGC
--Para usar únicamente en los Trabajos de asignatura
--top del multiplicador


LIBRARY ieee;
  USE ieee.std_logic_1164.all;
  USE ieee.numeric_std.all;
  USE WORK.ALL;

ENTITY multiplier_top IS

  PORT (
        x_in        : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
        y_in        : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
        start_in    : IN  STD_LOGIC;
        product_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        done_out    : OUT STD_LOGIC;
        reset_n     : IN  STD_LOGIC ;
        clock       : IN  STD_LOGIC);
END multiplier_top;


