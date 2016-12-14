--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:17:33 12/14/2016
-- Design Name:   
-- Module Name:   E:/Project/final_test/Processor_TB.vhd
-- Project Name:  final_test
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Processor
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.std_logic_textio.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
library STD;
use STD.textio.all;
 
ENTITY Processor_TB IS
END Processor_TB;
 
ARCHITECTURE behavior OF Processor_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Processor
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         ukey : IN  std_logic_vector(63 downto 0);
         main_din : IN  std_logic_vector(63 downto 0);
         user_data_rdy : IN  std_logic;
         all_rdy : IN  std_logic;
         enc_dout : OUT  std_logic_vector(63 downto 0);
         dec_dout : OUT  std_logic_vector(63 downto 0);
         instruction : OUT  std_logic_vector(31 downto 0);
         key_out : OUT  std_logic_vector(63 downto 0);
         sw : IN  std_logic_vector(15 downto 0);
         sw_out : OUT  std_logic_vector(63 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '1';
   signal ukey : std_logic_vector(63 downto 0);
   signal main_din : std_logic_vector(63 downto 0);
   signal user_data_rdy : std_logic;
   signal all_rdy : std_logic;
   signal sw : std_logic_vector(15 downto 0);

 	--Outputs
   signal enc_dout : std_logic_vector(63 downto 0);
   signal dec_dout : std_logic_vector(63 downto 0);
   signal instruction : std_logic_vector(31 downto 0);
   signal key_out : std_logic_vector(63 downto 0);
   signal sw_out : std_logic_vector(63 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
	
	signal endoffile : bit := '0';
	
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Processor PORT MAP (
          clk => clk,
          reset => reset,
          ukey => ukey,
          main_din => main_din,
          user_data_rdy => user_data_rdy,
          all_rdy => all_rdy,
          enc_dout => enc_dout,
          dec_dout => dec_dout,
          instruction => instruction,
          key_out => key_out,
          sw => sw,
          sw_out => sw_out
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

--   -- Stimulus process
--   stim_proc: process
--   begin		
--      -- hold reset state for 100 ns.
--      wait for 100 ns;	
--
--      -- insert stimulus here 
--
--      wait;
--   end process;

--read process
reading:
process
    file   infile    : text is in  "inputs.txt";   --declare input file
	 
    variable  inline    : line; --line number declaration
    VARIABLE reset1 : std_logic;
	 VARIABLE ukey1 : std_logic_vector(63 downto 0);
	 VARIABLE main_din1 : std_logic_vector(63 downto 0);
    VARIABLE user_data_rdy1 : std_logic;
    VARIABLE all_rdy1 : std_logic;
    VARIABLE sw1 : std_logic_vector(15 downto 0);
	 
begin
	wait until clk = '1' and clk'event;
	if (not endfile(infile)) then   --checking the "END OF FILE" is not reached.

		readline(infile, inline);     
		read(inline, reset1);
		reset <=reset1; 

		readline(infile, inline);
		read(inline, ukey1);
		ukey <=ukey1; 

		readline(infile, inline);
		read(inline, main_din1);
		main_din <=main_din1; 

		readline(infile, inline);
		read(inline, user_data_rdy1);
		user_data_rdy <=user_data_rdy1; 

		readline(infile, inline);
		read(inline, all_rdy1);
		all_rdy <=all_rdy1; 

		readline(infile, inline);
		read(inline, sw1);
		sw <=sw1; 

	else
	endoffile <='1';         --set signal to tell end of file read file is reached.
	end if;

end process reading;

--write process
writing :
process
    file      outfile  : text is out "outputs.txt";  --declare output file
    variable  outline  : line;   --line number declaration  
begin
	wait until clk = '0' and clk'event;
	if(endoffile='0') then   --if the file end is not reached.
   wait for 400 us;
		write(outline, enc_dout);
		writeline(outfile, outline);

		write(outline, dec_dout);
		writeline(outfile, outline);
		
		write(outline, key_out);
		writeline(outfile, outline);
		
		write(outline, sw_out);
		writeline(outfile, outline);

	else
	null;
	end if;

end process writing;

END;
