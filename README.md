# Pousada App

## Description

This project is a web application for managing guesthouses. It allows guesthouse owners to register their guesthouses, manage rooms, and handle bookings. It also allows users to search for guesthouses, book rooms, and make payments.
It's a project from the treinaDev Bootcamp from [Campus Code school](https://www.campuscode.com.br/inicio).

## Features

- User registration and authentication
- Guesthouse registration
- Room management
- Booking system
- Payment system

## Technologies Used

- Ruby version 3.0.0
- Ruby on Rails version 7.1.1
- Devise for authentication
- SQLite3 for database
- RSpec for testing
- Capybara for testing

## Setup

To run this project locally, follow these steps:

1. Clone the repository: `git clone git@github.com:DanSmaR/guesthouse_app.git`
2. Navigate to the project directory: `cd projectname`
3. Install dependencies: `bundle install`
4. Drop the database: `rails db:drop`
5. Set up the database: `rails db:create db:migrate`
6. Seed the database: `rails db:seed`
7. Start the server: `rails server`

## Testing

To run the tests, run `rspec` in the project directory.

## Login

The database is seeded with a default user with the following credentials:

**User 1**
- name: João
- email: joao@email.com
- password: password

**User 2**
- name: Maria
- email: maria@email.com
- password: password

The user João already has a complete profile, with a guesthouse, rooms and rooms_rates.
The user Maria has only guesthouse and rooms.

## Contributing

Contributions are welcome. Please open a pull request with your changes.

## License

This project is licensed under the MIT License.