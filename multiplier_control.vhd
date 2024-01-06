--Electronica Digital 2º curso EITE/ULPGC
--Para usar únicamente en los Trabajos de asignatura
--Control del multiplicador

LIBRARY ieee;
  USE ieee.std_logic_1164.all;
  USE ieee.numeric_std.all;

ENTITY multiplier_control IS
  PORT   (start   : IN STD_LOGIC ;
          done    : IN STD_LOGIC;
          ready   : OUT STD_LOGIC;
          inicio  : OUT STD_LOGIC;
          enable  : OUT STD_LOGIC;
          reset_n : IN  STD_LOGIC;
          clock   : IN STD_LOGIC );
END multiplier_control;

ARCHITECTURE behavioral OF multiplier_control IS
    -- A completar por el estudiante
    TYPE estado IS (idle, setup, check, mult);
	SIGNAL Qactual, Qfuturo: estado;

BEGIN
    -- A completar por el estudiante
    PROCESS (Qactual, start, done)
	BEGIN
		CASE Qactual IS
			WHEN idle =>
				IF (start = '1') THEN Qfuturo <= setup;
				ELSE Qfuturo <= idle;
				END IF;

			WHEN setup => Qfuturo <= mult;

			WHEN mult =>
				IF (done = '1') THEN Qfuturo <= check;
				ELSE Qfuturo <= mult;
				END IF;

			WHEN check =>
				IF (start = '1') THEN Qfuturo <= check;
				ELSE Qfuturo <= idle;
				END IF;
			
			WHEN OTHERS => Qfuturo <= idle;
		END CASE;
	END PROCESS;


    PROCESS (clock, reset_n)
	BEGIN
		IF (reset_n = '0') then
			Qactual <= idle;
		ELSIF RISING_EDGE(clock) then
			Qactual <= Qfuturo;
		END IF;
	END PROCESS;
	
    inicio <= '1' WHEN Qactual = setup ELSE '0';
    enable <= '1' WHEN (Qactual = setup OR Qactual = mult) ELSE '0';
    ready <= '1' WHEN (Qactual = check OR Qactual = idle) ELSE '0';

END behavioral;

