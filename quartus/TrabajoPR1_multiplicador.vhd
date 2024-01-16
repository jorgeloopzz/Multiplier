LIBRARY ieee;
  USE ieee.std_logic_1164.all;
  USE ieee.numeric_std.all;
  USE work.all;

ENTITY TrabajoPR1_multiplicador IS
  PORT   (adc_clock_10      : IN  STD_LOGIC;          -- reloj del sistema 10 MHz (Bank 3B)
          max10_clk1_50     : IN  STD_LOGIC;          -- reloj del sistema 50 MHz (Bank 3B)
          max10_clk2_50     : IN  STD_LOGIC;          -- reloj del sistema 50 MHz (Bank 3B)
          key0, key1        : IN  STD_LOGIC;          -- Pulsadores key0 y key1
          input_switch      : IN  STD_LOGIC_VECTOR (9 DOWNTO 0); -- 10 switch de entrada
          leds_output       : OUT STD_LOGIC_VECTOR (9 DOWNTO 0); -- 10 leds de salida
          display_7segment0 : OUT STD_LOGIC_VECTOR (7 DOWNTO 0); -- Digito 0 de 7 segmentos
          display_7segment1 : OUT STD_LOGIC_VECTOR (7 DOWNTO 0); -- Digito 1 de 7 segmentos
          display_7segment2 : OUT STD_LOGIC_VECTOR (7 DOWNTO 0); -- Digito 2 de 7 segmentos
          display_7segment3 : OUT STD_LOGIC_VECTOR (7 DOWNTO 0); -- Digito 3 de 7 segmentos
          display_7segment4 : OUT STD_LOGIC_VECTOR (7 DOWNTO 0); -- Digito 4 de 7 segmentos
          display_7segment5 : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)); -- Digito 5 de 7 segmentos
END TrabajoPR1_multiplicador;

ARCHITECTURE funcional OF TrabajoPR1_multiplicador IS
   SIGNAL clock      : STD_LOGIC;                     -- reloj de mi sistema
   SIGNAL x_in       : STD_LOGIC_VECTOR (3 DOWNTO 0); -- declaración de la entrada 1
   SIGNAL y_in       : STD_LOGIC_VECTOR (3 DOWNTO 0); -- declaración de la entrada 2
   SIGNAL start_in   : STD_LOGIC;            -- Señal que indica el comienzo de la operación
   SIGNAL product_out: STD_LOGIC_VECTOR (7 DOWNTO 0); -- salida con el producto
   SIGNAL done_out   : STD_LOGIC;             -- Final de operación
   SIGNAL reset_n    : STD_LOGIC;
   SIGNAL busy       : STD_LOGIC;
   SIGNAL bcd        : STD_LOGIC_VECTOR (11 DOWNTO 0);
BEGIN
   -- =======================================================================================
   -- Entrada de los operandos y selección del reloj
   clock      <= adc_clock_10;          -- Reloj del sistema
   reset_n    <= key0;                  -- Reset del sistema activo a nivel bajo
   
   x_in      <= input_switch(3 DOWNTO 0);   -- El operando A se introduce aquí
   y_in      <= input_switch(7 DOWNTO 4);   -- El operando B se introduce aquí
   start_in  <= NOt(key1);                  -- La señal star se da desde el imterruptor 9
   
   -- =======================================================================================
   -- DUT: ALU que realiza operaciones de suma y resta
   U1: ENTITY multiplier_top
            PORT MAP(x_in, y_in, start_in, product_out, done_out, reset_n, clock);   

   -- =======================================================================================
   -- Representación de las salidas en los displays de 7 segmentos
   -- Las entradas A y B se representan en los displays 7 segments 5 and 4 respectivamente   
   -- Se utiliza la función binary_to_7seg_display para convertir el binario a 7 segmentos
   U7: ENTITY binary_to_7seg_display
            PORT MAP(x_in(3 DOWNTO 0), display_7segment5(6 DOWNTO 0));
   U8: ENTITY binary_to_7seg_display
            PORT MAP(y_in(3 DOWNTO 0), display_7segment4(6 DOWNTO 0));   
   display_7segment5(7) <= '1';   -- apagar el punto decimal del display 5
   display_7segment4(7) <= '1';   -- apagar el punto decimal del display 4
   
   -- El resultado se representa en BCD (2 digitos) en los dispalys 0 y 1
   -- El resultado se convierte en BCD con la función Binary_to_BCD
   -- Convertir a BCD el resultado
   U3: ENTITY Binary_to_BCD 
         GENERIC MAP (8, 3)
         PORT MAP (clock, '1', '1', product_out, busy, bcd);   
   -- Para representarlos en los displays 7 segmentos se utiliza bcd_to_7seg_display
   U4: ENTITY bcd_to_7seg_display
            PORT MAP(bcd(3 DOWNTO 0), display_7segment0(6 DOWNTO 0));         
   U5: ENTITY bcd_to_7seg_display
            PORT MAP(bcd(7 DOWNTO 4), display_7segment1(6 DOWNTO 0));
   U6: ENTITY bcd_to_7seg_display
            PORT MAP(bcd(11 DOWNTO 8), display_7segment2(6 DOWNTO 0));
            
   display_7segment0(7) <= '1';   -- apagar el punto decimal del display 0
   display_7segment1(7) <= '1';   -- apagar el punto decimal del display 1
   display_7segment2(7) <= '1';   -- apagar el punto decimal del display 2
 
   -- El fin de la operación se representa en el led 9
   leds_output(9) <= done_out;
   -- Apagar el resto de recursos no usados
   leds_output(8) <= '0';
   leds_output(7) <= '0';            
   leds_output(0) <= '0';   
   leds_output(1) <= '0';
   leds_output(2) <= '0';
   leds_output(3) <= '0';
   leds_output(4) <= '0';   
   leds_output(5) <= '0';
   display_7segment3 <= "11111111";      -- Apagar el display 3            
END funcional;
