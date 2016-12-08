----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:02:20 12/06/2016 
-- Design Name: 
-- Module Name:    Decode - Behavioral 
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

entity Decode is

port ( op: in std_logic_vector(5 downto 0);  
		 aluop: out std_logic_vector(5 downto 0);
		 alu_src: out std_logic:='0';
		 branch_lt: out std_logic:='0';
		 branch_ne: out std_logic:='0';
		 branch_eq: out std_logic:='0';
		 reg_write: out std_logic:='0';
		 reg_dst: out std_logic:='0'; --rd or rt
		 mem_read: out std_logic:='0';
		 mem_write: out std_logic:='0';
		 mem_to_reg: out std_logic:='0';
		 shift: out std_logic:='0';
		 jump: out std_logic:='0';
		 halt: out std_logic:='0'
);

end Decode;

architecture Behavioral of Decode is

begin

--		case op is
--		when "000000" => aluop<=op; mem_to_reg<='0';
--		when "000001" => aluop<=op;
--		when "000010" => aluop<=op;
--		when "000011" => aluop<=op;
--		when "000100" => aluop<=op;
--		when "000101" => shift<='0'; --left
--		when "000110" => shift<='1'; --right
--		when "000111" => mem_read<='1'; mem_to_reg<='1';
--		when "001000" => mem_write<='1';
--		when "001001" => branch_lt<='1';
--		when "001010" => branch_eq<='1';
--		when "001011" => branch_ne<='1';
--		when "001100" => jump<='1';
--		when "111111" => halt<='1';
--		when others => null;
--		end case;
		with op select 
		aluop <= "000000" when "000000",
					"000001" when "000001",
					"000010" when "000010",
					"000011" when "000011",
					"000100" when "000100",
					"000101" when "000101",
					"000110" when "000110",
					"001111" when others;

		shift<='0' when op = "000101" else '1' when op = "000110";-- 0 is left, 1 is right

		mem_read<='1' when op = "000111" else '0';
		mem_to_reg<='1' when op = "000111" else '0';
		mem_write<='1' when op = "001000" else '0';
		
		branch_lt<='1' when op = "001001" else '0';
		branch_eq<='1' when op = "001010" else '0';
		branch_ne<='1' when op = "001011" else '0';
		
		jump<='1' when op = "001100" else '0';
		
		halt<='1' when op = "111111" else '0';

end Behavioral;

