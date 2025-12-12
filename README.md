# Trabalho de Fundamento de Banco de Dados

**Disciplina:** Fundamento de Banco de Dados  
**Período:** 2025/2  
**Instituição:** UFRGS (Universidade Federal do Rio Grande do Sul)

## Alunos

- Joel Soares González
- Milena Silva Braga

## Tema

🌱 **Hortas Urbanas Comunitárias** 🌱

## Universo do Discurso (UdD)

O municípi pretende gerenciar um sistema integrado de hortas urbanas comunitárias, permitindo a coordenação de múltiplas hortas distribuídas em diferentes bairros, o gerenciamento de lotes individuais, responsabilidades de cultivo e manutenção, além da organização de eventos comunitários.

### Componentes principais:

**Hortas:** Espaços urbanos comunitários localizados em diferentes bairros (ex: Rua das Flores, Avenida Brasil, Rua Independência), cada uma com data de fundação e endereço.

**Lotes:** Subdivisions dentro de cada horta, com área específica (em m²), status (ativo, inativo, em manutenção). Cada lote pode hospedar múltiplas plantações.

**Responsáveis:** Pessoas físicas (com CPF) ou instituições (com CNPJ) que se responsabilizam pela manutenção e cultivo dos lotes. Cada responsável pode estar associado a múltiplos lotes e em períodos distintos (data_início e data_fim), permitindo histórico de responsabilidades.

**Espécies:** Plantas cultivadas nas hortas, categorizadas em tipos (Alimentícia, Ornamental, Repelente, PANC, Outros), com marcação se são tóxicas. Exemplos: tomate, alface, girassol, arruda, bertalha, rosa.

**Plantios:** Registros de quando uma espécie é plantada em um lote, incluindo quantidade de mudas, data de plantio, previsão de colheita e status (crescendo, pronto para colheita, colhido, perdido).

**Manutenção:** Atividades de cuidado dos lotes (limpeza, rega, adubação, poda, controle de pragas), realizadas por responsáveis, com data, descrição e custo.

**Eventos:** Atividades comunitárias (oficinas, plantios coletivos, colheitas) organizadas por responsáveis em hortas específicas para engajar a comunidade.

### Relacionamentos principais:

- Cada horta contém múltiplos lotes (1:N)
- Cada lote tem múltiplos responsáveis ao longo do tempo (N:N com atributo: período)
- Cada lote pode ter múltiplas espécies plantadas (N:N com atributos: quantidade, data, status)
- Cada lote requer múltiplas manutenções (1:N)
- Cada horta organiza múltiplos eventos (1:N)

Este modelo permite rastrear o histórico completo de cada lote, quem o mantém, o que foi plantado, quando será colhido e quanto custa mantê-lo — essencial para gerenciar eficientemente as hortas comunitárias.

## Diagrama Entidade-Relacionamento (ER)

### Entidades implementadas (10 total):

1. **horta** (id, endereco, fundado_em)
2. **lote** (id, id_horta, area, status) → FK para horta
3. **responsavel** (id, nome, endereco, contato) — supertype
4. **pessoa_fisica** (id, cpf) — subtype de responsavel (1:1)
5. **instituicao** (id, cnpj, nome_representante) — subtype de responsavel (1:1)
6. **especie** (id, nome, categoria, toxica)
7. **evento** (id, id_responsavel, id_horta, nome, data) → FK para responsavel e horta
8. **lote_responsavel** (id_lote, id_responsavel, data_inicio, data_fim) — N:N com atributo
9. **manutencao** (id, id_lote, id_responsavel, data, descricao, custo) → FK para lote e responsavel
10. **plantio** (id_lote, id_especie, data, quantidade, previsao, status) — N:N com atributo

### Características implementadas:

- **6+ entidades**
- **Relacionamentos N:N com atributos**: lote_responsavel (período), plantio (quantidade, previsão)
- **Hierarquia de especialização**: responsavel (pessoa_fisica, instituicao)
- **Constraints de domínio**: CHECK para status, categoria, valores não-negativos
- **Integridade referencial**: FK com ON DELETE CASCADE/SET NULL conforme apropriado

## Estrutura do Repositório

```
Trabalho/
├── README.md                      # Este arquivo
├── sql/
│   ├── schema.sql                 # DDL: criação de tabelas, FKs, constraints, indexes
│   ├── entities.sql               # Dados fictícios (3+ instâncias por entidade)
│   └── queries.sql                # 1 visão + 6 consultas conforme requisitos
└── diagrams/                      # Diagramas e documentação do modelo ER
```

## Dados de Exemplo

O projeto inclui dados fictícios realistas:
- **3 hortas** em diferentes bairros de Porto Alegre
- **6 responsáveis** (3 pessoas físicas, 3 instituições)
- **6 lotes** com diferentes áreas e status
- **6 espécies** (alimentícia, ornamental, repelente, PANC)
- **3 eventos** comunitários
- **6+ registros** de manutenção e plantio

## Objetivos do Projeto

1. Modelar o banco de dados para o sistema de hortas urbanas comunitárias
2. Criar um diagrama ER que represente fielmente o universo do discurso
3. Garantir a integridade e consistência dos dados através de relacionamentos adequados
4. Facilitar o gerenciamento de lotes, responsáveis e atividades comunitárias
5. Fornecer visões e consultas para análise operacional das hortas

---

**UFRGS - 2025/2**
