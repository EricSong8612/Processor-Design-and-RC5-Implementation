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
--library IEEE;
--use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.STD_LOGIC_UNSIGNED.ALL;



library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;
PACKAGE rom IS
TYPE rom IS ARRAY(0 TO 25) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
END rom;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.rom.all;



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
		 ukey: in std_logic_vector(63 downto 0); -- for key expansion
		 main_din: in std_logic_vector(63 downto 0); -- for en/decryption
		 user_data_rdy: in std_logic;						-- main_din can be stored now
		 enc_dout: out std_logic_vector(63 downto 0);
		 dec_dout: out std_logic_vector(63 downto 0);		 
		 dout: out std_logic_vector(31 downto 0);
		 key_out: out std_logic_vector(63 downto 0);
		 sw: in std_logic_vector(15 downto 0);
		 sw_out: out std_logic_vector(63 downto 0)
);

end Data_Memory;

architecture Behavioral of Data_Memory is

	TYPE datafile IS ARRAY (0 TO 63) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
	--signal data_file: datafile; 
	signal data_file: datafile:=datafile'(
X"00000000", X"00000000",X"00000000", X"00000000", X"00000000", X"00000000",
X"00000000", X"00000000", X"00000000", X"00000000",
X"00000000", X"00000000", X"00000000", X"00000000",
X"00000000", X"00000000", X"00000000", X"00000000",
X"00000000", X"00000000", X"00000000", X"00000000",
X"00000000", X"00000000", X"00000000", X"00000000",
X"00000000", X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",
		X"00000000", X"00000000", X"00000000",
      X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
      X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
      X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
      X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
      X"00000000", X"00000000", X"00000000",X"00000000",X"00000000",
		X"00000000",X"00000000",X"12345678",X"00000000"); 


begin

	--Read from mem
	dout<= data_file(conv_integer(address(31 downto 0))) when mem_read='1';

	--Write into mem
	process (clk, mem_write)
	begin
      enc_dout(63 downto 32)<=data_file(28); -------READ OUTPUT
		enc_dout(31 downto 0)<=data_file(29);
	   dec_dout(63 downto 32)<=data_file(32);
	   dec_dout(31 downto 0)<=data_file(33); 
	   key_out<= data_file(27)&data_file(27);
		sw_out(63 downto 32) <= data_file(to_integer(unsigned(sw(6 downto 1))));
		sw_out(31 downto 0) <= data_file(to_integer(unsigned(sw(6 downto 1))));
		
		
		if (clk'event and clk='1') then
		
			if (user_data_rdy='1') then data_file(52)<= ukey(63 downto 32); --------------STORE USER DATA
												 data_file(53)<= ukey(31 downto 0);
												 data_file(51)<= X"00000000";
												 data_file(50)<= X"00000000";
												 data_file(0)<= main_din(63 downto 32);
												 data_file(1)<= main_din(31 downto 0);end if;
			
			if (mem_write='1') then data_file(conv_integer(address(31 downto 0))) <= din; end if;
	   end if;
	end process;

end Behavioral;

