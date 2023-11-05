library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity sample04 is
  
  port (
    clk     : in  std_logic;
    led_out : out std_logic_vector(3 downto 0));

end sample04;

architecture rtl of sample04 is

signal counter : std_logic_vector(3 downto 0);

-- 以下は分周用のカウンタとクロック
signal div_counter : std_logic_vector(25 downto 0);
signal div_clk : std_logic;

begin

  -- 以下は50MHzのクロックから1秒弱のクロックを作成する
  -- 分周回路です。
  process (clk)
  begin  -- process
    if clk'event and clk = '1' then
      div_counter <= div_counter + 1;
    end if;
  end process;

  -- div_clkが1Hzのクロックで、デコーダへのクロック入力
  div_clk <= div_counter(19);
  -- ここまでが分周回路

  process (div_clk)
  begin
    if div_clk'event and div_clk = '1' then
      counter <= counter + 1;
    end if;
  end process;

  process (counter)
  begin
    case counter is
      when "0000" =>
        led_out <= "1111";
      when "0001" =>
        led_out <= "1110";
      when "0010" =>
        led_out <= "1100";
      when "0011" =>
        led_out <= "1101";
      when "0100" =>
        led_out <= "1001";
      when "0101" =>
        led_out <= "1000";
      when "0110" =>
        led_out <= "1010";
      when "0111" =>
        led_out <= "1011";
      when "1000" =>
        led_out <= "0011";
      when "1001" =>
        led_out <= "0010";
      when "1010" =>
        led_out <= "0000";
      when "1011" =>
        led_out <= "0001";
      when "1100" =>
        led_out <= "0101";
      when "1101" =>
        led_out <= "0100";
      when "1110" =>
        led_out <= "0110";
      when "1111" =>
        led_out <= "0111";
      when others => null;
    end case;
  end process;
end rtl;