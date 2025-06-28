----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:18:01 11/02/2023 
-- Design Name: 
-- Module Name:    Cache_Controller - Behavioral 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Cache_Controller is
    Port ( 
			  -- Inputs
			  Din : in  STD_LOGIC_VECTOR (15 downto 0);
           CPU_WR_RD : in  STD_LOGIC;
           CS : in  STD_LOGIC;
			  clk : in STD_LOGIC;
			  
			  -- Outputs
           Dout : out  STD_LOGIC_VECTOR (15 downto 0);
           SDRAM_WR_RD : out  STD_LOGIC;
           MSTRB : out  STD_LOGIC;
           Cache_Dout_MUX : out  STD_LOGIC;
           Cache_Addr : out  STD_LOGIC_VECTOR (7 downto 0);
           WEN : out  STD_LOGIC_VECTOR(0 DOWNTO 0);
           Cache_Din_MUX : out  STD_LOGIC;
			  Rdy : out STD_LOGIC);
end Cache_Controller;

architecture Behavioral of Cache_Controller is

	-- States;
	-- s0 - idle
	-- s1 - Write word to cache; hit
	-- s2 - Read word to cache; hit
	-- s3 - Read/Write from/to cache; miss; dBit = 0
	-- s4 - Read/Write from/to cache; miss; dBit = 1
	
	-- State Type Declaration
	type state is (s0, s1, s2, s3, s4);
	
	-- State Signals
	signal currentState : state;
	
	-- Identifier Signals
	signal tag : STD_LOGIC_VECTOR(7 downto 0) := Din(15 downto 8);
	signal index : STD_LOGIC_VECTOR(2 downto 0) := Din(7 downto 5);
	signal validBit : STD_LOGIC;
	signal dirtyBit : STD_LOGIC;
	signal offset : STD_LOGIC_VECTOR(4 downto 0) := Din(4 downto 0);
	signal indexAndOffset : STD_LOGIC_VECTOR(7 downto 0) := Din(7 downto 0);
	
	-- Hit/Miss Signal
	signal tempVal : STD_LOGIC;
	
	-- Memory Definition
	type mem is array (7 downto 0) of STD_LOGIC_VECTOR(7 downto 0);
	signal memTag : mem := ((others => (others => '0')));

begin

	-- Hit or Miss Decoder
	process(clk)
	begin
		if(clk'event and clk = '1') then
			if(memTag(to_integer(unsigned(index))) = tag) then
				tempVal <= '1'; -- Match
			else
				tempVal <= '0'; -- No Match
			end if;
		end if;
	end process;
	
	-- State Signals Generator
	process(currentState)
	begin
		case currentState is
			when s0 =>
				Rdy <= '1';
			when s1 =>
				dirtyBit <= '1';
				validBit <= '1';
				Rdy <= '1';
				WEN <= "1";
				Cache_Addr <= indexAndOffset;
				Cache_Din_MUX <= '1';
			when s2 =>
				Rdy <= '1';
				Cache_Dout_MUX <= '1';
				WEN <= "1";
				Cache_Addr <= indexAndOffset;
			when s3 =>
				validBit <= '1';
				WEN <= "1";
				Dout <=  (Din and "1111111111100000");
				SDRAM_WR_RD <= '0';
				Cache_Din_MUX <= '1';
			when s4 =>
				Dout <= (Din and "1111111111100000");
				SDRAM_WR_RD <= '1';
				Cache_Dout_MUX <= '0';
		end case;
	end process;
			
	-- State Decoder
	process(clk)
	begin
		if(clk'event and clk = '1') then
			if(tempVal = '1' and CPU_WR_RD = '1') then
				currentState <= s1;
			elsif(tempVal = '1' and CPU_WR_RD = '0') then
				currentState <= s2;
			elsif(tempVal = '0' and dirtyBit = '0') then
				currentState <= s3;
			elsif(tempVal = '0' and dirtyBit = '1') then
				currentState <= s4;
			end if;
			case currentState is
				when s0 => -- s0. Idle
					if(CS = '1') then
						Rdy <= '1';
					else
						currentState <= s0;
					end if;
				when s1 => -- s1. Write a word to cache, hit
						currentState <= s0;

				when s2 => -- s2. Read a word frome cache, hit
						currentState <= s0;

				when s3 => -- s3. Read/Write from/to cache, miss, and dirty bit = 0
					if(CPU_WR_RD = '0') then
						currentState <= s2;
					elsif(CPU_WR_RD = '1') then
						currentState <= s1;
					end if;
				when s4 => -- s4. Read/Write from/to cache, miss, and dirty bit = 1
						currentState <= s3;
			end case;
		end if;
	end process;

end Behavioral;

