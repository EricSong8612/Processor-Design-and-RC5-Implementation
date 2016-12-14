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
		aluop <= op; 

		alu_src<='0' when op = "000000" else '1';-- 0 is R type, 1 is I type
		shift<='1' when op = "000101" or op = "000110" else '0';

		mem_read<='1' when op = "000111" else '0';
		mem_to_reg<='1' when op = "000111" else '0';
		mem_write<='1' when op = "001000" else '0';
		
		with op select
		reg_write <= '1' when "000000",
					 	 '1' when "000001",
						 '1' when "000010",
						 '1' when "000011",
						 '1' when "000100",
						 '1' when "000101",
						 '1' when "000110",
						 '1' when "000111",
						 '0' when others;
						 
		reg_dst <= '1' when op = "000000" else '0';
 		
		branch_lt<='1' when op = "001001" else '0';
		branch_eq<='1' when op = "001010" else '0';
		branch_ne<='1' when op = "001011" else '0';
		
		jump<='1' when op = "001100" else '0';
		
		halt<='1' when op = "111111" else '0';

end Behavioral;

