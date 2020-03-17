----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/27/2019 02:28:53 PM
-- Design Name: 
-- Module Name: test_env - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity test_env is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end test_env;

architecture Behavioral of test_env is
component MPG is
    Port ( btn : in STD_LOGIC;
           clk : in STD_LOGIC;
           enable : out STD_LOGIC);
end component MPG;
component SSD is
    Port ( digit_0 : in STD_LOGIC_VECTOR (3 downto 0);
           digit_1 : in STD_LOGIC_VECTOR (3 downto 0);
           digit_2 : in STD_LOGIC_VECTOR (3 downto 0);
           digit_3 : in STD_LOGIC_VECTOR (3 downto 0);
           clk : in STD_LOGIC;
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end component SSD;
component InstructionFetch is
    Port ( jAdr : in STD_LOGIC_VECTOR (15 downto 0);
           brAdr : in STD_LOGIC_VECTOR (15 downto 0);
           jSel : in STD_LOGIC;
           bSel : in STD_LOGIC;
           clk : in STD_LOGIC;
           en : in STD_LOGIC;
           rst : in STD_LOGIC;
           pcu : out STD_LOGIC_VECTOR (15 downto 0);
           instr : out STD_LOGIC_VECTOR (15 downto 0));
end component;
component InstructionDecode is
    Port ( instr : in STD_LOGIC_VECTOR (15 downto 0);
           regWrite : in STD_LOGIC;
           extOp : in STD_LOGIC;
           wd : in STD_LOGIC_VECTOR (15 downto 0);
           clk : in STD_LOGIC;
           wa : in STD_LOGIC_VECTOR(2 downto 0); 
           rd1 : out STD_LOGIC_VECTOR (15 downto 0);
           rd2 : out STD_LOGIC_VECTOR (15 downto 0);
           ext_imm : out STD_LOGIC_VECTOR (15 downto 0);
           funct : out STD_LOGIC_VECTOR (2 downto 0);
           sa : out STD_LOGIC);
end component;
component MainControl is
    Port ( opcode : in STD_LOGIC_VECTOR (2 downto 0);
           regDst : out STD_LOGIC;
           jump : out STD_LOGIC;
           branch : out STD_LOGIC;
           branch1 : out STD_LOGIC;
           memToReg : out STD_LOGIC;
           ALUOp : out STD_LOGIC_VECTOR(1 downto 0);
           memWrite : out STD_LOGIC;
           ALUSrc : out STD_LOGIC;
           regWrite : out STD_LOGIC;
           slti : out STD_LOGIC;
           extOp : out STD_LOGIC);          
end component;
component Execute is
    Port ( rd1 : in STD_LOGIC_VECTOR(15 downto 0);
           ALUSrc : in STD_LOGIC;
           rd2 : in STD_LOGIC_VECTOR (15 downto 0);
           ext_imm : in STD_LOGIC_VECTOR (15 downto 0);
           sa : in STD_LOGIC;
           funct : in STD_LOGIC_VECTOR(2 downto 0);
           ALUOp : in STD_LOGIC_VECTOR(1 downto 0);
           --branch1 : in STD_LOGIC;
           --branch : in STD_LOGIC;
           --pcu : in STD_LOGIC_VECTOR(15 downto 0);
           --branch_sel : out STD_LOGIC;
           zero : out STD_LOGIC;
           ALURes : out STD_LOGIC_VECTOR(15 downto 0));
           --branchAddr : out STD_LOGIC_VECTOR(15 downto 0));
end component;
component Memory is
    Port ( ALURes : in STD_LOGIC_VECTOR (15 downto 0);
           rd2 : in STD_LOGIC_VECTOR (15 downto 0);
           clk : in STD_LOGIC;
           memWrite : in STD_LOGIC;
           slti : in STD_LOGIC;
           memData : out STD_LOGIC_VECTOR (15 downto 0);
           ALUResOut : out STD_LOGIC_VECTOR (15 downto 0));
end component;

signal en : STD_LOGIC:='0';
signal reset : STD_LOGIC:='0';
signal PCU : STD_LOGIC_VECTOR(15 downto 0);
signal INSTR : STD_LOGIC_VECTOR(15 downto 0);
signal D : STD_LOGIC_VECTOR(15 downto 0);
signal jump : STD_LOGIC;
signal branch : STD_LOGIC;
signal regW : STD_LOGIC;
signal rd1 : STD_LOGIC_VECTOR(15 downto 0);
signal rd2 : STD_LOGIC_VECTOR(15 downto 0);
signal rw : STD_LOGIC;
signal EXT_IMM : STD_LOGIC_VECTOR(15 downto 0);
signal FUNCT : STD_LOGIC_VECTOR(2 downto 0);
signal SA : STD_LOGIC;
signal regDst,branch1,memToReg,memWrite,ALUSrc,slti,extOp : STD_LOGIC;
signal ALUOp : STD_LOGIC_VECTOR(1 downto 0);
signal ALUResult : STD_LOGIC_VECTOR(15 downto 0);
signal memData,ALUResOut : STD_LOGIC_VECTOR(15 downto 0);
signal memWriteEn : STD_LOGIC;
signal writeBack : STD_LOGIC_VECTOR(15 downto 0);
signal branch_sel,ZERO : STD_LOGIC;
signal branchAddr, jumpAddr : STD_LOGIC_VECTOR(15 downto 0);
signal muxDst : STD_LOGIC_VECTOR(2 downto 0);

