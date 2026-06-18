library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FIR is
	port(
		clk, reset: in std_logic;
		x: in std_logic_vector(15 downto 0);
		y: out std_logic_vector(15 downto 0));
end entity;

architecture FIR_ARCH of FIR is
constant h0: signed(15 downto 0) := to_signed(2, 16);
constant h1: signed(15 downto 0) := to_signed(5, 16);
constant h2: signed(15 downto 0) := to_signed(7, 16);
type reg_file is array (5 downto 0) of signed (15 downto 0);
type sum_file is array (2 downto 0) of signed (15 downto 0);
type mult_file is array (2 downto 0) of signed (31 downto 0);
signal x_reg: reg_file := (others => (others => '0'));
signal x_next: reg_file;
signal sum_reg: sum_file := (others => (others => '0'));
signal sum_next: sum_file;
signal mult_reg: mult_file := (others => (others => '0'));
signal mult_next: mult_file;
signal st1_reg, st2_reg, m3d_reg: signed (31 downto 0) := (others => '0');
signal st1_next, st2_next, m3d_next: signed (31 downto 0);

begin
	process (clk, reset)
		begin
		if(reset = '1') then
			x_reg <= (others => (others => '0'));
			sum_reg <= (others => (others => '0'));
			mult_reg <= (others => (others => '0'));
			st1_reg <= (others => '0');
			st2_reg <= (others => '0');
			m3d_reg <= (others => '0');
		elsif(clk'event and clk = '1') then
			x_reg <= x_next;
			sum_reg <= sum_next;
			mult_reg <= mult_next;
			st1_reg <= st1_next;
			st2_reg <= st2_next;
			m3d_reg <= m3d_next;
		end if;
	end process;
	-- entrada y desplazamiento de muestras
	x_next(0) <= signed(x);
	x_next(1) <= x_reg(0);
	x_next(2) <= x_reg(1);
	x_next(3) <= x_reg(2);
	x_next(4) <= x_reg(3);
	x_next(5) <= x_reg(4);
	--etapa 1 sumas simetricas de muestras
	sum_next(0) <= x_reg(0) + x_reg(5);
	sum_next(1) <= x_reg(1) + x_reg(4);
	sum_next(2) <= x_reg(2) + x_reg(3);
	--etapa 2 multiplicaciones por los coeficientes
	mult_next(0) <= sum_reg(0) * h0;
	mult_next(1) <= sum_reg(1) * h1;
	mult_next(2) <= sum_reg(2) * h2;	
	-- etapa 3 primera suma
	st1_next <= mult_reg(0) + mult_reg(1);
	m3d_next <= mult_reg(2);
	-- etapa 4 segunda suma
	st2_next <= st1_reg + m3d_reg;
	-- salida
	y <= std_logic_vector(resize(st2_reg, 16));
end architecture;