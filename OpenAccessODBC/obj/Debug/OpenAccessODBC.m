// This file contains your Data Connector logic
section OpenAccessODBC;

/* This is the method for connection to ODBC*/
[DataSource.Kind="OpenAccessODBC", Publish="OpenAccessODBC.Publish"]
shared OpenAccessODBC.Databases = (server as text,catalog as text) as table =>
      let
        ConnectionString = [
            Driver = "DataDirect OpenAccess SDK 8.1"
        ] & GetAddress(server),
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
        ]),
        // Filter with Catalog
       Database = OdbcDatasource{[Name=catalog,Kind="Database"]}[Data],
       OAUSER_Schema = Database{[Name="OAUSER",Kind="Schema"]}[Data]
    in
        OAUSER_Schema;


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

 GetAddress = (server as text) as record =>
            let
                Address = Uri.Parts("http://" & server),
                Port = if Address[Port] = 80 and not Text.EndsWith(server, ":80") then [] else [port = Address[Port]],
                Host = [host = Address[Host]],
                ConnectionString = Host & Port,
                Result =
                    if Address[Host] = ""
                        or Address[Scheme] <> "http"
                        or Address[Path] <> "/"
                        or Address[Query] <> []
                        or Address[Fragment] <> ""
                        or Address[UserName] <> ""
                        or Address[Password] <> ""
                        or Text.StartsWith(server, "http:/", Comparer.OrdinalIgnoreCase) then
                        error "Invalid server name"
                    else
                        ConnectionString
            in
                Result;
