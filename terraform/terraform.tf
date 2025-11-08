# Module Title:         Network Systems and Administration
# Module Code:          B9IS121
# Module Instructor:    Kingsley Ibomo
# Assessment Title:     Automated Container Deployment and Administration in the Cloud
# Assessment Number:    1
# Assessment Type:      Practical
# Assessment Weighting: 60%
# Assessment Due Date:  Sunday, 9 November 2025, 8:36 AM
# Student Name:         Mateus Fonseca Campos
# Student ID:           20095949
# Student Email:        20095949@mydbs.ie
# GitHub Repo:          https://github.com/20095949-mateus-campos/networking-ca1

# This file belongs to Part 1: Infrastructure Setup

# Tells Terraform to install all required providers to run the main script
terraform {
  required_providers {
    aws = { # Amazon Web Services (AWS): the cloud infrastructure provider
      source  = "hashicorp/aws"
      version = "~> 6.18.0"
    }

    local = { # Terraform module for handling local files
      source  = "hashicorp/local"
      version = "~> 2.5.3"
    }

    tls = { # Terraform module for handling encryption tasks
      source  = "hashicorp/tls"
      version = "~> 4.1.0"
    }

    http = { # Terraform module for handling HTTP requests
      source  = "hashicorp/http"
      version = "~> 3.5.0"
    }

    null = { # Terraform module for performing operations without creating/destroying resources
      source  = "hashicorp/null"
      version = "~> 3.2.4"
    }
  }

  required_version = ">= 1.13.4"
}
