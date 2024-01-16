LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY binary_to_7seg_display IS
	PORT(
		binary_in				:	IN		STD_LOGIC_VECTOR(3 DOWNTO 0);		--number to display in BCD
		display_7seg	:	OUT	STD_LOGIC_VECTOR(6 DOWNTO 0));	--outputs to seven segment display
END binary_to_7seg_display;

ARCHITECTURE logic OF binary_to_7seg_display IS
BEGIN

	--map binary input to desired output segments
	WITH binary_in SELECT
		display_7seg <= 	"1000000" WHEN "0000",	--0
								"1111001" WHEN "0001",	--1
								"0100100" WHEN "0010",	--2
								"0110000" WHEN "0011",	--3
								"0011001" WHEN "0100",	--4
								"0010010" WHEN "0101",	--5
								"0000010" WHEN "0110",	--6
								"1111000" WHEN "0111",	--7
								"0000000" WHEN "1000",	--8
								"0011000" WHEN "1001",	--9
								
								"0001000" WHEN "1010",	--10
								"0000011" WHEN "1011",	--11
								"1000110" WHEN "1100",	--12
								"0100001" WHEN "1101",	--13
								"0000110" WHEN "1110",	--14
								"0001110" WHEN "1111",	--15
								
								"1111111" WHEN OTHERS;	--blank when not a digit
	
END logic;