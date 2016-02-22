# SwiftSQL
Currently, SwiftSQL support `PostgreSQL`, `MySQL` and `SQLite` are coming soon.

## Install
```swift
.Package(url: "https://github.com/tuanphung/SwiftSQL", majorVersion: 1)
```

Ensure that you have installed `libpq` (http://www.postgresql.org/download/)

## Usage
```swift
import SwiftSQL

let sql = SQL.open(.Postgre, connectionString: "user=test dbname=tuanphung sslmode=disable")

if (sql.status() == .Connected) {
	print("Connected postgre database...")
	
	// Execute query
	sql.execute("select * from tableName")
}
```
