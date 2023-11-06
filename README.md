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

- Ruby on Rails
- Devise for authentication
- SQLite3 for database

## Setup

To run this project locally, follow these steps:

1. Clone the repository: `git clone git@github.com:DanSmaR/guesthouse_app.git`
2. Navigate to the project directory: `cd projectname`
3. Install dependencies: `bundle install`
4. Setup the database: `rails db:create db:migrate`
5. Start the server: `rails server`

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