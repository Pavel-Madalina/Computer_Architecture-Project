----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/13/2019 02:35:04 PM
-- Design Name: 
-- Module Name: REG_FILE - Behavioral
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

entity REG_FILE is
    Port ( ra1 : in STD_LOGIC_VECTOR (2 downto 0);
           ra2 : in STD_LOGIC_VECTOR (2 downto 0);
           wa : in STD_LOGIC_VECTOR (2 downto 0);
           wd : in STD_LOGIC_VECTOR (15 downto 0);
           clk : in STD_LOGIC;
           rd1 : out STD_LOGIC_VECTOR (15 downto 0);
           rd2 : out STD_LOGIC_VECTOR (15 downto 0);
           reg_wr : in STD_LOGIC);
end REG_FILE;

architecture Behavioral of REG_FILE is
type memorie is array(0 to 7) of STD_LOGIC_VECTOR(15 downto 0);
signal RegFile : memorie :=("0000000000000000",
                            "0000000000000001",
                            "0000000000000010",
                            "0000000000000011",
                            "0000000000000100",
                            "0000000000000101",
                            "0000000000000110",
                            "0000000000000111");
begin
    rd1<=RegFile(conv_integer(ra1));
    rd2<=RegFile(conv_integer(ra2));
    process(clk)
    begin
        if falling_edge(clk) then
            if(reg_wr='1') then
                RegFile(conv_integer(wa))<=wd;
            end if;
        end if;
    end process;
end Behavioral;
