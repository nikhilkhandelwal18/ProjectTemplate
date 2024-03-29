// import React from "react";
// import { render, screen } from "@testing-library/react";
// import App from "./App";

// const mockedUsedNavigate = jest.fn();
// const mockedUsedLocation = jest.fn();

// jest.mock("react-router-dom", () => ({
//   ...(jest.requireActual("react-router-dom") as any),
//   useNavigate: () => mockedUsedNavigate,
//   useLoaction: () => mockedUsedLocation,
// }));

// test("renders welcome text", () => {
//   render(<App />);
//   const welcomeText = screen.getByText(/WELCOME/i);
//   expect(welcomeText).toBeInTheDocument();
// });

import React from "react";
import { render, screen } from "@testing-library/react";
import { MemoryRouter, Routes, Route } from "react-router-dom";

// Import your App component after mocking react-router-dom
import App from "./App";

// Mock the react-router-dom module
jest.mock("react-router-dom", () => ({
  ...jest.requireActual("react-router-dom"),
  useNavigate: jest.fn(),
  useLocation: jest.fn(),
}));

// Mock the NavBar component
jest.mock("./components/NavBar", () => ({
  __esModule: true,
  default: () => <nav>Mock NavBar</nav>,
}));

describe("App", () => {
  it("renders without crashing", () => {
    render(
      <MemoryRouter>
        <Routes>
          <Route path="/" element={<App />} />
        </Routes>
      </MemoryRouter>
    );
  });
});

test("renders welcome text", () => {
  render(<App />);
  const welcomeText = screen.getByText(/Copyright 2024/i);
  expect(welcomeText).toBeInTheDocument();
});
