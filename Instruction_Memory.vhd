----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:14:17 12/06/2016 
-- Design Name: 
-- Module Name:    Instruction_Memory - Behavioral 
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

entity Instruction_Memory is

port ( --clk: in std_logic;
		 address: in std_logic_vector(31 downto 0); 
		 instr: out std_logic_vector(31 downto 0)	 
);

end Instruction_Memory;

architecture Behavioral of Instruction_Memory is

   TYPE instrfile IS ARRAY (0 TO 31) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
	--signal data_file: datafile;
	signal instr_file: instrfile:=instrfile'(X"9BBBD8C8", X"1A37F7FB", X"46F8E8C5",
      X"460C6085", X"70F83B8A", X"284B8303", X"513E1454", X"F621ED22",
      X"3125065D", X"11A83A5D", X"D427686B", X"713AD82D", X"4B792F99",
      X"2799A4DD", X"A7901C49", X"DEDE871A", X"36C03196", X"A7EFC249",
      X"61A78BB8", X"3B0A1D2B", X"4DBFCA76", X"AE162167", X"30D76B0A",
      X"43192304", X"F6CC1431", X"65046380",X"00000000",X"00000000",
		X"00000000",X"00000000",X"00000000",X"00000000"); 

begin

	instr<=instr_file(conv_integer(address(31 downto 2)));

end Behavioral;

