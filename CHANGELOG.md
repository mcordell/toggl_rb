# 0.1.0 (April 14, 2024)

## Initial Release

### Adds Endpoints

- Core
  - Me
    - **GET me**
    - **GET me/workspaces**
  - Groups
    - **GET organizations/{organization_id}/workspace/{workspace_id}/groups**
  - Projects
    - **GET workspace/{workspace_id}/projects**
    - **POST workspace/{workspace_id}/users**
  - Users
    - **GET workspace/{workspace_id}/users**
  - Time Entries
    - **POST workspace/{workspace_id}/time_entries**
    - **PATCH workspace/{workspace_id}/time_entries/{time_entry_ids}**
- Reporting
  - Summary
    - **POST workspace/{workspace_id}/summary/time_entries**
  - **Detailed**
    - **POST workspace/{workspace_id}/search/time_entries**
