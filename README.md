# Call me as

1. **Ensure either Docker engine or Docker desktop are installed**:
   - Install Docker from [here](https://docs.docker.com/get-docker/).
   - Install Docker Compose from [here](https://docs.docker.com/compose/install/).

2. **Clone the repository**:
   ```sh
   git clone <repository-url>
   cd <repository-directory>
   ```

3. **Create and configure the `.env` file**:
   - Copy the provided `env-template` file content into a new file named `.env` in the project root directory.
   - Ensure all necessary environment variables are set correctly.

4. **Build and run the Docker containers**:
   ```sh
   docker compose up --build
   ```

5. **Access the project container**:
   - To access the `call-me-as` service container:
     ```sh
     make bash
     ```

6. **Push the Twilio flows**:
    
    This is an optional step but is strongly recommended to ensure the Twilio flow is not blocked by other developers. 
   - To push the personalized Twilio flow to Twilio Studio:
     ```sh
     make push-flow
     ```
     You'll get an output similar to:
     ```sh
      ~/src/call-me-as> make push-flow 
      New Flow SID (alejandrogarcia_press_1_flow): FW532be50f3ede1d3c76c6e552e2f12345
      New Flow SID (alejandrogarcia_call_flow): FW2a6102d0a5b13297856ae4c526d67890
      ```

7. **Make a call to your number and being asked to press 1 after it**:
   - To execute the Twilio flow:
     ```sh
     make call-press-1 to=<destination-phone-number>
     ```

8. **Make a call to your number**:
   - To execute the Twilio flow:
     ```sh
     make call to=<destination-phone-number>
     ```