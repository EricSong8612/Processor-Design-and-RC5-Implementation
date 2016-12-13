----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:56:06 12/08/2016 
-- Design Name: 
-- Module Name:    Processor - Behavioral 
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
use work.rom.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Processor is
    Port ( clk : in  STD_LOGIC;
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
end Processor;

architecture Structure of Processor is

	component Instr_Fetch is
	Port ( clk : in  STD_LOGIC;
			 reset : in  STD_LOGIC;
			 branch_in : in  STD_LOGIC_VECTOR (31 downto 0);           
			 jump_bool : in  STD_LOGIC;
			 branch_bool : in  STD_LOGIC;
			 all_rdy: in std_logic;
			 instr : out  STD_LOGIC_VECTOR (31 downto 0));
	end component;
	
	component Decode is
   port ( op: in std_logic_vector(5 downto 0);  
			 aluop: out std_logic_vector(5 downto 0);
			 alu_src: out std_logic:='0';
			 branch_lt: out std_logic:='0';
			 branch_ne: out std_logic:='0';
			 branch_eq: out std_logic:='0';
			 reg_write: out std_logic:='0';
			 reg_dst: out std_logic:='0'; --rd or rt
			 mem_read: out std_logic:='0';
			 mem_write: out std_logic:='0';
			 mem_to_reg: out std_logic:='0';
			 shift: out std_logic:='0';
			 jump: out std_logic:='0';
			 halt: out std_logic:='0');

	end component;
		
	component ALU_Control is
    Port ( aluop : in  STD_LOGIC_VECTOR (5 downto 0);
           func : in  STD_LOGIC_VECTOR (5 downto 0);
           alu_ctr : out  STD_LOGIC_VECTOR (3 downto 0));
	end component;
	
	component ALU is
    Port ( a: in std_logic_vector(31 downto 0); ----- RS
			  b: in std_logic_vector(31 downto 0); ------RT, imm
			  alu_ctr: in std_logic_vector(3 downto 0); --control function type
			  alu_src: in std_logic; --control b
			  imm: in std_logic_vector(31 downto 0); --imm
			  zero: out std_logic;
			  dout: out std_logic_vector(31 downto 0));
	end component;
	
	component sign_ext is
    Port ( Input : in  STD_LOGIC_VECTOR (15 downto 0);
           Output : out  std_logic_vector (31 downto 0));
	end component;
	
	component Register_File
		PORT( clk: in std_logic;
				reset: in std_logic;
				rs: in std_logic_vector(4 downto 0);
				rt: in std_logic_vector(4 downto 0);
				dst: in std_logic_vector(4 downto 0); --rd or rt
				write_enable: in std_logic;  --- write
				write_data: in std_logic_vector(31 downto 0);
				rs_out: out std_logic_vector(31 downto 0);
				rt_out: out std_logic_vector(31 downto 0));
	end component;
	
	component  Data_Memory is
	port ( clk: in std_logic;
			 mem_read: in std_logic;
			 mem_write: in std_logic;
			 din: in std_logic_vector(31 downto 0); --rt_out
			 address: in std_logic_vector(31 downto 0);
		    ukey: in std_logic_vector(63 downto 0);
		    main_din: in std_logic_vector(63 downto 0);
			 user_data_rdy: in std_logic;
		    enc_dout: out std_logic_vector(63 downto 0);
		    dec_dout: out std_logic_vector(63 downto 0);			 
			 dout: out std_logic_vector(31 downto 0);
			 key_out: out std_logic_vector(63 downto 0);
			 sw: in std_logic_vector(15 downto 0);
			 sw_out: out std_logic_vector(63 downto 0));
			 
	end  component;

	--Instruction fetch signal
	
	signal jump_bool : std_logic;
	signal branch_bool : std_logic;
	signal instr : std_logic_vector (31 downto 0);
	
	--Control Unit signals
	signal ALUOp : std_logic_vector(5 downto 0);
	signal RegDst : std_logic;
	signal ALUSrc : std_logic;
	signal MemToReg : std_logic;
	signal RegWrite : std_logic;
	signal MemRead : std_logic;
	signal MemWrite : std_logic;
	signal branchEQ : std_logic;
	signal branchNE : std_logic;
	signal branchLT : std_logic;
	signal shift : std_logic;
	signal jump : std_logic;
	signal halt : std_logic;
	
	--ALU Control signals
--	signal func : std_logic_vector(5 downto 0);
	signal ALUCtr : std_logic_vector(3 downto 0);
	
	--ALU signals
	signal DataA : std_logic_vector(31 downto 0);
	signal DataB : std_logic_vector(31 downto 0);
	signal signext_imm : std_logic_vector(31 downto 0);
	signal Zero : std_logic;
	signal ALU_Result : std_logic_vector(31 downto 0);
	
	--Register File signals
--	signal rsAddress : std_logic_vector(4 downto 0);
--	signal rtAddress : std_logic_vector(4 downto 0);
--	signal rdAddress : std_logic_vector(4 downto 0);
	signal WriteData : std_logic_vector(31 downto 0);
	signal dst : std_logic_vector(4 downto 0);
--	signal rsOut : std_logic_vector(31 downto 0); --DataA
--	signal rtOut : std_logic_vector(31 downto 0); --DataB
	
	--Data Memory signals
--	signal mem_read : std_logic;
--	signal mem_write : std_logic;
	signal DataOut : std_logic_vector(31 downto 0);

begin
  
	Instruction_Fetch : Instr_Fetch PORT MAP (clk, reset, signext_imm, jump_bool, branch_bool, all_rdy, instr);
	
	Control_Unit : Decode PORT MAP( instr(31 downto 26), ALUOp, ALUSrc, branchLT, branchNE, branchEQ, RegWrite, RegDst, MemRead, MemWrite, MemToReg, shift, jump, halt);
	
	ALU_Ctrl : ALU_Control PORT MAP(ALUOp, instr(5 downto 0), ALUCtr);
	
	Regiter_File : Register_File PORT MAP(clk, reset, instr(25 downto 21), instr(20 downto 16), dst, RegWrite, WriteData, DataA, DataB);
	dst <= instr(20 downto 16) when RegDst = '0' else
		    instr(15 downto 11);
					 
	ALU_Compution : ALU PORT MAP(DataA, DataB, ALUCtr, ALUSrc, signext_imm, zero, ALU_Result);
	
	RAM : Data_Memory PORT MAP(clk, MemRead, MemWrite, DataB, ALU_Result, ukey, main_din, user_data_rdy, enc_dout, dec_dout, DataOut, key_out, sw, sw_out);
	WriteData <= DataOut when MemToReg = '1' else
					 ALU_Result;		
					 
	Sign_Extender : sign_ext PORT MAP (instr(15 downto 0), signext_imm);
	
	branch_bool <= (branchEQ and Zero) or (branchNE and Zero) or (branchLT and Zero);
	jump_bool <= jump;
					 			 
	instruction <= instr;
	

end Structure;

