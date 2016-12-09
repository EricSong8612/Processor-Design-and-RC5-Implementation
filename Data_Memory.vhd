----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:31:51 12/06/2016 
-- Design Name: 
-- Module Name:    Data_Memory - Behavioral 
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

entity Data_Memory is

port ( clk: in std_logic;
		 mem_read: in std_logic;
		 mem_write: in std_logic;
		 din: in std_logic_vector(31 downto 0); --rt_out
		 address: in std_logic_vector(31 downto 0); 
		 dout: out std_logic_vector(31 downto 0)	 
);

end Data_Memory;

architecture Behavioral of Data_Memory is

	TYPE datafile IS ARRAY (0 TO 31) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
	--signal data_file: datafile;
	signal data_file: datafile:=datafile'(X"9BBBD8C8", X"1A37F7FB", X"46F8E8C5",
      X"460C6085", X"70F83B8A", X"284B8303", X"513E1454", X"F621ED22",
      X"00000000", X"11A83A5D", X"D427686B", X"713AD82D", X"4B792F99",
      X"2799A4DD", X"A7901C49", X"DEDE871A", X"36C03196", X"A7EFC249",
      X"61A78BB8", X"3B0A1D2B", X"4DBFCA76", X"AE162167", X"30D76B0A",
      X"43192304", X"F6CC1431", X"65046380",X"00000000",X"00000000",
		X"00000000",X"00000000",X"00000000",X"00000000"); 

begin
	--Read from mem
	dout<= data_file(conv_integer(address(31 downto 0))) when mem_read='1';
	
	--Write into mem
	process (clk, mem_write)
	begin
		if (clk'event and clk='1') then
		if (mem_write='1') then data_file(conv_integer(address(31 downto 0))) <= din;
		end if;
		end if;
	end process;

end Behavioral;

