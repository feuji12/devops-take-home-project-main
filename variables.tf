variable "aws_region" {
  description = "AWS region to use"
  type        = string
  default     = "us-west-1"
}

variable "aws_access_key" {
  description = "AWS Access Key ID for the target AWS account"
  type        = string
  default     = "AGIB2LTR72GYZHUQN6PT"
}

variable "aws_secret_key" {
  description = "AWS Secret Key for the target AWS account"
  type        = string
  default     = "4rFhNY7fVqxxcs4gYh5kyKBR2DkyE8Cffh403oLw"
}

variable "aws_session_token" {
  description = "AWS Session Token for the target AWS account. Required only if authenticating using temporary credentials"
  type        = string
  default     = ""
}