import SwiftSQL

let sql = SQL.open(.Postgre, connectionString: "user=test dbname=tuanphung sslmode=disable")

if sql.connected {
	print("Connected postgre database...")

	print(sql.execute("select * from place where name = $1 AND note LIKE '%%' || $2 || '%%'", parameters: "hometown2", "this is"))
}
