-- | Demonstração da Fase 1: imprime a classificação, a forma recente
-- e algumas previsões a partir dos dados de exemplo.
module Main (main) where

import Dados (historico)
import Domain
import Model

preencher :: Int -> String -> String
preencher n s = s ++ replicate (n - length s) ' '

simbolo :: Resultado -> Char
simbolo Vitoria = 'V'
simbolo Empate  = 'E'
simbolo Derrota = 'D'

descrever :: Previsao -> String
descrever PrevVitoriaCasa = "vitoria da casa"
descrever PrevEmpate      = "empate"
descrever PrevVitoriaFora = "vitoria do visitante"

linhaTabela :: (Int, Estatisticas) -> String
linhaTabela (pos, e) = unwords
  [ show pos ++ "."
  , preencher 9 (equipa e)
  , "J:" ++ show (jogos e)
  , "V:" ++ show (vitorias e)
  , "E:" ++ show (empates e)
  , "D:" ++ show (derrotas e)
  , "GM:" ++ show (golosMarcados e)
  , "GS:" ++ show (golosSofridos e)
  , "Pts:" ++ show (pontosEstat e)
  ]

linhaForma :: Equipa -> String
linhaForma e = preencher 9 e ++ map simbolo (formaRecente 5 e historico)

linhaPrevisao :: (Equipa, Equipa) -> String
linhaPrevisao (c, f) =
  c ++ " vs " ++ f ++ ": " ++ descrever (preverJogo historico c f)

main :: IO ()
main = do
  putStrLn "=== Classificacao ==="
  mapM_ (putStrLn . linhaTabela) (zip [1 ..] (classificacao historico))

  putStrLn ""
  putStrLn "=== Forma (ultimos 5 jogos) ==="
  mapM_ (putStrLn . linhaForma) (equipasDoHistorico historico)

  putStrLn ""
  putStrLn "=== Previsoes (modelo simples) ==="
  mapM_ (putStrLn . linhaPrevisao)
    [ ("Porto", "Braga")
    , ("Benfica", "Sporting")
    , ("Sporting", "Porto")
    ]
