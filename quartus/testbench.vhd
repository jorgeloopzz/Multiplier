--Electronica Digital 2º curso EITE/ULPGC
--Para usar únicamente en los Trabajos de asignatura
--Tesbecnh sencillo para multiplicador serie

library ieee;
  use ieee.std_logic_1164.all;
  use WORK.ALL;
  
entity multiplier_tb is
end multiplier_tb;

architecture tb of multiplier_tb is
  component multiplier_top

  PORT (
        x_in        : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
        y_in        : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
        start_in    : IN  STD_LOGIC;
        product_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        done_out    : OUT STD_LOGIC;
        reset_n     : IN  STD_LOGIC ;
        clock       : IN  STD_LOGIC);
END component;

  signal start_in   : std_logic;
  signal x_in       : std_logic_vector (3 downto 0);
  signal y_in       : std_logic_vector (3 downto 0);
  signal clock      : std_logic;
  signal p_out      : std_logic_vector (7 downto 0);
  signal done_out   : std_logic;
  signal reset_n    : std_logic;
  signal TbClock    : std_logic := '0';
  signal TbSimEnded : std_logic := '0';
  constant TbPeriod : time := 40 ns; 
begin
  top : multiplier_top
    port map (
    		clock    => clock,
    		x_in     => x_in,
            y_in     => y_in,
    		start_in => start_in,    
            product_out    => p_out,
            done_out => done_out,
            reset_n  => reset_n);
  
  TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';
  clock <= TbClock;
  stimuli : process
  begin
    start_in <= '0';
    x_in <= (others => '0');
    y_in <= (others => '0');
    reset_n <= '1';
    wait for 20 ns;
    reset_n <= '0';  -- Se hace un reset del sistema
    wait for 60 ns;
    reset_n <= '1';
    wait for 80 ns;
    x_in <= "1001";  -- Se hace el producto de 9x6
    y_in <= "0110";
    start_in <= '1';
    wait for 6 * TbPeriod;
    start_in <= '0';
    wait for 6 * TbPeriod;
    x_in <= "0101";   -- Se hace el producto de 5x9
    y_in <= "1001";
    start_in <= '1';
    wait for 6 * TbPeriod;
    start_in <= '0';
    wait for 6 * TbPeriod;
    -- Stop the clock and hence terminate the simulation
    TbSimEnded <= '1';
    wait;
  end process;
end tb;