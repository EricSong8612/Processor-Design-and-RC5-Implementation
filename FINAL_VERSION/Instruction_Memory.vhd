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

port ( address: in std_logic_vector(31 downto 0); 
		 instr: out std_logic_vector(31 downto 0)	 
);

end Instruction_Memory;

architecture Behavioral of Instruction_Memory is

   TYPE instrfile IS ARRAY (0 TO 206) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
	--signal data_file: datafile;
	signal instr_file: instrfile:=instrfile'( X"00000000",
"00000100000000100000000000000010",
"00000100000000110000000000000001",
"00000100000001000000000000011010",
"00000011110000000011100000010011",
"00100000010001110000000000000000",
"00000100010000100000000000000001",
"00000100000010000000000000000000",
"00000011101001110100000000010000",
"00100000010010000000000000000000",
"00000100010000100000000000000001",
"00000101000001110000000000000000",
"00000100011000110000000000000001",
"00100100011001001111111111111010",
"00000100000101010000000000000000",
"00000100000101100000000000000000",
"00000100000000110000000000000000",
"00000100000110000000000000011010",
"00000100000101110000000000000100",
"00000100000001000000000001001110",
"00000100000010010000000000110101",
"00000100000010100000000000000010",
"00000100000010110000000000000000",
"00000100000011000000000000000000",
"00000100000110010000000000000000",
"00000100000110100000000000000000",
"00011101010011000000000000000000",
"00011101001010110000000000000000",
"00000011010110010111100000010000",
"00000001100011110110000000010000",
"00010101100011010000000000000011",
"00011001100011100000000000011101",
"00000001110011010110000000010011",
"00000001100000001100100000010000",
"00100001010011000000000000000000",
"00000011010110010111100000010000",
"00000001011011110101100000010000",
"00000100000100000000000000011111",
"00000100000100010000000000100000",
"00000010000011110111100000010010",
"00000010001011111001000000010001",
"00000100000100110000000000000000",
"00000101011101000000000000000000",
"00101001111100110000000000000011",
"00010101011010110000000000000001",
"00000110011100110000000000000001",
"00100110011011111111111111111101",
"00000100000100110000000000000000",
"00101010010100110000000000000011",
"00011010100101000000000000000001",
"00000110011100110000000000000001",
"00100110011100101111111111111101",
"00000010100010110101100000010011",
"00000001011000001101000000010000",
"00100001001010110000000000000000",
"00000110101101010000000000000001",
"00000101010010100000000000000001",
"00101111000101010000000000000010",
"00000100000101010000000000000000",
"00000100000010100000000000000010",
"00000110110101100000000000000001",
"00000101001010011111111111111111",
"00101110111101100000000000000010",
"00000100000101100000000000000000",
"00000100000010010000000000110101",
"00000100011000110000000000000001",
"00101100100000111111111111010111",
"00000100000000000000000000000000",

------------------------------------------------------------------------------encryption

