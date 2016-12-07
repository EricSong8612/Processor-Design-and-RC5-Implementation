----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:06:06 12/07/2016 
-- Design Name: 
-- Module Name:    ALU_Control - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU_Control is

Port ( aluop : in  STD_LOGIC_VECTOR (5 downto 0);
       func : in  STD_LOGIC_VECTOR (5 downto 0);
       alu_ctr : out  STD_LOGIC_VECTOR (2 downto 0));

end ALU_Control;

architecture Behavioral of ALU_Control is

begin

	process (aluop, func)
	begin
		case aluop is
		when "000000" => if(func="010000") then alu_ctr<="000";
							  elsif(func="010001") then alu_ctr<="001";
							  elsif(func="010010") then alu_ctr<="010";
							  elsif(func="010011") then alu_ctr<="011";
							  elsif(func="010100") then alu_ctr<="100";
							  end if;
		 when "000001" => alu_ctr<="000";
		 when "000010" => alu_ctr<="001";
		 when "000011" => alu_ctr<="010";
		 when "000100" => alu_ctr<="011";
		 when "000101" => alu_ctr<="101";
		 when "000110" => alu_ctr<="110";
		 when others => null;
		 end case;
	end process;

end Behavioral;

