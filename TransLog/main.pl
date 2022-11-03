:-include('Base de Datos Adjetivos.pl').
:-include('Base de datos Sustantivos.pl').
:-include('Base de Datos Verbos.pl').

% regla que se tiene que llamar desde la consola para
% realizar la traducción. Es lo que inicia el traductor

texto :-
  write('Ingrese el idioma a traducir '),
  nl,
  read(Spanish), traductor(Spanish), !.


% Seleccion del idioma English: traduce al idioma Español
traductor(E) :- E = "In",
  write('Please type your text: '),
  nl,
  read(Spanish),
  split_string(Spanish, " ", "¿¡,", L),
  oracion(K, L),
  atomic_list_concat(K, ' ', ListWordsSpanish),
  write(ListWordsSpanish).

% Seleccion del idioma Español: traduce al idioma Inglés
traductor(E) :- E = "Es",
  write('Ingresa el oracion: '),
  nl,
  read(Spanish),
  split_string(Spanish, " ", "¿¡,", L),
  oracion(L, K),
  atomic_list_concat(K, ' ', ListWordsSpanish),
  write(ListWordsSpanish).

% En caso de que la frase u oración no se reconozca
no_reconocido :- write('Disculpa, no te he entendido'), nl,
                 write('Intentalo de nuevo'), nl,
                 texto.

%Funcion que concatena las distintas partes de la oración que se encontraron
% Cabeza: Cabeza de la lista
% R: Resto
% L: lista
% ListaA, ListaB, ListaC, ListaX, ListaZ: son listas cualesquiera
unir([], Lista, Lista). % caso base
unir([Cabeza|R1], Lista, [Cabeza|R2]) :- unir(R1, Lista, R2).
unir(ListaA, ListaB, ListaC, ListaZ)  :- unir(ListaA, ListaB, ListaX),
                                         unir(ListaX, ListaC, ListaZ).


% ------------------------------------GRAMÁTICA LIBRE DE CONTEXTO-----------------------------------------

oracion(ListWordsSpanish, ListWordsEnglish) :- oracion_simple(ListWordsSpanish, ListWordsEnglish).
oracion(ListWordsSpanish, ListWordsEnglish) :- oracion_simple(Spanish, English), conjuncion(Spanish2, English2),
                                               unir(Spanish, Spanish2, Spanish3),
                                               unir(English, English2, English3),
                                               unir(Spanish3, RestoSpanish, ListWordsSpanish),
                                               unir(English3, RestoEnglish, ListWordsEnglish),
                                               oracion(RestoSpanish, RestoEnglish).

oracion(ListWordsSpanish, ListWordsEnglish) :- oracion_simple(Spanish, English), preposicion(Spanish2, English2),
                                               unir(Spanish,Spanish2, Spanish3),
                                               unir(English,English2, English3),
                                               unir(Spanish3, RestoSpanish, ListWordsSpanish),
                                               unir(English3, RestoEnglish, ListWordsEnglish),
                                               oracion(RestoSpanish,RestoEnglish).


oracion(ListWordsSpanish, ListWordsEnglish) :- no_reconocido, !.

% Es una subdivisión de una oración más compleja en una oración más simple. En este caso para
% facilidad a la hora de formar oraciones con más elementos en la gramática
% Persona: significa la persona en la cual está conjugado algún elemento de la oración (primera, segunda, tercera)

oracion_simple(ListWordsSpanish, ListWordsEnglish) :- saludo(Spanish, English),
                                                      unir(Spanish, ["!"], ListWordsSpanish),
                                                      unir(English, ["!"], ListWordsEnglish).

% Esto es una excepción a la gramática, solo para temas de la especificación de la tarea
oracion_simple(ListWordsSpanish, ListWordsEnglish) :- nominal_sintac(ListWordsSpanish, ListWordsEnglish, Persona).

oracion_simple(ListWordsSpanish, ListWordsEnglish) :- nominal_sintac(Spanish, English, Persona),
                                                      verbal_sintac(Spanish2, English2, Persona),
                                                      unir(Spanish, Spanish2, ListWordsSpanish),
                                                      unir(English, English2, ListWordsEnglish).

