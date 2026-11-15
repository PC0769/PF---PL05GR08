-- | Núcleo funcional: funções puras sobre o histórico de jogos.
--
-- Fase 1: foco em pattern matching, guards e recursão explícita.
-- (Na Fase 2, muitas destas recursões serão substituídas por map/filter/fold.)
module Domain
  ( -- * Resultados e pontos
    resultadoCasa
  , inverter
  , participa
  , resultadosEquipa
  , pontosResultado
  , somaPontos
  , pontos
    -- * Golos e estatísticas
  , golosMarcadosPor
  , golosSofridosPor
  , contar
  , estatisticasEquipa
  , pontosEstat
  , diferencaGolos
    -- * Classificação
  , pertence
  , equipasDoHistorico
  , melhorQue
  , ordenar
  , classificacao
    -- * Forma e previsão
  , ultimos
  , formaRecente
  , pontosPorJogo
  , vantagemCasa
  , margemEmpate
  , preverJogo
  ) where

import Model

-- ---------------------------------------------------------------------------
-- Resultados e pontos
-- ---------------------------------------------------------------------------

-- | Resultado de um jogo do ponto de vista da equipa da casa.
resultadoCasa :: Jogo -> Resultado
resultadoCasa j
  | golosCasa j > golosFora j  = Vitoria
  | golosCasa j == golosFora j = Empate
  | otherwise                  = Derrota

-- | Resultado visto do lado oposto.
inverter :: Resultado -> Resultado
inverter Vitoria = Derrota
inverter Empate  = Empate
inverter Derrota = Vitoria

-- | A equipa participou neste jogo?
participa :: Equipa -> Jogo -> Bool
participa e j = e == casa j || e == fora j

-- | Resultados de uma equipa, pela ordem em que os jogos aparecem na lista.
-- Jogos em que a equipa não participa são ignorados.
resultadosEquipa :: Equipa -> [Jogo] -> [Resultado]
resultadosEquipa _ [] = []
resultadosEquipa e (j : js)
  | e == casa j = resultadoCasa j           : resto
  | e == fora j = inverter (resultadoCasa j) : resto
  | otherwise   = resto
  where
    resto = resultadosEquipa e js

-- | Pontos atribuídos por um resultado (3 / 1 / 0).
pontosResultado :: Resultado -> Int
pontosResultado Vitoria = 3
pontosResultado Empate  = 1
pontosResultado Derrota = 0

-- | Soma dos pontos de uma lista de resultados.
somaPontos :: [Resultado] -> Int
somaPontos []       = 0
somaPontos (r : rs) = pontosResultado r + somaPontos rs

-- | Total de pontos de uma equipa no histórico.
pontos :: Equipa -> [Jogo] -> Int
pontos e js = somaPontos (resultadosEquipa e js)

-- ---------------------------------------------------------------------------
-- Golos e estatísticas
-- ---------------------------------------------------------------------------

-- | Golos marcados por uma equipa em todos os jogos.
golosMarcadosPor :: Equipa -> [Jogo] -> Int
golosMarcadosPor _ [] = 0
golosMarcadosPor e (j : js)
  | e == casa j = golosCasa j + resto
  | e == fora j = golosFora j + resto
  | otherwise   = resto
  where
    resto = golosMarcadosPor e js

-- | Golos sofridos por uma equipa em todos os jogos.
golosSofridosPor :: Equipa -> [Jogo] -> Int
golosSofridosPor _ [] = 0
golosSofridosPor e (j : js)
  | e == casa j = golosFora j + resto
  | e == fora j = golosCasa j + resto
  | otherwise   = resto
  where
    resto = golosSofridosPor e js

-- | Quantas vezes um resultado ocorre numa lista.
contar :: Resultado -> [Resultado] -> Int
contar _ [] = 0
contar r (x : xs)
  | r == x    = 1 + contar r xs
  | otherwise = contar r xs

-- | Estatísticas completas de uma equipa.
estatisticasEquipa :: Equipa -> [Jogo] -> Estatisticas
estatisticasEquipa e js = Estatisticas
  { equipa        = e
  , jogos         = length rs
  , vitorias      = contar Vitoria rs
  , empates       = contar Empate rs
  , derrotas      = contar Derrota rs
  , golosMarcados = golosMarcadosPor e js
  , golosSofridos = golosSofridosPor e js
  }
  where
    rs = resultadosEquipa e js

