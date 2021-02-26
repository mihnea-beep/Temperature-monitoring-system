`timescale 1ns / 1ps

module output_display(
	output reg [7:0] coded_out_o, // semnalul codificat pentru iesire
	output reg    alert_o, 	  // semnalul de alerta, pentru iesirea in afara intervalului [19:26]
	input [15:0] temp_Q_i,    // catul din division med. aritm.
	input [15:0] temp_R_i,	  // restul din division med. aritm.
	input  [7:0] active_sensors_nr); // numarul de senzori activi med. aritm.
	
	reg [15:0] raw_output_data; // ce se intampla cu coded_out_o?
	
	always @(*)
		begin
			
			// aproximarea valorii temperaturii in functie de prima zecimala
			
			if(temp_R_i + temp_R_i >= active_sensors_nr) // daca dublul restului este mai mare decat impartitorul, 
				begin													// inseamna ca prima zecimala este mai mare decat 5, deci aproximarea va fi la urmatorul intreg
					raw_output_data = temp_Q_i + 1;
				end
			else
				begin
					raw_output_data = temp_Q_i;
				end
					
			if(raw_output_data < 19 || raw_output_data > 26) // daca valoarea output e in afara range-ului, se activeaza semnalul de alerta
				begin
					alert_o = 1;
				end
			else
				begin
					alert_o = 0;
				end
			
			case(alert_o)
			
			1: begin									// codificarea semnalului pentru valorile din afara intervalului acceptat
					if(raw_output_data < 19)
						begin
							coded_out_o = 8'b0000_0001;
						end
					if(raw_output_data > 26)
						begin
							coded_out_o = 8'b1111_1111;
						end
				end
				
			0: begin
					
					case(raw_output_data) // codificare semnal conform tabelului de valori
						
						19: coded_out_o = 8'b0000_0001;
						
						20: coded_out_o = 8'b0000_0011;
						
						21: coded_out_o = 8'b0000_0111;
						
						22: coded_out_o = 8'b0000_1111;
						
						23: coded_out_o = 8'b0001_1111;
						
						24: coded_out_o = 8'b0011_1111;
						
						25: coded_out_o = 8'b0111_1111;
						
						26: coded_out_o = 8'b1111_1111;				
					
					endcase
				
				end
			
			endcase
				
			
			
		end
	


endmodule
