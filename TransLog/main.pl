:-include('Base de Datos Adjetivos.pl').
:-include('Base de datos Sustantivos.pl').
:-include('Base de Datos Verbos.pl').

oracion:-
  write('Ingrese el idioma a traducir '),
  nl,
  read(Spanish), translate(Spanish), !.

% Seleccion del idioma English para traducir al español.
translate(E) :- E = "In",
  write('Please type your text to be translated: '),
  nl,read(Spanish),
  split_string(Spanish, " ", "¿¡,", L),
  oracion(K, L),
  atomic_list_concat(K, ' ', ListWordSpanish),
  write(ListWordSpanish).

% seleccion del idioma en español, para traducir al English.
translate(E) :- E = "Es",
  write('Ingresa el la frase para ser traducida: '),
  nl,
  read(Spanish),
  split_string(Spanish, " ", "¿¡,", L),
  oracion(L, K),
  atomic_list_concat(K, ' ', ListWordSpanish),
  write(ListWordSpanish).

% esta gramatica es para cuando la oracion introducida no es valida
text_unknown :- write('Hola, diculpa puedes volver a repetir la frase'), nl,
                 write('Intentalo de nuevo'), nl, oracion.



%Funcion que une las distintas partes de la oración que se encontraron
% head: head de la lista
% R: el REsto
% L: lista
% ListaA, ListaB, ListaC, ListaX, ListaZ: son listas cualesquiera
unir([], Lista, Lista). % caso base
unir([Head|R1], Lista, [Head|R2]) :- unir(R1, Lista, R2).
unir(ListaA, ListaB, ListaC, ListaZ)  :- unir(ListaA, ListaB, ListaX),
                                         unir(ListaX, ListaC, ListaZ).



% ------------------------------------GRAMÁTICA LIBRE DE CONTEXTO-----------------------------------------



oracion(ListWordspanish, listWordEnglish) :- simple_sentence(ListWordspanish, listWordEnglish).
oracion(ListWordspanish, listWordEnglish) :- simple_sentence(spanish, English), conjuncion(spanishl2, English2),
                                                      unir(spanish, spanishl2, spanishl3),
                                                      unir(English, English2, English3),
                                                      unir(spanishl3, Restospanishl, ListWordspanish),
                                                      unir(English3, RestoEnglish, listWordEnglish),
                                                      oracion(Restospanishl, RestoEnglish).

oracion(ListWordspanish, listWordEnglish) :- simple_sentence(spanish, English), preposicion(spanishl2, English2),
                                                      unir(spanish,spanishl2, spanishl3),
                                                      unir(English,English2, English3),
                                                      unir(spanishl3, Restospanishl, ListWordspanish),
                                                      unir(English3, RestoEnglish, listWordEnglish),
                                                      oracion(Restospanishl,RestoEnglish).


oracion(ListWordspanish, listWordEnglish) :- text_unknown, !.




% Es una subdivisión de una oración más compleja en una oración más simple. En este caso para
% facilidad a la hora de formar oraciones con más elementos en la gramática
% Person: significa la Person en la cual está conjugado algún elemento de la oración (primera, segunda, tercera)

simple_sentence(ListWordspanish, ListaPalabrasEnglish) :- saludo(spanish, English),
                                                             unir(spanish, ["!"], ListWordspanish),
                                                             unir(English, ["!"], ListaPalabrasEnglish).


simple_sentence(ListWordspanish, ListaPalabrasEnglish) :-nominal_sintac(ListWordspanish, ListaPalabrasEnglish, Person).

simple_sentence(ListWordspanish, ListaPalabrasEnglish) :-nominal_sintac(spanish, English, Person),
                                                             verbal_sintac(spanishl2, English2, Person),
                                                             unir(spanish, spanishl2, ListWordspanish),
                                                             unir(English, English2, ListaPalabrasEnglish).

% Esto es una excepción a la gramática, solo para temas de la especificación de la tarea. Se utiliza para
% preguntas sencillas
simple_sentence(ListWordspanish, ListaPalabrasEnglish) :- interrogativo(spanish, English),
                                                             verbal_sintac(spanishl2, English2, Person),
                                                             unir(spanish, spanishl2, Resultadospanishl),
                                                             unir(Resultadospanishl, ["?"], ListWordspanish),
                                                             unir(English, English2, ResultadoEnglish),
                                                             unir(ResultadoEnglish, ["?"], ListaPalabrasEnglish).


%-----------------------------------------SINTAGMA VERBAL------------------------------------------


verbal_sintac(wordSpanish, WordEnglish, Person) :- verbo(Numero, Tiempo, Person, wordSpanish, WordEnglish).
verbal_sintac(wordSpanish, WordEnglish, Person) :- verbo(Numero, Tiempo, Person, spanish, English),
                                                          nominal_sintac(spanishl2, English2, Person),
                                                           unir(spanish, spanishl2, wordSpanish),
                                                           unir(English, English2, WordEnglish).


%-------------------------------------------------SINTAGMA NOMINAL-----------------------------------


nominal_sintac(wordSpanish, WordEnglish, Person) :- sustantivo(Numero, Genero, wordSpanish, WordEnglish).
nominal_sintac(wordSpanish, WordEnglish, Person) :- pronombre(Numero, Person, wordSpanish, WordEnglish).nominal_sintac(wordSpanish, WordEnglish, Person).
nominal_sintac(wordSpanish, WordEnglish, Person) :- adjetivo(Numero, Genero, wordSpanish, WordEnglish).





nominal_sintac(WordSpanish, WordEnglish, Person) :- determinante(Numero, Genero, Person, spanish, English),
                                                            sustantivo(Numero, Genero, spanishl2, English2),
                                                            unir(spanish, spanishl2, WordSpanish),
                                                            unir(English, English2, WordEnglish).
nominal_sintac(WordSpanish, WordEnglish, Person) :- sustantivo(Numero, Genero, spanish, English),
                                                            adjetivo(Numero, Genero, spanishl2, English2),
                                                            unir(spanish, spanishl2, WordSpanish),
                                                            unir(English2, English, WordEnglish).
nominal_sintac(WordSpanish, WordEnglish, Person) :- determinante(Numero, Genero, Person, spanish, English),
                                                            adjetivo(Numero, Genero, spanishl2, English2),
                                                            sustantivo(Numero, Genero, spanishl3, English3),
                                                            unir(spanish, spanishl2, spanishl3, WordSpanish),
                                                            unir(English, English2, English3, WordEnglish).
nominal_sintac(WordSpanish, WordEnglish, Person) :- determinante(Numero, Genero, Person, spanish, English),
                                                            sustantivo(Numero, Genero, spanishl2, English2),
                                                            adjetivo(Numero, Genero, spanishl3, English3),
                                                            unir(spanish, spanishl2, spanishl3, WordSpanish),
                                                            unir(English, English3, English2, WordEnglish).
nominal_sintac(WordSpanish, WordEnglish, Person) :- adjetivo(Numero, Genero, spanish, English),
                                                            adverbio(spanishl2, English2),
                                                            unir(spanish, spanishl2, WordSpanish),
                                                            unir(English, English2, WordEnglish).















