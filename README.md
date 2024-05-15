# Pomodoro App

A Pomodoro timer application with a frontend built using Swift for iOS and macOS, a backend powered by Vapor, and infrastructure managed with Terraform. 

## Project Structure

```
pomodoro-app/
├── frontend/
│   ├── PomodoroApp.xcodeproj/
│   └── ... (other Xcode project files)
├── backend/
│   ├── PomodoroBackend/
│   └── ... (other Vapor project files)
├── infrastructure/
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
├── README.md
├── .gitignore
└── LICENSE
```

## Getting Started

### Prerequisites

- **Xcode**: [Install Xcode](https://developer.apple.com/xcode/)
- **Vapor CLI**: Install using Homebrew
  ```bash
  brew install vapor/tap/vapor
  ```
- **Terraform**: [Install Terraform](https://www.terraform.io/downloads.html)

### Setup

#### Frontend

1. Open Xcode.
2. Open the `frontend/PomodoroApp/PomodoroApp.xcodeproj` project.
3. Build and run the project on your simulator or device.

#### Backend

1. Navigate to the `backend` directory:
   ```bash
   cd backend/PomodoroBackend
   ```
2. Build and run the Vapor project:
   ```bash
   vapor build
   vapor run
   ```

#### Infrastructure

1. Navigate to the `infrastructure` directory:
   ```bash
   cd infrastructure
   ```
2. Initialize Terraform:
   ```bash
   terraform init
   ```
3. Apply the Terraform configuration:
   ```bash
   terraform apply
   ```

### Usage

- Open the Pomodoro app on your device.
- Use the app to start, pause, and reset the Pomodoro timer.
- Monitor your progress through the app’s interface.

## Contributing

1. Fork the repository.
2. Create your feature branch (`git checkout -b feature/your-feature`).
3. Commit your changes (`git commit -m 'Add some feature'`).
4. Push to the branch (`git push origin feature/your-feature`).
5. Open a pull request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contact

If you have any questions or feedback, please contact the project maintainer at [jsambuo@gmail.com].
