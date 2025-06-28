----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:17:43 11/06/2023 
-- Design Name: 
-- Module Name:    Cache_System - Behavioral 
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

entity Cache_System is
    Port ( clk : in  STD_LOGIC);
end Cache_System;

architecture Behavioral of Cache_System is

	-- CPU
	component CPU_gen
	Port ( 
		clk 		: in  STD_LOGIC;
      rst 		: in  STD_LOGIC;
      trig 		: in  STD_LOGIC;
		-- Interface to the Cache Controller.
      Address 	: out  STD_LOGIC_VECTOR (15 downto 0);
      wr_rd 	: out  STD_LOGIC;
      cs 		: out  STD_LOGIC;
      DOut 		: out  STD_LOGIC_VECTOR (7 downto 0)
		);
	end component;
	
	-- CPU input signals
	signal RST, TRIG : STD_LOGIC;
	
	-- CPU output signals
	signal CPU_Address : STD_LOGIC_VECTOR(15 DOWNTO 0);
	signal CPU_wr_rd : STD_LOGIC;
	signal ChipSel : STD_LOGIC;
	signal Dout : STD_LOGIC_VECTOR(7 DOWNTO 0);
	
	-- Cache
	component Cache
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
	end component;
		
	-- Cache output signals
	signal SDRAM_Address : STD_LOGIC_VECTOR(15 DOWNTO 0);
	signal SDRAM_wr_rd : STD_LOGIC;
	signal SDRAM_MSTRB : STD_LOGIC;
	signal SDRAM_DIN : STD_LOGIC_VECTOR(7 DOWNTO 0);
	
	-- SDRAM Controller
	component SDRAM_Controller
    Port ( 
			  -- Inputs
			  clk : in STD_LOGIC;
			  Address : in  STD_LOGIC_VECTOR (15 downto 0);
           WR_RD : in  STD_LOGIC;
           MEMSTRB : in  STD_LOGIC;
           Din : in  STD_LOGIC_VECTOR (7 downto 0);
			  
			  -- Output
           Dout : out  STD_LOGIC_VECTOR (7 downto 0) -- route to CPU Din; CPU_gen file has no Din???
			  );
	end component;
	
	-- SDRAM output signals
	signal SDRAM_DOUT : STD_LOGIC_VECTOR(7 DOWNTO 0);


begin

	-- CPU
	system_cpu : CPU_gen port map
	(
		clk => clk,
      rst => RST,
      trig => TRIG,
		-- Interface to the Cache Controller.
      Address => CPU_Address,
      wr_rd => CPU_wr_rd,
      cs => ChipSel,
      DOut => Dout
	);
	
	-- Cache
	system_cache : Cache port map
	(
			  -- Inputs
			  Din => CPU_Address,
           CPU_WR_RD => CPU_wr_rd,
			  CS => ChipSel,
			  CPU_Dout => Dout,
           SDRAM_Dout => SDRAM_DOUT,
			  Clk => clk,
			  
			  -- Outputs
			  Dout => SDRAM_Address,
           SDRAM_WR_RD => SDRAM_wr_rd,
           MSTRB => SDRAM_MSTRB,
           RDY => TRIG,
           -- CPU_Din => ;
           SDRAM_Din => SDRAM_DIN
	);
	
	-- SDRAM Controller
	system_sdramController : SDRAM_Controller port map
	(
			  clk => clk,
			  Address => SDRAM_Address,
           WR_RD => SDRAM_wr_rd,
           MEMSTRB => SDRAM_MSTRB,
           Din => SDRAM_DIN,
			  
			  -- Output
           Dout => SDRAM_DOUT
	);

end Behavioral;

