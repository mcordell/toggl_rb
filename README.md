# TogglRb

[![Ruby](https://github.com/mcordell/toggl_rb/actions/workflows/ruby.yml/badge.svg)](https://github.com/mcordell/toggl_rb/actions/workflows/ruby.yml)
[![Coverage Status](https://coveralls.io/repos/github/mcordell/toggl_rb/badge.svg)](https://coveralls.io/github/mcordell/toggl_rb)
[![Gem Version](https://badge.fury.io/rb/toggl_rb.svg)](https://badge.fury.io/rb/toggl_rb.svg)

> A ruby API client for toggl's V9 API and V3 Reports API.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add toggl_rb

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install toggl_rb

## Usage

### Authentication

To use the Toggl API you need an API token, this can be found on the [profile settings page](https://track.toggl.com/profile).

You can then setup the token for all instances of TogglRb's connections to the API:

```ruby
# Assuming API token is stored in an environmental variable, this will setup an API token for all TogglRb connections
TogglRb.config.api_token = ENV.fetch("TOGGL_API_TOKEN", "")

# Alternatively, if you need more granular control you can set up a connection and endpoints with a token:
core_connection = TogglRb::Connection.core_connection
core_connection.api_token = ENV.fetch("TOGGL_API_TOKEN_TWO", "")
projects_endpoint = TogglRb::Core::Projects.new(core_connection)
# projects_endpoint requests will use TOGGL_API_TOKEN_TWO rather than TOGGL_API_TOKEN setup globally
```

## Endpoints

Currently TogglRb only supports a select subset of endpoints:

| Group        | Endpoint                                                                                                                | Status |
| ------------ | ----------------------------------------------------------------------------------------------------------------------- | :----: |
| Me           | [GET Me](https://engineering.toggl.com/docs/api/me/index.html#get-me)                                                   |   ✔️   |
| Me           | [PUT Me](https://engineering.toggl.com/docs/api/me/index.html#put-me)                                                   |   ✔️   |
| Me           | [GET Clients](https://engineering.toggl.com/docs/api/me/index.html#get-clients)                                         |   🔲   |
| Me           | [GET Features](https://engineering.toggl.com/docs/api/me/index.html#get-features)                                       |   🔲   |
| Me           | [GET User's last known location](https://engineering.toggl.com/docs/api/me/index.html#get-users-last-known-location)    |   🔲   |
| Me           | [GET Logged](https://engineering.toggl.com/docs/api/me/index.html#get-logged)                                           |   🔲   |
| Me           | [GET Organizations that a user is part of][org-user-is-apart-of]                                                        |   🔲   |
| Me           | [GET Projects](https://engineering.toggl.com/docs/api/me/index.html#get-projects)                                       |   🔲   |
| Me           | [GET ProjectsPaginated](https://engineering.toggl.com/docs/api/me/index.html#get-projectspaginated)                     |   🔲   |
| Me           | [GET Tags](https://engineering.toggl.com/docs/api/me/index.html#get-tags)                                               |   🔲   |
| Me           | [GET Tasks](https://engineering.toggl.com/docs/api/me/index.html#get-tasks)                                             |   🔲   |
| Me           | [GET TrackReminders](https://engineering.toggl.com/docs/api/me/index.html#get-trackreminders)                           |   🔲   |
| Me           | [GET WebTimer](https://engineering.toggl.com/docs/api/me/index.html#get-webtimer)                                       |   🔲   |
| Me           | [GET Workspaces](https://engineering.toggl.com/docs/api/me/index.html#get-workspaces)                                   |   🔲   |
| Groups       | [GET List of groups in a workspace within an organization with user assignments][group-doc]                             |   ✔️   |
| ProjectUsers | [GET Get workspace projects users][get-workspace-project-users]                                                         |   🔲   |
| ProjectUsers | [POST Add an user into workspace projects users][add-project-user]                                                      |   🔲   |
| ProjectUsers | [PATCH Patch project users from workspace][patch-project-user]                                                          |   🔲   |
| ProjectUsers | [PUT Update an user into workspace projects users][update-project-user]                                                 |   🔲   |
| ProjectUsers | [DELETE Delete a project user from workspace projects users][delete-project-user]                                       |   🔲   |
| Projects     | [GET WorkspaceProjects](https://engineering.toggl.com/docs/api/projects/index.html#get-workspaceprojects)               |   🔲   |
| Projects     | [PATCH WorkspaceProjects](https://engineering.toggl.com/docs/api/projects/index.html#patch-workspaceprojects)           |   ✔️   |
| Projects     | [POST WorkspaceProjects](https://engineering.toggl.com/docs/api/projects/index.html#post-workspaceprojects)             |   ✔️   |
| Projects     | [GET WorkspaceProject](https://engineering.toggl.com/docs/api/projects/index.html#get-workspaceproject)                 |   ✔️   |
| Projects     | [PUT WorkspaceProject](https://engineering.toggl.com/docs/api/projects/index.html#put-workspaceproject)                 |   ✔️   |
| Projects     | [DELETE WorkspaceProject](https://engineering.toggl.com/docs/api/projects/index.html#delete-workspaceproject)           |   ✔️   |
| Users        | [GET List of users who belong to the given workspace](workspace-users-doc)                                              |   ✔️   |
| TimeEntries  | [GET TimeEntries](https://engineering.toggl.com/docs/api/time_entries/index.html#get-timeentries)                       |   ✔️   |
| TimeEntries  | [GET Get current time entry](https://engineering.toggl.com/docs/api/time_entries/index.html#get-get-current-time-entry) |   ✔️   |
| TimeEntries  | [GET Get a time entry by ID](https://engineering.toggl.com/docs/api/time_entries/index.html#get-get-a-time-entry-by-id) |   ✔️   |
| TimeEntries  | [POST TimeEntries](https://engineering.toggl.com/docs/api/time_entries/index.html#post-timeentries)                     |   ✔️   |
| TimeEntries  | [PATCH Bulk editing time entries][bulk-edit-time-entries]                                                               |   ✔️   |
| TimeEntries  | [PUT TimeEntries](https://engineering.toggl.com/docs/api/time_entries/index.html#put-timeentries)                       |   ✔️   |
| TimeEntries  | [DELETE TimeEntries](https://engineering.toggl.com/docs/api/time_entries/index.html#delete-timeentries)                 |   ✔️   |
| TimeEntries  | [PATCH Stop TimeEntry](https://engineering.toggl.com/docs/api/time_entries/index.html#patch-stop-timeentry)             |   ✔️   |
| Workspaces   | [POST Create a new workspace](https://engineering.toggl.com/docs/api/workspaces/index.html#post-create-a-new-workspace) |   🔲   |
| Workspaces   | [GET List of users who belong to the given workspace][list-users]                                                       |   🔲   |
| Workspaces   | [PATCH Changes the users in a workspace][change-user-in-workspace]                                                      |   🔲   |
| Workspaces   | [POST Workspaces](https://engineering.toggl.com/docs/api/workspaces/index.html#post-workspaces)                         |   🔲   |
| Workspaces   | [GET Get single workspace](https://engineering.toggl.com/docs/api/workspaces/index.html#get-get-single-workspace)       |   ✔️   |
| Workspaces   | [PUT Update workspace](https://engineering.toggl.com/docs/api/workspaces/index.html#put-update-workspace)               |   🔲   |
| Workspaces   | [POST Alerts](https://engineering.toggl.com/docs/api/workspaces/index.html#post-alerts)                                 |   🔲   |
| Workspaces   | [DELETE Alerts](https://engineering.toggl.com/docs/api/workspaces/index.html#delete-alerts)                             |   🔲   |
| Workspaces   | [GET Workspace statistics](https://engineering.toggl.com/docs/api/workspaces/index.html#get-workspace-statistics)       |   🔲   |
| Workspaces   | [GET Get workspace time entry constraints][time-constraints]                                                            |   🔲   |
| Workspaces   | [GET TrackReminders](https://engineering.toggl.com/docs/api/workspaces/index.html#get-trackreminders)                   |   🔲   |
| Workspaces   | [POST TrackReminders](https://engineering.toggl.com/docs/api/workspaces/index.html#post-trackreminders)                 |   🔲   |
| Workspaces   | [PUT TrackReminder](https://engineering.toggl.com/docs/api/workspaces/index.html#put-trackreminder)                     |   🔲   |
| Workspaces   | [DELETE TrackReminder](https://engineering.toggl.com/docs/api/workspaces/index.html#delete-trackreminder)               |   🔲   |
| Workspaces   | [GET Get workspace users](https://engineering.toggl.com/docs/api/workspaces/index.html#get-get-workspace-users)         |   🔲   |
| Workspaces   | [PUT Update workspace user](https://engineering.toggl.com/docs/api/workspaces/index.html#put-update-workspace-user)     |   🔲   |
| Workspaces   | [POST Change a lost password][change-a-lost-password]                                                                   |   🔲   |
| Workspaces   | [DELETE Delete workspace user][delete-workspace-user]                                                                   |   🔲   |

On The Reporting Endpoints

| Group    | Endpoint                                                                                                                                    | Status |
| -------- | ------------------------------------------------------------------------------------------------------------------------------------------- | :----: |
| Detailed | [POST Search time entries](https://engineering.toggl.com/docs/reports/detailed_reports/index.html/post-search-time-entries)                 |   ✔️   |
| Detailed | [POST Export detailed report](https://engineering.toggl.com/docs/reports/detailed_reports/index.html/post-export-detailed-report)           |   🔲   |
| Detailed | [POST Export detailed report](https://engineering.toggl.com/docs/reports/detailed_reports/index.html/post-export-detailed-report-1)         |   🔲   |
| Detailed | [POST Load totals detailed report](https://engineering.toggl.com/docs/reports/detailed_reports/index.html/post-load-totals-detailed-report) |   🔲   |
| Summary  | [POST List project users](https://engineering.toggl.com/docs/reports/summary_reports/index.html/post-list-project-users)                    |   🔲   |
| Summary  | [POST Load project summary](https://engineering.toggl.com/docs/reports/summary_reports/index.html/post-load-project-summary)                |   🔲   |
| Summary  | [POST Search time entries](https://engineering.toggl.com/docs/reports/summary_reports/index.html/post-search-time-entries)                  |   ✔️   |
| Summary  | [POST Export summary report](https://engineering.toggl.com/docs/reports/summary_reports/index.html/post-export-summary-report)              |   🔲   |
| Summary  | [POST Export summary report](https://engineering.toggl.com/docs/reports/summary_reports/index.html/post-export-summary-report-1)            |   🔲   |

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mcordell/toggl_rb.

[group-doc]: https://engineering.toggl.com/docs/api/groups/index.html#get-list-of-groups-in-a-workspace-within-an-organization-with-user-assignments
[workspace-users-doc]: https://engineering.toggl.com/docs/api/workspaces/index.html#get-list-of-users-who-belong-to-the-given-workspace
[list-users]: https://engineering.toggl.com/docs/api/workspaces/index.html#get-list-of-users-who-belong-to-the-given-workspace
[time-constraints]: https://engineering.toggl.com/docs/api/workspaces/index.html#get-get-workspace-time-entry-constraints
[org-user-is-apart-of]: https://engineering.toggl.com/docs/api/me/index.html#get-organizations-that-a-user-is-part-of
[delete-project-user]: https://engineering.toggl.com/docs/api/projects/index.html#delete-delete-a-project-user-from-workspace-projects-users
[update-project-user]: https://engineering.toggl.com/docs/api/projects/index.html#put-update-an-user-into-workspace-projects-users
[patch-project-user]: https://engineering.toggl.com/docs/api/projects/index.html#patch-patch-project-users-from-workspace
[add-project-user]: https://engineering.toggl.com/docs/api/projects/index.html#post-add-an-user-into-workspace-projects-users
[change-user-in-workspace]: https://engineering.toggl.com/docs/api/workspaces/index.html#patch-changes-the-users-in-a-workspace
[bulk-edit-time-entries]: https://engineering.toggl.com/docs/api/time_entries/index.html#patch-bulk-editing-time-entries
[get-workspace-project-users]: https://engineering.toggl.com/docs/api/projects/index.html#get-workspace-projects-users
[delete-workspace-user]: https://engineering.toggl.com/docs/api/workspaces/index.html#delete-delete-workspace-user
[change-a-lost-password]: https://engineering.toggl.com/docs/api/workspaces/index.html#post-change-a-lost-password
