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
	signal instr_file: instrfile:=instrfile'( X"00000000", 
		"00000100000000010000000000000111", "00000100000000100000000000001000",
      "00000000010000010001100000010000", X"00000004", X"00000005", X"00000006", X"00000007",
		X"00000008", X"00000009", X"0000000a", X"0000000b", X"0000000c",
		X"0000000d", X"0000000e", X"0000000f", X"00000000", X"00000000",
		X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
		X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
		X"00000000", X"00000000", X"00000000", X"00000000"); 

begin

	instr<=instr_file(conv_integer(address(31 downto 0)));

end Behavioral;

