lib/
│
└── features/
    └── authentication/
        ├── data/
        │   ├── data_sources/      # Direct API or local DB calls
        │   └── repositories/      # IMPLEMENTATION: AuthRepositoryImpl
        ├── domain/
        │   ├── models/            # Pure data structures
        │   └── repositories/      # ABSTRACT CONTRACTS: AuthRepository interface
        └── presentation/          # Screens, Widgets, and Controllers/Blocs