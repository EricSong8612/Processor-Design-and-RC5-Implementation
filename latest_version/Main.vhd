----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:17:33 12/10/2016 
-- Design Name: 
-- Module Name:    Main - Behavioral 
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
use work.rom.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Main is

    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
			  sw: in STD_LOGIC_VECTOR(15 DOWNTO 0);
			  btnl: in STD_LOGIC; 
			  btnr: in STD_LOGIC; 
			  btnu: in STD_LOGIC; 
			  btnd: in STD_LOGIC;
			  instruction : out std_logic_vector(31 downto 0);
--			  output: out std_logic_vector(63 downto 0);
--			  led: out std_logic_vector(15 downto 0);
			  an  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			  sevenseg: OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
			  );


end Main;

architecture Behavioral of Main is

TYPE  StateType IS (ST_IDLE,
						  ST_UKEY_RDY,
						  ST_DATA_SET,
						  ST_OPERATION
						  );
 
signal state: StateType;
signal ukey: std_logic_vector(63 downto 0);
signal main_din: std_logic_vector(63 downto 0);
signal user_data_rdy: std_logic;
signal all_rdy: std_logic;
--signal key_dout: std_logic_vector(63 downto 0);
signal enc_dout: std_logic_vector(63 downto 0);
signal dec_dout: std_logic_vector(63 downto 0);
signal dout: std_logic_vector(63 downto 0);
signal key_out: std_logic_vector(63 downto 0);
--signal counter: STD_LOGIC_VECTOR(63 DOWNTO 0); -- segment counter
--signal an_sig     : STD_LOGIC_VECTOR(7 DOWNTO 0);  -- segment circle
signal counter: STD_LOGIC_VECTOR(20 downto 0) := (others => '0');
signal an_sig: std_logic_vector(7 downto 0);
signal disp_sw : std_logic;
signal sw_out: std_logic_vector(63 downto 0); 


COMPONENT  Processor  -- Key expansion module
   Port (  clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
			  ukey: in std_logic_vector(63 downto 0); -- ukey for expansion
			  main_din: in std_logic_vector(63 downto 0);	-- data for en/decryption
			  user_data_rdy: in std_logic; -- the mem can store user data now
			  all_rdy: in std_logic;
			  enc_dout: out std_logic_vector(63 downto 0);
			  dec_dout: out std_logic_vector(63 downto 0);
			  instruction : out std_logic_vector(31 downto 0);
			  key_out: out std_logic_vector(63 downto 0);
			  sw: in std_logic_vector(15 downto 0);
			  sw_out: out std_logic_vector(63 downto 0)
			 );
END COMPONENT;
begin
an<=an_sig;
disp_sw <= sw(0);
--output <= dout;



Proc: Processor PORT MAP(  clk=>counter(2),
							reset=>reset,
							ukey=>ukey,
							main_din=>main_din,
							user_data_rdy=>user_data_rdy,
							all_rdy=>all_rdy,
							enc_dout=>enc_dout,
							dec_dout=>dec_dout,
							instruction=>instruction,
							key_out=>key_out,
							sw => sw,
							sw_out => sw_out
						);

---- Input Control
--process(reset, clk)
--begin
--if (reset = '1') then
--	ukey<=X"0000000000000000";
--	main_din<=X"0000000000000000";
----	dout<=X"f000000000000000";
--elsif (rising_edge(clk)) then
--	if (state = ST_IDLE) THEN 
--		IF(btnd='1') THEN ukey(15 DOWNTO 0)<= sw;
--		ELSIF(btnu='1') THEN ukey(31 DOWNTO 16)<= sw;
--		ELSIF(btnr='1') THEN ukey(47 DOWNTO 32)<= sw;
--		ELSIF(btnl='1') THEN ukey(63 DOWNTO 48)<= sw; 
--		END IF;
--	elsif (state = ST_UKEY_RDY) THEN 
--		IF(btnd='1') THEN main_din(15 DOWNTO 0)<= sw;
--		ELSIF(btnu='1') THEN main_din(31 DOWNTO 16)<= sw;
--		ELSIF(btnl='1') THEN main_din(47 DOWNTO 32)<= sw;
--		ELSIF(btnr='1') THEN main_din(63 DOWNTO 48)<= sw; 
--		END IF;
--	end if;
--end if;
--end process;

WITH state select
	user_data_rdy <= '1' WHEN ST_DATA_SET, '0' WHEN OTHERS;

