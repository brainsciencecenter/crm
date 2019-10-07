

output "project_id"{
  description = "The project id for the host project."
  value       = google_project.project.number
}
