----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/03/2019 02:15:06 PM
-- Design Name: 
-- Module Name: InstructionDecode - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity InstructionDecode is
    Port ( instr : in STD_LOGIC_VECTOR (15 downto 0);
           regWrite : in STD_LOGIC;
           --regDst : in STD_LOGIC;
           extOp : in STD_LOGIC;
           wd : in STD_LOGIC_VECTOR (15 downto 0);
           clk : in STD_LOGIC;
           wa : in STD_LOGIC_VECTOR(2 downto 0); -----
           rd1 : out STD_LOGIC_VECTOR (15 downto 0);
           rd2 : out STD_LOGIC_VECTOR (15 downto 0);
           ext_imm : out STD_LOGIC_VECTOR (15 downto 0);
           funct : out STD_LOGIC_VECTOR (2 downto 0);
           sa : out STD_LOGIC);
end InstructionDecode;

architecture Behavioral of InstructionDecode is
component REG_FILE is
    Port ( ra1 : in STD_LOGIC_VECTOR (2 downto 0);
           ra2 : in STD_LOGIC_VECTOR (2 downto 0);
           wa : in STD_LOGIC_VECTOR (2 downto 0);
           wd : in STD_LOGIC_VECTOR (15 downto 0);
           clk : in STD_LOGIC;
           rd1 : out STD_LOGIC_VECTOR (15 downto 0);
           rd2 : out STD_LOGIC_VECTOR (15 downto 0);
           reg_wr : in STD_LOGIC);
end component;

begin
    RF : REG_FILE port map(ra1=>instr(12 downto 10),ra2=>instr(9 downto 7),wa=>wa,wd =>wd,clk=>clk,rd1=>rd1,rd2=>rd2,reg_wr=>regWrite);
    process(extOp)
    begin
        if extOp='0' then
            ext_imm<="000000000" & instr(6 downto 0);
        else 
            if instr(6)='1' then
                ext_imm<="111111111" & instr(6 downto 0);
            else ext_imm<="000000000" & instr(6 downto 0);
            end if;
        end if;
     end process;
     funct<=instr(2 downto 0);
     sa<=instr(3);
end Behavioral;
