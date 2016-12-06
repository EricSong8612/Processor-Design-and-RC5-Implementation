----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:03:17 12/06/2016 
-- Design Name: 
-- Module Name:    ALU - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU is

port ( clr,clk: in std_logic;
		 a: in std_logic_vector(31 downto 0); ----- RS
		 b: in std_logic_vector(31 downto 0); ------RT
		 imm: in std_logic_vector(15 downto 0);
		 op: in std_logic_vector(5 downto 0);  --- opcode
		 fun: in std_logic_vector(5 downto 0); --funtion code
		 dout: out std_logic_vector(31 downto 0)
);
end ALU;

architecture Behavioral of ALU is

signal signext_imm: std_logic_vector(31 downto 0); 

begin
signext_imm <= imm & X"0000";
process(clk, clr)

 begin
	if(clr='1') then dout<=X"00000000";
	elsif(clk'EVENT AND clk='1') then 
		 case op is
		 when X"00" => if(fun=X"00") then dout<= a + b;
							elsif(fun=X"01") then dout<= a - b;
							elsif(fun=X"12") then dout<= a and b;
							elsif(fun=X"13") then dout<= a or b;
							elsif(fun=X"14") then dout<= not(a or b);
							end if;
		 when X"01" => dout<= a + signext_imm;
		 when X"02" => dout<= a - signext_imm;
		 when X"03" => dout<= a and signext_imm;
		 when X"04" => dout<= a or signext_imm;
		 when X"05" => dout<= a sll conv_integer(signext_imm);
		 when X"06" => dout<= a srl conv_integer(signext_imm);
		 when X"07" => dout<= a + signext_imm;

		 end case;
	end if;
 end process;






end Behavioral;

