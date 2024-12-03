import { defineConfig } from 'kysely-ctl'
import { Kysely, PostgresDialect } from 'kysely'
import pg from 'pg'

// Pretend that this is fetching a value from a secret manager
const response = await fetch('https://httpbin.org/get')
const dbPassword = await response.json()

const connection: pg.ClientConfig = {
	database: 'database',
	host: 'localhost',
	user: 'user',
	password: 'password', // dbPassword would be used here
	port: 5432,
}

const dialect = new PostgresDialect({
	pool: new pg.Pool({
		...connection,
		max: 10,
	})
})

export const db = new Kysely({ dialect })

// Code above this line would typically be imported from another file,
// but I included it here to make this example as minimal as possible
export default defineConfig({
	kysely: db,
	migrations: {
		migrationFolder: 'migrations',
	},
})
