library ieee;
use ieee.std_logic_1164.all;

entity sample02 is
  
  port (
    led_out : out std_logic_vector(3 downto 0));

end sample02;

architecture rtl of sample02 is

begin

  -- 10進数の5を表現する。LEDはLOWで点灯するため、
  -- ビット反転した値を出力する
  led_out <= "0000";

end rtl;
