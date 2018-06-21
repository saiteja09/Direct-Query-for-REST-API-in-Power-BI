// This file contains your Data Connector logic
section OpenAccessODBC;

/* This is the method for connection to ODBC*/
[DataSource.Kind="OpenAccessODBC", Publish="OpenAccessODBC.Publish"]
shared OpenAccessODBC.Databases = (dsn as text) as table =>
      let
        ConnectionString = [
            DSN=dsn
        ],
        OdbcDatasource = Odbc.DataSource(ConnectionString, [
            HierarchicalNavigation = true,
            TolerateConcatOverflow = true,
            SqlCapabilities = [
                SupportsTop = true,
                Sql92Conformance = 8,
                SupportsNumericLiterals = true,
                SupportsStringLiterals = true,
                SupportsOdbcDateLiterals = true,
                SupportsOdbcTimeLiterals = true,
                SupportsOdbcTimestampLiterals = true
            ],
            SQLGetFunctions = [
                // Disable using parameters in the queries that get generated.
                // We enable numeric and string literals which should enable literals for all constants.
                SQL_API_SQLBINDPARAMETER = false
            ]
        ])

        in OdbcDatasource;


// Data Source Kind description
OpenAccessODBC = [
 // Authentication Type
    Authentication = [
        Implicit = []
    ],
    Label = Extension.LoadString("DataSourceLabel")
];

// Data Source UI publishing description
OpenAccessODBC.Publish = [
    Category = "Database",
    ButtonText = { Extension.LoadString("ButtonTitle"), Extension.LoadString("ButtonHelp") },
    LearnMoreUrl = "https://powerbi.microsoft.com/",
    SourceImage = OpenAccessODBC.Icons,
    SourceTypeImage = OpenAccessODBC.Icons,
    // This is for Direct Query Support
    SupportsDirectQuery = true
];

OpenAccessODBC.Icons = [
    Icon16 = { Extension.Contents("OpenAccessODBC16.png"), Extension.Contents("OpenAccessODBC20.png"), Extension.Contents("OpenAccessODBC24.png"), Extension.Contents("OpenAccessODBC32.png") },
    Icon32 = { Extension.Contents("OpenAccessODBC32.png"), Extension.Contents("OpenAccessODBC40.png"), Extension.Contents("OpenAccessODBC48.png"), Extension.Contents("OpenAccessODBC64.png") }
];

