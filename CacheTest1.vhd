--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   20:49:12 11/05/2023
-- Design Name:   
-- Module Name:   /home/student2/t11ngo/COE758/Project 1/Project1/CacheTest1.vhd
-- Project Name:  Project1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Cache
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY CacheTest1 IS
END CacheTest1;
 
ARCHITECTURE behavior OF CacheTest1 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Cache
    PORT(
         Din : IN  std_logic_vector(15 downto 0);
         CPU_WR_RD : IN  std_logic;
         CS : IN  std_logic;
         CPU_Dout : IN  std_logic_vector(7 downto 0);
         SDRAM_Dout : IN  std_logic_vector(7 downto 0);
         Clk : IN  std_logic;
         Dout : OUT  std_logic_vector(15 downto 0);
         SDRAM_WR_RD : OUT  std_logic;
         MSTRB : OUT  std_logic;
         RDY : OUT  std_logic;
         CPU_Din : OUT  std_logic_vector(7 downto 0);
         SDRAM_Din : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal Din : std_logic_vector(15 downto 0) := (others => '0');
   signal CPU_WR_RD : std_logic := '0';
   signal CS : std_logic := '0';
   signal CPU_Dout : std_logic_vector(7 downto 0) := (others => '0');
   signal SDRAM_Dout : std_logic_vector(7 downto 0) := (others => '0');
   signal Clk : std_logic := '0';

 	--Outputs
   signal Dout : std_logic_vector(15 downto 0);
   signal SDRAM_WR_RD : std_logic;
   signal MSTRB : std_logic;
   signal RDY : std_logic;
   signal CPU_Din : std_logic_vector(7 downto 0);
   signal SDRAM_Din : std_logic_vector(7 downto 0);
	
	-- Cache Controller
	component Cache_Controller
		port (
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
         WEN : out  STD_LOGIC_VECTOR (0 downto 0);
         Cache_Din_MUX : out  STD_LOGIC;
			Rdy : out STD_LOGIC
		);
	end component;
	
	-- Cache Controller Signals	
   signal Cache_Dout_MUX :  STD_LOGIC;
   signal Cache_Addr :  STD_LOGIC_VECTOR (7 downto 0);
   signal WEN :  STD_LOGIC_VECTOR (0 downto 0);
   signal Cache_Din_MUX :  STD_LOGIC;
	
	-- SRAM
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
	signal clka : STD_LOGIC := '0';
	signal wea : STD_LOGIC_VECTOR(0 DOWNTO 0) := (others => '0');
	signal addra : STD_LOGIC_VECTOR(7 DOWNTO 0) := (others => '0');
	signal dina : STD_LOGIC_VECTOR(7 DOWNTO 0) := (others => '0');
	
	signal douta : STD_LOGIC_VECTOR(7 DOWNTO 0);

   -- Clock period definitions
   constant Clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Cache PORT MAP (
          Din => Din,
          CPU_WR_RD => CPU_WR_RD,
          CS => CS,
          CPU_Dout => CPU_Dout,
          SDRAM_Dout => SDRAM_Dout,
          Clk => Clk,
          Dout => Dout,
          SDRAM_WR_RD => SDRAM_WR_RD,
          MSTRB => MSTRB,
          RDY => RDY,
          CPU_Din => CPU_Din,
          SDRAM_Din => SDRAM_Din
        );
		  
	-- Cache Controller
	cacheController : Cache_Controller port map(
			Din => Din,
			CPU_WR_RD => CPU_WR_RD,
			CS => CS,
			Dout => Dout,
			SDRAM_WR_RD => SDRAM_WR_RD,
			MSTRB => MSTRB,
			Rdy => RDY,
			clk => clk,
			Cache_Addr => Cache_Addr,
			WEN => WEN,
			Cache_Dout_MUX => Cache_Dout_MUX,
			Cache_Din_MUX => Cache_Din_MUX
	);
	
	-- SRAM
	-- Cache SRAM Component
	system_sram : sram
	PORT MAP (
		clka => clka,
		wea => wea,
		addra => addra,
		dina => dina,
		douta => douta
	);

   -- Clock process definitions
   Clk_process :process
   begin
		Clk <= '0';
		wait for Clk_period/2;
		Clk <= '1';
		wait for Clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin	
		-- State 0: Idle
		wait for Clk_period*2;
		CS <= '0';
		-- State 1: Write word to cache
      wait for Clk_period*2;	
		Din <= "1000000000000101";
		CPU_WR_RD <= '1';
		CS <= '1';
		CPU_Dout <= "10110110";
		SDRAM_Dout <= "11101110";
		Clk <= '1';
		clk <= '1';
		clka <= '1';
		wea <= "1";
		addra <= Din(15 downto 8);
		dina <= CPU_Dout;
		-- State 2: Read word from cache
      wait for Clk_period*2;
		Din <= "1100000000000101";
		CPU_WR_RD <= '0';
		CS <= '0';
		CPU_Dout <= "10110110";
		SDRAM_Dout <= "11101110";
		Clk <= '0';
		clk <= '0';
		wea <= "1";
		addra <= Din(15 downto 8);
		dina <= CPU_Dout;
		-- State 3: Read/Write from/to cache d = 1
      wait for Clk_period*2;
		Din <= "1110000000000101";
		CPU_WR_RD <= '1';
		CS <= '1';
		CPU_Dout <= "10110110";
		SDRAM_Dout <= "11101110";
		Clk <= '1';
		clk <= '1';
		wea <= "1";
		addra <= Din(15 downto 8);
		dina <= CPU_Dout;
		-- State 4: Read/Write from/to cache d = 0
      wait for Clk_period*2;
		Din <= "1111000000000101";
		CPU_WR_RD <= '0';
		CS <= '0';
		CPU_Dout <= "10110110";
		SDRAM_Dout <= "11101110";
		Clk <= '0';
		clk <= '0';
		wea <= "1";
		addra <= Din(15 downto 8);
		dina <= CPU_Dout;
      -- insert stimulus here 
      wait;
   end process;

END;
