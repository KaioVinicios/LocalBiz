# Arquitetura do Projeto

O LocalBiz usa uma estrutura Flutter orientada por features, com bases
compartilhadas de tema e UI dentro de `core`. Como o projeto ainda é composto
principalmente por telas, as features mantêm apenas a camada de `presentation`
por enquanto. Adicionar `data` e `domain` somente quando a feature tiver acesso a
dados, repositórios, entidades ou casos de uso reais.

## Estrutura do Projeto

```plaintext
lib/
├── main.dart                         # Entrada do app e configuração do MaterialApp
├── core/                             # Blocos compartilhados do app
│   ├── router/                       # Enum de rotas e tabela de navegação
│   │   ├── app_route.dart
│   │   └── app_router.dart
│   ├── theme/                        # Cores, espaçamentos, raios, tamanhos e textos
│   │   ├── app_colors.dart
│   │   └── app_design_tokens.dart
│   └── ui/                           # Componentes reutilizáveis de apresentação
└── features/                         # Áreas de negócio e telas
    ├── auth/
    │   └── presentation/
    │       └── screens/
    │           ├── forgot_password_page.dart
    │           ├── login_page.dart
    │           └── register_page.dart
    ├── clientes/
    │   ├── domain/
    │   │   └── entities/
    │   │       └── cliente_model.dart
    │   └── presentation/
    │       ├── screens/
    │       │   ├── cliente_detalhe_page.dart
    │       │   └── clientes_page.dart
    │       └── widgets/
    │           ├── cliente_list_item.dart
    │           └── novo_cliente_form.dart
    ├── configuration/
    │   └── presentation/
    │       ├── models/
    │       │   └── mock_data.dart
    │       └── screens/
    │           ├── business_profile_page.dart
    │           ├── configuration_page.dart
    │           └── report_page.dart
    ├── produtos/
    │   ├── domain/
    │   │   └── entities/
    │   │       └── produto_model.dart
    │   └── presentation/
    │       ├── screens/
    │       │   ├── produto_estoque_page.dart
    │       │   ├── produto_form_page.dart
    │       │   └── produtos_page.dart
    │       └── widgets/
    │           ├── produto_image.dart
    │           ├── produto_list_item.dart
    │           ├── produto_photo_picker.dart
    │           ├── produto_photo_picker_stub.dart
    │           └── produto_photo_picker_web.dart
    ├── services/
    │   └── presentation/
    │       ├── screens/
    │       │   ├── dashboard_page.dart
    │       │   ├── service_create_page.dart
    │       │   ├── service_edit_page.dart
    │       │   ├── service_listing.dart
    │       │   ├── services_details.dart
    │       │   └── services_scheduling.dart
    │       └── widgets/
    │           └── service_form_fields.dart
    └── vendas/
        └── presentation/
            └── screens/
                └── venda_page.dart
```

## Responsabilidades das Pastas

### `core/theme`

Guarda constantes visuais reutilizáveis em todas as features:

- `AppColors`: paleta de cores e cores semânticas.
- `AppSpacing`, `AppRadii`, `AppSizes`, `AppTextStyles`: tokens de design usados
  por widgets compartilhados e telas de features.

### `core/router`

Centraliza a navegação nomeada do app:

- `AppRoute`: enum com os paths disponíveis.
- `AppRouter`: rota inicial e mapa de `WidgetBuilder` usado pelo `MaterialApp`.

### `core/ui`

Guarda widgets reutilizáveis que não dependem de um model específico de feature
ou de um fluxo de negócio. Exemplos no app atual:

- Botões: `AppPrimaryButton`, `AppSquareActionButton`.
- Campos: `AppTextField`, `AppOutlinedTextField`, `LabeledTextField`,
  `LabeledDropdown`, `LabeledDateField`.
- Navegação e estrutura visual de tela: `NavBar`, `NavBarButton`, `AppTopBar`.
- Cards genéricos: `AppListCard`.

### `features/<feature>/domain`

Guarda conceitos de negócio da feature que não dependem de Flutter UI, rotas ou
widgets. No estado atual do app, essa camada existe apenas onde já há entidades
compartilhadas entre telas/widgets:

- `clientes/domain/entities`: `Cliente` e `ClienteHistorico`.
- `produtos/domain/entities`: `Produto`.

### `features/<feature>/presentation`

Guarda telas, widgets locais de UI, models temporários, mocks visuais e
controllers/estado que atendem apenas aquela feature. As features atuais são:

- `auth`: telas de login, cadastro e recuperação de senha.
- `clientes`: lista de clientes, detalhes e formulário de cliente.
- `configuration`: configurações, perfil do negócio, relatórios e dados mockados
  de configuração. Os itens dessa feature permanecem em `presentation` porque
  usam `IconData` e `AppRoute`.
- `produtos`: lista, cadastro, edição, estoque, imagem e seleção de foto de
  produtos.
- `services`: dashboard, lista de serviços, detalhes de serviço, cadastro e
  edição/agendamento de serviço.
- `vendas`: fluxo de nova venda.

## Evolução Além de Presentation

Quando uma feature ganhar regra de negócio real ou acesso externo a dados,
adicionar apenas as camadas necessárias:

```plaintext
features/<feature>/
├── data/             # APIs, data sources locais, DTOs e implementações de repositório
├── domain/           # Entidades, contratos de repositório e casos de uso
└── presentation/     # Telas, widgets da feature e state/controllers
```
