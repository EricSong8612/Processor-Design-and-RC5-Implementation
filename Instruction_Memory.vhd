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

   TYPE instrfile IS ARRAY (0 TO 31) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
	--signal data_file: datafile;
	signal instr_file: instrfile:=instrfile'( X"00000000",

"00000100000000010000000000000010",
"00000100000000110000000000001010","00000100000001000000000000001110","00000100000001010000000000000010",
"00100000011001000000000000000010","00100000011000110000000000000001","00000000011001000010000000010001",
"00001000000001000000000000000001","00000000011000100010000000010010","00001100010001000000000000001010",
"00000000011000100010000000010011","00011100011000100000000000000001","00010000010001000000000000001010",
"00000000011000100010000000010100","00010100010001000000000000001010","00011000010001000000000000001010","00101000000001011111111111111110",


	
		
		X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
		X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
		X"00000000", X"00000000", X"00000000", X"00000000"); 

begin

	instr<=instr_file(conv_integer(address(31 downto 0)));

end Behavioral;

