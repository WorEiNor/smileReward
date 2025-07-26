# SmileReward 🎁

A full-stack reward system for users to earn and redeem points.

## 🚀 Features

- User Authentication (Login)
- Reward Browsing
- Wishlist Management
- Profile with Points Display
- Responsive Frontend (Flutter)
- Backend API with Express & MongoDB

---

## 📦 Backend Setup (with Docker)

1. **Ensure Docker & Docker Compose are installed**

   - Download from: https://www.docker.com/products/docker-desktop

2. **Navigate to the `backend/` folder**:
   ```bash
   cd backend
   ```

3. **Run the backend using Docker Compose**:
   ```bash
   docker-compose up --build
   ```

   This will:
   - Build the Node.js backend image
   - Start the backend server
   - Connect to MongoDB service defined in `docker-compose.yml`

---

## 📱 Frontend Setup (Flutter)

1. **Navigate to the Flutter project root**:
   ```bash
   cd loyalty_app
   ```

2. **Run the app**:
   ```bash
   flutter pub get
   flutter run
   ```

---

## 🛠 Tech Stack

- **Frontend**: Flutter, Riverpod, GoRouter
- **Backend**: Node.js, Express, MongoDB, Mongoose
- **Auth**: JWT
- **Containerization**: Docker, Docker Compose

---

✅ To Do

- Fix some bugs

- Pagination & search

- Cleanup

---

## 👤 Author

WorEiNor – [github.com/WorEiNor](https://github.com/WorEiNor)