% Esto es una excepción a la gramática, solo para temas de la especificación de la tarea. Se utiliza para
% preguntas sencillas
oracion_simple(ListWordsSpanish, ListWordsEnglish) :- interrogativo(Spanish, English),
                                                      verbal_sintac(Spanish2, English2, Persona),
                                                      unir(Spanish, Spanish2, ResultadoSpanish),
                                                      unir(ResultadoSpanish, ["?"], ListWordsSpanish),
                                                      unir(English, English2, ResultadoEnglish),
                                                      unir(ResultadoEnglish, ["?"], ListWordsEnglish).


%-----------------------------------------SINTAGMA VERBAL------------------------------------------



verbal_sintac(PalabraSpanish, PalabraEnglish, Persona) :- verbo(Numero, Tiempo, Persona, PalabraSpanish, PalabraEnglish).
verbal_sintac(PalabraSpanish, PalabraEnglish, Persona) :- verbo(Numero, Tiempo, Persona, Spanish, English),
                                                           nominal_sintac(Spanish2, English2, Persona),
                                                           unir(Spanish, Spanish2, PalabraSpanish),
                                                           unir(English, English2, PalabraEnglish).


%-------------------------------------------------SINTAGMA NOMINAL-----------------------------------



% Estos son los elementos más atómicos del sintagma nominal
nominal_sintac(PalabraSpanish, PalabraEnglish, Persona) :- sustantivo(Numero, Genero, PalabraSpanish, PalabraEnglish).
nominal_sintac(PalabraSpanish, PalabraEnglish, Persona) :- pronombre(Numero, Persona, PalabraSpanish, PalabraEnglish).
nominal_sintac(PalabraSpanish, PalabraEnglish, Persona) :- adjetivo(Numero, Genero, PalabraSpanish, PalabraEnglish).


% Estos son los elementos complejos del sintagma nominal
nominal_sintac(PalabraSpanish, PalabraEnglish, Persona) :- determinante(Numero, Genero, Persona, Spanish, English),
                                                            sustantivo(Numero, Genero, Spanish2, English2),
                                                            unir(Spanish, Spanish2, PalabraSpanish),
                                                            unir(English, English2, PalabraEnglish).

nominal_sintac(PalabraSpanish, PalabraEnglish, Persona) :- sustantivo(Numero, Genero, Spanish, English),
                                                            adjetivo(Numero, Genero, Spanish2, English2),
                                                            unir(Spanish, Spanish2, PalabraSpanish),
                                                            unir(English2, English, PalabraEnglish).

nominal_sintac(PalabraSpanish, PalabraEnglish, Persona) :- determinante(Numero, Genero, Persona, Spanish, English),
                                                            adjetivo(Numero, Genero, Spanish2, English2),
                                                            sustantivo(Numero, Genero, Spanish3, English3),
                                                            unir(Spanish, Spanish2, Spanish3, PalabraSpanish),
                                                            unir(English, English2, English3, PalabraEnglish).

nominal_sintac(PalabraSpanish, PalabraEnglish, Persona) :- determinante(Numero, Genero, Persona, Spanish, English),
                                                            sustantivo(Numero, Genero, Spanish2, English2),
                                                            adjetivo(Numero, Genero, Spanish3, English3),
                                                            unir(Spanish, Spanish2, Spanish3, PalabraSpanish),
                                                            unir(English, English3, English2, PalabraEnglish).

nominal_sintac(PalabraSpanish, PalabraEnglish, Persona) :- adjetivo(Numero, Genero, Spanish, English),
                                                            adverbio(Spanish2, English2),
                                                            unir(Spanish, Spanish2, PalabraSpanish),
                                                            unir(English, English2, PalabraEnglish).

saludo(["Hola"], ["Hello"]).


adverbio(["comunmente"], ["commonly"]).
adverbio(["hoy"], ["today"]).

determinante(singular, masculino, tercera, ["el"], ["the"]).
determinante(singular, femenino, tercera, ["la"], ["the"]).
determinante(plural, masculino, tercera, ["los"], ["the"]).

conjuncion(["y"], ["and"]).
conjuncion(["o"], ["or"]).
sustantivo(plural, femenino, ["sillas"], ["chairs"]).
