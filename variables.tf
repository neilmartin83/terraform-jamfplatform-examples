variable "jamfplatform_base_url" {
  description = "The base URL for the Jamf Platform API. Example: https://us.apigw.jamf.com"
  sensitive   = true
  default     = ""
}

variable "jamfplatform_client_id" {
  description = "The Jamf Platform Client ID for authentication."
  sensitive   = true
  default     = ""
}

variable "jamfplatform_client_secret" {
  description = "The Jamf Platform Client secret for authentication."
  sensitive   = true
  default     = ""
}
