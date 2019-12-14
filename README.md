# API
**base_url: https://expert-palm-tree.herokuapp.com**

Headers
```json
{
  "Content-Type": "application/json"
}
```

## Stocks
**GET /api/v1/stocks**

*Request params:*
- page // integer, optional
- per_page // integer, optional

*Response code: 200*

*Response body:*
```json
{
  "data": [
    {
      "id": "uuid",
      "name": "name",
      "bearer_name": "bearer_name"
    }
  ]
}
```

**POST /api/v1/stocks**

*Request body:*
```json
{
  "name": "name",
  "bearer_name": "bearer_name" // optional
}
```

*Response codes:*
- 201 // success
- 400 // wrong params
- 404 // stock not found

*Response body:*
```json
{
  "data": {
    "id": "uuid",
    "name": "name",
    "bearer_name": "bearer_name"
  }
}
```

**PATCH /api/v1/stocks/:id**

*Request body:*
```json
{
  "name": "name",
  "bearer_name": "bearer_name" // optional
}
```

*Response codes:*
- 200 // success
- 400 // wrong params
- 404 // stock not found

*Response body:*
```json
{
  "data": {
    "id": "uuid",
    "name": "name",
    "bearer_name": "bearer_name"
  }
}
```

**DELETE /api/v1/stocks/:id**

*Response codes:*
- 200 // success
- 404 // stock not found
