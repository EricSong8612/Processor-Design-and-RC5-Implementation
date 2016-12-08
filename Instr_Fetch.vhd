----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:47:38 12/07/2016 
-- Design Name: 
-- Module Name:    Instr_Fetch - Behavioral 
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

entity Instr_Fetch is

    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
			  branch_in : in  STD_LOGIC_VECTOR (31 downto 0); --signext_imm       
           jump_bool : in  STD_LOGIC; --jump or not (jump mux)
           branch_bool : in  STD_LOGIC; --branch or pc+4 (branch mux)
           instr : out  STD_LOGIC_VECTOR (31 downto 0)); --instruction
			  
end Instr_Fetch;

architecture Structural  of Instr_Fetch is
	component PC is
			Port ( input : in  STD_LOGIC_VECTOR (31 downto 0); --pc
                reset : in  STD_LOGIC;
                clk : in  STD_LOGIC;
                output : out  STD_LOGIC_VECTOR (31 downto 0) --pc, address
					);
	end component;
	
	component Instruction_Memory
			Port ( address : in  STD_LOGIC_VECTOR (31 downto 0); --pc
                Instr : out  STD_LOGIC_VECTOR (31 downto 0) --instruction
					);
	end component;
	
	component Adder
			Port ( num1 : in  STD_LOGIC_VECTOR (31 downto 0);
                num2 : in  STD_LOGIC_VECTOR (31 downto 0);
			       result : OUT STD_LOGIC_VECTOR (31 downto 0));
	end component;
	
	component Shift_Left_2
			Port ( input : in  STD_LOGIC_VECTOR (31 downto 0); --address       
			       output : out STD_LOGIC_VECTOR(31 downto 0) --address
					);
	end component;
	
	component Binary_MUX
			Port ( inputA : in  STD_LOGIC_VECTOR (31 downto 0); --sel='0'
                inputB : in  STD_LOGIC_VECTOR (31 downto 0); --sel='1'
                sel : in  STD_LOGIC;
                output : out  STD_LOGIC_VECTOR (31 downto 0) --address
					);
	end component;
	
	signal pc_output : STD_LOGIC_VECTOR (31 downto 0);
	constant PC_INCREMENT : std_logic_vector(31 downto 0):= X"00000004"; 
	signal pc_adder_output : std_logic_vector(31 downto 0);
	
	signal branch_shift_output : std_logic_vector(31 downto 0);
	signal branch_adder_output : std_logic_vector(31 downto 0);
	
	--signal jump_shift_output : std_logic_vector(31 downto 0);
	signal jump_32bit_signal : std_logic_vector(31 downto 0);
	
	signal branchMUX_output : std_logic_vector(31 downto 0);
	signal PC_new_value : std_logic_vector(31 downto 0);
	
	signal InstrMemOut : std_logic_vector(31 downto 0);
begin

	PC1: PC PORT MAP(PC_new_value, reset, clk, pc_output);
	InstrMem : Instruction_Memory PORT MAP( pc_output, InstrMemOut );
	
	PC_Adder : Adder PORT MAP( pc_output, PC_INCREMENT, pc_adder_output );
	
	Shift_Branch : Shift_Left_2 PORT MAP( branch_in, branch_shift_output );
	Branch_Adder : Adder PORT MAP( branch_shift_output, pc_adder_output, branch_adder_output );
	
	instr <= InstrMemOut;
	
	--Shift_Jump : Shift_Left_2 PORT MAP( "000000" & InstrMemOut(25 downto 0), jump_shift_output );
	jump_32bit_signal <= pc_adder_output(31 downto 26) & InstrMemOut(25 downto 0);
	
	BranchMUX : Binary_MUX PORT MAP( pc_adder_output, branch_adder_output, branch_bool, branchMUX_output);
	
	JumpMUX : Binary_MUX PORT MAP ( branchMUX_output, jump_32bit_signal, jump_bool, PC_new_value);
	
end Structural ;