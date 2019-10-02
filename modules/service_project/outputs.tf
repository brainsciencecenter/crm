
output "project_id" {
  description = "The project id for the service project."
  value       = google_project.project.number
}
