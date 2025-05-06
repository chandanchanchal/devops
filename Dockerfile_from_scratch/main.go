func toRadians(deg float64) float64 {
	return deg * math.Pi / 180
}

func haversine(lat1, lon1, lat2, lon2 float64) float64 {
	dLat := toRadians(lat2 - lat1)
	dLon := toRadians(lon2 - lon1)

	a := math.Sin(dLat/2)*math.Sin(dLat/2) +
		math.Cos(toRadians(lat1))*math.Cos(toRadians(lat2))*
			math.Sin(dLon/2)*math.Sin(dLon/2)

	c := 2 * math.Atan2(math.Sqrt(a), math.Sqrt(1-a))
	return earthRadiusKm * c
}

func handler(w http.ResponseWriter, r *http.Request) {
	q := r.URL.Query()
	lat1, _ := strconv.ParseFloat(q.Get("lat1"), 64)
	lon1, _ := strconv.ParseFloat(q.Get("lon1"), 64)
	lat2, _ := strconv.ParseFloat(q.Get("lat2"), 64)
	lon2, _ := strconv.ParseFloat(q.Get("lon2"), 64)

	dist := haversine(lat1, lon1, lat2, lon2)
	fmt.Fprintf(w, "Distance: %.2f km\n", dist)
}

func main() {
	http.HandleFunc("/distance", handler)
	log.Println("Server is running on port 8080...")
	log.Fatal(http.ListenAndServe(":8080", nil))
}
