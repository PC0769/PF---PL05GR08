# Sistema de Análise e Previsão de Resultados Desportivos

Projeto semestral de Programação Funcional (Haskell).

**Objetivo:** processar o histórico de jogos de um campeonato, calcular
estatísticas por equipa e modelar previsões de resultados.

> Estado: **Fase 1** — modelação e núcleo funcional.

## Requisitos

- GHC (>= 9.2 recomendado) e `cabal` (>= 3.0), por exemplo via [GHCup](https://www.haskell.org/ghcup/).
- Sem dependências externas além da biblioteca `base`.

## Compilar, executar e testar

```bash
cabal build
cabal run previsao-desportiva   # demonstração: classificação, forma e previsões
cabal test                      # corre os testes das funções puras
```

## Estrutura

```
.
├── README.md
├── cabal.project
├── previsao-desportiva.cabal
├── src/
│   ├── Model.hs     # tipos: Jogo, Resultado, Estatisticas, Previsao
│   ├── Domain.hs    # funções puras (núcleo funcional)
│   └── Dados.hs     # dados de exemplo (fictícios)
├── app/
│   └── Main.hs      # demonstração em terminal
├── test/
│   └── Spec.hs      # testes
├── data/            # (reservado para ficheiros de dados — Fase 3)
└── docs/            # (reservado para o relatório final)
```

## Modelo de domínio (Fase 1)

| Tipo           | Descrição                                                        |
|----------------|------------------------------------------------------------------|
| `Equipa`       | Sinónimo de `String` (nome da equipa)                            |
| `Resultado`    | `Vitoria \| Empate \| Derrota`, do ponto de vista de uma equipa  |
| `Jogo`         | Record: id, jornada, equipa da casa, visitante, golos de cada lado |
| `Estatisticas` | Record: jogos, V/E/D, golos marcados e sofridos de uma equipa    |
| `Previsao`     | `PrevVitoriaCasa \| PrevEmpate \| PrevVitoriaFora`               |

## Funcionalidades da Fase 1

- Resultado de um jogo e pontuação (3/1/0).
- Pontos, golos marcados/sofridos e estatísticas completas por equipa.
- Classificação (pontos, diferença de golos, golos marcados, ordem alfabética).
- Forma recente (últimos *n* resultados).
- Previsão simples: compara a média de pontos por jogo das duas equipas,
  com um pequeno bónus para a equipa da casa.

Todas as funções do núcleo (`Domain`) são **puras** e a maioria é definida por
**recursão explícita** com *pattern matching* e *guards*. O único módulo com IO é `app/Main.hs`.

## Dados de teste

`Dados.historico` contém 12 jogos **fictícios** (4 equipas, 6 jornadas), apenas para demonstração.

## Próximos passos

- **Fase 2:** funções de ordem superior (`map`, `filter`, `foldr`), composição,
  validação de dados (`Maybe`/`Either`), por exemplo jogos com equipa a jogar contra si própria
  ou golos negativos, e melhoria do modelo de previsão.
- **Fase 3:** leitura de ficheiros (CSV), parsing, menu em terminal, relatórios e testes completos.
