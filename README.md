# API Documentation

<details>
<summary>Guesthouses API</summary>

## Guesthouses API

### GET /api/v1/guesthouses

This endpoint returns a list of all active guesthouses.

#### Response

Returns a JSON array of guesthouses. Each object in the array contains the following properties:

- `brand_name`: The brand name of the guesthouse.
- `phone_number`: The phone number of the guesthouse.
- `email`: The email of the guesthouse.
- `description`: The description of the guesthouse.
- `pets`: A boolean indicating whether pets are allowed.
- `use_policy`: The use policy of the guesthouse.
- `checkin_hour`: The check-in hour of the guesthouse.
- `checkout_hour`: The checkout hour of the guesthouse.
- `active`: A boolean indicating whether the guesthouse is active.
- `address`: An object containing the address of the guesthouse.
- `payment_methods`: An array of payment methods available at the guesthouse.
- `average_rating`: The average rating of the guesthouse.

#### Parameters

- `search`: (Optional) A string to filter guesthouses by name. 
  - **Example Request**
    - ```sh
        curl -X GET "http://localhost:3000/api/v1/guesthouses?search=ana"
        ```
  - **Example Response**
    - ```json
      [
        {
          "id": 7,
          "brand_name": "Pousada Serrana",
          "phone_number": "01598308183",
          "email": "contato@serrana.com.br",
          "address_id": 7,
          "guesthouse_owner_id": 7,
          "description": "Descrição da Pousada Serrana",
          "pets": false,
          "use_policy": "Não é permitido fumar nas dependências da pousada",
          "checkout_hour": "12:00",
          "active": true,
          "address": {
            "id": 7,
            "street": "Avenida 0, 0000",
            "neighborhood": "Bairro 0",
            "city": "Ouro Preto",
            "postal_code": "01001-000",
            "state": "MG"
          },
          "payment_methods": [
            {
              "id": 1,
              "method": "credit_card"
            },
            {
              "id": 2,
              "method": "debit_card"
            },
            {
              "id": 3,
              "method": "pix"
            }
          ],
          "checkin_hour": "14:00",
          "average_rating": null
        },
        {
          "id": 8,
          "brand_name": "Pousada Praiana",
          "phone_number": "11598308183",
          "email": "contato@praiana.com.br",
          "address_id": 8,
          "guesthouse_owner_id": 8,
          "description": "Descrição da Pousada Praiana",
          "pets": true,
          "use_policy": "Não é permitido fumar nas dependências da pousada",
          "checkout_hour": "12:00",
          "active": true,
          "address": {
            "id": 8,
            "street": "Rua 1,  1000",
            "neighborhood": "Centro 1",
            "city": "Camboriu",
            "postal_code": "11001-000",
            "state": "SC"
          },
          "payment_methods": [
            {
              "id": 1,
              "method": "credit_card"
            },
            {
              "id": 2,
              "method": "debit_card"
            },
            {
              "id": 3,
              "method": "pix"
            }
          ],
          "checkin_hour": "14:00",
          "average_rating": null
        }
      ]
      ```

#### Error Response

- `500 Internal Server Error`: If there is any server error.

### GET /api/v1/guesthouses/:id

This endpoint returns a specific guesthouse.

#### Parameters

- `id`: The ID of the guesthouse.

#### Response

Returns a JSON object of the guesthouse with the same properties as listed in the `GET /api/v1/guesthouses` endpoint.

  - **Example Request**
    - ```sh
      curl -X GET "http://localhost:3000/api/v1/guesthouses/1"
      ```
  - **Example Response**
  - ```json
    {
      "id": 1,
      "brand_name": "Pousada Nascer do Sol",
      "phone_number": "01598308183",
      "email": "contato@nascerdosol.com.br",
      "address_id": 1,
      "guesthouse_owner_id": 1,
      "description": "Descrição da Pousada Nascer do Sol",
      "pets": false,
      "use_policy": "Não é permitido fumar nas dependências da pousada",
      "checkin_hour": "14:00",
      "checkout_hour": "12:00",
      "active": true,
      "address": {
        "id": 1,
        "street": "Avenida 0, 0000",
        "neighborhood": "Bairro 0",
        "city": "Itapetininga",
        "postal_code": "01001-000",
        "state": "SP"
      },
      "payment_methods": [
        {
          "id": 1,
          "method": "credit_card"
        },
        {
          "id": 2,
          "method": "debit_card"
        },
        {
          "id": 3,
          "method": "pix"
        }
      ],
      "average_rating": 4
    }
    ```

