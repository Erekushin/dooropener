// package main

// import (
// 	"encoding/json"
// 	"fmt"
// 	"net/http"
// )

// func main() {
// 	http.HandleFunc("/back", performOperationHandler)
// 	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
// 		fmt.Println("font code is appending")
// 		http.ServeFile(w, r, "front/index.html")
// 	})

// 	fmt.Println("Server is running on :9090...")
// 	http.ListenAndServe(":9090", nil)
// }

// func performOperationHandler(w http.ResponseWriter, r *http.Request) {
// 	// Perform your simple operation here.
// 	result := performSimpleOperation()

// 	// Prepare the response data.
// 	responseData := map[string]interface{}{
// 		"status":  "success",
// 		"message": "Operation performed successfully",
// 		"result":  result,
// 	}

// 	// Set the Content-Type header to JSON.
// 	w.Header().Set("Content-Type", "application/json")

// 	// Write the response data as JSON.
// 	json.NewEncoder(w).Encode(responseData)
// }

// func performSimpleOperation() string {
// 	// Replace this with your actual simple operation.
// 	// For example, you might perform a calculation, fetch data, etc.
// 	return "Result of the simple operation"
// }

package main

import (
	"fmt"
	"log"
	"net/http"
	"path"
)

func main() {
	// Create a new ServeMux (router)
	mux := http.NewServeMux()

	// Serve static files from the "front" directory
	staticDir := "./front/"
	mux.Handle(staticDir, http.StripPrefix(staticDir, http.FileServer(http.Dir("public"))))

	// Handle all requests by serving the index.html file
	mux.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Println("it is where is point to")
		http.ServeFile(w, r, path.Join("./front", "index.html"))
	})

	// Set up the server
	port := "9090"
	addr := ":" + port
	log.Printf("Golang server running on port %s...\n", port)

	// Start the server
	err := http.ListenAndServe(addr, mux)
	if err != nil {
		log.Fatalf("Server error: %v", err)
	}
}
