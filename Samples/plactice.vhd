library ieee;
use ieee.std_logic_1164.all;

entity plactice is 

	port(
		led_out : out std_logic_vector(3 downto 0));
		
end plactice;

architecture rtl of plactice is 

signal counter : std_logic_vector(2 downto 0):=(others=>'0');

begin

	counter <= "011";
	
	process(counter)
	begin
		case counter is 
			when "000"=>
				led_out<= "1111";
			when "001"=>
				led_out<= "1110";
			when "010"=>
				led_out<= "1101";
			when "011"=>
				led_out<= "1011";
			when "100"=>
				led_out<= "0111";
			when others => null;
		end case;
	end process;
end rtl;