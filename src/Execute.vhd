----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/06/2019 02:39:00 PM
-- Design Name: 
-- Module Name: ALU - Behavioral
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

entity Execute is
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
end Execute;

architecture Behavioral of Execute is
signal op2 : STD_LOGIC_VECTOR(15 downto 0);
signal ALUCtrl : STD_LOGIC_VECTOR(2 downto 0);
signal result : STD_LOGIC_VECTOR(15 downto 0);
begin
    op2 <= rd2 when ALUSrc='0' else ext_imm;
    process(funct,ALUOp)
    begin
        case ALUOp is
            when "00" => case funct is 
                            when "000" => ALUCtrl <= "000";
                            when "001" => ALUCtrl <= "001";
                            when "010" => ALUCtrl <= "010";
                            when "011" => ALUCtrl <= "011";
                            when "100" => ALUCtrl <= "100";
                            when "101" => ALUCtrl <= "101";
                            when "110" => ALUCtrl <= "110";
                            when "111" => ALUCtrl <= "111";
                         end case;
            when "01" => ALUCtrl <= "000";
            when others => ALUCtrl <= "001";
       end case;
    end process;
    
    process(ALUCtrl,rd1,op2)
    begin 
        case ALUCtrl is
            when "000" => result <= rd1 + op2;
            when "001" => result <= rd1 - op2;
            when "010" => if sa='0' then 
                            result <= rd1(14 downto 0) & "0";
                          else 
                            result <= rd1(13 downto 0) & "00";
                          end if;
            when "011" => if sa='0' then 
                            result <= "0" & rd1(15 downto 1);
                          else 
                            result <= "00" & rd1(15 downto 2);
                          end if;
            when "100" => result <= rd1 and op2;
            when "101" => result <= rd1 or op2;
            when "110" => case(op2) is
                            when "0000000000000000" => result<=rd1;
                            when "0000000000000001" => result<=rd1(14 downto 0) & "0";
                            when "0000000000000010" => result<=rd1(13 downto 0) & "00";
                            when "0000000000000011" => result<=rd1(12 downto 0) & "000";
                            when "0000000000000100" => result<=rd1(11 downto 0) & "0000";
                            when "0000000000000101" => result<=rd1(10 downto 0) & "00000";
                            when "0000000000000110" => result<=rd1(9 downto 0) & "000000";
                            when "0000000000000111" => result<=rd1(8 downto 0) & "0000000";
                            when "0000000000001000" => result<=rd1(7 downto 0) & "00000000";
                            when "0000000000001001" => result<=rd1(6 downto 0) & "000000000";
                            when "0000000000001010" => result<=rd1(5 downto 0) & "0000000000";
                            when "0000000000001011" => result<=rd1(4 downto 0) & "00000000000";
                            when "0000000000001100" => result<=rd1(3 downto 0) & "000000000000";
                            when "0000000000001101" => result<=rd1(2 downto 0) & "0000000000000";
                            when "0000000000001110" => result<=rd1(1 downto 0) & "00000000000000";
                            when others=>result<="0000000000000000";
                          end case;
            when "111" => result <= rd1 xor op2;
       end case;
    end process;
    ALURes <= result;
    zero <= '1' when result="0000000000000000" else '0';
    
end Behavioral;
