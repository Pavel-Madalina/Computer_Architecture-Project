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

entity ALU is
    Port ( mpg_enable : in STD_LOGIC;
           clk : in STD_LOGIC;
           sw : in STD_LOGIC_VECTOR (7 downto 0);
           digits : out STD_LOGIC_VECTOR (15 downto 0);
           led7 : out STD_LOGIC);
end ALU;

architecture Behavioral of ALU is
signal tmp: STD_LOGIC_VECTOR(1 downto 0):="00";
signal sw30: STD_LOGIC_VECTOR(15 downto 0):=(others => '0');
signal sw74: STD_LOGIC_VECTOR(15 downto 0):=(others => '0');
signal sw70: STD_LOGIC_VECTOR(15 downto 0):=(others => '0');
signal s_digits: STD_LOGIC_VECTOR(15 downto 0):=(others => '0');
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if mpg_enable='1' then
                tmp <= tmp + 1;
            end if;
        end if;
    end process;
    
    sw30<="000000000000" & sw(3 downto 0);
    sw74<="000000000000" & sw(7 downto 4);
    sw70<="00000000" & sw(7 downto 0);
    
    process(tmp)
    begin
        case tmp is
            when "00" => s_digits <= sw30 + sw74;
            when "01" => s_digits <= sw30 - sw74;
            when "10" => s_digits <= sw70(13 downto 0) & "00";
            when others => s_digits <= "00" & sw70(15 downto 2);
        end case;
    end process;
       
    digits <= s_digits;   
    led7 <= '1' when s_digits="0000000000000000" else '0';
end Behavioral;
