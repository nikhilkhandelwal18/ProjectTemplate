import axios from "../app/axios";
import { fetchUserInfo } from "./UserService";

jest.mock("../app/axios");

// Type assertion for axios mock
const mockAxios = axios as jest.Mocked<typeof axios>;

describe("UserService", () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  it("fetches user info successfully", async () => {
    const mockUser = { userId: "user1", firstName: "John", lastName: "Doe", displayName: "Doe, John (user1)", emailAddress: "john@example.com" };
    mockAxios.get.mockResolvedValueOnce({ data: mockUser });

    const userInfo = await fetchUserInfo();

    expect(userInfo).toEqual(mockUser);
    expect(axios.get).toHaveBeenCalledTimes(1);
    // expect(axios.get).toHaveBeenCalledWith("/api/user");
  });

  it("handles error during fetch", async () => {
    const errorMessage = "Failed to fetch user info";
    mockAxios.get.mockRejectedValueOnce(new Error(errorMessage));

    await expect(fetchUserInfo()).rejects.toThrow(errorMessage);
    expect(axios.get).toHaveBeenCalledTimes(1);
    // expect(axios.get).toHaveBeenCalledWith("/api/user");
  });
});