#### Error Response

- `404 Not Found`: If the guesthouse with the specified ID does not exist.
  - **Example Response**
  - ```json
    {
      "message": "Not found"
    }
    ```
- `500 Internal Server Error`: If there is any server error.
</details>

<details>
<summary>Rooms API</summary>

## Rooms API

### GET /api/v1/guesthouses/:id/rooms

This endpoint returns a list of rooms in a specific guesthouse.

#### Parameters

- `id`: The ID of the guesthouse.

#### Response

Returns a JSON array of rooms. Each object in the array contains the following properties:

- `name`: The name of the room.
- `description`: The description of the room.
- `size`: The size of the room.
- `max_people`: The maximum number of people allowed in the room.
- `daily_rate`: The daily rate for the room.
- `bathroom`: A boolean indicating whether the room has a bathroom.
- `balcony`: A boolean indicating whether the room has a balcony.
- `air_conditioning`: A boolean indicating whether the room has air conditioning.
- `tv`: A boolean indicating whether the room has a TV.
- `wardrobe`: A boolean indicating whether the room has a wardrobe.
- `safe`: A boolean indicating whether the room has a safe.
- `accessible`: A boolean indicating whether the room is accessible.
- `guesthouse_id`: The ID of the guesthouse the room belongs to.

  - **Example Request**

  - ```sh
    curl -X GET "http://localhost:3000/api/v1/guesthouses/1/rooms"
    ```

  - **Example Response**
  - ```json
    [
      {
        "id": 1,
        "name": "Quarto 1",
        "description": "Descrição do Quarto 1",
        "size": 20,
        "max_people": 2,
        "daily_rate": 100,
        "bathroom": true,
        "balcony": true,
        "air_conditioning": true,
        "tv": true,
        "wardrobe": true,
        "safe": true,
        "accessible": true,
        "guesthouse_id": 1
      },
      {
        "id": 2,
        "name": "Quarto 2",
        "description": "Descrição do Quarto 2",
        "size": 30,
        "max_people": 3,
        "daily_rate": 200,
        "bathroom": true,
        "balcony": true,
        "air_conditioning": true,
        "tv": true,
        "wardrobe": true,
        "safe": true,
        "accessible": true,
        "guesthouse_id": 1
      }
    ]
    ```
#### Error Response

- `200 OK`: If there are no rooms in the guesthouse.

### GET /api/v1/rooms/:id/availability

This endpoint checks the availability of a specific room.

#### Parameters

- `id`: The ID of the room.
- `check_in_date`: The desired check-in date.
- `check_out_date`: The desired check-out date.
- `number_of_guests`: The number of guests.

#### Response

Returns a JSON object with the following properties:

- `available`: A boolean indicating whether the room is available.
- `total_price`: The total price for the stay.
- `message`: A message indicating the availability of the room.

   - **Example Request**
  
    - ```sh
      curl -X GET "http://localhost:3000/api/v1/rooms/1/availability?check_in_date=2023-10-10&check_out_date=2023-10-15&number_of_guests=2"
      ```
  
    - **Example Response**

    - ```json
      {
        "available": true,
        "total_price": 500,
        "message": "Quarto disponível"
      }
      ```

#### Error Response

- `400 Bad Request`: If any of the required parameters are missing.

  - **Example Request**
  - ```sh
    curl -X GET "http://localhost:3000/api/v1/rooms/1/availability?check_in_date=2023-10-10"
    ```

  - **Example Response**
  
  - ```json
    {
      "message": "Preencha todos os campos!",
      "errors": [
        "Data de Check-out não pode estar em branco",
        "Quantidade de Hóspedes não pode estar em branco"
      ]
    }
    ```

- `409 Conflict`: If the room is not available.

  - **Example Request**
  - ```sh
    curl -X GET "http://localhost:3000/api/v1/rooms/1/availability?check_in_date=2023-10-10&check_out_date=2023-10-15&number_of_guests=5"
    ```

  - **Example Response**
  
  - ```json
    {
      "available": false,
      "message": "Quarto indisponível",
      "errors": [
        "Não está disponível neste período",
        "Não comporta este número de pessoas"
      ]
    }
    ```
</details>