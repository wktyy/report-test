library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity sample07 is
  generic (
    div_bits : integer := 15);
  
  port (
    clk     : in  std_logic;
    sw_in   : in  std_logic;
    led_out : out std_logic_vector(3 downto 0));

end sample07;

architecture rtl of sample07 is

-- ステートマシンのためのノード宣言
signal counter_curr, counter_next : std_logic_vector(3 downto 0):= (others=>'0');

-- チャタリング除去のための分周クロックとスイッチ入力のためのラッチ
signal clk_div_sw, sw_node, sw_dff : std_logic := '0';
-- LED出力用の分周カウンタ。このカウンタのビット数を増やすと
-- ルーレットの変化がゆっくりになります。
signal clk_div_count : std_logic_vector(22 downto 0) := (others => '0');
signal div_counter : std_logic_vector(div_bits-1 downto 0) := (others => '0');
signal sw_latch_on : std_logic := '0';
begin

  -- チャタリング除去のためのクロック分周
  process (clk)
  begin
    if clk'event and clk = '1' then
      div_counter <= div_counter + 1;
    end if;
  end process;
  -- 最上位をチャタリング除去クロックとして用いる
  clk_div_sw <=  div_counter(div_bits-1);

  -- チャタリング除去してスイッチ入力値を採る
  process (clk_div_sw)
  begin
    if clk_div_sw'event and clk_div_sw = '1' then
      sw_node <= sw_in;
    end if;
  end process;

  -- ルーレットの回る速さをゆっくりにするための分周回路
  -- clk_div_countの最上位ビットをステートマシンのクロックとして用います。
  process (clk)
  begin
    if clk'event and clk = '1' then
      clk_div_count <= clk_div_count + 1;
    end if;
  end process;

  -- ルーレットをストップ・スタートさせるためのラッチ
  -- スイッチ入力によってトグルされます。
  process (clk)
  begin  -- process
    if clk'event and clk = '1' then  -- rising clock edge
      if sw_node = '0' and sw_latch_on = '0' then
        sw_dff <= not sw_dff;
        sw_latch_on <= '1';
      elsif sw_node = '1' and sw_latch_on = '1' then
        sw_latch_on <= '0';
      elsif sw_node = '0' and sw_latch_on = '1' then
        sw_latch_on <= '1';
      end if;
    end if;
  end process;

  -- LED出力を制御するステートマシン
  process (clk)
  begin
    if clk_div_count(22)'event and clk_div_count(22) = '1' then  -- rising clock edge
      if sw_dff = '1' then
        counter_curr <= counter_next;        
      end if;
    end if;
  end process;

  process (counter_curr)
  begin
    case counter_curr is
      when "1011" =>
        counter_next <= "0000";         -- (a)
      when "0000" =>
        counter_next <= "0001";
      when "0001" =>
        counter_next <= "0010";
      when "0010" =>
        counter_next <= "0011";
      when "0011" =>
        counter_next <= "0100";
      when "0100" =>
        counter_next <= "0101";
      when "0101" =>
        counter_next <= "0110";
      when "0110" =>
        counter_next <= "0111";
      when "0111" =>
        counter_next <= "1000";
      when "1000" =>
        counter_next <= "1001";
		when "1001" =>
        counter_next <= "1010";
		when "1010" =>
        counter_next <= "1011";
      when others => null;
    end case;
  end process;


  process (counter_curr)
  begin
    led_out <= not counter_curr;
  end process;
end rtl;