signal if_id : STD_LOGIC_VECTOR(31 downto 0);
signal id_ex : STD_LOGIC_VECTOR(79 downto 0);
signal ex_mem : STD_LOGIC_VECTOR(38 downto 0);
signal mem_wb : STD_LOGIC_VECTOR(36 downto 0);
begin
    c1 : MPG port map (btn => btn(0),clk => clk,enable => en);
    c2 : MPG port map (btn => btn(1),clk => clk,enable => reset);                                                   
    c_if : InstructionFetch port map(jAdr =>jumpAddr, brAdr => branchAddr, jSel => jump, bSel => branch_sel, clk => clk, en => en, rst => reset, pcu => PCU, instr => INSTR);
                 
    process(clk,en)
    begin
        if rising_edge(clk) then
            if en='1' then 
                if_id(31 downto 16)<=PCU;
                if_id(15 downto 0)<=INSTR;
            end if;
        end if;
    end process;
    
    jumpAddr <= if_id(31 downto 29) & if_id(12 downto 0); 
    --rw <= en and mem_wb(35);                                                                             
    c_id : InstructionDecode port map(instr =>if_id(15 downto 0),regWrite => mem_wb(35),extOp =>extOp ,wd=>writeBack,clk =>clk,wa => mem_wb(2 downto 0), rd1=>rd1, rd2=>rd2, ext_imm => EXT_IMM, funct => FUNCT,sa => SA);
    muxDst<= if_id(9 downto 7) when regDst='0' else if_id(6 downto 4);
    c_mc : MainControl port map(opcode =>if_id(15 downto 13),regDst =>regDst,jump => jump,branch => branch,branch1 => branch1,memToReg=>memToReg,ALUOp =>ALUOp,memWrite =>memWrite ,ALUSrc => ALUSrc,regWrite=>regW,slti =>slti,extOp=>extOp);
    
    process(clk,en)
    begin
        if rising_edge(clk) then
            if en='1' then 
                id_ex(79)<=branch1;
                id_ex(78)<=branch;
                id_ex(77)<=memToReg;
                id_ex(76 downto 75)<=ALUOp;
                id_ex(74)<=memWrite;
                id_ex(73)<=ALUSrc;
                id_ex(72)<=regW;
                id_ex(71)<=slti;
                id_ex(70 downto 55)<=if_id(31 downto 16);
                id_ex(54 downto 39)<=rd1;
                id_ex(38 downto 23)<=rd2;
                id_ex(22 downto 7)<=EXT_IMM;
                id_ex(6 downto 4)<=FUNCT;
                id_ex(3)<=SA;
                id_ex(2 downto 0)<=muxDst;
            end if;
        end if;
    end process;
    
    c_ex : Execute port map(rd1 => id_ex(54 downto 39),ALUSrc => id_ex(73), rd2 => id_ex(38 downto 23), ext_imm => id_ex(22 downto 7), sa => id_ex(3), funct=> id_ex(6 downto 4), ALUOp => id_ex(76 downto 75),ALURes=>ALUResult,zero => ZERO);
    branch_sel<= (id_ex(78) and ZERO) or (id_ex(79) and (not ZERO));
    branchAddr <= id_ex(70 downto 55) + id_ex(22 downto 7);
    
    process(clk,en)
    begin
        if rising_edge(clk) then
            if en='1' then 
                ex_mem(38)<=id_ex(77);
                ex_mem(37)<=id_ex(74);
                ex_mem(36)<=id_ex(72);
                ex_mem(35 downto 20)<=ALUResult;
                ex_mem(19 downto 4)<=id_ex(38 downto 23);
                ex_mem(3)<=id_ex(71);
                ex_mem(2 downto 0)<=id_ex(2 downto 0);
            end if;
        end if;
    end process;
    
    memWriteEn<=en and ex_mem(37);
    c_mem : Memory port map(ALURes => ex_mem(35 downto 20),rd2 => ex_mem(19 downto 4),clk=> clk,memWrite =>memWriteEn,slti => ex_mem(3),memData=>memData,ALUResOut=>ALUResOut); 
    
    process(clk,en)
    begin
        if rising_edge(clk) then
            if en='1' then 
                mem_wb(36)<=ex_mem(38);
                mem_wb(35)<=ex_mem(36);
                mem_wb(34 downto 19)<=memData;
                mem_wb(18 downto 3)<=ALUResOut;
                mem_wb(2 downto 0)<=ex_mem(2 downto 0);
            end if;
        end if;
    end process;
    
    writeBack<=mem_wb(34 downto 19) when mem_wb(36)='1' else mem_wb(18 downto 3);
    process(sw(7 downto 5),INSTR,PCU,rd1,rd2,EXT_IMM,ALUResult,memData,writeBack)
    begin
        case sw(7 downto 5) is
            when "000" => D<=INSTR;
            when "001" => D<=PCU;
            when "010" => D<=rd1;
            when "011" => D<=rd2;
            when "100" => D<=EXT_IMM;
            when "101" => D<=ALUResult;
            when "110" => D<=memData;
            when "111" => D<=writeBack;
        end case;
    end process;
    c_afisor : SSD port map (digit_0=> D(3 downto 0),digit_1 => D(7 downto 4),digit_2=> D(11 downto 8),digit_3=> D(15 downto 12),clk=> clk,an=> an,cat=>cat);
    led(0)<=slti;
    led(1)<=regW;
    led(2)<=ALUSrc;
    led(3)<=memWrite;
    led(5 downto 4)<=ALUOp;
    led(6)<=memToReg;
    led(7)<=branch;
    led(8)<=branch1;
    led(9)<=jump;
    led(10)<=regDst;
    led(14 downto 11)<="0000";
end Behavioral;
