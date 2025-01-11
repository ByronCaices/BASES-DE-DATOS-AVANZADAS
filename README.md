# Advanced Databases Projects

This repository contains several submodules, each representing different projects focused on advanced databases. Each project covers distinct topics and uses various technologies, including backend services and frontend interfaces.

## Submodules

1. **tbd-ctrl2-backend**

   - **Technologies**: Java, Spring Boot, PostgreSQL, MongoDB
   - **Description**: Backend for the second control of advanced databases. It uses Spring Boot for building RESTful APIs and interacts with PostgreSQL&#x20;

2. **tbd-ctrl2-frontend**

   - **Technologies**: Vue.js, Nuxt.js, Vuetify
   - **Description**: Frontend interface for the second control of advanced databases, built using Vue.js and styled with Vuetify.

3. **tbd-lab1-backend**

   - **Technologies**: Java, Spring Boot, PostgreSQL
   - **Description**: Backend for the first lab project. It includes REST API endpoints and interacts with a simple PostgreSQL database.

4. **tbd-lab1-frontend**

   - **Technologies**: Vue.js, Nuxt.js, Vuetify
   - **Description**: Frontend interface for the first lab project, using Vue.js and Vuetify for UI components.

5. **tbd-lab2-backend**

   - **Technologies**: Java, Spring Boot, PostgreSQL, PostGIS
   - **Description**: Backend for the second lab project, focused on working with a PostgreSQL database enhanced with PostGIS for geographic data handling.

6. **tbd-lab2-frontend**

   - **Technologies**: Vue.js, Nuxt.js, Vuetify, Mapbox
   - **Description**: Frontend interface for the second lab project, incorporating Mapbox for interactive map displays.

7. **tbd-lab3-backend**

   - **Technologies**: Java, Spring Boot, PostgreSQL, PostGIS, MongoDB, Docker
   - **Description**: Backend for the third lab project. It uses a monolithic architecture and combines PostgreSQL with PostGIS for spatial data and MongoDB for storing user geolocation. Docker is used for containerization.

8. **tbd-lab3-frontend**

   - **Technologies**: Vue.js, Nuxt.js, Vuetify
   - **Description**: Frontend interface for the third lab project, offering a responsive user interface built with Vue.js and Vuetify.

## Usage Instructions

At this preliminary phase of the project, it is intended for local use only. Deployment on cloud-based IaaS or PaaS services will be covered in future courses, such as Software Engineering Techniques. Some team members used Docker to run the project locally. Since Docker was not a requirement, its files were added to the `.gitignore` file.

## Deployment

### Start the Project

Execute the following Docker Compose command to build and run the project:
```bash
docker compose up --build -d
```
This will start the PostgreSQL and MongoDB databases along with PgAdmin for managing the PostgreSQL database.

### Prepare the Databases

1. **Create the PostgreSQL database**:

   ```bash
   # Enter the container
   docker exec -it tbd-lab3-backend-postgres-1 bash

   # Navigate to the folder containing the script
   cd /docker-entrypoint-initdb.d

   # Execute the script
   psql -U postgres -f dbCreate.sql

   # Populate the database
   psql -U postgres -d ecommercedb -f loadData.sql
   ```

2. **Connect to MongoDB**:
   The MongoDB initialization process is automated, and you can connect to the database using MongoDB Compass or any MongoDB client with the following URI:

   ```bash
   mongodb://${MONGO_INITDB_ROOT_USERNAME}:${MONGO_INITDB_ROOT_PASSWORD}@${MONGO_HOST}:${MONGO_PORT}
   ```

## Requirements

- **JDK**: Version 17.0.9
- **Backend**: Run the backend using a Java IDE, or navigate to `api/src/main/java/cl/soge/api` and execute the following command:
  ```bash
  mvnw spring-boot:run
  ```

## Development Team

| [Sebastian Cassone](https://github.com/sebacassone/) | [Byron Caices](https://github.com/ByronCaices) | [Benjamin Bustamante](https://github.com/benbuselola) | [Bastián Brito](https://github.com/PerroWachooo) |
| ---------------------------------------------------- | ---------------------------------------------- | ----------------------------------------------------- | ------------------------------------------------ |
|                                                      |                                                |                                                       |                                                  |

| [Andrea Cosio](https://github.com/PerroWachooo) | [Isidora Oyanedel](https://github.com/IsisIOo) | [Tomás Riffo](https://github.com/Ovejazo) |
| ----------------------------------------------- | ---------------------------------------------- | ----------------------------------------- |
|                                                 |                                                |                                           |

