`timescale 1ns / 1ps

module division(
	output reg [15:0] Q, 
	output reg [15:0] R, 
	input  [15:0] N, // deimpartit - iesirea temp_sum_o din modulul sensors_input
	input  [15:0] D); // impartitor - iesirea nr_active_sensors_o din modulul sensors_input

	reg [4:0] i;
	
	// versiunea binara a algoritmului long division (adaptat dupa pseudocodul de pe pagina de Wikipedia - Division Algorithms)

	always @(*)		
		begin
			
			if(D != 0)
				begin 
					
					Q = 0;
					R = 0;
					
					for(i = 15; i > 0; i = i - 1)
						begin
						
							R = R << 1;
							R[0] = N[i];
							
							if(R >= D)  
								begin				
									R = R - D;
									Q[i] = 1;
								end
								
						end
						
						R = R << 1;	// bitul de pe prima pozitie este tratat separat pentru a evita cazul in care i ia valoarea maxima
						R[0] = N[i];
							
							if(R >= D)  
								begin				
									R = R - D;
									Q[0] = 1;
								end
				end				
		end
				

endmodule
