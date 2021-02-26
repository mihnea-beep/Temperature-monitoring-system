`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:33:27 11/07/2020 
// Design Name: 
// Module Name:    temperature_top 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module temperature_top(
	led_output_o,
	alert_o,
	sensors_data_i, 
	sensors_en_i);  
	
	parameter NR_OF_SENSORS = 5; // parametru pentru utilizarea unui numar variabil de senzori (maxim 200)
	
	output [7:0]  led_output_o;
	output 		  alert_o;
	wire [15:0]temp_sum_o;
	wire [7:0] nr_active_sensors_o;
	wire [15:0] x; // impartitorul pentru modulul division (numarul de senzori activi reprezentat pe 16 biti)
	wire [15:0] Q;
	wire [15:0] R;
	
	input [NR_OF_SENSORS * 8 - 1:0] sensors_data_i;
	input  [NR_OF_SENSORS - 1:0] sensors_en_i;
	
	// instantierea fiecarui modul, conform schemei bloc
	// senzorii preiau temperaturile, iar modulul sensors_input realizeaza suma acestora si numara senzorii activi
	// modulul division realizeaza media aritmetica a temperaturilor cu ajutorul unui algoritm de impartire cu rest
	// modulul output_display afiseaza temperatura aproximata intr-o forma codificata, precum si un semnal de alerta
	// daca temperatura se afla in afara intervalului acceptat
	
	sensors_input #(.NR_OF_SENSORS(NR_OF_SENSORS)) s(temp_sum_o, nr_active_sensors_o[7:0], sensors_data_i, sensors_en_i);
	
	assign x = {8'b0000_0000, nr_active_sensors_o[7:0]}; // modulul division primeste un impartitor pe 16 biti realizat prin concatenare
																		  // (noul semnal reprezinta numarul de senzori activi, pe 16 biti)
   division d(Q, R, temp_sum_o, x);
	
	output_display o(led_output_o, alert_o, Q, R, nr_active_sensors_o[7:0]);
	
endmodule
