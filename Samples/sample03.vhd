library ieee;
use ieee.std_logic_1164.all;

entity sample03 is
  
  port (
    led_out : out std_logic_vector(3 downto 0));

end sample03;

architecture rtl of sample03 is

signal counter : std_logic_vector(3 downto 0):= (others=>'0');

begin

  counter <= "1000";                -- ①
  
  process (counter)                 -- ②
  begin
    case counter is
      when "0000" =>
        led_out <= "1111";          -- ③
      when "0001" =>
        led_out <= "1110";
      when "0011" =>
        led_out <= "1100";
      when "0010" =>
        led_out <= "1101";
      when "0110" =>
        led_out <= "1001";
      when "0111" =>
        led_out <= "1000";
      when "0101" =>
        led_out <= "1010";
      when "0100" =>
        led_out <= "1011";
      when "1100" =>
        led_out <= "0011";
      when "1101" =>
        led_out <= "0010";
      when "1111" =>
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
