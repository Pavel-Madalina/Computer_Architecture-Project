----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/27/2019 02:18:59 PM
-- Design Name: 
-- Module Name: InstructionFetch - Behavioral
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

entity InstructionFetch is
    Port ( jAdr : in STD_LOGIC_VECTOR (15 downto 0);
           brAdr : in STD_LOGIC_VECTOR (15 downto 0);
           jSel : in STD_LOGIC;
           bSel : in STD_LOGIC;
           clk : in STD_LOGIC;
           en : in STD_LOGIC;
           rst : in STD_LOGIC;
           pcu : out STD_LOGIC_VECTOR (15 downto 0);
           instr : out STD_LOGIC_VECTOR (15 downto 0));
end InstructionFetch;

architecture Behavioral of InstructionFetch is
type memorie is array(0 to 31) of STD_LOGIC_VECTOR(15 downto 0);
signal ROM : memorie :=(B"000_000_000_010_0_000", --add $2,$0,$0
                         B"000_000_000_001_0_000", --add $1,$0,$0
                         B"001_000_011_0001010", --addi $3,$0,10
                         B"001_000_100_0000001", --addi $4,$0,1
                         B"000_000_000_000_0_000", --add $0,$0,$0
                         B"100_001_011_0001110", --beq $1,$3,14
                         B"000_000_000_000_0_000", --add $0,$0,$0
                         B"000_000_000_000_0_000", --add $0,$0,$0
                         B"010_001_101_0000000", --lw $5,0($1)
                         B"000_000_000_000_0_000", --add $0,$0,$0
                         B"000_000_000_000_0_000", --add $0,$0,$0
                         B"000_101_100_110_0_100", --and $6,$5,$4
                         B"000_000_000_000_0_000", --add $0,$0,$0
                         B"000_000_000_000_0_000", --add $0,$0,$0
                         B"100_110_100_0000011", --beq $6,$4,3
                         B"000_000_000_000_0_000", --add $0,$0,$0
                         B"000_000_000_000_0_000", --add $0,$0,$0
                         B"000_010_101_010_0_000", --add $2,$2,$5
                         B"001_001_001_0000001", --addi $1,$1,1
                         B"111_0000000000101", --j 5
                         B"000_000_000_000_0_000", --add $0,$0,$0
                         B"011_000_010_0001010", --sw $2,10($0)
                         others=> "0000000000000000");
signal D : STD_LOGIC_VECTOR(15 downto 0);
signal PC : STD_LOGIC_VECTOR(15 downto 0);
signal sum_PC : STD_LOGIC_VECTOR(15 downto 0);
signal muxB : STD_LOGIC_VECTOR(15 downto 0);
signal muxJ : STD_LOGIC_VECTOR(15 downto 0);

begin
    process(clk)
    begin
        if rst='1' then
            PC<=(others=>'0');
        else
            if rising_edge(clk) then
                if en='1' then
                    PC<=muxJ;
                end if;
            end if;
        end if;
    end process;
     
    instr<=ROM(conv_integer(PC(5 downto 0)));
    sum_PC<= PC + 1;
    pcu<=sum_PC;
    muxB<= brAdr when bSel='1' else sum_PC;
    muxJ<= jAdr when jSel='1' else muxB;

end Behavioral;