WITH state select
	all_rdy <= '1' WHEN ST_OPERATION, '0' WHEN OTHERS;
	
--WITH state select
--	led(15) <= '1' WHEN ST_IDLE, '0' WHEN OTHERS;
--	
--WITH state select
--	led(14) <= '1' WHEN ST_UKEY_RDY, '0' WHEN OTHERS;
--
--WITH state select
--	led(13) <= '1' WHEN ST_DATA_SET, '0' WHEN OTHERS;
--
--WITH state select
--	led(12) <= '1' WHEN ST_OPERATION, '0' WHEN OTHERS;

---- State Machine
--process(reset, clk, btnl, btnr, btnd)
--begin
--if (reset = '1') then state <= ST_IDLE;
--else case state is
--		when ST_IDLE => if (btnl = '1') then state <= ST_UKEY_RDY; end if;
--		when ST_UKEY_RDY => if (btnr = '1') then state <= ST_DATA_SET; end if;
--		when ST_DATA_SET => if (btnd = '1') then state <= ST_OPERATION; end if;
--		when ST_OPERATION => IF(sw(15)='1' and sw(14)='0') THEN dout<=enc_dout; 
--								ELSIF(sw(15)='1' and sw(14)='1') THEN dout<=dec_dout; 
--								ELSIF(sw(15)='0' and sw(14)='0') THEN dout<=key_out;END IF;
--		end case;
--end if;
--end process;

PROCESS(reset, clk)
BEGIN
	IF(reset='1') THEN
		state<=ST_IDLE;
		ukey<=X"0000000000000000";
		main_din<=X"0000000000000000";
--		enc_dout<=X"0000000000000000";
--		dec_dout<=X"0000000000000000";
		dout<=X"f000000000000000";
