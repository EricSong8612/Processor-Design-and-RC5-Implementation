library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic funcctions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU is

port ( a: in std_logic_vector(31 downto 0); ----- RS
		 b: in std_logic_vector(31 downto 0); ------RT, signed_b
		 op: in std_logic_vector(5 downto 0);  --- opcode
		 func: in std_logic_vector(5 downto 0); --function code
		 alu_src: in std_logic; --control b
		 signext_imm: in std_logic_vector(31 downto 0); --imm
		 zero: out std_logic;
		 dout: out std_logic_vector(31 downto 0)
);
end ALU;

architecture Behavioral of ALU is

signal signed_a: signed(31 downto 0);
signal signed_b: signed(31 downto 0);
signal signed_o: signed(31 downto 0);

begin

signed_a <= signed(a);
signed_b <= signed(b) when alu_src = '0' else signext_imm;

process(clk, clr)

 begin
		 case op is
		 when "000000" => if(func="000000") then signed_o<= signed_a + signed_b;
							elsif(func="000001") then signed_o<= signed_a - signed_b;
							elsif(func="010010") then signed_o<= signed_a and signed_b;
							elsif(func="010011") then signed_o<= signed_a or signed_b;
							elsif(func="010100") then signed_o<= not(signed_a or signed_b);
							end if;
		 when "000001" => signed_o<= signed_a + signed_b;
		 when "000010" => signed_o<= signed_a - signed_b;
		 when "000011" => signed_o<= signed_a and signed_b;
		 when "000100" => signed_o<= signed_a or signed_b;
--		 when "000101" => signed_o<= signed_a sll conv_integer(signed_b);
--		 when "000110" => signed_o<= signed_a srl conv_integer(signed_b);
		 when others => signed_o<= X"FFFFFFFF";
		 end case;
 end process;

dout<=std_logic_vector(signed_o);

process(signed_o)
	begin
	if (signed_o /= 0) then zero<='0';
	else zero<='1';
	end if;
end process;

end behavioral;
