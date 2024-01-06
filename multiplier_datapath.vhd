--Electronica Digital 2º curso EITE/ULPGC
--Para usar únicamente en los Trabajos de asignatura
--Datapath del multiplicador

LIBRARY ieee;
  USE ieee.std_logic_1164.all;
  USE ieee.numeric_std.all;
  USE work.ALL;

ENTITY multiplier_datapath IS
  GENERIC(n : INTEGER:= 4;     -- number of bits of operands
        	m : INTEGER:= 2);   --  -- log2 number of bits in operands
  PORT   (x_in, y_in : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
          inicio     : IN STD_LOGIC;
          enable     : IN STD_LOGIC;
          done       : OUT STD_LOGIC;
          p_out      : OUT STD_LOGIC_VECTOR(2*n-1 DOWNTO 0);
          reset_n    : IN STD_LOGIC;
          clock      : IN  STD_LOGIC );
END multiplier_datapath;

ARCHITECTURE trabajo OF multiplier_datapath IS
	COMPONENT registro_enable IS
		GENERIC(n : INTEGER := 8);
		PORT(
			rstn : IN STD_LOGIC;
			clk : IN STD_LOGIC;
			enable: IN STD_LOGIC;
			entrada : IN UNSIGNED (n-1 DOWNTO 0);
			salida : OUT UNSIGNED (n-1 DOWNTO 0)
			);
	END COMPONENT;

	COMPONENT contador_k IS
		  GENERIC(k : INTEGER := 4;
					m : INTEGER:= 2);
		  PORT(
		  reset_n	: IN STD_LOGIC;
		  clock		: IN STD_LOGIC;
		  enable		: IN STD_LOGIC;
		  fin_cuenta: OUT STD_LOGIC );
	END COMPONENT;
	
	-- SEÑALES
	SIGNAL X: UNSIGNED (3 DOWNTO 0);
	SIGNAL Y: UNSIGNED (3 DOWNTO 0);
	SIGNAL ph: UNSIGNED (3 DOWNTO 0); -- Inicialmente se inicializa a 0 y después la parte alta de la salida
	SIGNAL pl: UNSIGNED (3 DOWNTO 0);	-- Inicialmente se inicializa con el valor de y_in y después la parte baja de la salida
	SIGNAL p: UNSIGNED (7 DOWNTO 0);	-- Unen ambos números
	SIGNAL LSB: STD_LOGIC;
	SIGNAL salida_ALU: UNSIGNED (4 DOWNTO 0);	-- Almacena la salida de la ALU

	SIGNAL m1: UNSIGNED (3 downto 0); -- Salida del primer multiplexor
	SIGNAL m2: UNSIGNED (3 downto 0); -- Salida del segundo multiplexor

	BEGIN
		X <= UNSIGNED(x_in);
		Y <= UNSIGNED(y_in);
		ph <= (OTHERS => '0') WHEN inicio = '1' else p(7 downto 4);
		pl <= UNSIGNED(y_in) WHEN inicio = '1' else p(3 downto 0);

		--
		-- ALU
		--
		LSB <= pl(0);
		
		PROCESS(ph, X, LSB) BEGIN
			CASE LSB IS
				WHEN '0' => salida_ALU <= '0' & ph;
				WHEN OTHERS => salida_ALU <= '0' & (ph + X);
			END CASE;
		END PROCESS;

		--
		-- MULTIPLEXORES
		--
		PROCESS(inicio, Y, salida_ALU, pl) BEGIN
			if inicio = '1' then
				m1 <= (OTHERS => '0');
				m2 <= Y;
			else
				m1 <= salida_ALU(3 downto 0);
				m2 <= salida_ALU(4) & pl(2 downto 0);
			end if;
		END PROCESS;

		-- p <= ph & pl;

		-- p_out <= STD_LOGIC_VECTOR(p);
		
END trabajo;
