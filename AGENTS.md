# Hack Club Visa Letter Generator

## Commands

### Development
```bash
# Start development server (runs web, js, css, and sidekiq)
bin/dev

# Run Rails server only
rails server

# Run Sidekiq worker
bundle exec sidekiq -C config/sidekiq.yml
```

### Database
```bash
rails db:create db:migrate db:seed
```

### Testing
```bash
# Run all tests
bundle exec rspec

# Run specific test file
bundle exec rspec spec/models/participant_spec.rb

# Run with documentation format
bundle exec rspec --format documentation
```

### Code Quality
```bash
# Run RuboCop
bundle exec rubocop

# Run Brakeman security scan
bundle exec brakeman
```

## Architecture

- **Framework**: Rails 7.2 with PostgreSQL
- **Background Jobs**: Sidekiq with Redis
- **PDF Generation**: Prawn
- **Styling**: Tailwind CSS 4.x
- **Frontend**: Hotwire (Turbo + Stimulus)
- **Authentication**: Devise (for admins)
- **Authorization**: Pundit

## Key Models

- `Admin` - Admin users who manage events and approve applications
- `Event` - Hack Club events that participants can apply for
- `LetterTemplate` - Templates for visa invitation letters
- `Participant` - People applying for visa letters
- `VisaLetterApplication` - The application linking participants to events
- `ActivityLog` - Audit trail for all actions

## Application Flow

1. Participant selects an event from the public events page
2. Fills out application form with personal details
3. Receives 6-digit verification code via email
4. Enters code to verify email ownership
5. Application goes to "pending_approval" status
6. Admin reviews and approves/rejects
7. If approved, PDF is generated and emailed to participant

## Admin Credentials (Development)

- Email: `admin@hackclub.com`
- Password: `password123`

## Environment Variables

See README.md section 15 for the complete list of required environment variables.
