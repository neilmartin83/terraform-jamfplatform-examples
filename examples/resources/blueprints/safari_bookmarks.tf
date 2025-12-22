# Safari Bookmarks
resource "jamfplatform_blueprints_blueprint" "safari_bookmarks" {
  name        = "Safari Bookmarks"
  description = "Managed by Terraform"

  device_groups = [jamfplatform_device_group.demo_computer_group.id]

  safari_bookmarks {
    managed_bookmarks {
      group_identifier = "work-bookmarks"
      title            = "Work Bookmarks"
      bookmarks {
        type  = "bookmark"
        title = "Company Portal"
        url   = "https://portal.company.com"
      }
      bookmarks {
        type  = "bookmark"
        title = "Internal Wiki"
        url   = "https://wiki.company.com"
      }
      bookmarks {
        type  = "folder"
        title = "Development Tools"
        folder {
          title = "GitHub"
          url   = "https://github.com"
        }
        folder {
          title = "Stack Overflow"
          url   = "https://stackoverflow.com"
        }
      }
    }
  }
}
