--------------------------------------------------

## Prezentarea generala a circuitului:

	Am abordat implementarea ca pe o serie de 4 sisteme tip "black-box", deoarece fiecare modul are intrari si iesiri,
acestea putand fi create si testate separat, cu exceptia modulului temperature_top (care le imbina pe celelalte 3).

- In modulul *sensors_input*:

	Am calculat suma totala a temperaturilor, adunand doar acele valori ale caror biti enable corespunzatori aveau valoarea 1.
Totodata, am numarat cati biti de enable aveau valoarea 1.

- In modulul *division*:

	Am realizat media aritmetica a temperaturilor adunate in modulul precedent, folosind impartirea cu rest si cat pentru numere binare.

- In modulul *output_display*:

	Am aproximat valoarea mediei temperaturii (calculata anterior) la un intreg si am codificat-o conform tabelului de valori, pentru afisare.
Totodata, in functie de limitele de temperatura prestabilite, am activat (dupa caz) un semnal de alerta.

--------------------------------------------------

## Detalii de implementare:

In cod sunt comentarii care explica anumite portiuni, insa pe scurt:

- In modulul *division*:

	Operatia realizata in modul este o impartire (ce reprezinta media aritmetica a temperaturii),
intre suma totala a temperaturilor si numarul senzorilor activi corespunzatori acestora. Pentru a realiza aceasta medie,
am utilizat versiunea pentru numere reprezentate in baza 2 a algoritmului "Long Division", al carui pseudocod
se poate gasi aici: https://en.wikipedia.org/wiki/Division_algorithm.
In bucla for, am tratat separat bitul de pe pozitia 0. Am observat ca atunci cand variabila i (pentru parcurgerea bitilor)
devine 0 si din ea este scazut 1, aceasta (nefiind reprezentata cu semn) ia valoarea maxima pozitiva in binar pe dimensiunea pe care este reprezentata.

- In modulul *output_display*:

	Am realizat aproximarea mediei temperaturii conform regulii prezentate in continuare. ( 2 * rest >= impartitor => aproximare la urmatorul intreg)
Am considerat ca prima zecimala a numarului (real pozitiv) reprezentat initial cu ajutorului catului si al restului
va fi mai mare sau egala cu 5 (0.5 reprezentand jumatate din intreg), atunci cand dublul restului este mai mare sau egal cu impartitorul.
In caz contrar, prima zecimala are valoarea sub 5, deci aproximarea se va face la partea intreaga a numarului real (deci va ramane catul).


- In modulul *temperature_top*:

	Fiecare modul este instantiat conform schemei bloc, respectand dimensiunile semnalelor de intrare/iesire.
Variabila x este impartitorul din modulul division, reprezentat pe 16 biti. Primii opt (de la stanga, la dreapta) sunt biti de 0
concatenati cu bitii ce reprezinta numarul de senzori activi (nr_active_sensors_o, iesire de 8 biti din sensors_input).

--------------------------------------------------

## Explicatii referitoare la numarul variabil de parametri:

	Pentru a putea citi un numar de temperaturi ce poate varia, am parametrizat modulele sensors_input
si temperature_top (in functie de numarul de senzori de la care se citesc temperaturi).
Folosind parametrul NR_OF_SENSORS, marimile intrarilor din sensors_input se pot schimba,
iar acesta este instantiat in temperature_top, deci si acesta va folosi un parametru. In modulul sensors_input, am folosit operatorul
+: pentru selectarea unui numar constat de biti cu punct de start variabil, pentru a parcurge bitii din sensors_data_i, si am marit dimensiunea variabilei
de tip reg, i, pentru a putea creste pana la NR_OF_SENSORS (cand numarul de senzori creste pana la maxim 200).
