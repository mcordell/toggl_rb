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

Currently TogglRb only supports a select subset of endpoints:

| Group       | Endpoint                                                                                                                                  | Status |
| ----------- | ----------------------------------------------------------------------------------------------------------------------------------------- | :----: |
| Me          | [GET Me](https://engineering.toggl.com/docs/api/me/index.html#get-me)                                                                     |   ✔️   |
| Me          | [PUT Me](https://engineering.toggl.com/docs/api/me/index.html#put-me)                                                                     |   ✔️   |
| Me          | [GET Clients](https://engineering.toggl.com/docs/api/me/index.html#get-clients)                                                           |   🔲   |
| Me          | [GET Features](https://engineering.toggl.com/docs/api/me/index.html#get-features)                                                         |   🔲   |
| Me          | [GET User's last known location](https://engineering.toggl.com/docs/api/me/index.html#get-users-last-known-location)                      |   🔲   |
| Me          | [GET Logged](https://engineering.toggl.com/docs/api/me/index.html#get-logged)                                                             |   🔲   |
| Me          | [GET Organizations that a user is part of](https://engineering.toggl.com/docs/api/me/index.html#get-organizations-that-a-user-is-part-of) |   🔲   |
| Me          | [GET Projects](https://engineering.toggl.com/docs/api/me/index.html#get-projects)                                                         |   🔲   |
| Me          | [GET ProjectsPaginated](https://engineering.toggl.com/docs/api/me/index.html#get-projectspaginated)                                       |   🔲   |
| Me          | [GET Tags](https://engineering.toggl.com/docs/api/me/index.html#get-tags)                                                                 |   🔲   |
| Me          | [GET Tasks](https://engineering.toggl.com/docs/api/me/index.html#get-tasks)                                                               |   🔲   |
| Me          | [GET TrackReminders](https://engineering.toggl.com/docs/api/me/index.html#get-trackreminders)                                             |   🔲   |
| Me          | [GET WebTimer](https://engineering.toggl.com/docs/api/me/index.html#get-webtimer)                                                         |   🔲   |
| Me          | [GET Workspaces](https://engineering.toggl.com/docs/api/me/index.html#get-workspaces)                                                     |   🔲   |
| Groups      | [GET List of groups in a workspace within an organization with user assignments][group-doc]                                               |   ✔️   |
| Projects    | [GET WorkspaceProjects](https://engineering.toggl.com/docs/api/projects#get-workspaceprojects)                                            |   ✔️   |
| Projects    | [POST WorkspaceProjects](https://engineering.toggl.com/docs/api/projects#post-workspaceprojects)                                          |   ✔️   |
| Users       | [GET List of users who belong to the given workspace](workspace-users-doc)                                                                |   ✔️   |
| TimeEntries | [GET TimeEntries](https://engineering.toggl.com/docs/api/time_entries#get-timeentries)                                                    |   🔲   |
| TimeEntries | [GET Get current time entry](https://engineering.toggl.com/docs/api/time_entries#get-get-current-time-entry)                              |   🔲   |
| TimeEntries | [GET Get a time entry by ID](https://engineering.toggl.com/docs/api/time_entries#get-get-a-time-entry-by-id)                              |   🔲   |
| TimeEntries | [POST TimeEntries](https://engineering.toggl.com/docs/api/time_entries#post-timeentries)                                                  |   ✔️   |
| TimeEntries | [PATCH Bulk editing time entries](https://engineering.toggl.com/docs/api/time_entries#patch-bulk-editing-time-entries)                    |   ✔️   |
| TimeEntries | [PUT TimeEntries](https://engineering.toggl.com/docs/api/time_entries#put-timeentries)                                                    |   🔲   |
| TimeEntries | [DELETE TimeEntries](https://engineering.toggl.com/docs/api/time_entries#delete-timeentries)                                              |   🔲   |
| TimeEntries | [PATCH Stop TimeEntry](https://engineering.toggl.com/docs/api/time_entries#patch-stop-timeentry)                                          |   🔲   |

On The Reporting Endpoints

| Group    | Endpoint                                                                                                                         | Status |
| -------- | -------------------------------------------------------------------------------------------------------------------------------- | :----: |
| Detailed | [POST Search time entries](https://engineering.toggl.com/docs/reports/detailed_reports#post-search-time-entries)                 |   ✔️   |
| Detailed | [POST Export detailed report](https://engineering.toggl.com/docs/reports/detailed_reports#post-export-detailed-report)           |   🔲   |
| Detailed | [POST Export detailed report](https://engineering.toggl.com/docs/reports/detailed_reports#post-export-detailed-report-1)         |   🔲   |
| Detailed | [POST Load totals detailed report](https://engineering.toggl.com/docs/reports/detailed_reports#post-load-totals-detailed-report) |   🔲   |
| Summary  | [POST List project users](https://engineering.toggl.com/docs/reports/summary_reports#post-list-project-users)                    |   🔲   |
| Summary  | [POST Load project summary](https://engineering.toggl.com/docs/reports/summary_reports#post-load-project-summary)                |   🔲   |
| Summary  | [POST Search time entries](https://engineering.toggl.com/docs/reports/summary_reports#post-search-time-entries)                  |   ✔️   |
| Summary  | [POST Export summary report](https://engineering.toggl.com/docs/reports/summary_reports#post-export-summary-report)              |   🔲   |
| Summary  | [POST Export summary report](https://engineering.toggl.com/docs/reports/summary_reports#post-export-summary-report-1)            |   🔲   |

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mcordell/toggl_rb.

[group-doc]: https://engineering.toggl.com/docs/api/groups#get-list-of-groups-in-a-workspace-within-an-organization-with-user-assignments
[workspace-users-doc]: https://engineering.toggl.com/docs/api/workspaces#get-list-of-users-who-belong-to-the-given-workspace
