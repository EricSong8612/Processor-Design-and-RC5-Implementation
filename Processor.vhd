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
			  instruction : out std_logic_vector(31 downto 0)
			 );
end Processor;

architecture Structure of Processor is

	component Instr_Fetch is
	Port ( clk : in  STD_LOGIC;
			 reset : in  STD_LOGIC;
			 branch_in : in  STD_LOGIC_VECTOR (31 downto 0);           
			 jump_bool : in  STD_LOGIC;
			 branch_bool : in  STD_LOGIC;
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
--		  Port ( OPcode : in  STD_LOGIC_VECTOR (5 downto 0);
--           ALUOp : out  STD_LOGIC_VECTOR (1 downto 0);
--           RegDst : out  STD_LOGIC;
--           ALUSrc : out  STD_LOGIC;
--           MemToReg : out  STD_LOGIC;
--           RegWrite : out  STD_LOGIC;
--           MemRead : out  STD_LOGIC;
--           MemWrite : out  STD_LOGIC;
--			  Jump : out STD_LOGIC;
--			  BranchNE : out std_logic;
--           Branch : out  STD_LOGIC);
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
--			  Data1 : in  STD_LOGIC_VECTOR (31 downto 0);
--           Data2 : in  STD_LOGIC_VECTOR (31 downto 0);
--           Sign_Extended : in  STD_LOGIC_VECTOR (31 downto 0);
--           ALUSrc : in  STD_LOGIC;
--           Zero : out  STD_LOGIC;
--           ALU_Result : out  STD_LOGIC_VECTOR (31 downto 0);
--			  ALUCtr : in std_logic_vector(2 downto 0));
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
--				RDData	:	IN	STD_LOGIC_VECTOR (31 DOWNTO 0); 
--				CLK	:	IN	STD_LOGIC; 
--				Reset	:	IN	STD_LOGIC; 
--				RS	:	IN	STD_LOGIC_VECTOR (4 DOWNTO 0); 
--				RS_OUT	:	OUT	STD_LOGIC_VECTOR (31 DOWNTO 0); 
--				RT	:	IN	STD_LOGIC_VECTOR (4 DOWNTO 0); 
--				RT_OUT	:	OUT	STD_LOGIC_VECTOR (31 DOWNTO 0); 
--				Rd	:	IN	STD_LOGIC_VECTOR (4 DOWNTO 0); 
--				RegWrite	:	IN	STD_LOGIC);
	end component;
	
	component  Data_Memory is
	port ( clk: in std_logic;
			 mem_read: in std_logic;
			 mem_write: in std_logic;
			 din: in std_logic_vector(31 downto 0); --rt_out
			 address: in std_logic_vector(31 downto 0); 
			 dout: out std_logic_vector(31 downto 0));
--	generic (
--					ADDR_WIDTH :integer := 32 ;
--					DATA_WIDTH : integer := 32
--				);
--	port (
--				clk : in std_logic;
--				MemWrite: in std_logic;
--				MemRead: in std_logic;
--				addr : in std_logic_vector (ADDR_WIDTH-1 downto 0) ;
--				dout : out std_logic_vector (DATA_WIDTH-1 downto 0);
--				din: in std_logic_vector (DATA_WIDTH -1 downto 0 ) 
--		);
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
	
	--Asynchronous RAM signals
--	signal mem_read : std_logic;
--	signal mem_write : std_logic;
	signal DataOut : std_logic_vector(31 downto 0);

begin
  
	InstrFetch : Instr_Fetch PORT MAP (clk, reset, signext_imm, jump_bool, branch_bool, instr);
	
	CtrlUnit : Decode PORT MAP( instr(31 downto 26), ALUOp, ALUSrc, branchLT, branchNE, branchEQ, RegWrite, RegDst, MemRead, MemWrite, MemToReg, shift, jump, halt);
	
	ALUControl : ALU_Control PORT MAP(ALUOp, instr(5 downto 0), ALUCtr);
	
	RegFile : Register_File PORT MAP(clk, reset, instr(25 downto 21), instr(20 downto 16), dst, RegWrite, WriteData, DataA, DataB);
	dst <= instr(20 downto 16) when RegDst = '0' else
		    instr(15 downto 11);
					 
	ALUMain : ALU PORT MAP(DataA, DataB, ALUCtr, ALUSrc, signext_imm, zero, ALU_Result);
	
	RAM : Data_Memory PORT MAP(clk, MemRead, MemWrite, DataB, ALU_Result, DataOut);
	WriteData <= DataOut when MemToReg = '1' else
					 ALU_Result;		
					 
	Sign_Extender : sign_ext PORT MAP (instr(15 downto 0), signext_imm);
	
	branch_bool <=Zero;
	jump_bool <= jump;
					 			 
	instruction <= instr;
	

end Structure;

