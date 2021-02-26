`timescale 1ns / 1ps

module sensors_input(
	temp_sum_o,
	nr_active_sensors_o,
	sensors_data_i,
	sensors_en_i
	);
	
	// parametru pentru primirea unui numar variabil de senzori (cerinta bonus)
	
	parameter NR_OF_SENSORS = 5;
	
	
	output reg [15:0] temp_sum_o; // suma temperaturilor valide
	output reg [7:0] nr_active_sensors_o; // numarul senzorilor activi
	input  [NR_OF_SENSORS * 8 - 1:0] sensors_data_i; // valorile de temperatura ale senzorilor, concatenate intr-un vector
	input   [NR_OF_SENSORS - 1:0] sensors_en_i;
	
	
	reg [8:0] i; // reg pentru parcugerea temperaturilor concatenate
	
	always @(*)
		begin
			
			temp_sum_o = 0;
			nr_active_sensors_o = 0;
			
			for(i = 0; i < NR_OF_SENSORS; i = i + 1) // calcularea sumei totale a temperaturilor (in functie de bitul enable)
				begin
					
					if(sensors_en_i[i] == 1)
						begin
							temp_sum_o = temp_sum_o + sensors_data_i[i * 8 +: 8]; // operator +: pentru selectarea unui numar constant de biti cu un punct de start variabil
							nr_active_sensors_o = nr_active_sensors_o + 1; // incrementare numar senzori activi
						end
				end
				
		end

endmodule
