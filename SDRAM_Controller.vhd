----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:51:29 11/02/2023 
-- Design Name: 
-- Module Name:    SDRAM_Controller - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SDRAM_Controller is
    Port ( 
			  -- Inputs
			  clk : in STD_LOGIC;
			  Address : in  STD_LOGIC_VECTOR (15 downto 0);
           WR_RD : in  STD_LOGIC;
           MEMSTRB : in  STD_LOGIC;
           Din : in  STD_LOGIC_VECTOR (7 downto 0);
			  
			  -- Output
           Dout : out  STD_LOGIC_VECTOR (7 downto 0));
end SDRAM_Controller;

architecture Behavioral of SDRAM_Controller is

	-- Define RAM Memory Array; 8 blocks 32 words 1 byte each
	type RAM is array (7 downto 0, 31 downto 0) of STD_LOGIC_VECTOR(7 downto 0);
	
	signal tempRAM : RAM;
	signal tagAndIndex : STD_LOGIC_VECTOR(10 DOWNTO 0) := Address(15 downto 5);
	
	-- word counter
	signal counter : INTEGER := 0;

begin

	process(WR_RD, MEMSTRB)
	begin
		if(clk'event and clk ='1') then
			if(counter = 0) then
				for i in 0 to 7 loop -- iterate 8 blocks
					for j in 0 to 31 loop -- iterate 32 words
						tempRAM(i, j) <= "11110000";
					end loop;
				end loop;
				counter <= 1;
			end if;
			if(MEMSTRB = '1') then
				if(WR_RD = '1') then -- Write word to main memory (SDRAM)
					tempRAM(to_integer(unsigned(Address(7 downto 5))), to_integer(unsigned(Address(4 downto 0)))) <= Din;
				else -- Send block to CPU
					Dout <= tempRAM(to_integer(unsigned(Address(7 downto 5))), to_integer(unsigned(Address(4 downto 0))));
				end if;
			end if;
		end if;
	end process;



end Behavioral;

