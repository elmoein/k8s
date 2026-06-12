package main

import (
	"database/sql"
	"fmt"
	"log"
	"os"

	_ "github.com/go-sql-driver/mysql"
	"github.com/gofiber/fiber/v2"
)

func main() {
	host := getEnv("DB_HOST", "mysql-db-pxc-db-haproxy.mysql.svc.cluster.local")
	port := getEnv("DB_PORT", "3306")
	user := getEnv("DB_USER", "root")
	pass := getEnv("DB_PASSWORD", "") 

	dsn := fmt.Sprintf("%s:%s@tcp(%s:%s)/", user, pass, host, port)

	db, err := sql.Open("mysql", dsn)
	if err != nil {
		log.Fatal("Failed to open DB:", err)
	}
	defer db.Close()

	app := fiber.New()

	app.Get("/health", func(c *fiber.Ctx) error {
		err := db.Ping()
		if err != nil {
			return c.Status(500).JSON(fiber.Map{
				"status":  "error",
				"message": "Cannot connect to database: " + err.Error(),
			})
		}

		var version string
		err = db.QueryRow("SELECT VERSION()").Scan(&version)
		if err != nil {
			return c.Status(500).JSON(fiber.Map{
				"status":  "error",
				"message": "Failed to execute query: " + err.Error(),
			})
		}

		return c.JSON(fiber.Map{
			"status":  "success",
			"message": "Connected to MySQL via HAProxy successfully!",
			"version": version,
		})
	})

	log.Println("Server running on :3000")
	log.Fatal(app.Listen(":3000"))
}

func getEnv(key, fallback string) string {
	if value, exists := os.LookupEnv(key); exists {
		return value
	}
	return fallback
}