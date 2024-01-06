-- Registro de n bits con reset activo a nivel bajo y enable

LIBRARY ieee;
  USE ieee.std_logic_1164.all;
  USE ieee.numeric_std.all;
ENTITY registro_enable IS
	GENERIC(n : INTEGER := 8);
	PORT(rstn : IN STD_LOGIC;
		clk : IN STD_LOGIC;
		enable: IN STD_LOGIC;
		entrada : IN UNSIGNED (n-1 DOWNTO 0);
		salida : OUT UNSIGNED (n-1 DOWNTO 0) );
END registro_enable;
ARCHITECTURE funcional OF registro_enable IS
    SIGNAL din, qout : UNSIGNED (n-1 DOWNTO 0);
BEGIN
    din <= entrada WHEN (enable = '1') ELSE qout;
PROCESS(rstn, clk)
   BEGIN
	IF (rstn = '0') THEN
		qout <= (OTHERS => '0');
	ELSIF RISING_EDGE(clk) THEN
		qout <= din;
		END IF;
   END PROCESS;
salida <= qout;
END funcional;
