-- | Modelo de domínio do Sistema de Análise e Previsão de Resultados Desportivos.
--
-- Este módulo só define tipos: não contém lógica.
module Model
  ( Equipa
  , Resultado (..)
  , Jogo (..)
  , Estatisticas (..)
  , Previsao (..)
  ) where

-- | Uma equipa é identificada pelo seu nome.
type Equipa = String

-- | Resultado de um jogo do ponto de vista de uma equipa.
data Resultado
  = Vitoria
  | Empate
  | Derrota
  deriving (Show, Eq)

-- | Um jogo do histórico.
data Jogo = Jogo
  { jogoId     :: Int     -- ^ identificador único do jogo
  , jornada    :: Int     -- ^ número da jornada (ordem temporal)
  , casa       :: Equipa  -- ^ equipa que joga em casa
  , fora       :: Equipa  -- ^ equipa visitante
  , golosCasa  :: Int     -- ^ golos marcados pela equipa da casa
  , golosFora  :: Int     -- ^ golos marcados pela equipa visitante
  } deriving (Show, Eq)

-- | Estatísticas acumuladas de uma equipa sobre um conjunto de jogos.
data Estatisticas = Estatisticas
  { equipa         :: Equipa
  , jogos          :: Int
  , vitorias       :: Int
  , empates        :: Int
  , derrotas       :: Int
  , golosMarcados  :: Int
  , golosSofridos  :: Int
  } deriving (Show, Eq)

-- | Previsão do resultado de um jogo futuro.
data Previsao
  = PrevVitoriaCasa
  | PrevEmpate
  | PrevVitoriaFora
  deriving (Show, Eq)
