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
constant h0: signed(15 downto 0) := to_signed(544, 16);
constant h1: signed(15 downto 0) := to_signed(128, 16);
constant h2: signed(15 downto 0) := to_signed(-463, 16);
constant h3: signed(15 downto 0) := to_signed(-255, 16);
constant h4: signed(15 downto 0) := to_signed(472, 16);
constant h5: signed(15 downto 0) := to_signed(629, 16);
constant h6: signed(15 downto 0) := to_signed(-520, 16);
constant h7: signed(15 downto 0) := to_signed(-1029, 16);
constant h8: signed(15 downto 0) := to_signed(304, 16);
constant h9: signed(15 downto 0) := to_signed(1717, 16);
constant h10: signed(15 downto 0) := to_signed(1717, 16);
constant h11: signed(15 downto 0) := to_signed(-2767, 16);
constant h12: signed(15 downto 0) := to_signed(-1570, 16);
constant h13: signed(15 downto 0) := to_signed(5888, 16);
constant h14: signed(15 downto 0) := to_signed(13535, 16);
type reg_file is array (29 downto 0) of signed (15 downto 0);
type sum_file is array (14 downto 0) of signed (15 downto 0);
type mult_file is array (14 downto 0) of signed (31 downto 0);
type st1_file is array (6 downto 0) of signed (31 downto 0);
type st2_file is array (3 downto 0) of signed (31 downto 0);
signal x_reg: reg_file := (others => (others => '0'));
signal x_next: reg_file := (others => (others => '0'));
signal sum_reg: sum_file := (others => (others => '0'));
signal sum_next: sum_file := (others => (others => '0'));
signal mult_reg: mult_file := (others => (others => '0'));
signal mult_next: mult_file := (others => (others => '0'));
signal st1_reg, st1_next: st1_file := (others => (others => '0'));
signal st2_reg, st2_next: st2_file := (others => (others => '0'));
signal md_reg, md_next, st3_reg, st3_next, st4_reg, st4_next, st5_reg, st5_next: signed (31 downto 0) := (others => '0');
begin
	--Registros
	process (clk, reset)
		begin
		if(reset = '1') then
			x_reg <= (others => (others => '0'));
			sum_reg <= (others => (others => '0'));
			mult_reg <= (others => (others => '0'));
			st1_reg <= (others => (others => '0'));
			st2_reg <= (others => (others => '0'));
			st3_reg <= (others => '0');
			st4_reg <= (others => '0');
			st5_reg <= (others => '0');
			md_reg <= (others => '0');
		elsif(clk'event and clk = '1') then
			x_reg <= x_next;
			sum_reg <= sum_next;
			mult_reg <= mult_next;
			st1_reg <= st1_next;
			st2_reg <= st2_next;
			st3_reg <= st3_next;
			st4_reg <= st4_next;
			st5_reg <= st5_next;
			md_reg <= md_next;
		end if;
	end process;
	-- Entrada y desplazamiento de muestras
	x_next(0) <= signed(x);
	x_next(1) <= x_reg(0);
	x_next(2) <= x_reg(1);
	x_next(3) <= x_reg(2);
	x_next(4) <= x_reg(3);
	x_next(5) <= x_reg(4);
	x_next(6) <= x_reg(5);
	x_next(7) <= x_reg(6);
	x_next(8) <= x_reg(7);
	x_next(9) <= x_reg(8);
	x_next(10) <= x_reg(9);
	x_next(11) <= x_reg(10);
	x_next(12) <= x_reg(11);
	x_next(13) <= x_reg(12);
	x_next(14) <= x_reg(13);
	x_next(15) <= x_reg(14);
	x_next(16) <= x_reg(15);
	x_next(17) <= x_reg(16);
	x_next(18) <= x_reg(17);
	x_next(19) <= x_reg(18);
	x_next(20) <= x_reg(19);
	x_next(21) <= x_reg(20);
	x_next(22) <= x_reg(21);
	x_next(23) <= x_reg(22);
	x_next(24) <= x_reg(23);
	x_next(25) <= x_reg(24);
	x_next(26) <= x_reg(25);
	x_next(27) <= x_reg(26);
	x_next(28) <= x_reg(27);
	x_next(29) <= x_reg(28);
	-- Etapa 1 - Sumas simetricas de muestras
	sum_next(0) <= x_reg(0) + x_reg(29);
	sum_next(1) <= x_reg(1) + x_reg(28);
	sum_next(2) <= x_reg(2) + x_reg(27);
	sum_next(3) <= x_reg(3) + x_reg(26);
	sum_next(4) <= x_reg(4) + x_reg(25);
	sum_next(5) <= x_reg(5) + x_reg(24);
	sum_next(6) <= x_reg(6) + x_reg(23);
	sum_next(7) <= x_reg(7) + x_reg(22);
	sum_next(8) <= x_reg(8) + x_reg(21);
	sum_next(9) <= x_reg(9) + x_reg(20);
	sum_next(10) <= x_reg(10) + x_reg(19);
	sum_next(11) <= x_reg(11) + x_reg(18);
	sum_next(12) <= x_reg(12) + x_reg(17);
	sum_next(13) <= x_reg(13) + x_reg(16);
	sum_next(14) <= x_reg(14) + x_reg(15);
	-- Etapa 2 - Multiplicación de muestras por coeficientes
	mult_next(0) <= sum_reg(0) * h0;
	mult_next(1) <= sum_reg(1) * h1;
	mult_next(2) <= sum_reg(2) * h2;
	mult_next(3) <= sum_reg(3) * h3;
	mult_next(4) <= sum_reg(4) * h4;
	mult_next(5) <= sum_reg(5) * h5;
	mult_next(6) <= sum_reg(6) * h6;
	mult_next(7) <= sum_reg(7) * h7;
	mult_next(8) <= sum_reg(8) * h8;
	mult_next(9) <= sum_reg(9) * h9;
	mult_next(10) <= sum_reg(10) * h10;
	mult_next(11) <= sum_reg(11) * h11;
	mult_next(12) <= sum_reg(12) * h12;
	mult_next(13) <= sum_reg(13) * h13;
	mult_next(14) <= sum_reg(14) * h14;	
	-- Etapa 3 - Primera suma de resultados
	st1_next(0) <= mult_reg(0) + mult_reg(1);
	st1_next(1) <= mult_reg(2) + mult_reg(3);
	st1_next(2) <= mult_reg(4) + mult_reg(5);
	st1_next(3) <= mult_reg(6) + mult_reg(7);
	st1_next(4) <= mult_reg(8) + mult_reg(9);
	st1_next(5) <= mult_reg(10) + mult_reg(11);
	st1_next(6) <= mult_reg(12) + mult_reg(13); 
	md_next <= mult_reg(14);
	-- Etapa 4 - Segunda suma de resultados
	st2_next(0) <= st1_reg(0) + st1_reg(1);
	st2_next(1) <= st1_reg(2) + st1_reg(3);
	st2_next(2) <= st1_reg(4) + st1_reg(5);
	st2_next(3) <= st1_reg(6) + md_reg;
	-- Etapa 5 - Tercera suma de resultados
	st3_next <= st2_reg(0) + st2_reg(1);
	st4_next <= st2_reg(2) + st2_reg(3);
	-- Etapa 6 - Suma final
	st5_next <= st3_reg + st4_reg;
	-- Salida
	y <= std_logic_vector(resize(st5_reg, 16));
end architecture;