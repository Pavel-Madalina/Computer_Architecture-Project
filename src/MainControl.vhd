----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/03/2019 02:40:08 PM
-- Design Name: 
-- Module Name: MainControl - Behavioral
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

entity MainControl is
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
end MainControl;

architecture Behavioral of MainControl is
begin
    process(opcode)
    begin
    regDst<='0';
    jump <='0';
    branch <='0';
    branch1 <='0';
    memToReg <='0';
    ALUOp <="00";
    memWrite <='0';
    ALUSrc <='0';
    regWrite <='0';
    slti <='0';
    extOp <='0';              
    case opcode is
        when "000" => regDst<='1'; --R
                      regWrite <='1';
        when "001" => ALUSrc <='1'; --addi
                      regWrite <='1';
                      extOp <='1'; 
                      ALUOp <="01";
        when "010" => memToReg <='1'; --lw
                      ALUSrc <='1';
                      regWrite <='1'; 
                      extOp <='1'; 
                      ALUOp <="01";
        when "011" => memWrite <='1'; --sw
                      ALUSrc <='1';
                      extOp <='1'; 
                      ALUOp <="01";
        when "100" => branch <='1'; --beq 
                      ALUSrc <='0';
                      extOp <='1'; 
                      ALUOp <="10";
        when "101" => branch1 <='1'; --bne
                      ALUSrc <='1';
                      extOp <='1'; 
                      ALUOp <="10";
        when "110" => ALUSrc <='1'; --slti
                      slti <='1';
                      regWrite <='1';
                      extOp <='1'; 
                      ALUOp <="10";
        when "111" => jump <='1'; --j
    end case;
    end process;
end Behavioral;
