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

ARCHITECTURE top OF multiplier_top IS

      --
      -- Máquina de estados del multiplicador
      --
      COMPONENT multiplier_control IS
        PORT   (start   : IN STD_LOGIC ;
        done    : IN STD_LOGIC;
        ready   : OUT STD_LOGIC;
        inicio  : OUT STD_LOGIC;
        enable  : OUT STD_LOGIC;
        reset_n : IN  STD_LOGIC;
        clock   : IN STD_LOGIC );
      END COMPONENT;

      --
      -- Datapath del multiplicador
      --
      COMPONENT multiplier_datapath IS
        GENERIC(n : INTEGER:= 4;     -- number of bits of operands
        m : INTEGER:= 2);   -- log2 number of bits in operands
        PORT   (x_in, y_in : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
          inicio     : IN STD_LOGIC;
          enable     : IN STD_LOGIC;
          done       : OUT STD_LOGIC;
          p_out      : OUT STD_LOGIC_VECTOR(2*n-1 DOWNTO 0);
          reset_n    : IN STD_LOGIC;
          clock      : IN  STD_LOGIC );
      END COMPONENT;

      SIGNAL inicio, enable, done, ready : STD_LOGIC;

      begin
        control: multiplier_control
          PORT MAP(
            start => start_in,
            done => done,
            ready => done_out,
            inicio => inicio,
            enable => enable,
            reset_n => reset_n,
            clock => clock
          );

        datapath: multiplier_datapath
          PORT MAP(
            x_in => x_in,
            y_in => y_in,
            inicio => inicio,
            enable => enable,
            done => done,
            p_out => product_out,
            reset_n => reset_n,
            clock => clock
          );
END top;
