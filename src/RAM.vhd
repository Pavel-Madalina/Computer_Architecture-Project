----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/13/2019 03:03:53 PM
-- Design Name: 
-- Module Name: RAM - Behavioral
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

entity RAM is
    Port ( clk : in STD_LOGIC;
           we : in STD_LOGIC;
           adr : in STD_LOGIC_VECTOR (3 downto 0);
           di : in STD_LOGIC_VECTOR (15 downto 0);
           do : out STD_LOGIC_VECTOR (15 downto 0));
end RAM;

architecture Behavioral of RAM is
type memorie is array(0 to 15) of STD_LOGIC_VECTOR(15 downto 0);
signal RAM : memorie :=("0000000000000001",
                         "0000000000000010",
                         "0000000000000011",
                         others=> "0000000000000000");
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if(we='1') then
                RAM(conv_integer(adr))<=di;
            end if;
            do<=RAM(conv_integer(adr));
        end if;
    end process;

end Behavioral;
