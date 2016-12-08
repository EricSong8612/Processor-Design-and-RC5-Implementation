----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:18:04 12/07/2016 
-- Design Name: 
-- Module Name:    shift_left_2 - Behavioral 
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
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Shift_Left_2 is
    Port ( input : in  STD_LOGIC_VECTOR (31 downto 0);           
			  output : out STD_LOGIC_VECTOR(31 downto 0));
			  
end Shift_Left_2;

architecture Behavioral of Shift_Left_2 is

begin

		output <=  std_logic_vector(unsigned(input) sll 2);

end Behavioral;

