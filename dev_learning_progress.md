# flutter feaure-first architecture
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

# getting android sha certificate fingerprint 
`keytool -list -v -keystore "C:\Users\USERNAME\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android`