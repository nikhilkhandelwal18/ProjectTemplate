import React, { useContext } from "react";
import { render, screen, waitFor, fireEvent } from "@testing-library/react";
import { UserContextProvider, UserContext, UserContextType } from "./UserContext";
import axios from "../app/axios";

jest.mock("../app/axios");

// Mock the axios.get function
const mockAxiosGet = axios.get as jest.MockedFunction<typeof axios.get>;

describe("UserContextProvider", () => {
  it("should set the user context correctly", async () => {
    const mockUserResponse = {
      data: {
        userId: "123",
        displayName: "John Doe",
      },
    };

    // Mock the axios response
    mockAxiosGet.mockResolvedValueOnce(mockUserResponse);

    const TestComponent: React.FC = () => {
      const { user } = useContext(UserContext) as UserContextType;
      return <div>{user?.displayName}</div>;
    };

    render(
      <UserContextProvider>
        <TestComponent />
      </UserContextProvider>
    );

    await waitFor(() => {
      expect(screen.getByText("John Doe")).toBeInTheDocument();
    });
  });
});