"00000100000000010000000000000000",
"00011100001000100000000000000000",
"00000100001000010000000000000001",
"00011100001000110000000000000000",
"00000100001000010000000000000001",
"00011100001001000000000000000000",
"00000000100000100001000000010000",
"00000100001000010000000000000001",
"00011100001001000000000000000000",
"00000000100000110001100000010000",
"00000100000001010000000000000001",
"00000100000001100000000000001101",
"00000000000000100100000000010100",
"00000000000000110100100000010100",
"00000000011010000101000000010010",
"00000000010010010101100000010010",
"00000001010010110101000000010011",
"00000100000100010000000000011111",
"00000100000011110000000000100000",
"00000100011100000000000000000000",
"00000010001100001000000000010010",
"00000001111100001001000000010001",
"00000100000011000000000000000000",
"00000101010100110000000000000000",
"00101010000011000000000000000011",
"00010101010010100000000000000001",
"00000101100011000000000000000001",
"00100101100100001111111111111101",
"00000100000011000000000000000000",
"00101010010011000000000000000011",
"00011010011100110000000000000001",
"00000101100011000000000000000001",
"00100101100100101111111111111101",
"00000010011010100101000000010011",
"00000100001000010000000000000001",
"00011100001001000000000000000000",
"00000000100010100001000000010000",
"00000000000000100100000000010100",
"00000000011010000101000000010010",
"00000000010010010101100000010010",
"00000001010010110101000000010011",
"00000100000100010000000000011111",
"00000100000011110000000000100000",
"00000100010100000000000000000000",
"00000010001100001000000000010010",
"00000001111100001001000000010001",
"00000100000011000000000000000000",
"00000101010100110000000000000000",
"00101010000011000000000000000011",
"00010101010010100000000000000001",
"00000101100011000000000000000001",
"00100101100100001111111111111101",
"00000100000011000000000000000000",
"00101010010011000000000000000011",
"00011010011100110000000000000001",
"00000101100011000000000000000001",
"00100101100100101111111111111101",
"00000010011010100101000000010011",
"00000100001000010000000000000001",
"00011100001001000000000000000000",
"00000000100010100001100000010000",
"00000100101001010000000000000001",
"00100100101001101111111111001101",
"00000100000011100000000000011100",
"00100001110000100000000000000000",
"00000100000011100000000000011101",
"00100001110000110000000000000000",


----------------------------------------------------------------------------------- decryption

"00000100000000010000000000000000",
"00011100001000100000000000000000",
"00000100001000010000000000000001",
"00011100001000110000000000000000",
"00000100000001010000000000000001",
"00000100000001100000000000001101",
"00000100000000010000000000011011",
"00011100001001000000000000000000",
"00000000011001000001100000010001",
"00000100000100010000000000011111",
"00000100000011110000000000100000",
"00000100010100000000000000000000",
"00000010001100001000000000010010",
"00000001111100001001000000010001",
"00000100000011000000000000000000",
"00000100011100110000000000000000",
"00101010000011000000000000000011",
"00011000011000110000000000000001",
"00000101100011000000000000000001",
"00100101100100001111111111111101",
"00000100000011000000000000000000",
"00101010010011000000000000000011",
"00010110011100110000000000000001",
"00000101100011000000000000000001",
"00100101100100101111111111111101",
"00000010011000110001100000010011",
"00000000000000110100000000010100",
"00000000000000100100100000010100",
"00000001001000110101000000010010",
"00000001000000100101100000010010",
"00000001010010110001100000010011",
"00000100001000011111111111111111",
"00011100001001000000000000000000",
"00000000010001000001000000010001",
"00000100000100010000000000011111",
"00000100000011110000000000100000",
"00000100011100000000000000000000",
"00000010001100001000000000010010",
"00000001111100001001000000010001",
"00000100000011000000000000000000",
"00000100010100110000000000000000",
"00101010000011000000000000000011",
"00011000010000100000000000000001",
"00000101100011000000000000000001",
"00100101100100001111111111111101",
"00000100000011000000000000000000",
"00101010010011000000000000000011",
"00010110011100110000000000000001",
"00000101100011000000000000000001",
"00100101100100101111111111111101",
"00000010011000100001000000010011",
"00000000000000100100000000010100",
"00000000000000110100100000010100",
"00000001001000100101000000010010",
"00000000011010000101100000010010",
"00000001010010110001000000010011",
"00000100101001010000000000000001",
"00000100001000011111111111111111",
"00100100101001101111111111001100",
"00000100000000000000000000000000",
"00011100001001000000000000000000",
"00000000011001000001100000010001",
"00000100001000011111111111111111",
"00011100001001000000000000000000",
"00000000010001000001000000010001",
"00000100000011100000000000100000",
"00100001110000100000000000000000",
"00000100000011100000000000100001",
"00100001110000110000000000000000",
"00000100000101000000000000100010",
"00100010100111110000000000000000",


"00101000000000001111111111111111"





); 

begin

	instr<=instr_file(conv_integer(address(31 downto 0)));

end Behavioral;
