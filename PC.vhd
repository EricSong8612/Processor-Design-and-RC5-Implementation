----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:57:29 12/06/2016 
-- Design Name: 
-- Module Name:    PC - Behavioral 
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

entity PC is

Port ( clk : in  STD_LOGIC;
       reset : in  STD_LOGIC;
		 input : in  STD_LOGIC_VECTOR (31 downto 0);
       output : out  STD_LOGIC_VECTOR (31 downto 0));

end PC;

architecture Behavioral of PC is

begin

process(reset,clk)
  begin
    if reset='1' then
       output <= X"00000000";
    elsif rising_edge(clk) then
       output<=input;
    end	if;  
end process;

end Behavioral;

