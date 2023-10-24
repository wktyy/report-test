library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity sample06 is

  -- div_bitsは分周回路に用いられているカウンタのビット数
  generic (
    div_bits : integer := 16);
  
  port (
    clk     : in  std_logic;
    sw_in   : in  std_logic;
    led_out : out std_logic);

end sample06;

architecture rtl of sample06 is

signal led_node : std_logic := '0';
signal div_counter : std_logic_vector(div_bits-1 downto 0) := (others => '0');
signal sw_in_node : std_logic;
signal sw_latch_on : std_logic := '0';
begin

  -- 入力クロックを分周し、チャタリングを除去する回路
  process (clk)
  begin
    if clk'event and clk = '1' then  -- rising clock edge
      div_counter <= div_counter + 1;
    end if;
  end process;

  -- 分周したクロックでスイッチからの入力をラッチする回路
  -- 分周用カウンタの最上位ビットをクロックとして用いる
  process (div_counter(div_bits-1))
  begin  -- process
    if div_counter(div_bits-1)'event and div_counter(div_bits-1) = '1' then  
      sw_in_node <= sw_in;
    end if;
  end process;
  
  -- 基本クロックに同期してDFF(led_node)をトグルする。
  -- チャタリングが発生すると、この回路が複数回アクティブになり、
  -- パルスが何度も発生し、LEDがついたまま、あるいは、
  -- 消えたままの場合がある。このような時はdiv_counterのビット数を増やす。
  process (clk)
  begin  -- process
    if clk'event and clk = '1' then  -- rising clock edge
      if sw_in_node = '0' and sw_latch_on = '0' then
        led_node <= not led_node;
        sw_latch_on <= '1';
      elsif sw_in_node = '1' and sw_latch_on = '1' then
        sw_latch_on <= '0';
      elsif sw_in_node = '0' and sw_latch_on = '1' then
        sw_latch_on <= '1';
      end if;
    end if;
  end process;

  led_out <= led_node;
  
end rtl;
