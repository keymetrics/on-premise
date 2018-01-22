resource "google_service_account" "keymetrics-backend-logs" {
  account_id   = "keymetrics-backend-logs-${var.environment}"
  display_name = "Keymetrics Backend - Logs for ${var.environment}"
}

resource "google_project_iam_policy" "allow_write_logs" {
  project     = "${var.project}"
  policy_data = "${data.google_iam_policy.logger.policy_data}"
}

data "google_iam_policy" "logger" {
  binding {
    role = "roles/logging.logWriter"

    members = [
      "serviceAccount:${google_service_account.keymetrics-backend-logs.email}",
    ]
  }
}
