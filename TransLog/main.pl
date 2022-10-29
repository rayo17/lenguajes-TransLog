oracion:-
  write('Ingrese el idioma a traducir '),
  nl,
  read(Spanish), translate(Spanish), !.

% Seleccion del idioma Ingles para traducir al español.
traslate(E) :- E = "In", 
  write('Please type your text to be translated: '),
  nl,read(Spanish),
  split_string(Spanish, " ", "¿¡,", L),
  oracion(K, L),
  atomic_list_concat(K, ' ', ListaPalabrasEspanol),
  write(ListaPalabrasEspanol).

% seleccion del idioma en español, para traducir al ingles.
translate(E) :- E = "Es",
  write('Ingresa el la frase para ser traducida: '),
  nl,
  read(Spanish),
  split_string(Espanol, " ", "¿¡,", L),
  oracion(L, K),
  atomic_list_concat(K, ' ', ListaPalabrasEspanol),
  write(ListaPalabrasEspanol).

% esta gramatica es para cuando la oracion introducida no es valida
text_unknown :- write('Hola, diculpa puedes volver a repetir la frase'), nl,
                 write('Intentalo de nuevo'), nl, oracion.