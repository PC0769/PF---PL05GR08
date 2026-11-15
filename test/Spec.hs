-- | Testes da Fase 1 (apenas com a biblioteca base, sem dependências externas).
module Main (main) where

import System.Exit (exitFailure, exitSuccess)

import Dados (historico)
import Domain
import Model

data Teste = Teste String Bool

aprox :: Double -> Double -> Bool
aprox a b = abs (a - b) < 1e-9

-- | Jogo do histórico de exemplo pelo seu id (1..12).
jogoN :: Int -> Jogo
jogoN n = historico !! (n - 1)

-- | Histórico pequeno para testar os critérios de desempate.
historicoDesempate :: [Jogo]
historicoDesempate =
  [ Jogo 1 1 "A" "B" 1 0
  , Jogo 2 1 "C" "D" 2 0
  ]

testes :: [Teste]
testes =
  [ -- resultados
    Teste "resultadoCasa: vitoria da casa"  (resultadoCasa (jogoN 1) == Vitoria)
  , Teste "resultadoCasa: empate"           (resultadoCasa (jogoN 3) == Empate)
  , Teste "resultadoCasa: derrota da casa"  (resultadoCasa (jogoN 4) == Derrota)
  , Teste "inverter"                        (map inverter [Vitoria, Empate, Derrota]
                                              == [Derrota, Empate, Vitoria])
  , Teste "participa: sim"                  (participa "Porto" (jogoN 1))
  , Teste "participa: nao"                  (not (participa "Braga" (jogoN 1)))
  , Teste "resultadosEquipa Porto"          (resultadosEquipa "Porto" historico
                                              == [Vitoria, Vitoria, Empate, Vitoria, Vitoria, Vitoria])
  , Teste "resultadosEquipa: equipa inexistente" (resultadosEquipa "Xpto" historico == [])

    -- pontos
  , Teste "pontos Porto"                    (pontos "Porto" historico == 16)
  , Teste "pontos Braga"                    (pontos "Braga" historico == 1)
  , Teste "pontos: historico vazio"         (pontos "Porto" [] == 0)

    -- golos
  , Teste "golosMarcadosPor Porto"          (golosMarcadosPor "Porto" historico == 11)
  , Teste "golosSofridosPor Porto"          (golosSofridosPor "Porto" historico == 3)
  , Teste "golosMarcadosPor Benfica"        (golosMarcadosPor "Benfica" historico == 5)
  , Teste "golosSofridosPor Benfica"        (golosSofridosPor "Benfica" historico == 7)
  , Teste "golos: equipa inexistente"       (golosMarcadosPor "Xpto" historico == 0)

    -- estatisticas
  , Teste "estatisticasEquipa Sporting"     (estatisticasEquipa "Sporting" historico
                                              == Estatisticas "Sporting" 6 3 2 1 9 5)
  , Teste "pontosEstat == pontos"           (pontosEstat (estatisticasEquipa "Sporting" historico)
                                              == pontos "Sporting" historico)
  , Teste "diferencaGolos Braga"            (diferencaGolos (estatisticasEquipa "Braga" historico) == -10)

    -- classificacao
  , Teste "equipasDoHistorico: 4 equipas"   (length (equipasDoHistorico historico) == 4)
  , Teste "equipasDoHistorico: sem repetidas" (all (\e -> contarNomes e == 1) (equipasDoHistorico historico))
  , Teste "classificacao: ordem"            (map equipa (classificacao historico)
                                              == ["Porto", "Sporting", "Benfica", "Braga"])
  , Teste "classificacao: desempate"        (map equipa (classificacao historicoDesempate)
                                              == ["C", "A", "B", "D"])
  , Teste "classificacao: vazia"            (null (classificacao []))

    -- forma
  , Teste "ultimos 2"                       (ultimos 2 [1 :: Int, 2, 3, 4] == [3, 4])
  , Teste "ultimos 0"                       (null (ultimos 0 [1 :: Int, 2, 3]))
  , Teste "ultimos: n maior que a lista"    (ultimos 10 [1 :: Int, 2] == [1, 2])
  , Teste "formaRecente 3 Benfica"          (formaRecente 3 "Benfica" historico
                                              == [Derrota, Derrota, Empate])

    -- previsao
  , Teste "pontosPorJogo Porto"             (aprox (pontosPorJogo "Porto" historico) (16 / 6))
  , Teste "pontosPorJogo: sem jogos"        (aprox (pontosPorJogo "Porto" []) 0)
  , Teste "preverJogo: favorito em casa"    (preverJogo historico "Porto" "Braga" == PrevVitoriaCasa)
  , Teste "preverJogo: favorito fora"       (preverJogo historico "Benfica" "Sporting" == PrevVitoriaFora)
  , Teste "preverJogo: sem dados = empate"  (preverJogo [] "A" "B" == PrevEmpate)
  ]
  where
    contarNomes e = length (filter (== e) (equipasDoHistorico historico))

mostrar :: Teste -> IO ()
mostrar (Teste nome ok) =
  putStrLn ((if ok then "[OK]    " else "[FALHA] ") ++ nome)

passou :: Teste -> Bool
passou (Teste _ ok) = ok

main :: IO ()
main = do
  mapM_ mostrar testes
  let falhas = length (filter (not . passou) testes)
  putStrLn (show falhas ++ " falha(s) em " ++ show (length testes) ++ " testes")
  if falhas == 0 then exitSuccess else exitFailure