-- | Pontos a partir das estatísticas.
pontosEstat :: Estatisticas -> Int
pontosEstat s = 3 * vitorias s + empates s

-- | Diferença de golos (marcados - sofridos).
diferencaGolos :: Estatisticas -> Int
diferencaGolos s = golosMarcados s - golosSofridos s

-- ---------------------------------------------------------------------------
-- Classificação
-- ---------------------------------------------------------------------------

-- | Pertence à lista?
pertence :: Eq a => a -> [a] -> Bool
pertence _ [] = False
pertence x (y : ys)
  | x == y    = True
  | otherwise = pertence x ys

-- | Equipas que aparecem no histórico, sem repetições.
equipasDoHistorico :: [Jogo] -> [Equipa]
equipasDoHistorico []       = []
equipasDoHistorico (j : js) =
  adicionar (casa j) (adicionar (fora j) (equipasDoHistorico js))

-- | Acrescenta um elemento só se ainda não existir.
adicionar :: Eq a => a -> [a] -> [a]
adicionar x xs
  | pertence x xs = xs
  | otherwise     = x : xs

-- | Critério de ordenação da tabela: pontos, diferença de golos,
-- golos marcados e, por fim, ordem alfabética (para ser determinista).
melhorQue :: Estatisticas -> Estatisticas -> Bool
melhorQue a b
  | pontosEstat a /= pontosEstat b       = pontosEstat a > pontosEstat b
  | diferencaGolos a /= diferencaGolos b = diferencaGolos a > diferencaGolos b
  | golosMarcados a /= golosMarcados b   = golosMarcados a > golosMarcados b
  | otherwise                            = equipa a < equipa b

-- | Ordenação por inserção (recursiva): melhores primeiro.
ordenar :: [Estatisticas] -> [Estatisticas]
ordenar []       = []
ordenar (x : xs) = inserir x (ordenar xs)

inserir :: Estatisticas -> [Estatisticas] -> [Estatisticas]
inserir x [] = [x]
inserir x (y : ys)
  | melhorQue x y = x : y : ys
  | otherwise     = y : inserir x ys

-- | Estatísticas de todas as equipas indicadas.
estatisticasTodas :: [Equipa] -> [Jogo] -> [Estatisticas]
estatisticasTodas [] _        = []
estatisticasTodas (e : es) js = estatisticasEquipa e js : estatisticasTodas es js

-- | Tabela classificativa construída a partir do histórico.
classificacao :: [Jogo] -> [Estatisticas]
classificacao js = ordenar (estatisticasTodas (equipasDoHistorico js) js)

-- ---------------------------------------------------------------------------
-- Forma recente e previsão
-- ---------------------------------------------------------------------------

-- | Os últimos @n@ elementos de uma lista.
ultimos :: Int -> [a] -> [a]
ultimos n xs
  | n <= 0           = []
  | length xs <= n   = xs
  | otherwise        = case xs of
      []        -> []
      (_ : res) -> ultimos n res

-- | Resultados dos últimos @n@ jogos de uma equipa
-- (assume que a lista de jogos está por ordem cronológica).
formaRecente :: Int -> Equipa -> [Jogo] -> [Resultado]
formaRecente n e js = ultimos n (resultadosEquipa e js)

-- | Média de pontos por jogo (0 se a equipa ainda não jogou).
pontosPorJogo :: Equipa -> [Jogo] -> Double
pontosPorJogo e js
  | n == 0    = 0
  | otherwise = fromIntegral (somaPontos rs) / fromIntegral n
  where
    rs = resultadosEquipa e js
    n  = length rs

-- | Bónus (em pontos por jogo) dado à equipa que joga em casa.
vantagemCasa :: Double
vantagemCasa = 0.3

-- | Diferença máxima (em pontos por jogo) para considerar empate.
margemEmpate :: Double
margemEmpate = 0.35

-- | Modelo de previsão muito simples: compara a média de pontos por jogo
-- das duas equipas, com bónus para a equipa da casa.
preverJogo :: [Jogo] -> Equipa -> Equipa -> Previsao
preverJogo hist c f
  | diff >  margemEmpate = PrevVitoriaCasa
  | diff < -margemEmpate = PrevVitoriaFora
  | otherwise            = PrevEmpate
  where
    diff = pontosPorJogo c hist + vantagemCasa - pontosPorJogo f hist
