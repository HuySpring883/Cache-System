----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:06:48 11/02/2023 
-- Design Name: 
-- Module Name:    Cache - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Cache is
    Port ( 
			  -- Inputs
			  Din : in  STD_LOGIC_VECTOR (15 downto 0);
           CPU_WR_RD : in  STD_LOGIC;
			  CS : in  STD_LOGIC;
			  CPU_Dout : in  STD_LOGIC_VECTOR (7 downto 0);
           SDRAM_Dout : in  STD_LOGIC_VECTOR (7 downto 0);
			  Clk : in STD_LOGIC;
			  
			  -- Outputs
			  Dout : out  STD_LOGIC_VECTOR (15 downto 0);
           SDRAM_WR_RD : out  STD_LOGIC;
           MSTRB : out  STD_LOGIC;
           RDY : out  STD_LOGIC;
           CPU_Din : out  STD_LOGIC_VECTOR (7 downto 0);
           SDRAM_Din : out  STD_LOGIC_VECTOR (7 downto 0)
			  );
end Cache;

architecture Behavioral of Cache is

	-- Cache Controller Component
	component Cache_Controller
		port (
			Din : in  STD_LOGIC_VECTOR (15 downto 0);
         CPU_WR_RD : in  STD_LOGIC;
         CS : in  STD_LOGIC;
         Dout : out  STD_LOGIC_VECTOR (15 downto 0);
         SDRAM_WR_RD : out  STD_LOGIC;
         MSTRB : out  STD_LOGIC;
         Cache_Dout_MUX : out  STD_LOGIC;
         Cache_Addr : out  STD_LOGIC_VECTOR (7 downto 0);
         WEN : out  STD_LOGIC_VECTOR (0 downto 0);
         Cache_Din_MUX : out  STD_LOGIC;
			clk : in STD_LOGIC;
			Rdy : out STD_LOGIC
		);
	end component;
	
	-- Cache Controller Signals
	signal SRAM_Din_MUX, SRAM_Dout_MUX : STD_LOGIC;
	
	-- SRAM Component
	COMPONENT sram
	PORT (
		clka : IN STD_LOGIC;
		wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
		addra : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		dina : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
	END COMPONENT;
	
	-- SRAM Signals
	signal SRAM_Addr : STD_LOGIC_VECTOR(7 DOWNTO 0);
	signal SRAM_Din, SRAM_Dout : STD_LOGIC_VECTOR(7 DOWNTO 0);
	signal SRAM_Wen : STD_LOGIC_VECTOR(0 DOWNTO 0);

begin

	-- Cache Controller Component
	cacheController : Cache_Controller port map(
			Din => Din,
			CPU_WR_RD => CPU_WR_RD,
			CS => CS,
			Dout => Dout,
			SDRAM_WR_RD => SDRAM_WR_RD,
			MSTRB => MSTRB,
			Rdy => RDY,
			clk => Clk,
			Cache_Addr => SRAM_Addr,
			WEN => SRAM_Wen,
			Cache_Dout_MUX => SRAM_Dout_MUX,
			Cache_Din_MUX => SRAM_Din_MUX
	);
		
	-- Cache SRAM Component
	system_sram : sram
	PORT MAP (
		clka => clk,
		wea => SRAM_Wen,
		addra => SRAM_Addr,
		dina => SRAM_Din,
		douta => SRAM_Dout
	);
	
	-- 2to1 (SRAM Din) and 1to2 (SRAM Dout) MUX Behaviour
	process(clk, SRAM_Dout_MUX, SRAM_Din_MUX)
	begin
		if(clk'event and clk = '1') then
			-- Cache Dout Multiplexor
			if(SRAM_Dout_MUX = '1') then
				CPU_Din <= SRAM_Dout;
			else
				SDRAM_Din <= SRAM_Dout;
			end if;
			-- Cache Din Multiplexor
			if(SRAM_Din_MUX = '1') then
				SRAM_Din <= SDRAM_Dout;
			else
				SRAM_Din <= CPU_Dout;
			end if;
		end if;
	end process;

end Behavioral;

