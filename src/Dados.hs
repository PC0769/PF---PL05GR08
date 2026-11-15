-- | Dados de demonstração (FICTÍCIOS) para a Fase 1.
--
-- Campeonato de 4 equipas, 6 jornadas, ida e volta, por ordem cronológica.
module Dados
  ( historico
  ) where

import Model

historico :: [Jogo]
historico =
  [ Jogo  1 1 "Porto"    "Benfica"  2 1
  , Jogo  2 1 "Sporting" "Braga"    3 0
  , Jogo  3 2 "Benfica"  "Sporting" 1 1
  , Jogo  4 2 "Braga"    "Porto"    0 2
  , Jogo  5 3 "Porto"    "Sporting" 1 1
  , Jogo  6 3 "Benfica"  "Braga"    2 0
  , Jogo  7 4 "Benfica"  "Porto"    0 1
  , Jogo  8 4 "Braga"    "Sporting" 1 2
  , Jogo  9 5 "Sporting" "Benfica"  2 0
  , Jogo 10 5 "Porto"    "Braga"    3 1
  , Jogo 11 6 "Sporting" "Porto"    0 2
  , Jogo 12 6 "Braga"    "Benfica"  1 1
  ]
