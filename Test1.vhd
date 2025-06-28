--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   20:41:54 11/05/2023
-- Design Name:   
-- Module Name:   /home/student2/t11ngo/COE758/Project 1/Project1/Test1.vhd
-- Project Name:  Project1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Cache_Controller
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
 
ENTITY Test1 IS
END Test1;
 
ARCHITECTURE behavior OF Test1 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Cache_Controller
    PORT(
         Din : IN  std_logic_vector(15 downto 0);
         CPU_WR_RD : IN  std_logic;
         CS : IN  std_logic;
         clk : IN  std_logic;
         Dout : OUT  std_logic_vector(15 downto 0);
         SDRAM_WR_RD : OUT  std_logic;
         MSTRB : OUT  std_logic;
         Cache_Dout_MUX : OUT  std_logic;
         Cache_Addr : OUT  std_logic_vector(7 downto 0);
         WEN : OUT  std_logic_vector(0 downto 0);
         Cache_Din_MUX : OUT  std_logic;
         Rdy : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal Din : std_logic_vector(15 downto 0) := (others => '0');
   signal CPU_WR_RD : std_logic := '0';
   signal CS : std_logic := '0';
   signal clk : std_logic := '0';

 	--Outputs
   signal Dout : std_logic_vector(15 downto 0);
   signal SDRAM_WR_RD : std_logic;
   signal MSTRB : std_logic;
   signal Cache_Dout_MUX : std_logic;
   signal Cache_Addr : std_logic_vector(7 downto 0);
   signal WEN : std_logic_vector(0 downto 0);
   signal Cache_Din_MUX : std_logic;
   signal Rdy : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Cache_Controller PORT MAP (
          Din => Din,
          CPU_WR_RD => CPU_WR_RD,
          CS => CS,
          clk => clk,
          Dout => Dout,
          SDRAM_WR_RD => SDRAM_WR_RD,
          MSTRB => MSTRB,
          Cache_Dout_MUX => Cache_Dout_MUX,
          Cache_Addr => Cache_Addr,
          WEN => WEN,
          Cache_Din_MUX => Cache_Din_MUX,
          Rdy => Rdy
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
      wait for 100 ns;
		Din <= "1011011000111000";
		CPU_WR_RD <= '1';
		CS <= '1';
		clk <= '1';
      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
