# PokeStats API

## Setup
Run the following in a terminal:
 - `git clone https://github.com/tbierwirth/pokestats_api.git`
 - `cd pokestats_api`
 - `bundle install`
 - `rails db:{create,migrate}`

To run the API locally:
 - `rails s`
 - Connect on `localhost:3000/api/v1/`

## Endpoints

### Registration (`/api/v1/users`)
**Create an account and receive an API key**

| Params | Description                                |
|------------|--------------------------------------------|
| username       | Must be unique        |
| password | Must match password_confirmation        |
| password_confirmation | Must match password        |

Example Request:
```
POST /api/v1/users

{
  "email": "user@example.com",
  "password": "password"
  "password_confirmation": "password"
}
```

Example Response:
```
status: 201
body:

{
  "api_key": "wKijQBid7j-pIpjuwWOjxQ",
}
```

### Pokemon Index (`/api/v1/pokemon`)
**Return all Pokemon in the database**

Optional Params:

| Query Param | Value                                 |
|-------------|-------------------------------------------|
| sorted      | name, weight, height, attack, defense, hp |
| min_hp      | 0 - 100 |

Example Request:
`GET /api/v1/pokemon`

Example Response:
```
{
    "data": [
        {
            "id": "1",
            "type": "pokemon",
            "attributes": {
                "name": "Pikachu",
                "weight": 13.23,
                "height": 1.31,
                "defense": 40,
                "attack": 55,
                "hp": 35
            }
        },
        {
            "id": "2",
            "type": "pokemon",
            "attributes": {
                "name": "Bulbasaur",
                "weight": 15.21,
                "height": 2.3,
                "defense": 49,
                "attack": 49,
                "hp": 45
            }
        },
        {
            "id": "3",
            "type": "pokemon",
            "attributes": {
                "name": "Charizard",
                "weight": 199.51,
                "height": 5.58,
                "defense": 78,
                "attack": 84,
                "hp": 78
            }
        }
    ]
}
```

### Pokemon Show (`/api/v1/pokemon/"pokemon name"`)
**Search for a pokemon in the database**

Example Request:
`GET /api/v1/pokemon/pikachu`

Example Response:
```
{
    "data": {
        "id": "1",
        "type": "pokemon",
        "attributes": {
            "name": "Pikachu",
            "weight": 13.23,
            "height": 1.31,
            "defense": 40,
            "attack": 55,
            "hp": 35
        }
    }
}
```
