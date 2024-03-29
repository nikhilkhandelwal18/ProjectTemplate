export type Settings = Record<"hostEnvironment", string>;

export type User = {
  userId: string;
  firstName: string;
  middleName?: string;
  lastName: string;
  displayName: string;
  description: string;
  emailAddress?: string;
  extensionAttribute3?: string;
};
