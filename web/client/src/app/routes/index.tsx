import React from "react";
import PageNotFound from "../../components/PageNotFound";
import Home from "../../pages/Home";
import About from "../../pages/About";

const AppRoutes = [
  {
    index: true,
    element: <Home />,
  },
  {
    path: "/about",
    element: <About />,
  },
  {
    path: "*",
    element: <PageNotFound />,
  },
];

export default AppRoutes;
