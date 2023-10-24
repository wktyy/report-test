library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity sample08 is
  generic (
    div_bits : integer := 15);
  
  port (
    clk     : in  std_logic;
    resetn   : in  std_logic;
    sw_in   : in  std_logic;
    led_out0, led_out1, led_out2 : out std_logic_vector(3 downto 0));

end sample08;

architecture rtl of sample08 is

component roulette
  
  port (
    clk     : in  std_logic;
    resetn   : in  std_logic;
    sw_in   : in  std_logic;
    led_out : out std_logic_vector(3 downto 0));

end component;

signal clk_div, clk_roulette, sw_node : std_logic := '0';
signal div_counter : std_logic_vector(22 downto 0) := (others => '0');
signal sw0, sw1, sw2 : std_logic;
signal sw_latch, sw_latch_on : std_logic := '0';
begin

  roulette_unit0 : roulette port map (
    clk     => clk_roulette,
    resetn   => resetn,
    sw_in   => sw0,
    led_out => led_out0);
  
  roulette_unit1 : roulette port map (
    clk     => clk_roulette,
    resetn   => resetn,
    sw_in   => sw1,
    led_out => led_out1);
  
  roulette_unit2 : roulette port map (
    clk     => clk_roulette,
    resetn   => resetn,
    sw_in   => sw2,
    led_out => led_out2);
  
  process (clk)
  begin
    if clk'event and clk = '1' then  -- rising clock edge
      div_counter <= div_counter + 1;
    end if;
  end process;
  
  clk_div <=  div_counter(div_bits-1);
  clk_roulette <= div_counter(22);

  -- チャタリング除去
  process (clk_div)
  begin  -- process
    if clk_div'event and clk_div = '1' then  -- rising clock edge
      sw_node <= sw_in;
    end if;
  end process;

  -- スイッチ入力を1パルスにして出力する回路
  process (clk)
  begin  -- process
    if clk'event and clk = '1' then  -- rising clock edge
      if sw_node = '0' and sw_latch_on = '0' then
        sw_latch <= '1';
        sw_latch_on <= '1';
      elsif sw_node = '1' and sw_latch_on = '1' then
        sw_latch <= '0';
        sw_latch_on <= '0';
      elsif sw_node = '0' and sw_latch_on = '1' then
        sw_latch <= '0';
        sw_latch_on <= '1';
      end if;
    end if;
  end process;

  -- スイッチによるパルスを受け取ってルーレットを止めていく回路
  process (clk, resetn)
  begin  -- process
    if resetn = '0' then
      sw0 <= '1';
      sw1 <= '1';
      sw2 <= '1';
    elsif clk'event and clk = '1' then  -- rising clock edge
      if sw_latch = '1' then
        if (sw0 = '1' and sw1 = '1' and sw2 = '1') then
          sw0 <= '0';
        elsif (sw0 = '0' and sw1 = '1' and sw2 = '1') then
          sw1 <= '0';
        elsif (sw0 = '0' and sw1 = '0' and sw2 = '1') then
          sw2 <= '0';
        end if;
      end if;
    end if;
  end process;
end rtl;
