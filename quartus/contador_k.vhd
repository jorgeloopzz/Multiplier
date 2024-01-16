-- Contador de k ciclos con reset activo a nivel bajo y enable

LIBRARY ieee;
  USE ieee.std_logic_1164.all;
  USE ieee.numeric_std.all;

ENTITY contador_k IS
     GENERIC(k : INTEGER := 4;
             m : INTEGER:= 2);
     PORT(reset_n   : IN STD_LOGIC;
	  clock    : IN STD_LOGIC;
	  enable : IN STD_LOGIC;
	  fin_cuenta : OUT STD_LOGIC );
END contador_k;

ARCHITECTURE funcional OF contador_k IS
    SIGNAL r_reg  : UNSIGNED(m-1 DOWNTO 0);
    SIGNAL r_next : UNSIGNED(m-1 DOWNTO 0);
BEGIN
  PROCESS(enable, reset_n, clock)
   BEGIN
      IF enable = '1' THEN r_next <= r_reg +1;
       ELSE r_next <= (OTHERS => '0');
      END IF;
      IF (reset_n = '0') THEN
        r_reg <= (OTHERS=>'0');
       ELSIF RISING_EDGE(clock) THEN
         r_reg <= r_next;
      END IF;
     IF (r_reg = (k-1)) THEN fin_cuenta <= '1'; ELSE fin_cuenta <= '0';
     END IF;
  END PROCESS;
END funcional;