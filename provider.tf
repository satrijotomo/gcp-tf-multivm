provider "google" {
    region = "us-east1" # Change if needed"
    zone = "us-east1-b" # Change if needed"
    credentials = file("~/Desktop/terraform-code/starry-battery-311303-e47b8df09b74.json")
    project = "starry-battery-311303"
}
