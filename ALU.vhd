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
		 b: in std_logic_vector(31 downto 0); ------RT, imm
		 alu_ctr: in std_logic_vector(3 downto 0); --control function type
		 alu_src: in std_logic; --control b
		 imm: in std_logic_vector(31 downto 0); --signext_imm
		 zero: out std_logic;
		 dout: out std_logic_vector(31 downto 0)
);
end ALU;

architecture Behavioral of ALU is

signal signed_a: signed(31 downto 0);
signal signed_b: signed(31 downto 0);
signal signed_o: signed(31 downto 0);
signal blt, beq, bne: std_logic;
begin

signed_a <= signed(a);
signed_b <= signed(b) when alu_src = '0' else signed(imm);

process(signed_a, signed_b, alu_ctr)

 begin		 
		 case alu_ctr is
		 when "0000" => signed_o<= signed_a + signed_b;
		 when "0001" => signed_o<= signed_a - signed_b;
		 when "0010" => signed_o<= signed_a and signed_b;
		 when "0011" => signed_o<= signed_a or signed_b;
		 when "0100" => signed_o<= not(signed_a or signed_b);
		 when "0101" => signed_o<= signed_a sll to_integer(signed_b);
		 when "0110" => signed_o<= signed_a srl to_integer(signed_b);
		 when "0111" => signed_o<= signed_a + signed_b;
		 when "1000" => signed_o<= signed_a + signed_b;
		 when "1001" => if(signed_a < signed_b) then blt<='1'; else blt<='0'; end if;
		 when "1010" => if(signed_a = signed_b) then beq<='1'; else beq<='0'; end if;
		 when "1011" => if(signed_a /= signed_b) then bne<='1'; else bne<='0'; end if;
		 
		 when others => null;
		 end case;
 end process;

dout<=std_logic_vector(signed_o);

process(blt, beq, bne)
	begin
	if (blt='1' or beq='1' or bne='1') then zero<='1';
	else zero<='0';
	end if;
end process;

end behavioral;
