import SwiftSQL

let sql = SQL.open(.Postgre, connectionString: "user=test dbname=tuanphung sslmode=disable")

if (sql.status() == .Connected) {
	print("Connected postgre database...")

	print(sql.execute("select * from place"))
}
