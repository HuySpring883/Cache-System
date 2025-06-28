--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:48:31 11/06/2023
-- Design Name:   
-- Module Name:   /home/student2/t11ngo/COE758/Project 1/Project1/Cache_System_Test1.vhd
-- Project Name:  Project1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Cache_System
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
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY Cache_System_Test1 IS
END Cache_System_Test1;
 
ARCHITECTURE behavior OF Cache_System_Test1 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Cache_System
    PORT(
         clk : IN  std_logic
        );
    END COMPONENT;
	 
	 -- Cache
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
	
	-- CPU inputs
	--signal clk 	: STD_LOGIC := '0';
   signal rst 	: STD_LOGIC := '0';
   signal trig : STD_LOGIC := '0';
	
	-- CPU ouputs
   signal Address : STD_LOGIC_VECTOR (15 downto 0);
   signal wr_rd 	: STD_LOGIC;
   --signal cs 		: STD_LOGIC;
   --signal DOut 	: STD_LOGIC_VECTOR (7 downto 0);
   
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
	
	-- SDRAM inputs
--	signal clk : STD_LOGIC := '0';
--	signal Address :  STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
--   signal WR_RD : STD_LOGIC := '0';
--   signal MEMSTRB : STD_LOGIC := '0';
--   signal Din : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
	
	-- SDRAM outputs
--	signal Dout : STD_LOGIC_VECTOR(7 downto 0);
	

   --Inputs
--   signal clk : std_logic := '0';

   -- Clock period definitions
   constant clk_period : time := 10 ns;
	
	-- Signals
	signal cpu_cache_addr : std_logic_vector(15 downto 0) := (others => '0');
	signal cpu_cache_wr_rd : std_logic := '0';
	signal cpu_cache_cs : std_logic := '0';
	signal cpu_cache_dout : std_logic_vector(7 downto 0) := (others => '0');
	
	signal cache_cpu_rdy : std_logic;
	signal cache_sdram_addr std_logic_vector(15 downto 0) := (others => '0');
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Cache_System PORT MAP (
          clk => clk
        );
		  
	-- cache
   system_cache: Cache PORT MAP (
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
		  
	-- cpu
	system_cpu : CPU_gen port map
	(
		clk => clk,
      rst => rst,
      trig => trig,
		-- Interface to the Cache Controller.
      Address => Din,
      wr_rd => CPU_WR_RD,
      cs => CS,
      DOut => CPU_DOut
	);
	
	-- SDRAM
	system_sdramController : SDRAM_Controller port map
	(
			  clk => clk,
			  Address => Dout,
           WR_RD => SDRAM_WR_RD,
           MEMSTRB => MSTRB,
           Din => SDRAM_Din,
			  
			  -- Output
           Dout => SDRAM_Dout
	);

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 10 ns;
		-- State 0: Idle
		wait for Clk_period*4;
		CS <= '0';
		-- State 1: Write word to cache
      wait for Clk_period*4;
		CS <= '1';
		CPU_WR_RD <= '1';
		Clk <= '1';
		clk <= '1';
		SDRAM_wr_rd <= '0';
		MSTRB <= '0';
		RDY <= '1';
		Din <= "1000000000000101";
		--CPU_Dout <= "10110110";
		--SDRAM_Dout <= "11101110";
--		clka <= '1';
--		wea <= "1";
--		addra <= Din(15 downto 8);
--		dina <= CPU_Dout;
		-- State 2: Read word from cache
      wait for Clk_period*4;
		CS <= '0';
		CPU_WR_RD <= '0';
		Clk <= '0';
		clk <= '0';
		SDRAM_wr_rd <= '0';
		MSTRB <= '0';
		RDY <= '1';
		Din <= "1100000000000101";
		--CPU_Dout <= "10110110";
		--SDRAM_Dout <= "11101110";
--		wea <= "1";
--		addra <= Din(15 downto 8);
--		dina <= CPU_Dout;
		-- State 3: Read/Write from/to cache d = 1
      wait for Clk_period*4;
		CS <= '1';
		CPU_WR_RD <= '1';
		Clk <= '1';
		clk <= '1';
		SDRAM_wr_rd <= '1';
		MSTRB <= '1';
		RDY <= '1';
		Din <= "1110000000000101";
		--CPU_Dout <= "10110110";
		--SDRAM_Dout <= "11101110";
--		wea <= "1";
--		addra <= Din(15 downto 8);
--		dina <= CPU_Dout;
		-- State 4: Read/Write from/to cache d = 0
      wait for Clk_period*4;
		CS <= '0';
		CPU_WR_RD <= '0';
		Clk <= '0';
		clk <= '0';
		SDRAM_wr_rd <= '1';
		MSTRB <= '0';
		RDY <= '1';
		Din <= "1111000000000101";
		--CPU_Dout <= "10110110";
		--SDRAM_Dout <= "11101110";
--		wea <= "1";
--		addra <= Din(15 downto 8);
--		dina <= CPU_Dout;
		

      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