--		user_data_rdy<='0';
--		all_rdy<='0';
--		led<=X"0000";
		ELSIF(clk'EVENT AND clk='1') THEN

		CASE state IS
			WHEN ST_IDLE=>		--led(15)<='1';
									IF(btnd='1') THEN ukey(15 DOWNTO 0)<= sw;
									ELSIF(btnu='1') THEN ukey(31 DOWNTO 16)<= sw;
									ELSIF(btnr='1') THEN ukey(47 DOWNTO 32)<= sw;
									ELSIF(btnl='1') THEN ukey(63 DOWNTO 48)<= sw;state<=ST_UKEY_RDY;
								END IF;
			WHEN ST_UKEY_RDY=> --led(14)<='1';led(15)<='0';
									dout <= ukey;
									IF(btnd='1') THEN main_din(15 DOWNTO 0)<= sw;
									ELSIF(btnu='1') THEN main_din(31 DOWNTO 16)<= sw;
									ELSIF(btnl='1') THEN main_din(47 DOWNTO 32)<= sw;
									ELSIF(btnr='1') THEN main_din(63 DOWNTO 48)<= sw;state<=ST_DATA_SET;
								END IF;
			WHEN ST_DATA_SET=> --led(13)<='1';led(14)<='0';led(15)<='0';
									dout <= main_din;
									IF(btnd='1') THEN state<=ST_OPERATION; END IF;
			WHEN ST_OPERATION=> --led(12)<='1';led(13)<='0';led(14)<='0';led(15)<='0';
										dout <= sw_out;
--										IF(sw(15)='1' and sw(14)='0') THEN dout<=enc_dout; 
--										ELSIF(sw(15)='1' and sw(14)='1') THEN dout<=dec_dout; 
--									   ELSIF(sw(15)='0' and sw(14)='0') THEN dout<=key_out;END IF;
--										
									  IF(btnu='1') THEN state<=ST_IDLE; END IF;
		END CASE;
	END IF;
END PROCESS;

--PROCESS(reset, clk)
--BEGIN
--	IF(reset='1') THEN
--		state<=ST_IDLE;
--		ukey<=X"0000000000000000";
--		main_din<=X"0000000000000000";
----		enc_dout<=X"0000000000000000";
----		dec_dout<=X"0000000000000000";
--		dout<=X"f000000000000000";
--		user_data_rdy<='0';
--		all_rdy<='0';
--		led<=X"0000";
--		ELSIF(clk'EVENT AND clk='1') THEN
--
--		CASE state IS
--			WHEN ST_IDLE=>		led(15)<='1';
--									IF(btnd='1') THEN ukey(15 DOWNTO 0)<= sw;
--									ELSIF(btnu='1') THEN ukey(31 DOWNTO 16)<= sw;
--									ELSIF(btnr='1') THEN ukey(47 DOWNTO 32)<= sw;
--									ELSIF(btnl='1') THEN ukey(63 DOWNTO 48)<= sw;state<=ST_UKEY_RDY;
--								END IF;
--			WHEN ST_UKEY_RDY=>led(14)<='1';led(15)<='0';
--										IF(btnd='1') THEN main_din(15 DOWNTO 0)<= sw;
--									ELSIF(btnu='1') THEN main_din(31 DOWNTO 16)<= sw;
--									ELSIF(btnl='1') THEN main_din(47 DOWNTO 32)<= sw;
--									ELSIF(btnr='1') THEN main_din(63 DOWNTO 48)<= sw;state<=ST_DATA_SET;user_data_rdy<='1';
--								END IF;
--			WHEN ST_DATA_SET=> led(13)<='1';led(14)<='0';led(15)<='0';
--									IF(btnd='1') THEN state<=ST_OPERATION; all_rdy<='1';user_data_rdy<='0'; END IF;
--			WHEN ST_OPERATION=> led(12)<='1';led(13)<='0';led(14)<='0';led(15)<='0';
--										IF(sw(15)='1' and sw(14)='0') THEN dout<=enc_dout; 
--										ELSIF(sw(15)='1' and sw(14)='1') THEN dout<=dec_dout; 
--									   ELSIF(sw(15)='0' and sw(14)='0') THEN dout<=key_out;END IF;
--										
--									  IF(btnu='1') THEN state<=ST_IDLE; END IF;
--		END CASE;
--	END IF;
--END PROCESS;


--
---- round counter
--    PROCESS(reset, clk)  BEGIN
--        IF(reset='1') THEN
--           counter<=X"0000000000000000";
--        ELSIF(clk'EVENT AND clk='1') THEN
--					counter <= counter+'1';
--        END IF;
--    END PROCESS;

segmentcontrol: process(an_sig, disp_sw, dout)
begin
case disp_sw is
when '1' =>
	case an_sig(7 downto 0) is
		when "11111110" =>
			case dout(3 downto 0) is
				when "0000" => sevenseg <= "1000000";
				when "0001" => sevenseg <= "1111001";
				when "0010" => sevenseg <= "0100100";
				when "0011" => sevenseg <= "0110000";
				when "0100" => sevenseg <= "0011001";
				when "0101" => sevenseg <= "0010010";
				when "0110" => sevenseg <= "0000010";
				when "0111" => sevenseg <= "1111000";
				when "1000" => sevenseg <= "0000000";
				when "1001" => sevenseg <= "0010000";
				when "1010" => sevenseg <= "0001000";
				when "1011" => sevenseg <= "0000011";
				when "1100" => sevenseg <= "1000110";
				when "1101" => sevenseg <= "0100001";
				when "1110" => sevenseg <= "0000110";
				when "1111" => sevenseg <= "0001110";
				when others	=> sevenseg <= "1111111";
			end case;
		
		when "11111101" =>
			case dout(7 downto 4) is
				when "0000" => sevenseg <= "1000000";
				when "0001" => sevenseg <= "1111001";
				when "0010" => sevenseg <= "0100100";
				when "0011" => sevenseg <= "0110000";
				when "0100" => sevenseg <= "0011001";
				when "0101" => sevenseg <= "0010010";
				when "0110" => sevenseg <= "0000010";
				when "0111" => sevenseg <= "1111000";
				when "1000" => sevenseg <= "0000000";
				when "1001" => sevenseg <= "0010000";
				when "1010" => sevenseg <= "0001000";
				when "1011" => sevenseg <= "0000011";
				when "1100" => sevenseg <= "1000110";
				when "1101" => sevenseg <= "0100001";
				when "1110" => sevenseg <= "0000110";
				when "1111" => sevenseg <= "0001110";
				when others	=> sevenseg <= "1111111";
			end case;
		
		when "11111011" =>
			case dout(11 downto 8) is
				when "0000" => sevenseg <= "1000000";
				when "0001" => sevenseg <= "1111001";
				when "0010" => sevenseg <= "0100100";
				when "0011" => sevenseg <= "0110000";
				when "0100" => sevenseg <= "0011001";
				when "0101" => sevenseg <= "0010010";
				when "0110" => sevenseg <= "0000010";
				when "0111" => sevenseg <= "1111000";
				when "1000" => sevenseg <= "0000000";
				when "1001" => sevenseg <= "0010000";
				when "1010" => sevenseg <= "0001000";
				when "1011" => sevenseg <= "0000011";
				when "1100" => sevenseg <= "1000110";
				when "1101" => sevenseg <= "0100001";
				when "1110" => sevenseg <= "0000110";
				when "1111" => sevenseg <= "0001110";
				when others	=> sevenseg <= "1111111";
			end case;
		
		when "11110111" =>
			case dout(15 downto 12) is
				when "0000" => sevenseg <= "1000000";
				when "0001" => sevenseg <= "1111001";
				when "0010" => sevenseg <= "0100100";
				when "0011" => sevenseg <= "0110000";
				when "0100" => sevenseg <= "0011001";
				when "0101" => sevenseg <= "0010010";
				when "0110" => sevenseg <= "0000010";
				when "0111" => sevenseg <= "1111000";
				when "1000" => sevenseg <= "0000000";
				when "1001" => sevenseg <= "0010000";
				when "1010" => sevenseg <= "0001000";
				when "1011" => sevenseg <= "0000011";
				when "1100" => sevenseg <= "1000110";
				when "1101" => sevenseg <= "0100001";
				when "1110" => sevenseg <= "0000110";
				when "1111" => sevenseg <= "0001110";
				when others	=> sevenseg <= "1111111";
			end case;
			
		when "11101111" =>
			case dout(19 downto 16) is
				when "0000" => sevenseg <= "1000000";
				when "0001" => sevenseg <= "1111001";
				when "0010" => sevenseg <= "0100100";
				when "0011" => sevenseg <= "0110000";
				when "0100" => sevenseg <= "0011001";
				when "0101" => sevenseg <= "0010010";
				when "0110" => sevenseg <= "0000010";
				when "0111" => sevenseg <= "1111000";
				when "1000" => sevenseg <= "0000000";
				when "1001" => sevenseg <= "0010000";
				when "1010" => sevenseg <= "0001000";
				when "1011" => sevenseg <= "0000011";
				when "1100" => sevenseg <= "1000110";
				when "1101" => sevenseg <= "0100001";
				when "1110" => sevenseg <= "0000110";
				when "1111" => sevenseg <= "0001110";
				when others	=> sevenseg <= "1111111";
			end case;
		when "11011111" =>
			case dout(23 downto 20) is
				when "0000" => sevenseg <= "1000000";
				when "0001" => sevenseg <= "1111001";
				when "0010" => sevenseg <= "0100100";
				when "0011" => sevenseg <= "0110000";
				when "0100" => sevenseg <= "0011001";
				when "0101" => sevenseg <= "0010010";
				when "0110" => sevenseg <= "0000010";
				when "0111" => sevenseg <= "1111000";
				when "1000" => sevenseg <= "0000000";
				when "1001" => sevenseg <= "0010000";
				when "1010" => sevenseg <= "0001000";
				when "1011" => sevenseg <= "0000011";
				when "1100" => sevenseg <= "1000110";
				when "1101" => sevenseg <= "0100001";
				when "1110" => sevenseg <= "0000110";
				when "1111" => sevenseg <= "0001110";
				when others	=> sevenseg <= "1111111";
			end case;
		when "10111111" =>
			case dout(27 downto 24) is
				when "0000" => sevenseg <= "1000000";
				when "0001" => sevenseg <= "1111001";
				when "0010" => sevenseg <= "0100100";
				when "0011" => sevenseg <= "0110000";
				when "0100" => sevenseg <= "0011001";
				when "0101" => sevenseg <= "0010010";
				when "0110" => sevenseg <= "0000010";
				when "0111" => sevenseg <= "1111000";
				when "1000" => sevenseg <= "0000000";
				when "1001" => sevenseg <= "0010000";
				when "1010" => sevenseg <= "0001000";
				when "1011" => sevenseg <= "0000011";
				when "1100" => sevenseg <= "1000110";
				when "1101" => sevenseg <= "0100001";
				when "1110" => sevenseg <= "0000110";
				when "1111" => sevenseg <= "0001110";
				when others	=> sevenseg <= "1111111";
			end case;
		when "01111111" =>
			case dout(31 downto 28) is
				when "0000" => sevenseg <= "1000000";
				when "0001" => sevenseg <= "1111001";
				when "0010" => sevenseg <= "0100100";
				when "0011" => sevenseg <= "0110000";
				when "0100" => sevenseg <= "0011001";
				when "0101" => sevenseg <= "0010010";
				when "0110" => sevenseg <= "0000010";
				when "0111" => sevenseg <= "1111000";
				when "1000" => sevenseg <= "0000000";
				when "1001" => sevenseg <= "0010000";
				when "1010" => sevenseg <= "0001000";
				when "1011" => sevenseg <= "0000011";
				when "1100" => sevenseg <= "1000110";
				when "1101" => sevenseg <= "0100001";
				when "1110" => sevenseg <= "0000110";
				when "1111" => sevenseg <= "0001110";
				when others	=> sevenseg <= "1111111";
			end case;
		when others => sevenseg <= "1111111";
	end case;

when '0' =>
	case an_sig(7 downto 0) is
		when "11111110" =>
			case dout(35 downto 32) is
				when "0000" => sevenseg <= "1000000";
				when "0001" => sevenseg <= "1111001";
				when "0010" => sevenseg <= "0100100";
				when "0011" => sevenseg <= "0110000";
				when "0100" => sevenseg <= "0011001";
				when "0101" => sevenseg <= "0010010";
				when "0110" => sevenseg <= "0000010";
				when "0111" => sevenseg <= "1111000";
				when "1000" => sevenseg <= "0000000";
				when "1001" => sevenseg <= "0010000";
				when "1010" => sevenseg <= "0001000";
				when "1011" => sevenseg <= "0000011";
				when "1100" => sevenseg <= "1000110";
				when "1101" => sevenseg <= "0100001";
				when "1110" => sevenseg <= "0000110";
				when "1111" => sevenseg <= "0001110";
				when others	=> sevenseg <= "1111111";
			end case;
		
		when "11111101" =>
			case dout(39 downto 36) is
				when "0000" => sevenseg <= "1000000";
				when "0001" => sevenseg <= "1111001";
				when "0010" => sevenseg <= "0100100";
				when "0011" => sevenseg <= "0110000";
				when "0100" => sevenseg <= "0011001";
				when "0101" => sevenseg <= "0010010";
				when "0110" => sevenseg <= "0000010";
				when "0111" => sevenseg <= "1111000";
				when "1000" => sevenseg <= "0000000";
				when "1001" => sevenseg <= "0010000";
				when "1010" => sevenseg <= "0001000";
				when "1011" => sevenseg <= "0000011";
				when "1100" => sevenseg <= "1000110";
				when "1101" => sevenseg <= "0100001";
				when "1110" => sevenseg <= "0000110";
				when "1111" => sevenseg <= "0001110";
				when others	=> sevenseg <= "1111111";
			end case;
		
		when "11111011" =>
			case dout(43 downto 40) is
				when "0000" => sevenseg <= "1000000";
				when "0001" => sevenseg <= "1111001";
				when "0010" => sevenseg <= "0100100";
				when "0011" => sevenseg <= "0110000";
				when "0100" => sevenseg <= "0011001";
				when "0101" => sevenseg <= "0010010";
				when "0110" => sevenseg <= "0000010";
				when "0111" => sevenseg <= "1111000";
				when "1000" => sevenseg <= "0000000";
				when "1001" => sevenseg <= "0010000";
				when "1010" => sevenseg <= "0001000";
				when "1011" => sevenseg <= "0000011";
				when "1100" => sevenseg <= "1000110";
				when "1101" => sevenseg <= "0100001";
				when "1110" => sevenseg <= "0000110";
				when "1111" => sevenseg <= "0001110";
				when others	=> sevenseg <= "1111111";
			end case;
		
		when "11110111" =>
			case dout(47 downto 44) is
				when "0000" => sevenseg <= "1000000";
				when "0001" => sevenseg <= "1111001";
				when "0010" => sevenseg <= "0100100";
				when "0011" => sevenseg <= "0110000";
				when "0100" => sevenseg <= "0011001";
				when "0101" => sevenseg <= "0010010";
				when "0110" => sevenseg <= "0000010";
				when "0111" => sevenseg <= "1111000";
				when "1000" => sevenseg <= "0000000";
				when "1001" => sevenseg <= "0010000";
				when "1010" => sevenseg <= "0001000";
				when "1011" => sevenseg <= "0000011";
				when "1100" => sevenseg <= "1000110";
				when "1101" => sevenseg <= "0100001";
				when "1110" => sevenseg <= "0000110";
				when "1111" => sevenseg <= "0001110";
				when others	=> sevenseg <= "1111111";
			end case;
			
		when "11101111" =>
			case dout(51 downto 48) is
				when "0000" => sevenseg <= "1000000";
				when "0001" => sevenseg <= "1111001";
				when "0010" => sevenseg <= "0100100";
				when "0011" => sevenseg <= "0110000";
				when "0100" => sevenseg <= "0011001";
				when "0101" => sevenseg <= "0010010";
				when "0110" => sevenseg <= "0000010";
				when "0111" => sevenseg <= "1111000";
				when "1000" => sevenseg <= "0000000";
				when "1001" => sevenseg <= "0010000";
				when "1010" => sevenseg <= "0001000";
				when "1011" => sevenseg <= "0000011";
				when "1100" => sevenseg <= "1000110";
				when "1101" => sevenseg <= "0100001";
				when "1110" => sevenseg <= "0000110";
				when "1111" => sevenseg <= "0001110";
				when others	=> sevenseg <= "1111111";
			end case;
		when "11011111" =>
			case dout(55 downto 52) is
				when "0000" => sevenseg <= "1000000";
				when "0001" => sevenseg <= "1111001";
				when "0010" => sevenseg <= "0100100";
				when "0011" => sevenseg <= "0110000";
				when "0100" => sevenseg <= "0011001";
				when "0101" => sevenseg <= "0010010";
				when "0110" => sevenseg <= "0000010";
				when "0111" => sevenseg <= "1111000";
				when "1000" => sevenseg <= "0000000";
				when "1001" => sevenseg <= "0010000";
				when "1010" => sevenseg <= "0001000";
				when "1011" => sevenseg <= "0000011";
				when "1100" => sevenseg <= "1000110";
				when "1101" => sevenseg <= "0100001";
				when "1110" => sevenseg <= "0000110";
				when "1111" => sevenseg <= "0001110";
				when others	=> sevenseg <= "1111111";
			end case;
		when "10111111" =>
			case dout(59 downto 56) is
				when "0000" => sevenseg <= "1000000";
				when "0001" => sevenseg <= "1111001";
				when "0010" => sevenseg <= "0100100";
				when "0011" => sevenseg <= "0110000";
				when "0100" => sevenseg <= "0011001";
				when "0101" => sevenseg <= "0010010";
				when "0110" => sevenseg <= "0000010";
				when "0111" => sevenseg <= "1111000";
				when "1000" => sevenseg <= "0000000";
				when "1001" => sevenseg <= "0010000";
				when "1010" => sevenseg <= "0001000";
				when "1011" => sevenseg <= "0000011";
				when "1100" => sevenseg <= "1000110";
				when "1101" => sevenseg <= "0100001";
				when "1110" => sevenseg <= "0000110";
				when "1111" => sevenseg <= "0001110";
				when others	=> sevenseg <= "1111111";
			end case;
		when "01111111" =>
			case dout(63 downto 60) is
				when "0000" => sevenseg <= "1000000";
				when "0001" => sevenseg <= "1111001";
				when "0010" => sevenseg <= "0100100";
				when "0011" => sevenseg <= "0110000";
				when "0100" => sevenseg <= "0011001";
				when "0101" => sevenseg <= "0010010";
				when "0110" => sevenseg <= "0000010";
				when "0111" => sevenseg <= "1111000";
				when "1000" => sevenseg <= "0000000";
				when "1001" => sevenseg <= "0010000";
				when "1010" => sevenseg <= "0001000";
				when "1011" => sevenseg <= "0000011";
				when "1100" => sevenseg <= "1000110";
				when "1101" => sevenseg <= "0100001";
				when "1110" => sevenseg <= "0000110";
				when "1111" => sevenseg <= "0001110";
				when others	=> sevenseg <= "1111111";
			end case;
		when others => sevenseg <= "1111111";
	end case;
when others =>
	sevenseg <= "1111111";
end case;
end process;

selectseg: process(clk, reset)
begin
if reset = '1' then
	an_sig <= "11111111";
elsif rising_edge(clk) then
	case counter(20 downto 18) is
		when "000" => an_sig <= "11111110";
		when "001" => an_sig <= "11111101";
		when "010" => an_sig <= "11111011";
		when "011" => an_sig <= "11110111";
		when "100" => an_sig <= "11101111";
		when "101" => an_sig <= "11011111";
		when "110" => an_sig <= "10111111";
		when "111" => an_sig <= "01111111";
		when others => an_sig <= "11111111";
	end case;
end if;
end process;

				
count: process(clk, reset)
begin
	if (reset = '1') then
		counter<=(others=>'0');
	elsif rising_edge(clk) then
		counter <= counter + '1';
	end if;
end process;

end Behavioral;


