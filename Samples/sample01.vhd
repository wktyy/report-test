library ieee;
use ieee.std_logic_1164.all;

entity sample01 is
  
  port (
    led_out : out std_logic);

end sample01;

architecture rtl of sample01 is

begin

  -- LEDはLOWで点灯するように回路が構成されているため
  -- std_logic型の0を出力する。これを1にすると消灯する。
  led_out <= '0';

end rtl;
