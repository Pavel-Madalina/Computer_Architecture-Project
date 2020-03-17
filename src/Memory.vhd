----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/14/2019 06:57:24 PM
-- Design Name: 
-- Module Name: Memory - Behavioral
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

entity Memory is
    Port ( ALURes : in STD_LOGIC_VECTOR (15 downto 0);
           rd2 : in STD_LOGIC_VECTOR (15 downto 0);
           clk : in STD_LOGIC;
           memWrite : in STD_LOGIC;
           slti : in STD_LOGIC;
           memData : out STD_LOGIC_VECTOR (15 downto 0);
           ALUResOut : out STD_LOGIC_VECTOR (15 downto 0));
end Memory;

architecture Behavioral of Memory is
type memorie is array(0 to 31) of STD_LOGIC_VECTOR(15 downto 0);
signal RAM : memorie :=("0000000000000001",
                        "0000000000000010",
                        "0000000000000011",
                        "0000000000000100",
                        "0000000000000101",
                        "0000000000000110",
                        "0000000000000111",
                        "0000000000001000",
                        "0000000000001001",
                        "0000000000001010",
                        others=> "0000000000000000");
begin
    memData<=RAM(conv_integer(ALURes));
    process(clk)
    begin
        if rising_edge(clk) then
            if(memWrite='1') then
                RAM(conv_integer(ALURes))<=rd2;
            end if;
            
        end if;
    end process; 
    ALUResOut<=ALURes when slti='0' else "000000000000000" & ALURes(15);
end Behavioral;
