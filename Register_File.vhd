----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:44:02 12/06/2016 
-- Design Name: 
-- Module Name:    Register_File - Behavioral 
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

entity Register_File is

port ( clk: in std_logic;
		 rs: in std_logic_vector(4 downto 0);
		 rt: in std_logic_vector(4 downto 0);
		 dst: in std_logic_vector(4 downto 0); --rd or rt
		 write_enable: in std_logic;  --- write
		 write_data: in std_logic_vector(31 downto 0);
		 rs_out: out std_logic_vector(31 downto 0);
		 rt_out: out std_logic_vector(31 downto 0)
		 
);

end Register_File;

architecture Behavioral of Register_File is

	TYPE regfile IS ARRAY (0 TO 31) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
	signal reg_file: regfile := (X"00000000", X"00000000", X"00000000",
      X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
		X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
		X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
		X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
		X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
		X"00000000", X"00000000", X"00000000", X"00000000");
begin
	
	--read Rs
	rs_out<=reg_file(conv_integer(rs));
	
	--Read Rt
	rt_out<=reg_file(conv_integer(rt));

	--Write into register
	process (clk)
	begin
		if (clk'event and clk='1') then
		if (write_enable='1') then reg_file(conv_integer(dst)) <= write_data;
		end if;
		end if;
	end process;

end Behavioral;

