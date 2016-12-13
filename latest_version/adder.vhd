----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:15:29 12/07/2016 
-- Design Name: 
-- Module Name:    adder - Behavioral 
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

entity adder is
    Port ( num1 : in  STD_LOGIC_VECTOR (31 downto 0);
           num2 : in  STD_LOGIC_VECTOR (31 downto 0);
			  result : OUT STD_LOGIC_VECTOR (31 downto 0));
			  			  
end adder;

architecture Behavioral of adder is	
	
begin

	result <= STD_LOGIC_VECTOR( signed(num1) + signed(num2) );

end Behavioral;

