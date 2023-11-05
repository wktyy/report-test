library ieee;
use ieee.std_logic_1164.all;

entity sample05 is
  
  port (
    led_out : out std_logic;
    pb0: in std_logic;
    pb1: in std_logic);

end sample05;

architecture rtl of sample05 is

signal operation_result : std_logic;
signal pb0_positive : std_logic;
signal pb1_positive : std_logic;

begin

  pb0_positive <= not pb0;  -- スイッチ入力は負論理なので not で正論理に変換
  pb1_positive <= not pb1;  -- スイッチ入力は負論理なので not で正論理に変換

  operation_result <= (pb0_positive or pb1_positive);

  led_out <= not operation_result;   -- LEDは負論理動作なので not で正論理から変換

end rtl;
